<p align="center"><img src="https://raw.githubusercontent.com/tony709394/Hey/main/Images/logo.png" align="center" width="175"></p>
<h1 align="center">Hey</h1>

Language: English | [中文简体](README_zh_cn.md)

## What is Hey ?

A lightweight HTTP request library for Godot. Request is as simple as Hey.

## Install

> Godot 3.0+ is supported.

- Download this repository

- Copy the directory named Hey into your project

- In the Godot editor, select "Project -> Project Settings -> AutoLoad"

- Add a script named Hey.gd

<p align="center"><img src="https://raw.githubusercontent.com/tony709394/Hey/main/Images/autoload.png" align="center"></p>

## Examples

### (Global) Configuration and Interceptor

```
func _ready():
    Hey.config({
        "base_url": "http://www.mocky.io",
    })
    Hey.intercept({
        "node": self,
        "request": {
            "before": "before_request_callback",
        },
        "response": {
            "success": "success_response_callback",
            "fail": "fail_response_callback",
            "finally": "finally_response_callback",
        }
    })

func before_request_callback(http_request):
    print("before_request")
    print(http_request)

func success_response_callback(res):
    print("success_response")
    print(res)

func fail_response_callback(res):
    print("fail_response")
    print(res)

func finally_response_callback(res):
    print("finally_response")
    print(res)
```

### (Local) Request and response

```
func get_something():
    Hey.GET(self, {
        "url": "/v2/5185415ba171ea3a00704eed"
    }).success("success_callback").fail("fail_callback").finally("finally_callback")

func success_callback(res):
    print("success")
    print(res)

func fail_callback(res):
    print("fail")
    print(res)

func finally_callback(res):
    print("finally")
    print(res)
```

## API

### config

- Description: (Optional) Configure the HTTP client.

- Output: `Void`

- Input: `Dictionary`

- Usage:

```
Hey.config({
    "base_url": "http://www.mocky.io",
    "download_chunk_size": 65536,
    "download_file": "",
    "use_threads": false,
    "body_size_limit": -1,
    "max_redirects": 8,
    "timeout": 0,
})
```

> Please refer to the [official documentation](https://docs.godotengine.org/en/stable/classes/class_httprequest.html) for all fields except the `base_url` field. Some fields do not support earlier versions.

### intercept

- Description: (Optional) Set up global interceptors for requests and responses.

- Output: `Void`

- Input: `Dictionary`

- Usage:

```
Hey.intercept({
    "node": self,
    "request": {
        "before": "before_request_callback",
    },
    "response": {
        "success": "success_response_callback",
        "fail": "fail_response_callback",
        "finally": "finally_response_callback",
    }
})
```

> The `node` field is required and its value is a node reference. When a request or response occurs, the interceptor invokes the callback function from that node.

### GET | HEAD | POST | PUT | DELETE | OPTIONS | TRACE | CONNECT | PATCH | MAX

- Description: Request the remote interface in some HTTP method.

- Output: `State`

- Input: `Node, Dictionary`

- Usage:

```
Hey.GET(self, {
    "url": "/v2/5185415ba171ea3a00704eed",
    "headers": [],
    "use_ssl": false,
    "query": "",
}).success("success_callback").fail("fail_callback").finally("finally_callback")
```

> The `node` field is required and its value is a node reference. When a response occurs, the callback function is invoked from that node.
> 
> For details about how to fill in the second parameter, see the [official documentation](https://docs.godotengine.org/en/stable/classes/class_httprequest.html).

### all

- Description: Wait for all responses to complete.

- Output: `State`

- Input: `Array`

- Usage:

```
var state1 = Hey.GET(self, {
    "url": "/v2/5185415ba171ea3a00704eed",
})

var state2 = Hey.GET(self, {
    "url": "/v2/5185415ba171ea3a00704eed",
})

Hey.all([
    state1,
    state2,
]).success("success_callback").fail("fail_callback").finally("finally_callback")
```

> The argument is a `State` array.
