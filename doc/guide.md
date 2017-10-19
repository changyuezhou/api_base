#  后台开发人员入职指南
-------------------
## [1 关于文档](#about_doc)
## [2 开发环境](#dev_env)
## [3 服务器环境](#service_env)
## [4 学习过程](#study_progress)
## [5 开发流程](#dev_progress)
## [6 调试帮助](#debug_progress)
## [7 常用Linux操作命令](#used_shell)
## [8 需要完成的任务](#do_action)

-------------------
## 1. 关于文档 <a name="about_doc"/>
*   本文档作为开发人员入职指南，介绍了工作环境的搭建，基础工作环境的运行，调试，供新员工快速进入工作角色
   
## 2. 开发环境 <a name="dev_env"/>   
*   后端开发代码编辑器 Intelij IDE CE 版本
*   前端开发编码编辑器 sublime 
*   登录服务器终端  putty
*   远程连接服务器  smb（windows自带）
*   文本编辑器  notepad++
*   浏览器    chrome
*   API 调试工具  postman
*   沟通工具  wechat （建议安装 PC 版本）
*   LUA  运行环境
   
## 3. 服务器环境 <a name="service_env"/>  
*  操作系统     SUSE Linux
*  WEB服务器    Nginx
*  API代码      LUA
*  数据库       MySQL
*  数据库代理    DBC

## 4. 学习过程 <a name="study_progress"/>  
*  向主管领导申请开通开发账号和密码，开启新的工作之旅
*  工程样例代码： https://github.com/changyuezhou/api_base
*  变量使用 ${VAR} 这样的样式，需要替换成真实的目录或者值
*  1 登录开发服务器，使用主管分配给自己的用户名和密码,ssh ${USER}@101.37.253.12,输入密码.
*  2 在自己的home目录下 git clone https://github.com/changyuezhou/api_base.git 按照安装指南运行命令.
*  3 切换分支,cd api_base 进入代码目录 git checkout feature/${USER},切换好之后，拉取最新代码: git pull ,回到上级目录 cd ..;
*  4 使用命令: sudo ln -s /home/${USER}/api_base /usr/local/nginx/example_${USER}
*  5 修改 api_base/nginx/example.conf 文件中的端口号，在文件第50行，选择一个未使用的端口号，不然nginx实例启动会失败
*  6 修改一下 api_base/nginx/example.conf 文件中初始化文件路径, 在第45行 将路径 /usr/local/nginx/example/api/initial/init.lua; 修改为 /usr/local/nginx/example_${USER}/api/initial/init.lua;
*  7 修改一下 api_base/nginx/example.conf 文件中LOG路径, 在第69行 将路径 /usr/local/nginx/example/logs/example_api_nginx_debug.log; 修改为 /usr/local/nginx/example_${USER}/logs/example_api_nginx_debug.log;
*  8 修改一下 api_base/nginx/example.conf 文件中接口路径, 在第74行 将路径 /usr/local/nginx/example/api/interface/example.lua; 修改为 /usr/local/nginx/example_${USER}/api/interface/example.lua;
*  9 修改 api_base/api/initial目录下 init.lua 文件：将 HOME_DIR 由/usr/local/nginx/example/api 修改为 /usr/local/nginx/example_${USER}/api
*  10 启动 nginx 实例：sudo /usr/local/nginx/sbin/nginx -c /usr/local/nginx/example_${USER}/nginx/example.conf
*  11 使用 Postman 访问接口 http://${SERVICE_IP}:${PORT}/interface/example/${OP} OP可以为 add,update,query,delete
     请求方式为 POST 
*  12 自己修改代码，尝试着看看修改后的效果,记住只修改 interface和business目录下的代码,interface目录下的代码处理api参数检查
     business目录下的代码处理数据库业务逻辑    
     
## 5. 开发流程 <a name="dev_progress"/>
*  1  了解API接口定义,主要看接口需要哪些参数传入，接口会返回哪些数据
*  2  了解数据库表结构定义，需要知道表结构需要哪些字段，每个字段的含义是什么，字段可以从哪里取值
*  3  复制 interface目录下example.lua,修改文件名为要做的功能接口名字
*  4  修改刚刚复制的文件代码，从注释到内部字段定义修改，只需要按照接口修改参数检查代码即可，如果有新的接口定义，需要增加新的检查函数
*  5  在business目录下，创建新的功能模块文件夹，然后复制example目录下的文件到新的文件夹下，按个修改文件名为新模块文件命名
*  6  从example_add开始修改文件，直到query_stat_by_date文件，如果不需要的功能文件，可以去掉
*  7  全部修改完成后，使用Postman调试工具，测试接口，修正BUG，再调试直至完成接口功能
*  8  调试过程中请验证数据库中数据是否有问题      
     
## 6. 调试帮助 <a name="debug_progress"/>     
*  1  调试过程中需要问题，需要查看 example_conf 中配置的日志路径文件,样例中为: /usr/local/nginx/example/logs/example_api_nginx_debug.log;
*  2  打开日志文件,LUA代码错误会有错误提示，直接查看即可
*  3  如果是逻辑错误，需要用LOG模块打印日志,将变量和函数返回值打印出来，方便定位问题

## 7. 常用Linux操作命令 <a name="used_shell"/> 
*  1  登录服务器: ssh -p ${PORT} ${USER}@${IP} ssh默认端口22，无需输入，用户名和IP替换掉即可
*  2  查看LOG文件方式，1） cat ${FILE}，显示全部LOG,tail -n ${NUM} ${FILE} 显示文件末尾n行日志，tailf ${FILE} 显示文件末尾日志，并不断追加新日志
*  3  cd ${DIR} 切换目录
*  4  启动 Nginx： /usr/local/nginx/sbin/nginx -c ${CONF},重新加载 Nginx 配置文件:/usr/local/nginx/sbin/nginx -c ${CONF} -s reload
*  5  连接 Mysql 服务器: mysql -h ${IP} -u ${USER} -p ,输入密码即可
*  6  查看数据库库名： show databases;
*  7  查看数据库表名: show tables;
*  8  选择数据库: use ${DATABASE};
*  9  表查询: select * from ${TABLE} \G; 查看全部记录；select * from ${TABLE} where ${COLUMN} = '' \G;按条件查询;
*  10 表写入记录: insert into ${TABLE} (${COLUMNS}) values(${VALUES});
*  11 表修改记录: update ${TABLE} set ${COLUMN}='${VALUE}' where ${COLUMN}='${COLUMN}'; 修改记录千万记住加条件，不然全表修改，你就要请喝咖啡了
*  12 表删除记录: delete ${TABLE} where ${COLUMN}='${COLUMN}'; 删除记录千万记住加条件，不然全表删除，你就要请我们去中山路锦江大酒店吃烤鸭了
*  13 dbc 启动命令: sudo /usr/local/dbc/bin/start.sh;dbc 停止命令: sudo /usr/local/dbc/bin/stop.sh

## 8. 需要完成的任务 <a name="do_action"/> 
*  前提：以上内容都需要亲自动手做一遍
*  完成 https://github.com/changyuezhou/api_base/blob/master/doc/example.md 学生管理接口，完成后需要用 git 提交代码，由主管review.