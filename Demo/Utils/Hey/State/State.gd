extends Node


var is_locked = false
var error
var result
var source
var callback_name = {
	"success": null,
	"fail": null,
	"finally": null,
}


func _init(source):
	self.source = source


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
