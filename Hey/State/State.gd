extends Node


var is_locked = false
var error
var result
var source
var http_request
var callback_name = {
	"success": null,
	"fail": null,
	"finally": null,
}


func _init(source, http_request=null):
	self.source = source
	self.http_request = http_request


# ================= register callback func name (begin) =================

func success(name):
	self.callback_name.success = name
	return self


func fail(name):
	self.callback_name.fail = name
	return self


func finally(name):
	self.callback_name.finally = name
	return self

# ================= register callback func name (end) =================


func _get_progress():
	if self.http_request != null:
		var http_request = self.http_request
		var body_size = http_request.get_body_size()
		var downloaded_size = http_request.get_downloaded_bytes()
		var progress = float(downloaded_size) / body_size
		return progress
