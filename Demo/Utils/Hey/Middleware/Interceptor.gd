extends Node


const callback = {
	"node": null,
	"request": {
		"before": null,
	},
	"response": {
		"success": null,
		"fail": null,
		"finally": null,
	},
}


# ================= register callback func name (begin) =================

static func register_callback_node(node):
	callback.node = node


static func register_request_callback(params):
	callback.request.before = params.before if params.has("before") else null


static func register_response_callback(params):
	callback.response.success = params.success if params.has("success") else null
	callback.response.fail = params.fail if params.has("fail") else null
	callback.response.finally = params.finally if params.has("finally") else null

# ================= register callback func name (end) =================


# ================= call callback func (begin) =================

static func request_before(http_request):
	var request_before_callback_name = callback.request.before
	var node = callback.node
	
	if (request_before_callback_name != null) and node.has_method(request_before_callback_name):
		node.call(request_before_callback_name, http_request.instance)


static func response(step, res):
	var response_callback_name = callback.response[step]
	var node = callback.node
	
	if (response_callback_name != null) and node.has_method(response_callback_name):
		node.call(response_callback_name, res)

# ================= call callback func (begin) =================
