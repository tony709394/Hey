extends Node


const State = preload("./State/State.gd")
const StateMulti = preload("./State/StateMulti.gd")
const Interceptor = preload("./Middleware/Interceptor.gd")
const StringTool = preload("./Tool/StringTool.gd")
var config_http_request = {
	"official": null,
	"inofficial": {
		"base_url": ""
	},
}
var dict_http_request = {}


func _process(delta):
	remove_child_auto(5000)


# create dict with HTTPRequest
func create_request():
	var http_request = HTTPRequest.new()
	if config_http_request.official != null:
		for key in config_http_request.official:
			http_request[key] = config_http_request.official[key]
	self.add_child(http_request)
	http_request.connect("request_completed", self, "_on_request_completed")
	
	var id = StringTool.generate_random_string(16)
	var res = {
		"error": 0,
		"id": id,
		"create_timestamp": OS.get_system_time_msecs(),
		"instance": http_request,
		"source": null,
		"state": null,
	}
	
	dict_http_request[id] = res
	
	return res


# core of all HTTP methods 
func request(node, method, params):
	var http_request = create_request()
	
	var id = http_request.id
	var instance = http_request.instance
	var url = (config_http_request.inofficial.base_url + params.url) if params.has("url") else ""
	var headers = params.headers if params.has("headers") else []
	var use_ssl = params.use_ssl if params.has("ssl_validate_domain") else true
	var query = params.query if params.has("query") else ""
	
	headers.push_front("Godot-Request-ID:%s" % id)
	
	var error = instance.request(url, headers, use_ssl, method, query)
	var state = State.new(node)
	http_request.error = error
	http_request.source = node
	http_request.state = state
	
	if error != OK:
		push_error("An error occurred in the HTTP request.")
		free_node(id)
	else:
		Interceptor.request_before(http_request)
	
	return state


# ========================== interfaces (begin) ==========================

func GET(node, params):
	return request(node, HTTPClient.METHOD_GET, params)


func HEAD(node, params):
	return request(node, HTTPClient.METHOD_HEAD, params)


func POST(node, params):
	return request(node, HTTPClient.METHOD_POST, params)


func PUT(node, params):
	return request(node, HTTPClient.METHOD_PUT, params)


func DELETE(node, params):
	return request(node, HTTPClient.METHOD_DELETE, params)


func OPTIONS(node, params):
	return request(node, HTTPClient.METHOD_OPTIONS, params)


func TRACE(node, params):
	return request(node, HTTPClient.METHOD_TRACE, params)


func CONNECT(node, params):
	return request(node, HTTPClient.METHOD_CONNECT, params)


func PATCH(node, params):
	return request(node, HTTPClient.METHOD_PATCH, params)


func MAX(node, params):
	return request(node, HTTPClient.METHOD_MAX, params)


func all(array_state):
	var instance = StateMulti.new(self, array_state)
	self.add_child(instance)
	return instance


func config(params):
	var body_size_limit = params.body_size_limit if params.has("body_size_limit") else -1
	var download_chunk_size = params.download_chunk_size if params.has("download_chunk_size") else 65536
	var download_file = params.download_file if params.has("download_file") else ""
	var max_redirects = params.max_redirects if params.has("max_redirects") else 8
	var timeout = params.timeout if params.has("timeout") else 0
	var use_threads = params.use_threads if params.has("use_threads") else false
	var base_url = params.base_url if params.has("base_url") else ""
	
	config_http_request.official = {
		"download_chunk_size": download_chunk_size,
		"download_file": download_file,
		"use_threads": use_threads,
		"body_size_limit": body_size_limit,
		"max_redirects": max_redirects,
		"timeout": timeout,
	}
	config_http_request.inofficial = {
		"base_url": base_url,
	}


func intercept(params):
	
	var node = params.node if params.has("node") else null
	var request = params.request if params.has("request") else null
	var response = params.response if params.has("response") else null
	
	if node != null:
		Interceptor.register_callback_node(node)
	if request != null:
		Interceptor.register_request_callback(request)
	if response != null:
		Interceptor.register_response_callback(response)


func _on_request_completed(result, response_code, headers, body):
	
	var id = headers[0].split("Godot-Request-ID:")[1]
	headers.remove(0)
	var http_request = dict_http_request[id]
	var state = http_request.state
	var source = http_request.source
	var success_callback_name = state.callback_name.success
	var fail_callback_name = state.callback_name.fail
	var finally_callback_name = state.callback_name.finally
	
#	Then need to add the MIME type
#	MIME type list: https://blog.csdn.net/dodod2012/article/details/88868930
	var content_type = "application/json"
	var body_hex = body.hex_encode().to_upper()
	var dict_content_type = {
		"FFD8FF": "image/jpg",
		"89504E47": "image/png",
		"47494638": "image/gif",
		"49492A00": "image/tiff",
		"424D": "image/bmp",
		"57415645": "audio/x-wav",
	}
	for key in dict_content_type:
		if body_hex.find(key) == 0:
			content_type = dict_content_type[key]
			break
	
	var res = {
		"code": response_code,
		"body": null,
		"headers": headers,
		"content_type": content_type
	}
	
	if content_type.find("application/json") == 0:
		if body.get_string_from_utf8() != null:
			res.body = JSON.parse(body.get_string_from_utf8()).result
	else:
		res.body = body
	
	# ================= call callback func (begin) =================
	
	if result == 0:
		if (success_callback_name != null) and source.has_method(success_callback_name):
			source.call(success_callback_name, res)
			Interceptor.response("success", res)
	else:
		if (fail_callback_name != null) and source.has_method(fail_callback_name):
			source.call(fail_callback_name, res)
			Interceptor.response("fail", res)
	
	if (finally_callback_name != null) and source.has_method(finally_callback_name):
		source.call(finally_callback_name, res)
		Interceptor.response("finally", res)
	
	# ================= call callback func (end) =================
	
	state.error = result
	state.result = res
	
	free_node(id)

# ========================== interfaces (end) ==========================


# http_request create failed / http_request completed
func free_node(id):
	
	var item = dict_http_request[id]
	var http_request = item.instance
	var state = item.state
	http_request.queue_free()
	dict_http_request.erase(id)
	
	if not state.is_locked:
		state.queue_free()


# Help cancel_request() remove the node
# because cancel_request() releases only instances but does not remove nodes
func remove_child_auto(millisecond):
	
	for key in dict_http_request:
		var http_request = dict_http_request[key]
		var instance = dict_http_request[key].instance
		var state = dict_http_request[key].state
		var id = dict_http_request[key].id
		var current_timestamp = OS.get_system_time_msecs()
		var destroy_timestamp = http_request.create_timestamp + millisecond
		if current_timestamp >= destroy_timestamp:
			self.remove_child(instance)
			dict_http_request.erase(id)
