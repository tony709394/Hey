extends Spatial


var state_download_single_file
var state_download_multi_file


func _ready():
	pass
#	Hey.config({
#		"base_url": "http://www.mocky.io",
#	})
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


func _process(delta):

	if state_download_single_file != null:
		var progress_download = Hey.get_download_progress(state_download_single_file)
		print("progress download(single_file): %s" % progress_download)

	if state_download_multi_file != null:
		var progress_download = Hey.get_download_progress(state_download_multi_file)
		print("progress download(multi_file): %s" % progress_download)


func _input(event):
	
	# single req
	if Input.is_action_pressed("ui_up"):
		var state1 = Hey.GET(self, {
			"url": "http://www.mocky.io/v2/5185415ba171ea3a00704eed"
		}).success("success").fail("fail").finally("finally")
	
	# multi req
	if Input.is_action_pressed("ui_down"):
		var state1 = Hey.GET(self, {
			"url": "http://www.mocky.io/v2/5185415ba171ea3a00704eed"
		})
		var state2 = Hey.GET(self, {
			"url": "http://www.mocky.io/v2/5185415ba171ea3a00704eed"
		})
		Hey.all([ state1, state2 ]).success("success_all").fail("fail_all").finally("finally_all")
	
	# download single file
	if Input.is_action_pressed("ui_left"):
		state_download_single_file = Hey.download(self, {
			"url": "https://gamesounds.xyz/99Sounds/The%20Weird%20Side%20Samples%20%2899Sounds%29/Atmospheric/Atmospheric-01.wav"
		}).success("success_download").fail("fail_download").finally("finally_download")
	
	# download multi file
	if Input.is_action_pressed("ui_right"):
		var state1 = Hey.download(self, {
			"url": "https://gamesounds.xyz/99Sounds/The%20Weird%20Side%20Samples%20%2899Sounds%29/Atmospheric/Atmospheric-01.wav"
		})
		var state2 = Hey.download(self, {
			"url": "https://gamesounds.xyz/99Sounds/The%20Weird%20Side%20Samples%20%2899Sounds%29/Atmospheric/Atmospheric-01.wav"
		})
		state_download_multi_file = Hey.all([ state1, state2 ]).success("success_download").fail("fail_download").finally("finally_download")


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


# The download body is too large to print
# =================== download (begin) ===================

func success_download(res):
	print("download success")


func fail_download(res):
	print("download fail")


func finally_download(res):
	print("download finally")
	print("====================")

# =================== local single req (end) ===================
