#  开发人员API参考手册
-------------------
## [1 关于文档](#about_doc)
## [2 背景知识](#background)
## [3 API请求](#api_request)
## [4 API响应](#api_response)
## [5 会员管理](#member_manage)
### [5.1 会员增加](#member_add)
### [5.2 会员修改](#member_update)
### [5.3 会员删除](#member_delete)
### [5.4 会员查询](#member_query)
### [5.5 会员列表](#member_query_list)
### [5.6 按日期统计会员](#member_stat_by_date)
## [6 状态码](#status_code)
-------------------
## 1. 关于文档 <a name="about_doc"/>
   本文档作为管理系统与前端WEB UI进行联调的指引文档。主要包括以下几个个部分：
   管理端 API：阅读对象为产品和WEB UI开发人员,以及相关测试人员。该部分详细描述了管理系统相关的接口

## 2. 背景知识 <a name="background"/>
   本API文档所涉及接口均遵循HTTP和HTTPS协议，请求和响应数据格式如无特殊说明均为JSON，您可以使用任何支持HTTP和HTTPS协议和JSON格式的编程
   语言开发应用程序。有关标准HTTP和HTTPS协议，可参考RFC2616和RFC2818或维基百科-HTTP,HTTPS相关介绍。有关JSON数据格式，可参考JSON.ORG
   或维基百科–JSON相关介绍

## 3. API请求 <a name="api_request"/>
   HTTP Method
   调用方应设置HTTP Method为POST。
   HTTP Header
   调用方应遵循HTTP协议设置相应的Header，目前支持的Header有：Content-Type，Content-Type用于指定数据格式。本章节中Content-Type应为
   application/json

## 4. API响应 <a name="api_response"/>
* HTTP状态码，支持HTTP标准状态码，具体如下：

| 状态码  | 名称 | 描述 |
| :--------| ----:| :--- |
| 200 |  成功或者失败  |  当API 请求被正确处理，且能按设计获取结果时，返回该状态码；亦适用于批量接口返回部分结果，如果失败，亦包括失败信息 |

* HTTP Body响应的JSON数据中包含三部分内容，分别为返回码、返回信息和数据，如下表所示：

| 名称  | 类型 | 必填 | 描述 |
| :--------| ----:| ----:| :--- |
| code |  int  | 是 |  返回码：见状态码的定义  |
| msg |  string  | 是 |  返回信息：若有错误，此字段为详细的错误信息 |
| data |  json array 或json object | 否 |  返回结果：针对批量接口，若无特殊说明，结果将按请求数组的顺序全量返回  |

## 5.会员管理 <a name="member_manage"/>
### 5.1 会员增加 add <a name="member_add"/>
* 请求URL:http://${DOMAIN}/interface/example/add
* 请求字段:

| 名称  | 类型 | 必填 | 描述 |
| :--------| ----:| ----:| :--- |
| name | string | 是 | 会员名称 |

* 应答字段

| 名称  | 类型 | 必填 | 描述 |
| :--------| ----:| ----:| :--- |
| code |  int  | 是 | 状态码 |
| msg |  string  | 否 | 失败时的提示信息 |
| data |  json object  | 是 | 对象 |

* 应答data字段

| 名称  | 类型 | 必填 | 描述 |
| :--------| ----:| ----:| :--- |
| id |  string  | 是 | id |
| name |  string  | 是 | 名称 |

* 请求示例
   >{
	   "name": "张帅"
	}

* 应答示例
  >{
	  "msg": "",
	  "code": 0,
	  "data": {
		"id": "1",
		"name": "张帅"
	  }
	}
	
### 5.2 会员修改 update <a name="member_update"/>
* 请求URL:http://${DOMAIN}/interface/example/update
* 请求字段:

| 名称  | 类型 | 必填 | 描述 |
| :--------| ----:| ----:| :--- |
| id |  string  | 是 | id |
| name | string | 是 | 名称 |

* 应答字段

| 名称  | 类型 | 必填 | 描述 |
| :--------| ----:| ----:| :--- |
| code |  int  | 是 | 状态码 |
| msg |  string  | 否 | 失败时的提示信息 |


* 请求示例
   >{
       "id": "1",
	   "name": "李帅"
	}

* 应答示例
  >{
	   "msg": "",
	   "code": 0
   }

### 5.3 会员删除 delete <a name="member_delete"/>
* 请求URL:http://${DOMAIN}/interface/example/delete
* 请求字段:

| 名称  | 类型 | 必填 | 描述 |
| :--------| ----:| ----:| :--- |
| id |  array  | 是 | id数组 |

* 应答字段

| 名称  | 类型 | 必填 | 描述 |
| :--------| ----:| ----:| :--- |
| code |  int  | 是 | 状态码 |
| msg |  string  | 否 | 失败时的提示信息 |


