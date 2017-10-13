DROP TABLE IF EXISTS `t_example`;
CREATE TABLE `t_example` (
  `id` varchar(128) NOT NULL DEFAULT '' COMMENT '会员ID',
  `name` varchar(256) NOT NULL DEFAULT '' COMMENT '会员姓名',
  `update_time` bigint(20) NOT NULL DEFAULT '0' COMMENT '更新时间',
  `create_time` bigint(20) NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 MAX_ROWS=1000000 AVG_ROW_LENGTH=1000;