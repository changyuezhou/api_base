--------------------bit----------------------------
local bit={data32={}}

for i=1,32 do
  bit.data32[i]=2^(32-i)
end

function bit:d2b(arg)
  local   tr={}
  for i=1,32 do
    if arg >= self.data32[i] then
      tr[i]=1
      arg=arg-self.data32[i]
    else
      tr[i]=0
    end
  end
  return   tr
end   --bit:d2b


function  bit:b2d(arg)
  local   nr=0
  for i=1,32 do
    if arg[i] ==1 then
      nr=nr+2^(32-i)
    end
  end
  return  nr
end   --bit:b2d


function    bit:_and(a,b)
  local   op1=self:d2b(a)
  local   op2=self:d2b(b)
  local   r={}

  for i=1,32 do
    if op1[i]==1 and op2[i]==1  then
      r[i]=1
    else
      r[i]=0
    end
  end
  return  self:b2d(r)
end --bit:_and


function  bit:_rshift(a,n)
  local   op1=self:d2b(a)
  local   r=self:d2b(0)

  if n < 32 and n > 0 then
    for i=1,n do
      for i=31,1,-1 do
        op1[i+1]=op1[i]
      end
      op1[1]=0
    end
    r=op1
  end
  return  self:b2d(r)
end --bit:_rshift


function  bit:_lshift(a,n)
  local   op1=self:d2b(a)
  local   r=self:d2b(0)

  if n < 32 and n > 0 then
    for i=1,n do
      for i=1,31 do
        op1[i]=op1[i+1]
      end
      op1[32]=0
    end
    r=op1
  end
  return  self:b2d(r)
end --bit:_lshift


function bit:GetUserValue_bak(num)
  local flag = false
  if 1 == num % 2 then
    flag = true
  end

  local value = ""
  if flag then
    value = "1,"
  end
  local k = 0
  for i=1, 8 do
    local tmp = bit:_rshift(num,i)
    local v = bit:_and(tmp,1)
    if 0 ~= v then
      if 0 == k then
        value = value .. (i+1)
      else
        value = value .. "," .. (i+1)
      end
      k = k + 1
    end
  end
  return value
end
--end bit


function bit:GetUserValue(num)
  if 1 == num then
    return 0
  end
  local value = ""
  local k = 0
  for i=1, 8 do
    local tmp = bit:_rshift(num,i)
    local v = bit:_and(tmp,1)
    if 0 ~= v then
      if 0 == k then
        value = value .. (i)
      else
        value = value .. "," .. (i)
      end
      k = k + 1
    end
  end
  return value
end

return bit
-------------------end bit-------------------------
