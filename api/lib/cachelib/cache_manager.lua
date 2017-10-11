local util = require "util"
local cjson = require "cjson"
local TblPB = require "tbl_pb"
local sql_pb = require "sql_pb"
local db_manager = require "db_manager"
local Error = require "err"
local CacheManager = {}

CacheManager.pb_version = ""
CacheManager.pb_seq = ""

function CacheManager:encodeRequestHeader(request_pb, ver, seq)
  request_pb.version = ver
  request_pb.seq = seq
end

function CacheManager:sendToService(ip, port, request_pb, response)
  ngx.log(ngx.DEBUG, "sendToService begin...")
  CacheManager:encodeRequestHeader(request_pb, CacheManager.pb_version, CacheManager.pb_seq)
  local recv = {}
  local data = request_pb:SerializeToString()
  util.SendDataUseSocketSyncCatch(ip, port, data, recv)
  
  if nil == recv["data"] then
    response["code"] = Error.SERVER
	response["msg"] = "服务器没有响应。"
	ngx.log(ngx.ERR, "service no response!")
	return nil
  end
  return recv["data"]
end

function CacheManager:decodePbResponse(data, response)
  local service_response = sql_pb.Response()
  local success, res = pcall(service_response.ParseFromString,service_response,data)
  if not success then
    response["code"] = Error.SERVER
	response["msg"] = "服务器没有响应。"
	ngx.log(ngx.ERR, "service_response.ParseFromString error:"..res)
	return
  end
  ngx.log(ngx.DEBUG,"service_response is "..tostring(service_response))
  if nil == service_response.code then
    ngx.log(ngx.ERR,"service_response has no code "..tostring(service_response))
    return
  end
  
  if nil ~= service_response.msg then
    response["msg"] = service_response.msg
  end
  
  if nil ~= service_response.seq then
    response["seq"] = service_response.seq
  end
 
  if 0 ~= service_response.code then
	response["code"] = Error.DBIO
	ngx.log(ngx.WARN, "service_response code:"..service_response.code)
	return
  end
  
  response["code"] = service_response.code

  if nil ~= service_response.results then
	local record = {}
	TblPB:Pb2Tbl(record, service_response.results)
    if nil ~= record.records and 0 < #record.records then
	    ngx.log(ngx.DEBUG, "record is "..cjson.encode(record))
	    local web_tbl = {}
	    db_manager:sqlRecords2Tbl(record, web_tbl)
	    response["data"] = {}
	    response["data"]["data"] = {}
	    local num = #web_tbl.name
	    for i = 1, num do
            table.insert(response["data"]["data"],web_tbl.name[i])
        end
    end
  end
  if nil ~= service_response.pages then
	local pages_tbl = {}
	TblPB:Pb2Tbl(pages_tbl, service_response.pages)
    if (nil ~= pages_tbl.page_number) then
	    ngx.log(ngx.DEBUG, "pages_tbl is "..cjson.encode(pages_tbl))
	    if nil == response["data"] then
	        response["data"] = {}
	    end
	    response["data"]["page_number"] = pages_tbl.page_number
	    response["data"]["page_size"] = pages_tbl.page_size
	    response["data"]["total_number"] = pages_tbl.total_number
    end
  end
end

function CacheManager:add(db_conf, rec_tbl, response, tbl_name)
  local sql_pb_request = sql_pb.Request()
  db_manager:sqlTbl2PbAdd(sql_pb_request.sql, rec_tbl, tbl_name)
  ngx.log(ngx.DEBUG,"sql_pb_request.sql: " .. tostring(sql_pb_request.sql))
  local recvData = CacheManager:sendToService(db_conf.IP, db_conf.PORT, sql_pb_request, response)
  if nil ~= recvData then
    CacheManager:decodePbResponse(recvData, response)
  end
end

function CacheManager:update(db_conf, rec_tbl, response,tbl_name, con_tbl)
  local sql_pb_request = sql_pb.Request()
  db_manager:sqlTbl2PbUpdate(sql_pb_request.sql, rec_tbl, tbl_name, con_tbl)
  local recvData = CacheManager:sendToService(db_conf.IP, db_conf.PORT, sql_pb_request, response)
  if nil ~= recvData then
    CacheManager:decodePbResponse(recvData, response)
  end
end

function CacheManager:queryTbl(db_conf, response,tbl_name,column_tbl,con_tbl,pages_tbl,order_tbl,group_tbl,having_tbl)
  local sql_pb_request = sql_pb.Request()
  db_manager:sqlTbl2PbQuery(sql_pb_request.sql, tbl_name, column_tbl, con_tbl, pages_tbl,order_tbl, group_tbl, having_tbl)
  local recvData = CacheManager:sendToService(db_conf.IP, db_conf.PORT, sql_pb_request, response)
  if nil ~= recvData then
    CacheManager:decodePbResponse(recvData, response)
  end
end

function CacheManager:delete(db_conf, response, tbl_name, con_tbl)
  local sql_pb_request = sql_pb.Request()
  db_manager:sqlTbl2PbDelete(sql_pb_request.sql, tbl_name, con_tbl)
  local recvData = CacheManager:sendToService(db_conf.IP, db_conf.PORT, sql_pb_request, response)
  if nil ~= recvData then
    CacheManager:decodePbResponse(recvData, response)
  end
end

function CacheManager:queryBySQL(db_conf, response, tbl_name, sql_str, pages_tbl)
    local sql_pb_request = sql_pb.Request()
    db_manager:sqlTbl2PbQueryBySQL(sql_pb_request.sql, tbl_name, sql_str, pages_tbl)
    local recvData = CacheManager:sendToService(db_conf.IP, db_conf.PORT, sql_pb_request, response)
    if nil ~= recvData then
        CacheManager:decodePbResponse(recvData, response)
    end
end

function CacheManager:executeBySQL(db_conf, response, tbl_name, sql_str)
    local sql_pb_request = sql_pb.Request()
    db_manager:sqlTbl2PbExecuteBySQL(sql_pb_request.sql, tbl_name, sql_str)
    local recvData = CacheManager:sendToService(db_conf.IP, db_conf.PORT, sql_pb_request, response)
    if nil ~= recvData then
        CacheManager:decodePbResponse(recvData, response)
    end
end

return CacheManager
