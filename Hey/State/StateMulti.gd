extends "./State.gd"


var parent_node
var array_state
var is_complete_all = false
var is_success_all = true


func _init(parent_node, array_state).(array_state[0].source):
	self.parent_node = parent_node
	for state in array_state:
		state.is_locked = true
	self.array_state = array_state


# poll state array
func _process(delta):
	
	if not is_complete_all:
		
		var _is_complete_all = true
		
		for state in self.array_state:
			if state.error == null:
				_is_complete_all = false
				break
		
		if _is_complete_all:
			var array_res = []
			for state in self.array_state:
				if state.error != 0:
					is_success_all = false
				array_res.push_back(state.result)
			
			# ================= call callback func (begin) =================
			
			if is_success_all:
				if (self.callback_name.success != null) and self.source.has_method(self.callback_name.success):
					self.source.call(self.callback_name.success, array_res)
			else:
				if (self.callback_name.fail != null) and self.source.has_method(self.callback_name.fail):
					self.source.call(self.callback_name.fail, array_res)
			
			if (self.callback_name.finally != null) and self.source.has_method(self.callback_name.finally):
				self.source.call(self.callback_name.finally, array_res)
			
			# ================= call callback func (end) =================
			
			self.parent_node.remove_child(self)
			self.queue_free()
			
			for state in self.array_state:
				state.queue_free()
			
			is_complete_all = true
