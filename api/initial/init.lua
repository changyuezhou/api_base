-- *********************************************************************************************************
-- author: zhouchangyue
-- QQ:   23199412
-- Nginx 启动时加载该文件
-- nginx.conf 配置文件HTTP SERVICE中增加一条语句: init_by_lua_file ${HOME_DIR}/initial/init.lua;
-- 根据部署服务的路径,修改 HOME_DIR
-- *********************************************************************************************************
local HOME_DIR = "/usr/local/nginx/auth/api/"
local DIR_TABLES = {}

function LoadPath(root)
    local lfs = require "lfs"
    for entry in lfs.dir(root) do
        if entry ~= "." and entry ~= ".." then
            local path = root .. "/" .. entry
            local attr = lfs.attributes(path)
            if attr.mode == "directory" then
               table.insert(DIR_TABLES, path)
               LoadPath(path)
            end
        end
    end
end

LoadPath(HOME_DIR)

for i = 1, #DIR_TABLES do
    package.path = package.path .. ";" .. DIR_TABLES[i] .. "/?.lua"
    package.path = package.path .. ";" .. DIR_TABLES[i] .. "/?.so"
end
