-- *********************************************************************************************************
-- auth: zhouchangyue
-- QQ:   23199412
-- 文件实现了Cache Service Access的第一层
-- 函数命名必须为小写字母加下划线区分功能单词 例: encode_request_header
-- *********************************************************************************************************

local sql_pb = require "sql_pb"
local db_manager = require "db_manager"
local CacheManager = {}
local util = require "util"

CacheManager.pb_version = ""
CacheManager.pb_seq = ""

function CacheManager:encode_request_header(request_pb, ver, seq)
    request_pb.version = ver
    request_pb.seq = seq
end

function CacheManager:send_to_service(ip, port, request_pb)
    CacheManager:encode_request_header(request_pb, CacheManager.pb_version, CacheManager.pb_seq)
    local data = request_pb:SerializeToString()
    local result,recieve_data = util:send_data_use_socket_sync(ip, port, data, 3)
    return result, recieve_data
end

function CacheManager:decode_pb_response(data)
    local service_response = sql_pb.Response()
    local success, res = pcall(service_response.ParseFromString,service_response,data)
    if not success then
	    return false, "服务器返回数据格式错误"
    end
    if nil == service_response.code then
        return false, "服务器没有返回状态码"
    end
  
    if 0 ~= service_response.code and nil ~= service_response.msg then
        return false, service_response.msg
    end

    local response = {}
    if nil ~= service_response.results then
	    local record = {}
        local TblPB = require "tbl_pb"
	    TblPB:pb_to_tbl(record, service_response.results)
        if nil ~= record.records and 0 < #record.records then
	        local web_tbl = {}
	        response.list = {}
	        db_manager:sql_records_to_tbl(record, web_tbl)
	        local num = #web_tbl.name
	        for i = 1, num do
                table.insert(response.list, web_tbl.name[i])
            end
        end
    end
    if nil ~= service_response.pages then
	    local pages_tbl = {}
        local TblPB = require "tbl_pb"
	    TblPB:pb_to_tbl(pages_tbl, service_response.pages)
        if (nil ~= pages_tbl.page_number) then
	        response.page_number = pages_tbl.page_number
	        response.page_size = pages_tbl.page_size
	        response.total_number = pages_tbl.total_number
        end
    end

    return true, response
end

function CacheManager:add(db_conf, tbl_name, columns)
    local sql_pb_request = sql_pb.Request()
    db_manager:sql_tbl_to_pb_add(sql_pb_request.sql, columns, tbl_name)
    local result, data = CacheManager:send_to_service(db_conf.IP, db_conf.PORT, sql_pb_request)
    if false == result then
        return result, data
    end
    local result,errmsg = CacheManager:decode_pb_response(data)

    return result, errmsg
end

function CacheManager:update(db_conf, tbl_name, columns, conditions)
  local sql_pb_request = sql_pb.Request()
  db_manager:sql_tbl_to_pb_update(sql_pb_request.sql, columns, tbl_name, conditions)
  local result, data = CacheManager:send_to_service(db_conf.IP, db_conf.PORT, sql_pb_request)
  if false == result then
      return result, data
  end
  local result,errmsg = CacheManager:decode_pb_response(data)

  return result, errmsg
end

function CacheManager:query(db_conf,tbl_name,columns,conditions,pages,orders,groups,havings)
    local sql_pb_request = sql_pb.Request()
    db_manager:sql_tbl_to_pb_query(sql_pb_request.sql, tbl_name, columns, conditions, pages,orders, groups, havings)
    local result, data = CacheManager:send_to_service(db_conf.IP, db_conf.PORT, sql_pb_request)
    if false == result then
        return result, data
    end
    local result, records = CacheManager:decode_pb_response(data)

    return result, records
end

function CacheManager:delete(db_conf, tbl_name, conditions)
  local sql_pb_request = sql_pb.Request()
  db_manager:sql_tbl_to_pb_delete(sql_pb_request.sql, tbl_name, conditions)
  local result, data = CacheManager:send_to_service(db_conf.IP, db_conf.PORT, sql_pb_request)
  if false == result then
      return result, data
  end
  local result,errmsg = CacheManager:decode_pb_response(data)

  return result, errmsg
end

function CacheManager:query_by_sql(db_conf, db, sql_str, pages)
    local sql_pb_request = sql_pb.Request()
    db_manager:sql_tbl_to_pb_query_by_sql(sql_pb_request.sql, db, sql_str, pages)
    local result, data = CacheManager:send_to_service(db_conf.IP, db_conf.PORT, sql_pb_request)
    if false == result then
        return result, data
    end
    local result, records = CacheManager:decode_pb_response(data)

    return result, records
end

function CacheManager:execute_by_sql(db_conf, db, sql_str)
    local sql_pb_request = sql_pb.Request()
    db_manager:sql_tbl_to_pb_execute_by_sql(sql_pb_request.sql, db, sql_str)
    local result, data = CacheManager:send_to_service(db_conf.IP, db_conf.PORT, sql_pb_request)
    if false == result then
        return result, data
    end
    local result, records = CacheManager:decode_pb_response(data)

    return result, records
end

return CacheManager
