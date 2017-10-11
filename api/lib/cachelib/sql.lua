-- *********************************************************************************************************
-- auth: zhouchangyue
-- QQ:   23199412
-- 文件实现了Cache Service Access的第三层
-- 函数命名必须为小写字母加下划线区分功能单词 例: encode_request_header
-- *********************************************************************************************************

local util = require "util"
local cjson = require "cjson"
local SQL = {}
function SQL:serialize(obj)
  local str = ""
  local t = type(obj)
  if t == "number" then
    str = str .. obj
  elseif t == "string" then
    str = str .. obj
  elseif t == "table" then
    str = str .. SQL:serialize_tbl(obj)
  elseif t == "nil" then
    return nil
  else
    return "unknown type"
  end
  return str
end

function SQL:serialize_tbl(tbl)
  local str = ""
  local num = #tbl
  if num == 0 then
    str = str .. "\"{"
	for k, v in pairs(tbl) do
	  str = str .. "\"".. k.. "\""..":"
	  if type(v) == "table" then
		str = str .. "\"" .. SQL:serialize_tbl(v) .. "\","
	  end
    end
    str = str .. "}\""
  else
    str = str .. "\"["
	for i = 1, num do
	  str = str .. SQL:serialize(tbl[i])..","
	end
	str = str .. "]\""
  end
  return str
end

function SQL:sql_key_value(web_tbl, sql_tbl_name)
  if (nil == web_tbl) then
    return
  end
  for k,v in pairs(web_tbl) do
	local tmp = {}
	  tmp.column = k
	  if type(v) == "table" then
		tmp.value = cjson.encode(v)
	  else
	    tmp.value = tostring(v)
	  end
	  table.insert(sql_tbl_name,tmp)
	end
end

function SQL:sql_records_array(web_tbl_array, sql_tbl_records)
  local num  = #web_tbl_array
  if num == 0 then
    sql_tbl_records[1] = {}
	sql_tbl_records[1].name = {}
    SQL:sql_key_value(web_tbl_array, sql_tbl_records[1].name )
	
	return
  end
  for i = 1, num do
    sql_tbl_records[i] = {}
	sql_tbl_records[i].name = {}
    SQL:sql_key_value(web_tbl_array[i], sql_tbl_records[i].name )
  end 
end

function SQL:sql_records(web_tbl_array, sql_tbl_record)
  if (nil == web_tbl_array) then
    return
  end
  sql_tbl_record.records = {}
  SQL:sql_records_array(web_tbl_array, sql_tbl_record.records)
end

function SQL:sql_comb_condition(web_comb_cond_tbl, sql_comb_tbl_condition)
  local num = #web_comb_cond_tbl.item_tbl
  sql_comb_tbl_condition.condition = {}
  sql_comb_tbl_condition.operation = {}
  for i = 1, num do
    sql_comb_tbl_condition.condition[i] = {}
    SQL:sql_condition(web_comb_cond_tbl.item_tbl[i], sql_comb_tbl_condition.condition[i] )
  end
  for i = 1, #web_comb_cond_tbl.op_tbl do
    table.insert(sql_comb_tbl_condition.operation, web_comb_cond_tbl.op_tbl[i])
  end
end

