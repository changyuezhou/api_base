#  开发人员代码规范
-------------------
## [1 关于文档](#about_doc)
## [2 命名](#var_function_name)
## [3 函数返回值](#function_return)
## [4 出错处理](#error_handling)
## [5 日志处理](#log_handling)

-------------------
## 1. 关于文档 <a name="about_doc"/>
   本文档作为开发人员编写LUA代码的规范说明，规定了命名规则，函数返回值处理规则，出错处理规则，日志处理规则

## 2. 命名 <a name="var_function_name"/>
### 变量命名
    变量命名都用小写字母，单词之间用下划线区分
### 函数命名
    函数命名都用小写字母，单词之间用下划线区分
    
## 3. 函数返回值 <a name="function_return"/>
    函数一定要有返回值，标明成功或者失败，失败时一定要带上失败信息，失败信息必须可以定位出问题代码
    
## 4. 出错处理 <a name="error_handling"/>
    函数返回失败后，一定要有错误判断和相应的处理逻辑，并且必须打印错误级别的日志
    
## 5. 日志处理 <a name="log_handling"/>
    遇到变量异常或者函数返回值失败时，一定要打印日志，异常的日志级别至少是WARN，如果影响到程序后面的执行
    一定要打印ERROR级别日志
    为方便调试，函数成功时，一定要打印一条DEBUG日志级别，有一些必要的信息，可以打印INFO级别，INFO级别在部署
    运行时也会有打印，WARN和ERROR可以触发邮件和短信报警  
    
     