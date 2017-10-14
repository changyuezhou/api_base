#  项目介绍
-------------------
## [1 关于项目](#about_doc)
## [2 DOC目录](#doc_dir)
## [3 api/initial目录](#initial)
## [4 api/include目录](#include)
## [5 api/interface目录](#interface)
## [6 api/business目录](#business)
## [7 api/lib目录](#lib)
## [8 安装](#install)

-------------------
## 1. 关于项目 <a name="about_doc"/>
   本项目是API项目的范本，包含了编写Restful风格API需要的所有元素
   
## 2. DOC目录 <a name="doc_dir"/>
   目录下包含了编程规范，数据库设计脚本，API接口设计等
   
## 3. api/initial目录 <a name="initial"/>
   目录下包含了NGINX LUA启动时全局初始化代码
   
## 4. api/include目录 <a name="include"/>
   目录下包含了项目配置文件,包括数据库服务器地址，数据库名称等   
   
## 5. api/interface目录 <a name="interface"/>
   目录下包含了所有接口的入口运行文件，该目录下的文件只做参数必要性检查和数据类型检查  
   
## 6. api/business目录 <a name="business"/>
   目录下包含了所有业务逻辑代码，目录下按领域业务分包，比如example为单独的包，该包中
   包含业务添加，删除，修改，查询，逻辑检查，列表查询，日期统计等   
   
## 7. api/lib目录 <a name="lib"/>
   目录下包含了项目所需要的库文件
*  api/lib/cachelib 该目录下包含访问database proxy代码
*  api/lib/commlib 该目录下包含了通用的代码库，比如socket收发数据
*  api/lib/httplib 该目录下包含了http访问请求相关代码库
*  api/lib/redis 该目录下包含了访问redis服务器代码库
*  api/lib/reslib 该目录下包含了访问database proxy代码所需要的元代码
*  api/lib/syslib 该目录UUID，MD5，COOKIE相关的库，也包括了Protobuf代码库    
        
## 8. 安装和启动 <a name="install"/>    
*  git clone https://github.com/changyuezhou/api_base.git
*  sudo ln -s ${PWD}/api_base /usr/local/nginx/example
*  sudo /usr/local/nginx/sbin/nginx -c ${PWD}/api_base/nginx/example.conf     