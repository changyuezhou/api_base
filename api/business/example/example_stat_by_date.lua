-- *********************************************************************************************************
-- author: zhouchangyue
-- QQ:   23199412
-- 文件实现了业务数据的查询,按日期统计记录数
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
        if ( nil ~= info.list[i].num) then
            info.list[i]["num"] = tonumber(info.list[i].num)
        end
        if ( nil ~= info.list[i].update_time) then
            info.list[i]["update_time"] = tonumber(info.list[i].update_time)
        end
    end
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
-- 函数功能: 按日期统计记录信息
-- 参数定义:
-- tbl: table对象 记录值,key-value形式对
-- 返回值:
-- result: bool 函数成功或者失败
-- errmsg: 失败是,返回失败描述信息
-- info: 成功时返回,对象信息
-- #########################################################################################################
function business:do_action(tbl)
    -- 生成查询使用的SQL语句

    local sql = "select count(*) as num,from_unixtime(create_time, '%Y-%m-%d') as register_date from t_example where create_time >=" .. tostring(tbl.begin_time) ..
            " and create_time <=" .. tostring(tbl.end_time) .. " group by register_date"
    local pages = business:make_pages(tbl)

    local dao = require "dao"
    local configure = require "configure"
    local LOG = require "log"
    LOG:DEBUG("query sql:" .. sql)
    local result,info = dao:query_by_sql(configure.DBCService, sql, pages)
    if false == result then
        if nil ~= info then
            LOG:ERROR("query sql:" .. sql .. " failed msg:" .. info)
        else
            LOG:ERROR("query sql:" .. sql .. " failed")
        end
        return false,info
    end
    local cjson = require "cjson"
    LOG:DEBUG("query sql:" .. sql .. " success response:" .. cjson.encode(info))

    business:results_string_to_number(info)

    return true, info
end

return business