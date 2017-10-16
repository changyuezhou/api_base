-- *********************************************************************************************************
-- author: zhouchangyue
-- QQ:   23199412
-- 文件实现了业务数据的逻辑检查,并调用数据库访问接口,将记录数据持久化到数据库
-- 函数命名必须为小写字母加下划线区分功能单词 例:do_action

-- 表t_example结构
-- CREATE TABLE `t_example` (
-- `id` varchar(128) NOT NULL DEFAULT '' COMMENT '会员ID',
-- `name` varchar(256) NOT NULL DEFAULT '' COMMENT '会员姓名',
-- `update_time` bigint(20) NOT NULL DEFAULT '0' COMMENT '更新时间',
-- `create_time` bigint(20) NOT NULL DEFAULT '0' COMMENT '创建时间',
-- PRIMARY KEY (`id`)
-- ) ENGINE=InnoDB DEFAULT CHARSET=utf8 MAX_ROWS=1000000 AVG_ROW_LENGTH=1000;
-- *********************************************************************************************************

local business = {}

-- #########################################################################################################
-- 函数名: results_string_to_number
-- 函数功能: 记录中字符字段转换为整型字段
-- 参数定义:
-- info: 查询对象信息
-- 返回值:
-- 无
-- #########################################################################################################
function business:results_string_to_number(info)
    if nil == info or nil == info.list then
        return
    end
    local num = #info.list
    for i = 1, num do
        if ( nil ~= info.list[i].create_time) then
            info.list[i]["create_time"] = tonumber(info.list[i].create_time)
        end
        if ( nil ~= info.list[i].update_time) then
            info.list[i]["update_time"] = tonumber(info.list[i].update_time)
        end
    end
end

-- #########################################################################################################
-- 函数名: make_conditions
-- 函数功能: 封装条件对象
-- 参数定义:
-- tbl: table对象 记录值,key-value形式对
-- 返回值:
-- conditions
-- #########################################################################################################
function business:make_conditions(tbl)
    local conditions = { item_tbl = {}, op_tbl = {} }
    if nil ~= tbl.id then
        conditions.item_tbl.id = tbl.id
    end

    if nil ~= tbl.name then
        conditions.item_tbl.name = tbl.name .. " LIKE"
    end

    local util = require "util"
    local num = util:table_length(conditions.item_tbl)
    if 0 >= num then
        conditions.item_tbl = nil
        conditions.op_tbl = nil
        return
    end

    for i = 1, (num - 1) do
        conditions.op_tbl[i] = 1
    end

    return conditions
end

-- #########################################################################################################
-- 函数名: make_order
-- 函数功能: 封装排序对象
-- 参数定义:
-- 无:
-- 返回值:
-- order: 排序对象,包含需要排序的字段和升降序
-- #########################################################################################################
function business:make_order()
    local order = {}
    -- 设置按时间排序 1 DES 2 ASC
    order.update_time = 1
    return order
end

-- #########################################################################################################
-- 函数名: make_pages
-- 函数功能: 封装分页对象
-- 参数定义:
-- tbl: table对象 记录值,key-value形式对
-- 返回值:
-- pages: 分页对象,包含分页码和页大小
-- #########################################################################################################
function business:make_pages(tbl)
    local pages = {}
    pages.page_number = tbl.page_number
    pages.page_size = tbl.page_size
    return pages
end

-- #########################################################################################################
-- 函数名: do_action
-- 函数功能: 查询列表信息
-- 参数定义:
-- tbl: table对象 记录值,key-value形式对
-- 返回值:
-- result: bool 函数成功或者失败
-- errmsg: 失败是,返回失败描述信息
-- info: 成功时返回,对象信息
-- #########################################################################################################
function business:do_action(tbl)
    -- 封装查询条件和排序字段以及分页
    local columns = {"id", "name", "update_time", "create_time" }
    local conditions = business:make_conditions(tbl)
    local order = business:make_order()
    local pages = business:make_pages(tbl)

    -- 查询
    local configure = require "configure"
    local dao = require "dao"
    local table_name = configure.DBCService.DB .. ".t_example"
    local LOG = require "log"
    local cjson = require "cjson"
    LOG:DEBUG("query table:" .. table_name .. " value:" .. cjson.encode(tbl))
    local result,info = dao:query(configure.DBCService, table_name, columns, conditions, pages, order)
    if false == result then
        LOG:ERROR("query table:" .. table_name .. " value:" .. cjson.encode(tbl) .. " failed msg:" .. info)
        return false,info
    end

    LOG:DEBUG("query table:" .. table_name .. " value:" .. cjson.encode(tbl) .. " response:" .. cjson.encode(info))
    if nil == info or nil == info.list or 0 >= #info.list then
        return false, "数据库无记录"
    end

    business:results_string_to_number(info)

    return true, info
end

return business

