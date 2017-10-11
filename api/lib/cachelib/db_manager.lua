local TblPB = require "tbl_pb"
local sql = require "sql"
local util = require "util"
local cjson = require "cjson"
local db_manager = {db = sql:new()}

function db_manager:initializeSql()
  db_manager.db:init()
end

function db_manager:buildSqlJsTblAdd(web_tbl, tbl_name)
  db_manager:initializeSql()
  db_manager.db:addOperation(1) --add
  db_manager.db:addTable(tbl_name)
  db_manager.db:addRecord(web_tbl)
end

function db_manager:buildSqlJsTblUpdate(web_tbl, tbl_name, cond_tbl)
  db_manager:initializeSql()
  db_manager.db:addOperation(2) --update
  db_manager.db:addTable(tbl_name)
  db_manager.db:addRecord(web_tbl)
  if ( nil ~= cond_tbl) then
    db_manager.db:addCondition(cond_tbl)
  end
end

function db_manager:buildSqlJsTblQuery(tbl_name, column_tbl, cond_tbl, order_tbl, group_tbl, pages_tbl, having_tbl)
  db_manager:initializeSql()
  db_manager.db:addOperation(4) --query
  db_manager.db:addTable(tbl_name)
  if ( nil ~= column_tbl) then
    db_manager.db:addColumnList(column_tbl)
  end
  if ( nil ~= cond_tbl ) then
    db_manager.db:addCondition(cond_tbl)
  end
  if ( nil ~= group_tbl) then
    db_manager.db:addGroup(group_tbl)
  end
  if ( nil ~= order_tbl) then
    db_manager.db:addOrder(order_tbl)
  end
  if ( nil ~= having_tbl) then
    db_manager.db:addHaving(having_tbl)
  end
  if ( nil ~= pages_tbl) then
    db_manager.db:addPages(pages_tbl)
  end
end

function db_manager:buildSqlJsTblDelete(tbl_name, cond_tbl)
  db_manager:initializeSql()
  db_manager.db:addOperation(3) --delete
  db_manager.db:addTable(tbl_name)
  if nil ~= cond_tbl then
    db_manager.db:addCondition(cond_tbl)
  end
end

function db_manager:buildSqlJsTblExecuteSql(db_name, web_execute_str)
  db_manager:initializeSql()
  db_manager.db:addOperation(5) --execute_sql
  db_manager.db:addTable(db_name .. ".*")
  db_manager.db:addExecuteSql(web_execute_str)
end

function db_manager:buildSqlJsTblQuerySql(db_name, web_query_str, pages_tbl)
  db_manager:initializeSql()
  db_manager.db:addOperation(6) --query_sql
  db_manager.db:addTable(db_name .. ".*")
  db_manager.db:addExecuteSql(web_query_str)
  if ( nil ~= pages_tbl) then
    db_manager.db:addPages(pages_tbl)
  end
end

function db_manager:sql2pb(pb_tbl)
  if nil ~= db_manager.db.column_list and util.isEmptyTable(db_manager.db.column_list) then
    db_manager.db.column_list = nil
  end
  if nil ~= db_manager.db.record and util.isEmptyTable(db_manager.db.record) then
    db_manager.db.record = nil
  end
  if nil ~= db_manager.db.condition and util.isEmptyTable(db_manager.db.condition) then
    db_manager.db.condition = nil
  end
  if nil ~= db_manager.db.group and util.isEmptyTable(db_manager.db.group) then
    db_manager.db.group = nil
  end
  if nil ~= db_manager.db.order and util.isEmptyTable(db_manager.db.order) then
    db_manager.db.order = nil
  end
  if nil ~= db_manager.db.having and util.isEmptyTable(db_manager.db.having) then
    db_manager.db.having = nil
  end
  if nil ~= db_manager.db.pages and util.isEmptyTable(db_manager.db.pages) then
    db_manager.db.pages = nil
  end
  ngx.log(ngx.DEBUG, "db_manager.db :"..cjson.encode(db_manager.db))
  TblPB:Tbl2Pb(pb_tbl, db_manager.db)
end

function db_manager:sqlTbl2PbAdd(pb_tbl, web_tbl, tbl_name)
  db_manager:buildSqlJsTblAdd(web_tbl, tbl_name)
  db_manager:sql2pb(pb_tbl)
end

function db_manager:sqlTbl2PbUpdate(pb_tbl, web_tbl, tbl_name, cond_tbl)
  db_manager:buildSqlJsTblUpdate(web_tbl, tbl_name, cond_tbl)
  db_manager:sql2pb(pb_tbl)
end

function db_manager:sqlTbl2PbQuery(pb_tbl, tbl_name, column_tbl, cond_tbl, pages_tbl, order_tbl, group_tbl, having_tbl)
  db_manager:buildSqlJsTblQuery(tbl_name, column_tbl, cond_tbl, order_tbl, group_tbl, pages_tbl, having_tbl)
  db_manager:sql2pb(pb_tbl)
end

function db_manager:sqlTbl2PbDelete(pb_tbl, tbl_name, cond_tbl)
  db_manager:buildSqlJsTblDelete(tbl_name, cond_tbl)
  db_manager:sql2pb(pb_tbl)  
end

function db_manager:sqlTbl2PbQueryBySQL(pb_tbl, db_name, sql_str, pages_tbl)
  db_manager:buildSqlJsTblQuerySql(db_name, sql_str, pages_tbl)
  db_manager:sql2pb(pb_tbl)
end

function db_manager:sqlTbl2PbExecuteBySQL(pb_tbl, db_name, sql_str)
  db_manager:buildSqlJsTblExecuteSql(db_name, sql_str)
  db_manager:sql2pb(pb_tbl)
end

function db_manager:sqlKeyValue2Tbl(record_tbl_name, web_tbl_name)
  local num = #record_tbl_name
  for i = 1, num do
    local key = record_tbl_name[i].column
	local value = record_tbl_name[i].value
	web_tbl_name[key] = value
  end
end

function db_manager:sqlRecords2Tbl(record_tbl, web_tbl)
  web_tbl.name = {}
  if nil ~= record_tbl.records then
    local num = #record_tbl.records
	for i = 1, num do
	  web_tbl.name[i] = {}
	  db_manager:sqlKeyValue2Tbl(record_tbl.records[i].name, web_tbl.name[i])
	end
  end
end

return db_manager
