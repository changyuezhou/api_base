-- *********************************************************************************************************
-- auth: zhouchangyue
-- QQ:   23199412
-- 文件实现了Cache Service Access的第二层
-- 函数命名必须为小写字母加下划线区分功能单词 例: encode_request_header
-- *********************************************************************************************************

local TblPB = require "tbl_pb"
local sql = require "sql"
local util = require "util"
local db_manager = {db = sql:new()}

function db_manager:initialize_sql()
  db_manager.db:init()
end

function db_manager:build_add(web_tbl, tbl_name)
  db_manager:initialize_sql()
  db_manager.db:add_operation(1) --add
  db_manager.db:add_table(tbl_name)
  db_manager.db:add_record(web_tbl)
end

function db_manager:build_update(web_tbl, tbl_name, cond_tbl)
  db_manager:initialize_sql()
  db_manager.db:add_operation(2) --update
  db_manager.db:add_table(tbl_name)
  db_manager.db:add_record(web_tbl)
  if ( nil ~= cond_tbl) then
    db_manager.db:add_condition(cond_tbl)
  end
end

function db_manager:build_query(tbl_name, column_tbl, cond_tbl, order_tbl, group_tbl, pages_tbl, having_tbl)
  db_manager:initialize_sql()
  db_manager.db:add_operation(4) --query
  db_manager.db:add_table(tbl_name)
  if ( nil ~= column_tbl) then
    db_manager.db:add_column_list(column_tbl)
  end

  if ( nil ~= cond_tbl ) then
    db_manager.db:add_condition(cond_tbl)
  end
  if ( nil ~= group_tbl) then
    db_manager.db:add_group(group_tbl)
  end
  if ( nil ~= order_tbl) then
    db_manager.db:add_order(order_tbl)
  end
  if ( nil ~= having_tbl) then
    db_manager.db:add_having(having_tbl)
  end
  if ( nil ~= pages_tbl) then
    db_manager.db:add_pages(pages_tbl)
  end
end

function db_manager:build_delete(tbl_name, cond_tbl)
  db_manager:initialize_sql()
  db_manager.db:add_operation(3) --delete
  db_manager.db:add_table(tbl_name)
  if nil ~= cond_tbl then
    db_manager.db:add_condition(cond_tbl)
  end
end

function db_manager:build_execute_sql(db_name, web_execute_str)
  db_manager:initialize_sql()
  db_manager.db:add_operation(5) --execute_sql
  db_manager.db:add_table(db_name .. ".*")
  db_manager.db:add_execute_sql(web_execute_str)
end

function db_manager:build_query_sql(db_name, web_query_str, pages_tbl)
  db_manager:initialize_sql()
  db_manager.db:add_operation(6) --query_sql
  db_manager.db:add_table(db_name .. ".*")
  db_manager.db:add_execute_sql(web_query_str)
  if ( nil ~= pages_tbl) then
    db_manager.db:add_pages(pages_tbl)
  end
end

function db_manager:sql2pb(pb_tbl)
  if nil ~= db_manager.db.column_list and util.is_empty_table(db_manager.db.column_list) then
    db_manager.db.column_list = nil
  end
  if nil ~= db_manager.db.record and util.is_empty_table(db_manager.db.record) then
    db_manager.db.record = nil
  end
  if nil ~= db_manager.db.condition and util.is_empty_table(db_manager.db.condition) then
    db_manager.db.condition = nil
  end
  if nil ~= db_manager.db.group and util.is_empty_table(db_manager.db.group) then
    db_manager.db.group = nil
  end
  if nil ~= db_manager.db.order and util.is_empty_table(db_manager.db.order) then
    db_manager.db.order = nil
  end
  if nil ~= db_manager.db.having and util.is_empty_table(db_manager.db.having) then
    db_manager.db.having = nil
  end
  if nil ~= db_manager.db.pages and util.is_empty_table(db_manager.db.pages) then
    db_manager.db.pages = nil
  end
  TblPB:tbl_to_pb(pb_tbl, db_manager.db)
end

function db_manager:sql_tbl_to_pb_add(pb_tbl, web_tbl, tbl_name)
  db_manager:build_add(web_tbl, tbl_name)
  db_manager:sql2pb(pb_tbl)
end

function db_manager:sql_tbl_to_pb_update(pb_tbl, web_tbl, tbl_name, cond_tbl)
  db_manager:build_update(web_tbl, tbl_name, cond_tbl)
  db_manager:sql2pb(pb_tbl)
end

function db_manager:sql_tbl_to_pb_query(pb_tbl, tbl_name, column_tbl, cond_tbl, pages_tbl, order_tbl, group_tbl, having_tbl)
  db_manager:build_query(tbl_name, column_tbl, cond_tbl, order_tbl, group_tbl, pages_tbl, having_tbl)
  db_manager:sql2pb(pb_tbl)
end

function db_manager:sql_tbl_to_pb_delete(pb_tbl, tbl_name, cond_tbl)
  db_manager:build_delete(tbl_name, cond_tbl)
  db_manager:sql2pb(pb_tbl)  
end

function db_manager:sql_tbl_to_pb_query_by_sql(pb_tbl, db_name, sql_str, pages_tbl)
  db_manager:build_query_sql(db_name, sql_str, pages_tbl)
  db_manager:sql2pb(pb_tbl)
end

function db_manager:sql_tbl_to_pb_execute_by_sql(pb_tbl, db_name, sql_str)
  db_manager:build_execute_sql(db_name, sql_str)
  db_manager:sql2pb(pb_tbl)
end

function db_manager:sql_key_value_to_tbl(record_tbl_name, web_tbl_name)
  local num = #record_tbl_name
  for i = 1, num do
    local key = record_tbl_name[i].column
	local value = record_tbl_name[i].value
	web_tbl_name[key] = value
  end
end

function db_manager:sql_records_to_tbl(record_tbl, web_tbl)
  web_tbl.name = {}
  if nil ~= record_tbl.records then
    local num = #record_tbl.records
	for i = 1, num do
	  web_tbl.name[i] = {}
	  db_manager:sql_key_value_to_tbl(record_tbl.records[i].name, web_tbl.name[i])
	end
  end
end

return db_manager
