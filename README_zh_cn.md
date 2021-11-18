<p align="center"><img src="https://raw.githubusercontent.com/tony709394/Hey/main/Images/logo.png" align="center" width="175"></p>
<h1 align="center">Hey</h1>

Language: [English](README.md) | 中文简体

## Hey 是什么 ?

Godot HTTP 请求库。请求就像打招呼一样简单。

## 安装

> 支持 Godot 3.0+

- 下载这个仓库

- 复制 Hey 目录 至 你的项目目录

- 在 Godot 编辑器中，选择 "项目 -> 项目管理 -> 自动加载"

- 添加脚本 Hey.gd

<p align="center"><img src="https://raw.githubusercontent.com/tony709394/Hey/main/Images/autoload.png" align="center"></p>

## 示例

### (全局) 配置、拦截器

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

### (局部) 请求、响应

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

- 描述: (可选) 配置 HTTP 客户端。

- 输出: `Void`

- 输入: `Dictionary`

- 用法:

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

> 除了 `base_url` 字段，请参考 [官方文档](https://docs.godotengine.org/en/stable/classes/class_httprequest.html) 填写其他字段。部分字段不支持低版本。

### intercept

- 描述: (可选) 设置全局的请求、响应拦截器。

- 输出: `Void`

- 输入: `Dictionary`

- 用法:

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

> `node` 字段是必填的，值为节点引用。当请求发起 或 响应完成时，拦截器将调用该节点的回调函数。

### GET | HEAD | POST | PUT | DELETE | OPTIONS | TRACE | CONNECT | PATCH | MAX

- 描述: 通过某种 HTTP 方法，调用服务端接口。

- 输出: `State`

- 输入: `Node, Dictionary`

- 用法:

```
Hey.GET(self, {
    "url": "/v2/5185415ba171ea3a00704eed",
    "headers": "/v2/5185415ba171ea3a00704eed",
    "use_ssl": "/v2/5185415ba171ea3a00704eed",
    "query": "/v2/5185415ba171ea3a00704eed",
}).success("success_callback").fail("fail_callback").finally("finally_callback")
```

> `node` 字段是必填的，值为节点引用。当响应完成时，调用该节点的回调函数。
> 
> 请依据 [官方文档](https://docs.godotengine.org/en/stable/classes/class_httprequest.html) 填写第二个参数。

### all

- 描述: 等待所有接口完成。

- 输出: `State`

- 输入: `Array`

- 用法:

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

> 参数是 `State` 数组。
