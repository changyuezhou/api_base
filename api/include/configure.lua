-- *********************************************************************************************************
-- auth: zhouchangyue
-- QQ:   23199412
-- 配置文件定义
-- DBService 配置Database Proxy Service地址
-- *********************************************************************************************************

local Configure = {}

Configure.OPERATION = { AND = 1, OR = 2}
Configure.SORT = { DESC = 1, ASC = 2 }

Configure.DBCService = {}
Configure.DBCService.IP = "127.0.0.1"
Configure.DBCService.PORT = "10088"
Configure.DBCService.DB = ""

return Configure