* 请求示例
   >{
       "id": ["1", "2", "3"]
	}

* 应答示例
  >{
	   "msg": "",
	   "code": 0
   }
   
### 5.4 会员查询 query <a name="member_query"/>
* 请求URL:http://${DOMAIN}/interface/example/query
* 请求字段:

| 名称  | 类型 | 必填 | 描述 |
| :--------| ----:| ----:| :--- |
| id |  string  | 是 | 会员id |

* 应答字段

| 名称  | 类型 | 必填 | 描述 |
| :--------| ----:| ----:| :--- |
| code |  int  | 是 | 状态码 |
| msg |  string  | 否 | 失败时的提示信息 |
| data |  json object  | 是 | 对象 |

* 应答data字段

| 名称  | 类型 | 必填 | 描述 |
| :--------| ----:| ----:| :--- |
| id |  string  | 是 | id |
| name |  string  | 是 | 名称 |

* 请求示例
   >{
	   "id": "1"
	}

* 应答示例
  >{
	  "msg": "",
	  "code": 0,
	  "data": {
		"id": "1",
		"name": "李帅"
	  }
    }
### 5.5 会员列表 query_list <a name="member_query_list"/>
* 请求URL:http://${DOMAIN}/interface/example/query_list
* 请求字段:

| 名称  | 类型 | 必填 | 描述 |
| :--------| ----:| ----:| :--- |
| id |  string  | 否 | id |
| name |  string  | 否 | 名称(支持模糊查询) |
| page_number | int  | 是 |  页码  |
| page_size | int  | 是 |  每页记录条数 |

* 应答字段

| 名称  | 类型 | 必填 | 描述 |
| :--------| ----:| ----:| :--- |
| code |  int  | 是 | 状态码 |
| msg |  string  | 否 | 失败时的提示信息 |
| page_number | int  | 页码  |
| page_size | int  | 每页记录条数 |
| total_number |  int | 总记录条数  |
| data |  json array  | 是 | 对象数组 |

* 应答data数组单个元素字段

| 名称  | 类型 | 必填 | 描述 |
| :--------| ----:| ----:| :--- |
| id |  string  | 是 | id |
| name |  string  | 是 | 名称 |

* 请求示例
   >{
	   "id": "1",
	   "page_number": 1,
	   "page_size": 10
	}

* 应答示例
  >{
	"msg": "",
	"code": 0,
	"page_number": 1,
	"page_size": 10,
	"total_number": 2,
	"data": [
		{
		   "id": "1",
		   "name": "李帅"
		},
		{
		   "id": "2",
		   "name": "张帅"
		}
	]
   }
   
### 5.6 按日期统计会员 stat_by_date <a name="member_stat_by_date"/>
* 请求URL:http://${DOMAIN}/interface/example/stat_by_date
* 请求字段:

| 名称  | 类型 | 必填 | 描述 |
| :--------| ----:| ----:| :--- |
| begin_time |  int  | 是 | 开始时间 |
| end_time |  int  | 是 | 结束时间 |
| page_number | int  | 是 |  页码  |
| page_size | int  | 是 |  每页记录条数 |   
   
* 应答字段

| 名称  | 类型 | 必填 | 描述 |
| :--------| ----:| ----:| :--- |
| code |  int  | 是 | 状态码 |
| msg |  string  | 否 | 失败时的提示信息 |
| page_number | int  | 页码  |
| page_size | int  | 每页记录条数 |
| total_number |  int | 总记录条数  |
| data |  json array  | 是 | 对象数组 |

* 应答data数组单个元素字段

| 名称  | 类型 | 必填 | 描述 |
| :--------| ----:| ----:| :--- |
| num |  int  | 是 | 记录数量 |
| register_date |  string  | 是 | 注册日期 |
   
* 请求示例
   >{
	   "begin_time": 0,
	   "end_time": 16000000000,
	   "page_size": 10,
	   "page_number": 1
    }
    
* 应答示例
  >{
      "page_size": 10,
      "msg": "",
      "code": 0,
      "total_number": 1,
      "data": [
        {
            "num": 2,
            "register_date": "2017-10-15"
        }
      ],
      "page_number": 1
    } 
   
## 6.状态码 <a name="status_code"/> 

| 值  | 描述 |
| :--------| ----:|
| -100100 |  用户输入错误  |
| -100200 |  用户输入逻辑错误  |
| -100300 |  服务后台错误  |
| -100301 |  系统错误  |
| -100400 |  数据库读写错误  |
| -100401 |  数据库逻辑错误  |
| -100500 |  认证失败  |
| -100600 |  系统繁忙  |
