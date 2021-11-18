extends Spatial


func _ready():
	Hey.config({
		"base_url": "http://www.mocky.io",
	})
#	Hey.intercept({
#		"node": self,
#		"request": {
#			"before": "before_request",
#		},
#		"response": {
#			"success": "success_response",
#			"fail": "fail_response",
#			"finally": "finally_response",
#		}
#	})


func _input(event):
	
	# single req
	if Input.is_action_pressed("ui_up"):
		var state1 = Hey.GET(self, {
			"url": "/v2/5185415ba171ea3a00704eed"
		}).success("success").fail("fail").finally("finally")
	
	# multi req
	if Input.is_action_pressed("ui_down"):
		var state1 = Hey.GET(self, {
			"url": "/v2/5185415ba171ea3a00704eed"
		})
		var state2 = Hey.GET(self, {
			"url": "/v2/5185415ba171ea3a00704eed"
		})
		Hey.all([ state1, state2 ]).success("success_all").fail("fail_all").finally("finally_all")


# =================== local single req (begin) ===================

func success(res):
	print("success")
	print(res)


func fail(res):
	print("fail")
	print(res)


func finally(res):
	print("finally")
	print(res)
	print("====================")

# =================== local single req (end) ===================


# =================== local multi req (begin) ===================

func success_all(res):
	print("success_all")
	print(res)


func fail_all(res):
	print("fail_all")
	print(res)


func finally_all(res):
	print("finally_all")
	print(res)
	print("====================")

# =================== local multi req (end) ===================


# =================== global (begin) ===================

func before_request(http_request):
	print("before_request")
	print(http_request)
#	http_request.cancel_request()


func success_response(res):
	print("success_response")
	print(res)


func fail_response(res):
	print("fail_response")
	print(res)


func finally_response(res):
	print("finally_response")
	print(res)
	print("====================")

# =================== global (end) ===================
