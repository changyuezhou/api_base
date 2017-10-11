local descriptor = require "descriptor"
local FieldDescriptor = descriptor.FieldDescriptor
local cjson = require "cjson"

local JsonPB = {}

function JsonPB:copyRepeatedArray(v, new_tab)
  local num = #v
  if num == 0 then
    JsonPB:copy_table(v,new_tab)
  else
    for i = 1, num do
      local vtype = type(v[i])
	  if vtype == "table" then
	    JsonPB:copy_table(v[i], new_tab:add())
	  else
        table.insert(new_tab,v[i])
	  end
    end
  end
end

function JsonPB:copy_table(ori_tab, new_tab)
    if type(ori_tab) ~= "table" then
        return
    end
    for k,v in pairs(ori_tab) do
        local vtype = type(v)
        if vtype == "table" then
          JsonPB:copyRepeatedArray(v, new_tab[k])
        else
		  local success, f = pcall(new_tab.HasField,new_tab,tostring(k))
		  if (not success) then
		    ngx.log(ngx.DEBUG, "new_tab.HasField "..f)
		  else
            new_tab[k] = v
		  end
		end
    end
end

function JsonPB:copy_pb_table(ori_tab, new_tab)
    if type(ori_tab) ~= "table" then
        return
    end

	for field_descriptor, field_value in ori_tab.ListFields(ori_tab) do
	  if ( FieldDescriptor.LABEL_OPTIONAL == field_descriptor.label) and 
	     ( FieldDescriptor.CPPTYPE_MESSAGE ~= field_descriptor.cpp_type) then
	    new_tab[field_descriptor.name] = field_value
	  elseif ( FieldDescriptor.LABEL_OPTIONAL == field_descriptor.label) and 
	         ( FieldDescriptor.CPPTYPE_MESSAGE == field_descriptor.cpp_type) then
		new_tab[field_descriptor.name] = {}
	    JsonPB:copy_pb_table(ori_tab[field_descriptor.name], new_tab[field_descriptor.name])
	  elseif ( FieldDescriptor.LABEL_REPEATED == field_descriptor.label) and 
	         ( FieldDescriptor.CPPTYPE_MESSAGE ~= field_descriptor.cpp_type) then
	    local num = #ori_tab[field_descriptor.name]
		new_tab[field_descriptor.name] = {}
		for i =1, num do		  
	      table.insert(new_tab[field_descriptor.name],ori_tab[field_descriptor.name][i])
		end
	  elseif ( FieldDescriptor.LABEL_REPEATED == field_descriptor.label) and 
	         ( FieldDescriptor.CPPTYPE_MESSAGE == field_descriptor.cpp_type) then
	    local num = #ori_tab[field_descriptor.name]
		local tbl = {}
		for i =1, num do
		  tbl[i] = {}
		  JsonPB:copy_pb_table(ori_tab[field_descriptor.name][i], tbl[i])
		end
		new_tab[field_descriptor.name] = {}
		for i = 1,num do
		  table.insert(new_tab[field_descriptor.name],tbl[i])
		end
      end	  
	end
end

function JsonPB:Tbl2Pb(pb_tbl, js_tbl)
  JsonPB:copy_table(js_tbl, pb_tbl)
end

function JsonPB:Pb2Tbl(js_tbl, pb_tbl)
  JsonPB:copy_pb_table(pb_tbl, js_tbl)
end

return JsonPB
