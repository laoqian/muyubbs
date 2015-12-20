-- ******************************************************--
-- ******************************************************--

-- 版本记录
--	ver-1.0		2015-12-13		hanjun		初次创建
--	ver-1.01	2015-12-13		yuqixian	修改eb_category增加comm字段，为栏目说明 修改eb_article增加artindex字段，为索引 -----
--	ver-1.02	2015-12-15		wanghaowen	插入一些测试数据(已被注释);
--											修改表 eb_vip 字段 deadline 改为 serverdate;  
-- 											修改表 eb_online_record 字段 onlinetimes 为 onlinetime, 新增字段 connecttimes; 增加组合唯一约束
--											修改表 eb_vip_interest 字段 interesttype 增加限制唯一

-- ******************************************************--
-- ******************************************************--

/*创建数据库*/

DROP database IF EXISTS eb;			/*删除数据库*/
CREATE database IF NOT EXISTS eb;	/*创建数据库*/
USE eb;								/*使用数据库*/

/*创建表*/

/*配置表*/
-- DROP TABLE IF EXISTS eb_config;
CREATE TABLE IF NOT EXISTS `eb_config` (
  `id` INT NOT NULL AUTO_INCREMENT COMMENT '主键，自动增长',
  `ebkey` VARCHAR(20) NOT NULL COMMENT 'key-键',
  `ebvalue` VARCHAR(1000) NOT NULL COMMENT 'value-值',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='配置表';

/*管理员表*/
-- DROP TABLE IF EXISTS eb_admin;
CREATE TABLE IF NOT EXISTS `eb_admin` (
  `id` INT NOT NULL AUTO_INCREMENT COMMENT '主键，自动增长',
  `account` VARCHAR(20) NOT NULL UNIQUE COMMENT '账号',
  `pwd` VARCHAR(32) NOT NULL COMMENT '密码，MD5加密',
  `sn` INT NOT NULL UNIQUE COMMENT '编号',
  `name` VARCHAR(10) NOT NULL COMMENT '姓名',
  `idcard` VARCHAR(18) NOT NULL UNIQUE COMMENT '18位身份证号',
  `tel` VARCHAR(11) NOT NULL UNIQUE COMMENT '手机号',
  `qq` VARCHAR(20) NOT NULL UNIQUE COMMENT 'QQ号',
  `status` INT NOT NULL DEFAULT 0 COMMENT '状态，0-正常，1-冻结',
  `priviewvip` INT NOT NULL DEFAULT 0 COMMENT '权限-查看会员，0-无，1-有',
  `priactive` INT NOT NULL DEFAULT 0 COMMENT '权限-激活会员，0-无，1-有',
  `priaudit` INT NOT NULL DEFAULT 0 COMMENT '权限-审核会员，0-无，1-有',
  `prifrost` INT NOT NULL DEFAULT 0 COMMENT '权限-冻结会员，0-无，1-有',
  `regtime` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '注册时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='管理员表';

INSERT INTO eb_admin (account,pwd,sn,name,idcard,tel,qq) VALUES
('admin0000', '88888888', '100000', 'AA0', '123456789012345671', '13281819620', '123456781'),
('admin0001', '88888888', '100001', 'AA1', '123456789012345672', '13281819621', '123456782'),
('admin0002', '88888888', '100002', 'AA2', '123456789012345673', '13281819622', '123456783'),
('admin0003', '88888888', '100003', 'AA3', '123456789012345674', '13281819623', '123456784'),
('admin0004', '88888888', '100004', 'AA4', '123456789012345675', '13281819624', '123456785'),
('admin0005', '88888888', '100005', 'AA5', '123456789012345676', '13281819625', '123456786');

/*邀请码表*/
-- DROP TABLE IF EXISTS eb_invitecode;
CREATE TABLE IF NOT EXISTS `eb_invitecode` (
  `id` INT NOT NULL AUTO_INCREMENT COMMENT '主键，自动增长',
  `adminid` INT NOT NULL COMMENT '管理员id，外键',
  `code` VARCHAR(20) NOT NULL UNIQUE COMMENT '邀请码，10-15数字字母组合，唯一',
  `maketime` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '生成时间',
  `status` INT NOT NULL DEFAULT 0 COMMENT '0-已生成，1-已使用',
  PRIMARY KEY (`id`),
  KEY `fk_adminid_invitecode` (`adminid`),
  CONSTRAINT `fk_adminid_invitecode` FOREIGN KEY (`adminid`)
  REFERENCES `eb_admin` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='邀请码表';

/*vip用户表*/
-- DROP TABLE IF EXISTS eb_vip;
CREATE TABLE IF NOT EXISTS `eb_vip` (
  `id` INT NOT NULL AUTO_INCREMENT COMMENT '主键，自动增长',
  `adminid` INT NOT NULL COMMENT '管理员id，外键',
  `account` VARCHAR(20) NOT NULL UNIQUE COMMENT '账号',
  `pwd` VARCHAR(32) NOT NULL COMMENT '密码，MD5加密',
  `sn` INT NOT NULL UNIQUE COMMENT '编号',
  `name` VARCHAR(10) NOT NULL COMMENT '姓名',
  `sex` INT NOT NULL DEFAULT 0 COMMENT '性别，0-男，1-女',
  `handidpath` VARCHAR(200) NOT NULL COMMENT '用户手持身份证照片路径';
  `useridpath` VARCHAR(200) NOT NULL COMMENT '用户身份证正面照片路径';
  `area` VARCHAR(16) NOT NULL COMMENT '地区，四川省、重庆市。。。',
  `address` VARCHAR(100) NOT NULL COMMENT '地址，四川省成都市武侯区。。。',
  `qq` VARCHAR(20) NOT NULL UNIQUE COMMENT 'QQ号',
  `referrerqq` VARCHAR(20) DEFAULT "" COMMENT '推荐人QQ号，可以为空',
  `tel` VARCHAR(11) NOT NULL s COMMENT '手机号',
  `viplevel` INT NOT NULL DEFAULT 0 COMMENT '会员等级',
  `serverdate` DATE NOT NULL COMMENT '服务到期日期',
  `isaudit` INT NOT NULL DEFAULT 0 COMMENT '是否已审核，0-否，1-是',
  `status` INT NOT NULL DEFAULT 0 COMMENT '状态，0-正常，1-冻结',
  `regtime` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '注册时间',
  `lastlogintime` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '共享端最后登录时间',
  `statuscz` INT NOT NULL DEFAULT 0 COMMENT '状态-操作端，0-离线，1-空闲，2-忙碌',
  `statusgx` INT NOT NULL DEFAULT 0 COMMENT '状态-共享端，0-离线，1-空闲，2-忙碌',
  `ipcz` VARCHAR(20) NOT NULL DEFAULT "" COMMENT 'IP-操作端',
  `ipgx` VARCHAR(20) NOT NULL DEFAULT "" COMMENT 'IP-共享端',
  `macgx` VARCHAR(24) NOT NULL DEFAULT "" COMMENT 'MAC-共享端',
  `cht` INT NOT NULL DEFAULT 0 COMMENT '彩虹糖',
  `chd` INT NOT NULL DEFAULT 0 COMMENT '彩虹豆',
  PRIMARY KEY (`id`),
  KEY `fk_adminid_vip` (`adminid`),
  CONSTRAINT `fk_adminid_vip` FOREIGN KEY (`adminid`)
  REFERENCES `eb_admin` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='vip用户表';

/*
SELECT a.adminid, a.sn, a.sex, a.viplevel, a.isaudit, a.status, a.statuscz, a.statusgx, a.cht, a.chd, a.serverdate, a.regtime, a.lastlogintime, a.account, a.name, a.area, a.address, a.qq, a.referrerqq, a.tel, a.macgx FROM eb_vip AS a WHERE a.sn=10001;
*/


/*
INSERT INTO eb_vip
(adminid, account, pwd, sn, name, area, address, qq, tel, isaudit, serverdate) 
VALUES
(1, 'vip001', '001', 10001, 'user001', '四川', '成都', 'no qq1', '15000000001', 0, '2016-01-01'),
(1, 'vip002', '002', 10002, 'user002', '四川', '成都', 'no qq2', '15000000002', 1, '2016-01-01'),
(2, 'vip003', '003', 10003, 'user003', '重庆', '成都', 'no qq3', '15000000003', 0, '2016-01-01'),
(2, 'vip004', '004', 10004, 'user004', '重庆', '成都', 'no qq4', '15000000004', 1, '2016-01-01'),
(3, 'vip005', '005', 10005, 'user005', '北京', '成都', 'no qq5', '15000000005', 0, '2016-01-01'),
(3, 'vip006', '006', 10006, 'user006', '北京', '成都', 'no qq6', '15000000006', 1, '2016-01-01');
*/

/*vip权益表*/
-- DROP TABLE IF EXISTS eb_vip_interest;
CREATE TABLE IF NOT EXISTS `eb_vip_interest` (
  `id` INT NOT NULL AUTO_INCREMENT COMMENT '主键，自动增长',
  `interesttype` VARCHAR(20) NOT NULL UNIQUE COMMENT '权益类型',
  `level1` INT NOT NULL COMMENT '1级会员权益',
  `level2` INT NOT NULL COMMENT '2级会员权益',
  `level3` INT NOT NULL COMMENT '3级会员权益',
  `level4` INT NOT NULL COMMENT '4级会员权益',
  `level5` INT NOT NULL COMMENT '5级会员权益',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='vip权益表';

/*
-- 每日可连接次数
-- 挂机在线可获得chd的倍数
INSERT INTO eb_vip_interest
(interesttype, level1, level2, level3, level4, level5) 
VALUES
('mrkljcs', 5, 10, 10, 12, 15),
('gjhdchdbs', 1, 2, 2, 2, 2);

*/

/*在线记录表*/
-- DROP TABLE IF EXISTS eb_online_record;
CREATE TABLE IF NOT EXISTS `eb_online_record` (
  `id` INT NOT NULL AUTO_INCREMENT COMMENT '主键，自动增长',
  `vipid` INT NOT NULL COMMENT 'vip id，vip用户表外键',
  `onlinetype` INT NOT NULL DEFAULT 0 COMMENT '在线类型，0-操作端，1-共享段',
  `onlinedate` DATE NOT NULL COMMENT '在线日期',
  `onlinetime` INT NOT NULL DEFAULT 0 COMMENT '在线时长，单位分钟',
  `connecttimes` INT NOT NULL DEFAULT 0 COMMENT '今日(被)连接次数',
  PRIMARY KEY (`id`),
  UNIQUE (`vipid`, `onlinetype`, `onlinedate`),
  KEY `fk_vipid_online_record` (`vipid`),
  CONSTRAINT `fk_vipid_online_record` FOREIGN KEY (`vipid`)
  REFERENCES `eb_vip` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='在线记录表';

/*
INSERT INTO eb_online_record(vipid, onlinetype, onlinedate) 
VALUES((SELECT id FROM eb_vip WHERE sn=10002), 1, '2015-12-16');
*/



/*硬件表*/
-- DROP TABLE IF EXISTS eb_hardware;
CREATE TABLE IF NOT EXISTS `eb_hardware` (
  `id` INT NOT NULL AUTO_INCREMENT COMMENT '主键，自动增长',
  `ownerid` INT NOT NULL COMMENT '拥有者id，vip用户表外键',
  `img1config` VARCHAR(260) NOT NULL COMMENT '图片-电脑配置',
  `img2config` VARCHAR(260) NOT NULL COMMENT '图片-电脑配置',
  `imgpc` VARCHAR(260) NOT NULL COMMENT '图片-两台电脑图',
  `imgmodem` VARCHAR(260) NOT NULL COMMENT '图片-两台光猫',
  PRIMARY KEY (`id`),
  KEY `fk_ownerid_hardware` (`ownerid`),
  CONSTRAINT `fk_ownerid_hardware` FOREIGN KEY (`ownerid`)
  REFERENCES `eb_vip` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='硬件表';

/*小号表*/
-- DROP TABLE IF EXISTS eb_account;
CREATE TABLE IF NOT EXISTS `eb_account` (
  `id` INT NOT NULL AUTO_INCREMENT COMMENT '主键，自动增长',
  `ownerid` INT NOT NULL COMMENT '拥有者id，vip用户表外键',
  `name` VARCHAR(60) NOT NULL UNIQUE COMMENT '名称',
  `accountlevel` INT NOT NULL DEFAULT 0 COMMENT '账号等级',
  `img` VARCHAR(260) NOT NULL COMMENT '图片',
  `sex` INT NOT NULL DEFAULT 0 COMMENT '性别，0-男，1-女',
  `age` INT NOT NULL DEFAULT 0 COMMENT '性别，0-70后，1-80后，2-90后，3-00后',
  `consume` INT NOT NULL DEFAULT 0 COMMENT '消费范围，0-（0-100），1-（101-200），2-（201-400），3-401以上',
  `category` VARCHAR(20) NOT NULL COMMENT '类目标签',
  `accounttype` INT NOT NULL DEFAULT 0 COMMENT '账号类型，0-淘宝账号，1-京东账号',
  PRIMARY KEY (`id`),
  KEY `fk_ownerid_account` (`ownerid`),
  CONSTRAINT `fk_ownerid_account` FOREIGN KEY (`ownerid`)
  REFERENCES `eb_vip` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='小号表';

/*店铺表*/
-- DROP TABLE IF EXISTS eb_shop;
CREATE TABLE IF NOT EXISTS `eb_shop` (
  `id` INT NOT NULL AUTO_INCREMENT COMMENT '主键，自动增长',
  `ownerid` INT NOT NULL COMMENT '拥有者id，vip用户表外键',
  `name` VARCHAR(60) NOT NULL UNIQUE COMMENT '名称',
  `shoplevel` INT NOT NULL DEFAULT 0 COMMENT '店铺等级',
  `img` VARCHAR(260) NOT NULL COMMENT '图片',
  PRIMARY KEY (`id`),
  KEY `fk_ownerid_shop` (`ownerid`),
  CONSTRAINT `fk_ownerid_shop` FOREIGN KEY (`ownerid`)
  REFERENCES `eb_vip` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='店铺表';

/*充值表*/
-- DROP TABLE IF EXISTS eb_recharge;
CREATE TABLE IF NOT EXISTS `eb_recharge` (
  `id` INT NOT NULL AUTO_INCREMENT COMMENT '主键，自动增长',
  `oprid` INT NOT NULL COMMENT '操作员id，admin外键',
  `vipid` INT NOT NULL COMMENT '充值会员id，vip用户表外键',
  `sn` VARCHAR(60) NOT NULL COMMENT '充值订单号',
  `money` DECIMAL(11,2) NOT NULL DEFAULT 0.00 COMMENT '充值金额',
  `chicon` INT NOT NULL DEFAULT 0 COMMENT '彩虹桥币',
  `status` INT NOT NULL DEFAULT 0 COMMENT '状态，0-失败，1-成功',
  `rechargetime` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '充值时间',
  PRIMARY KEY (`id`),
  KEY `fk_oprid_recharge` (`oprid`),
  KEY `fk_vipid_recharge` (`vipid`),
  CONSTRAINT `fk_oprid_recharge` FOREIGN KEY (`oprid`)
  REFERENCES `eb_admin` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_vipid_recharge` FOREIGN KEY (`vipid`)
  REFERENCES `eb_vip` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='充值表';

/*刷单表*/
-- 刷单所在日期以结束时间为准
-- DROP TABLE IF EXISTS eb_sd;
CREATE TABLE IF NOT EXISTS `eb_sd` (
  `id` INT NOT NULL AUTO_INCREMENT COMMENT '主键，自动增长',
  `czid` INT NOT NULL COMMENT '操作端id，vip用户表外键',
  `gxid` INT NOT NULL COMMENT '共享端id，vip用户表外键',
  `oprtype` INT NOT NULL COMMENT '操作类型，0-刷单、1-收藏/加够、2-流量/直通车、3-评价/收货',
  `xh` VARCHAR(40) NOT NULL COMMENT '小号',
  `sdtype` INT NOT NULL DEFAULT 0 COMMENT '刷单类型，0-淘宝单，1-京东单',
  `category` VARCHAR(20) NOT NULL COMMENT '类目',
  `shop` VARCHAR(60) NOT NULL COMMENT '店铺名',
  `orderid` VARCHAR(60) NOT NULL COMMENT '订单号',
  `money` decimal(11,2) NOT NULL DEFAULT 0.00 COMMENT '金额',
  `begintime` DATETIME NOT NULL COMMENT '开始时间',
  `endtime` DATETIME NOT NULL COMMENT '结束时间',
  `orderstatus` INT NOT NULL COMMENT '订单状态',
  `evaluatetime` DATETIME NOT NULL COMMENT '评价时间',
  `evaluate` VARCHAR(600) NOT NULL COMMENT '评价',
  `status` INT NOT NULL DEFAULT 0 COMMENT '刷单状态，0-失败，1-成功',
  PRIMARY KEY (`id`),
  KEY `fk_czid_sd` (`czid`),
  KEY `fk_gxid_sd` (`gxid`),
  CONSTRAINT `fk_czid_sd` FOREIGN KEY (`czid`)
  REFERENCES `eb_vip` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_gxid_sd` FOREIGN KEY (`gxid`)
  REFERENCES `eb_vip` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='刷单表';
/*
INSERT INTO eb_sd(czid, gxid, oprtype, xh, sdtype, category, shop, orderid, money, begintime, endtime, orderstatus, evaluatetime, evaluate, status) 
VALUES(1, 2, 0, '小号a', 0, '类目x', '店铺xx', '订单号00000',125.7, '2015-12-15 20:20:20', '2015-12-15 20:55:55', 0, '2015-12-25 22:22:22', '这是评价', 1);
*/


/*投诉表*/
-- DROP TABLE IF EXISTS eb_complaint;
CREATE TABLE IF NOT EXISTS `eb_complaint` (
  `id` INT NOT NULL AUTO_INCREMENT COMMENT '主键，自动增长',
  `sdid` INT NOT NULL COMMENT '刷单id，sd表外键',
  `content` VARCHAR(1000) NOT NULL COMMENT '投诉内容',
  `complainttime` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '投诉时间',
  PRIMARY KEY (`id`),
  KEY `fk_sdid_complaint` (`sdid`),
  CONSTRAINT `fk_sdid_complaint` FOREIGN KEY (`sdid`)
  REFERENCES `eb_sd` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='投诉表';

/*广告表*/
-- DROP TABLE IF EXISTS eb_ad;
CREATE TABLE IF NOT EXISTS `eb_ad` (
  `id` INT NOT NULL AUTO_INCREMENT COMMENT '主键，自动增长',
  `img` VARCHAR(260) NOT NULL COMMENT '广告图片路径',
  `url` VARCHAR(1000) NOT NULL COMMENT '广告链接url',
  `publishtime` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '广告发布时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='广告表';

/*公告表*/
-- DROP TABLE IF EXISTS eb_notice;
CREATE TABLE IF NOT EXISTS `eb_notice` (
  `id` INT NOT NULL AUTO_INCREMENT COMMENT '主键，自动增长',
  `img` VARCHAR(260) NOT NULL COMMENT '公告图片路径',
  `content` VARCHAR(1000) NOT NULL COMMENT '公告内容',
  `publishtime` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '广告发布时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='公告表';

/* * 论坛表 * */

/*栏目表*/
-- DROP TABLE IF EXISTS eb_category ;
CREATE TABLE IF NOT EXISTS `eb_category` (
  `id` INT NOT NULL AUTO_INCREMENT COMMENT '主键，自动增长',
  `name` VARCHAR(20) NOT NULL COMMENT '栏目名称',
  `comm` VARCHAR(40) NOT NULL COMMENT '栏目说明',
  `pid` INT NOT NULL DEFAULT 0 COMMENT '父id，来自主键，默认为0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='栏目表';

ALTER TABLE eb_category AUTO_INCREMENT 1;

/* 
-- 此处脚本插入数据可能发生汉字识别错误，最好手动插入
INSERT INTO eb_category(name,comm, pid) VALUES
('交流专区','└─ 淘宝干货，高级玩法1', 0),
('分享专区','└─ 淘宝干货，高级玩法2',  0),
('站务办公','└─ 淘宝干货，高级玩法3',  0),
('有问必答','└─ 淘宝干货，高级玩法4',  1),
('交流中心','└─ 淘宝干货，高级玩法5',  1),
('案例分析','└─ 淘宝干货，高级玩法6',  1),
('举报骗子','└─ 淘宝干货，高级玩法7',  1),
('交易市场','└─ 淘宝干货，高级玩法8',  1),
('爆款研究','└─ 淘宝干货，高级玩法9',  2),
('干货分享','└─ 淘宝干货，高级玩法a',  2),
('微商专区','└─ 淘宝干货，高级玩法b',  2),
('运营干货','└─ 淘宝干货，高级玩法c',  2),
('站外收费教程','└─ 淘宝干货，高级玩法d',  2),
('京东专区','└─ 淘宝干货，高级玩法e',  2),
('软件│应用│网站','└─ 淘宝干货，高级玩法',  2),
('网店装修│素材', '└─ 淘宝干货，高级玩法', 2),
('自由分享', '└─ 淘宝干货，高级玩法', 2),
('版务公告','└─ 淘宝干货，高级玩法',  3),
('帖子回收','└─ 淘宝干货，高级玩法',  3);
*/

/*文章表*/
-- DROP TABLE IF EXISTS eb_article;
CREATE TABLE IF NOT EXISTS `eb_article` (
  `id` INT NOT NULL AUTO_INCREMENT COMMENT '主键，自动增长',
  `categoryid` INT NOT NULL COMMENT '栏目id，category表外键',
  `authorid` INT NOT NULL COMMENT '作者id，vip表外键',
  `title` VARCHAR(100) NOT NULL COMMENT '文章标题',
  `content` longblob NOT NULL COMMENT '文章内容',
  `publishtime` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '文章发布时间',
  `replynum` int NOT NULL COMMENT '评论数',
  `lastreplyer` VARCHAR(100) NOT NULL COMMENT '最后评论人',
  `reviewnum` int NOT NULL COMMENT '查看数量',
  PRIMARY KEY (`id`),
  KEY `fk_categoryid_article` (`categoryid`),
  KEY `fk_authorid_article` (`authorid`),
  CONSTRAINT `fk_categoryid_article` FOREIGN KEY (`categoryid`)
  REFERENCES `eb_category` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_authorid_article` FOREIGN KEY (`authorid`)
  REFERENCES `eb_vip` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='文章表';

/* 评论表 */
-- DROP TABLE IF EXISTS eb_review;
CREATE TABLE IF NOT EXISTS `eb_review` (
  `id` INT NOT NULL AUTO_INCREMENT COMMENT '主键，自动增长',
  `articleid` INT NOT NULL COMMENT '文章id，article表外键',
  `reviewerid` INT NOT NULL COMMENT '评论者id，vip表外键',
  `content` LONGBLOB NOT NULL COMMENT '评论内容',
  `commenttime` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '评论时间',
  PRIMARY KEY (`id`),
  KEY `fk_articleid_review` (`articleid`),
  KEY `fk_reviewerid_review` (`reviewerid`),
  CONSTRAINT `fk_articleid_review` FOREIGN KEY (`articleid`)
  REFERENCES `eb_article` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_reviewerid_review` FOREIGN KEY (`reviewerid`)
  REFERENCES `eb_vip` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='评论表';

-- source E:\myself\outsourcing\eb.sql
-- source F:\outsourcing\eb.sql
