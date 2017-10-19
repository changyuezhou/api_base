DROP TABLE IF EXISTS `t_example`;
CREATE TABLE `t_example` (
  `id` varchar(128) NOT NULL DEFAULT '' COMMENT '会员ID',
  `name` varchar(256) NOT NULL DEFAULT '' COMMENT '会员姓名',
  `update_time` bigint(20) NOT NULL DEFAULT '0' COMMENT '更新时间',
  `create_time` bigint(20) NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 MAX_ROWS=1000000 AVG_ROW_LENGTH=1000;

DROP TABLE IF EXISTS `t_student`;
CREATE TABLE `t_student` (
  `id` varchar(128) NOT NULL DEFAULT '' COMMENT '学生ID',
  `name` varchar(256) NOT NULL DEFAULT '' COMMENT '学生姓名',
  `age` int NOT NULL DEFAULT '0' COMMENT '学生年龄',
  `have_courses` varchar(1024) NOT NULL DEFAULT '' COMMENT '已修课程',
  `course_grade` varchar(1024) NOT NULL DEFAULT '' COMMENT '成绩课程',
  `update_time` bigint(20) NOT NULL DEFAULT '0' COMMENT '更新时间',
  `create_time` bigint(20) NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 MAX_ROWS=1000000 AVG_ROW_LENGTH=1000;