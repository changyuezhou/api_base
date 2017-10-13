-- *********************************************************************************************************
-- author: zhouchangyue
-- QQ:   23199412
-- LOG的定义
-- *********************************************************************************************************

local LOG = {}

function LOG:DEBUG(str)
    ngx.log(ngx.DEBUG, str)
end

function LOG:WARN(str)
    ngx.log(ngx.WARN, str)
end

function LOG:ERROR(str)
    ngx.log(ngx.ERR, str)
end

function LOG:FATAL(str)
ngx.log(ngx.FATAL, str)
end

return LOG

