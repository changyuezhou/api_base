-- *********************************************************************************************************
-- auth: zhouchangyue
-- QQ:   23199412
-- 文件实现了访问Database Proxy Service的接口
-- 函数命名必须为小写字母加下划线区分功能单词 例: query_by_view
-- *********************************************************************************************************

local cache_manager = require "cache_manager"
local dao = {}

function dao:add(db_proxy, table, columns)
    local result,errmsg = cache_manager:add(db_proxy, table, columns)
    return result, errmsg
end

function dao:update(db_proxy, table, columns, conditions)
    local result,errmsg = cache_manager:update(db_proxy, table, columns, conditions)
    return result, errmsg
end

function dao:query(db_proxy, table, columns, conditions, pages, orders, groups, havings)
    local result,data,errmsg = cache_manager:query(db_proxy, table, columns,
        conditions, pages, orders, groups, havings)
    return result,data,errmsg
end

function dao:delete(db_proxy, table, conditions)
    local result,errmsg =  cache_manager:delete(db_proxy, table, conditions)
    return result, errmsg
end

function dao:query_by_sql(db_proxy, sql_str, pages)
    local result,data,errmsg = cache_manager:query_by_sql(db_proxy,
        db_proxy.DB, sql_str, pages)
    return result,data,errmsg
end

function dao:execute_by_sql(db_proxy, sql_str)
    local result,data,errmsg = cache_manager:execute_by_sql(db_proxy,
        db_proxy.DB, sql_str)
    return result,data,errmsg
end

return dao