function SQL:sql_condition(web_cond_tbl, sql_tbl_condition)
  sql_tbl_condition.item = {}
  sql_tbl_condition.operation = {}
  if nil == web_cond_tbl.item_tbl then
    return
  end
  for k, v in pairs(web_cond_tbl.item_tbl) do
      local tmp = {}
      tmp.column = k
      tmp.val = tostring(v)
      local val_length = string.len(tmp.val)
      if type(v) == "string" then
          --if string.find(v, "%b()" ) then
          if string.find(v, " IN" , val_length - 3) then
              tmp.operation = 9 --IN
              tmp.val = string.sub(v,1,-4)
          elseif string.find(v, " like", val_length - 5) then
              tmp.operation = 8 --like
              tmp.val = "%"..string.sub(v,1,-6).."%"
          elseif string.find(v, " LIKE", val_length - 5) then
              tmp.operation = 8 --like
              tmp.val = "%"..string.sub(v,1,-6).."%"
          elseif string.find(v, " BE", val_length - 3) then
              tmp.operation = 7 --between
              tmp.val = string.sub(v,1,-4)
          elseif string.find(v, " NE", val_length - 3) then
              tmp.operation = 2 --not equal
              tmp.val = string.sub(v,1,-4)
          elseif string.find(v, " EGT", val_length - 4) then
              tmp.operation = 4 --EGT
              tmp.val = string.sub(v,1,-5)
          elseif string.find(v, " GT", val_length - 3) then
              tmp.operation = 3 --GT
              tmp.val = string.sub(v,1,-4)
          elseif string.find(v, " ELT", val_length - 4) then
              tmp.operation = 6 --ELT
              tmp.val = string.sub(v,1,-5)
          elseif string.find(v, " LT", val_length - 3) then
              tmp.operation = 5 --LT
              tmp.val = string.sub(v,1,-4)
          elseif string.find(v, " NOT_IN", val_length - 7) then
              tmp.operation = 10 --ELT
              tmp.val = string.sub(v,1,-8)
          else
              tmp.operation = 1 --EQ
          end
      else
          tmp.operation = 1 --EQ
      end
      table.insert(sql_tbl_condition.item, tmp)
  end

  if nil ~= web_cond_tbl.op_tbl and util.is_empty_table(web_cond_tbl.op_tbl) then
    sql_tbl_condition.operation = nil
  elseif nil ~= web_cond_tbl.op_tbl then
    for i = 1, #web_cond_tbl.op_tbl do
      table.insert(sql_tbl_condition.operation, web_cond_tbl.op_tbl[i])
    end
  end
end

function SQL:sql_order(web_order_tbl, sql_tbl_order)
  if nil == web_order_tbl then
    return
  end
  for k, v in pairs(web_order_tbl) do
    local tmp = {}
	tmp.name = k
	tmp.sort = v
	table.insert(sql_tbl_order, tmp)
  end
end

function SQL:sql_column_list(web_column_tbl, sql_tbl_column)
  local num = #web_column_tbl
  for i = 1, num do
    table.insert(sql_tbl_column, web_column_tbl[i])
  end
end

function SQL:sql_group(web_group_tbl, sql_tbl_group)
  local num = #web_group_tbl
  for i = 1, num do
    table.insert(sql_tbl_group, web_group_tbl[i])
  end
end

function SQL:sql_having(web_having_tbl, sql_tbl_having)
  SQL:sql_condition(web_having_tbl, sql_tbl_having.condition)
end

function SQL:sql_pages(web_pages_tbl, sql_tbl_pages)
  sql_tbl_pages.page_number = web_pages_tbl.page_number
  sql_tbl_pages.page_size = web_pages_tbl.page_size
  sql_tbl_pages.total_number = web_pages_tbl.total_number
end

function SQL:new()
  local o = {}
  o.operation = 0
  o.table = ""
  o.column_list = {}
  o.record = {}
  o.condition = {}
  o.group = {}
  o.order = {}
  o.having = {}
  o.execute_sql = ""
  o.pages = {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function SQL:init()
  self.column_list = {}
  self.record = {}
  self.condition = {}
  self.group = {}
  self.order = {}
  self.having = {}
  self.pages = {}
end

function SQL:add_operation(op)
  self.operation = op
end

function SQL:add_table(table_name)
  self.table = table_name
end

function SQL:add_column_list(column_tbl)
  SQL:sql_column_list(column_tbl, self.column_list)
end

function SQL:add_record(record_tbl)
  SQL:sql_records(record_tbl, self.record)
end

function SQL:add_condition(cond_tbl)
  local tmp_cond = {}
  if nil == cond_tbl.item_tbl then
    return
  end
  local num = #cond_tbl.item_tbl
  if 0 == num then
    SQL:sql_condition(cond_tbl, tmp_cond)
    self.condition.condition={}
    table.insert(self.condition.condition, tmp_cond)
  elseif num > 1 then
    SQL:sql_comb_condition(cond_tbl, self.condition)
  end
end

function SQL:add_group(group_tbl)
  SQL:sql_group(group_tbl, self.group)
end

function SQL:add_order(order_tbl)
  SQL:sql_order(order_tbl, self.order)
end

function SQL:add_having(having_tbl)
  local tmp_cond = {}
  SQL:sql_condition(having_tbl, tmp_cond)
  self.having.condition={}
  table.insert(self.having.condition, tmp_cond)  
end

function SQL:add_execute_sql(executeSql_str)
  self.execute_sql = executeSql_str
end

function SQL:add_pages(pages_tbl)
  SQL:sql_pages(pages_tbl, self.pages)
end

return SQL
