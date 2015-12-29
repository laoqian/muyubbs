  -- ******************************************************--
-- ******************************************************--

-- 版本记录
--	ver-1.0		2015-12-13		hanjun		初次创建
--	ver-1.01	2015-12-13		yuqixian	修改eb_category增加comm字段，为栏目说明 修改eb_article增加artindex字段，为索引 -----
--	ver-1.02	2015-12-15		wanghaowen	插入一些测试数据(已被注释);
--											修改表 eb_vip 字段 deadline 改为 serverdate;  
-- 											修改表 eb_online_record 字段 onlinetimes 为 onlinetime, 新增字段 connecttimes; 增加组合唯一约束
--											修改表 eb_vip_interest 字段 interesttype 增加限制唯一
--											将投诉表合并到刷单记录表中
--	ver-1.03	2015-12-22		wanghaowen	修改权益表

-- ******************************************************--
-- ******************************************************--

/*创建数据库*/

DROP DATABASE IF EXISTS eb;			/*删除数据库*/
CREATE DATABASE IF NOT EXISTS eb;	/*创建数据库*/
ALTER DATABASE eb CHARSET=utf8;
USE eb;								/*使用数据库*/


/*创建表*/

/*配置表*/
DROP TABLE IF EXISTS eb_config;
CREATE TABLE IF NOT EXISTS `eb_config` (
  `id` INT NOT NULL AUTO_INCREMENT COMMENT '主键，自动增长',
  `ebkey` INT NOT NULL COMMENT 'key-键',  
  `ebvalue` VARCHAR(1000) NOT NULL COMMENT 'value-值',
  `ebdesc` VARCHAR(100) NOT NULL COMMENT '键值说明',
  PRIMARY KEY (`id`),
  UNIQUE KEY (`ebkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='配置表';

/*管理员表*/
DROP TABLE IF EXISTS eb_admin;
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


/*邀请码表*/
DROP TABLE IF EXISTS eb_invitecode;
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
DROP TABLE IF EXISTS eb_vip;
CREATE TABLE IF NOT EXISTS `eb_vip` (
  `id` INT NOT NULL AUTO_INCREMENT COMMENT '主键，自动增长',
  `adminid` INT NOT NULL COMMENT '管理员id，外键',
  `account` VARCHAR(20) NOT NULL UNIQUE COMMENT '账号',
  `pwd` VARCHAR(32) NOT NULL COMMENT '密码，MD5加密',
  `sn` INT NOT NULL UNIQUE COMMENT '编号',
  `name` VARCHAR(10) NOT NULL COMMENT '姓名',
  `sex` INT NOT NULL DEFAULT 0 COMMENT '性别，0-男，1-女',
  `photopath` VARCHAR(200) NOT NULL DEFAULT "" COMMENT '用户头像照片路径',
  `handidpath` VARCHAR(200) NOT NULL DEFAULT "" COMMENT '用户手持身份证照片路径',
  `useridpath` VARCHAR(200) NOT NULL DEFAULT "" COMMENT '用户身份证正面照片路径',
  `area` VARCHAR(16) NOT NULL COMMENT '地区，四川省、重庆市。。。',
  `address` VARCHAR(100) NOT NULL COMMENT '地址，四川省成都市武侯区。。。',
  `qq` VARCHAR(20) NOT NULL UNIQUE COMMENT 'QQ号',
  `referrerqq` VARCHAR(20) DEFAULT "" COMMENT '推荐人QQ号，可以为空',
  `tel` VARCHAR(11) NOT NULL UNIQUE COMMENT '手机号',
  `viplevel` INT NOT NULL DEFAULT 1 COMMENT '会员等级',
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
  `anydeskid` VARCHAR(32) NOT NULL DEFAULT "" COMMENT "AnyDesk ID号",
  `cht` INT NOT NULL DEFAULT 0 COMMENT '彩虹糖',
  `chd` INT NOT NULL DEFAULT 0 COMMENT '彩虹豆',
  PRIMARY KEY (`id`),
  KEY `fk_adminid_vip` (`adminid`),
  CONSTRAINT `fk_adminid_vip` FOREIGN KEY (`adminid`)
  REFERENCES `eb_admin` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='vip用户表';



/*vip权益表*/
DROP TABLE IF EXISTS eb_vip_interest;
CREATE TABLE IF NOT EXISTS `eb_vip_interest` (
  `id` INT NOT NULL AUTO_INCREMENT COMMENT '主键，自动增长',
  `type` VARCHAR(30) NOT NULL COMMENT '权益类型',
  `level` INT NOT NULL COMMENT '会员等级',
  `value` INT NOT NULL DEFAULT 1 COMMENT '权益值',
  PRIMARY KEY (`id`),
  UNIQUE (`type`, `level`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='vip权益表';

/*
oncegxsd				共享端刷单一次获得20*x
oncegxscorjg			共享端收藏/加购一次获得5*x
oncegxllorztc			共享端流量/直通车一次获得5*x
oncegxshorpj			共享端收货/评价一次获得2*x
onhookonehouraward		共享端挂机一小时获得10*x
monthaward				共享端当月在线600小时获得x
shopnum					可绑定的店铺数x
imgquality				远程画质x 1/2
lastonlinetime			昨日在线时间x hour
connecttimes			每日可连接次数
chargediscount			充值折扣
onceczsd				操作端刷单一次消耗30
onceczscorjg			操作端收藏/加购一次获得5
onceczllorztc			操作端流量/直通车一次获得5
onceczshorpj			操作端收货/评价一次获得2
*/


/*在线记录表*/
DROP TABLE IF EXISTS eb_online_record;
CREATE TABLE IF NOT EXISTS `eb_online_record` (
  `id` INT NOT NULL AUTO_INCREMENT COMMENT '主键，自动增长',
  `vipid` INT NOT NULL COMMENT 'vip id，vip用户表外键',
  `onlinetype` INT NOT NULL DEFAULT 0 COMMENT '在线类型，0-操作端，1-共享段',
  `onlinedate` DATE NOT NULL COMMENT '在线日期',
  `onlinetime` INT NOT NULL DEFAULT 0 COMMENT '在线时长，单位分钟',
  `connecttimes` INT NOT NULL DEFAULT 0 COMMENT '今日(被)连接次数',
  `checkout` INT NOT NULL DEFAULT 0 COMMENT '是否已经结账 0-未结账 1-已结账',
  PRIMARY KEY (`id`),
  UNIQUE (`vipid`, `onlinetype`, `onlinedate`),
  KEY `fk_vipid_online_record` (`vipid`),
  CONSTRAINT `fk_vipid_online_record` FOREIGN KEY (`vipid`)
  REFERENCES `eb_vip` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='在线记录表';


/*硬件表*/
DROP TABLE IF EXISTS eb_hardware;
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
DROP TABLE IF EXISTS eb_account;
CREATE TABLE IF NOT EXISTS `eb_account` (
  `id` INT NOT NULL AUTO_INCREMENT COMMENT '主键，自动增长',
  `ownerid` INT NOT NULL COMMENT '拥有者id，vip用户表外键',
  `name` VARCHAR(60) NOT NULL UNIQUE COMMENT '名称',
  `accountlevel` INT NOT NULL DEFAULT 0 COMMENT '小号等级',
  `img` VARCHAR(260) NOT NULL COMMENT '图片',
  `sex` INT NOT NULL DEFAULT 0 COMMENT '性别，0-男，1-女',
  `age` INT NOT NULL DEFAULT 0 COMMENT '年龄，0-70后，1-80后，2-90后，3-00后',
  `consume` INT NOT NULL DEFAULT 0 COMMENT '消费范围，0-（0-100），1-（101-200），2-（201-400），3-401以上',
  `category` VARCHAR(20) NOT NULL COMMENT '类目标签',
  `accounttype` INT NOT NULL DEFAULT 0 COMMENT '账号类型，0-淘宝账号，1-京东账号',
  PRIMARY KEY (`id`),
  KEY `fk_ownerid_account` (`ownerid`),
  CONSTRAINT `fk_ownerid_account` FOREIGN KEY (`ownerid`)
  REFERENCES `eb_vip` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='小号表';

/*店铺表*/
DROP TABLE IF EXISTS eb_shop;
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
DROP TABLE IF EXISTS eb_recharge;
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
DROP TABLE IF EXISTS eb_sd;
CREATE TABLE IF NOT EXISTS `eb_sd` (
  `id` INT NOT NULL AUTO_INCREMENT COMMENT '主键，自动增长',
  `czid` INT NOT NULL COMMENT '操作端id，vip用户表外键',
  `gxid` INT NOT NULL COMMENT '共享端id，vip用户表外键',
  `oprtype` INT NOT NULL COMMENT '操作类型，0-刷单、1-收藏/加购、2-流量/直通车、3-评价/收货',
  `xh` VARCHAR(40) NOT NULL COMMENT '小号',
  `sdtype` INT NOT NULL DEFAULT 0 COMMENT '刷单类型，0-淘宝单，1-京东单',
  `category` VARCHAR(20) NOT NULL COMMENT '类目',
  `shop` VARCHAR(60) NOT NULL COMMENT '店铺名',
  `orderid` VARCHAR(60) NOT NULL COMMENT '订单号',
  `money` decimal(11,2) NOT NULL DEFAULT 0.00 COMMENT '金额',
  `linknum` INT NOT NULL DEFAULT 0 COMMENT '拍下的链接数',
  `begintime` DATETIME NOT NULL COMMENT '开始时间',
  `endtime` DATETIME NOT NULL COMMENT '结束时间',
  `orderstatus` INT NOT NULL COMMENT '订单状态，0-已收藏，1-已下单，2-已付款，3-已收货',
  `evaluatetime` DATETIME NOT NULL COMMENT '评价时间',
  `evaluate` VARCHAR(600) NOT NULL COMMENT '评价',
  `status` INT NOT NULL DEFAULT 0 COMMENT '刷单状态，0-失败，1-成功',
  `complaintcontent` VARCHAR(1000) COMMENT '投诉内容 可以为空，表示没有投诉',
  `complainttime` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '投诉时间',
  PRIMARY KEY (`id`),
  KEY `fk_czid_sd` (`czid`),
  KEY `fk_gxid_sd` (`gxid`),
  CONSTRAINT `fk_czid_sd` FOREIGN KEY (`czid`)
  REFERENCES `eb_vip` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_gxid_sd` FOREIGN KEY (`gxid`)
  REFERENCES `eb_vip` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='刷单表';



/*投诉表*/     -- 合并到刷单记录表
-- DROP TABLE IF EXISTS eb_complaint;
-- CREATE TABLE IF NOT EXISTS `eb_complaint` (
  -- `id` INT NOT NULL AUTO_INCREMENT COMMENT '主键，自动增长',
  -- `sdid` INT NOT NULL COMMENT '刷单id，sd表外键',
  -- `content` VARCHAR(1000) NOT NULL COMMENT '投诉内容',
  -- `complainttime` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '投诉时间',
  -- PRIMARY KEY (`id`),
  -- KEY `fk_sdid_complaint` (`sdid`),
  -- CONSTRAINT `fk_sdid_complaint` FOREIGN KEY (`sdid`)
  -- REFERENCES `eb_sd` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
-- ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='投诉表';


/* 操作端使用共享的统计表 */
DROP TABLE IF EXISTS eb_usegx_count;
CREATE TABLE IF NOT EXISTS `eb_usegx_count` (
	`id` INT NOT NULL AUTO_INCREMENT COMMENT '主键，自动增长',
	`czid` INT NOT NULL COMMENT '操作端id，vip用户表外键',
	`gxid` INT NOT NULL COMMENT '共享端id，vip用户表外键',
	`usetimes` INT NOT NULL DEFAULT 0 COMMENT '使用次数',
	`lastusetime` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '最后使用时间',
	`remark` VARCHAR(600) NOT NULL DEFAULT "" COMMENT '使用备注',
	PRIMARY KEY (`id`),
	UNIQUE (`czid`, `gxid`),
	KEY `fk_czid_use` (`czid`),
	KEY `fk_gxid_use` (`gxid`),
	CONSTRAINT `fk_czid_use` FOREIGN KEY (`czid`)
	REFERENCES `eb_vip` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT `fk_gxid_use` FOREIGN KEY (`gxid`)
	REFERENCES `eb_vip` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='操作端使用共享端统计表';


/* 触发器 在新插入刷单记录时，自动更新操作端使用共享端的统计表 */
DROP TRIGGER IF EXISTS trg_insert_sd;
DELIMITER $$
CREATE
    TRIGGER `trg_insert_sd`
    AFTER INSERT
    ON eb_sd FOR EACH ROW
    BEGIN
		IF EXISTS(SELECT id FROM eb_usegx_count WHERE czid=new.czid AND gxid=new.gxid)
		THEN
			UPDATE eb_usegx_count SET usetimes=usetimes+1, lastusetime=new.endtime WHERE czid=new.czid AND gxid=new.gxid;
		ELSE
			INSERT INTO eb_usegx_count(czid, gxid, usetimes, lastusetime) VALUES(new.czid, new.gxid, 1, new.endtime);
		END IF;
	END $$
DELIMITER ;


/*广告表*/
DROP TABLE IF EXISTS eb_ad;
CREATE TABLE IF NOT EXISTS `eb_ad` (
  `id` INT NOT NULL AUTO_INCREMENT COMMENT '主键，自动增长',
  `img` VARCHAR(260) NOT NULL COMMENT '广告图片路径',
  `url` VARCHAR(1000) NOT NULL COMMENT '广告链接url',
  `pos` VARCHAR(1000) NOT NULL COMMENT '广告位置',
  `displaydays` VARCHAR(1000) NOT NULL COMMENT '展示天数',
  `publishtime` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '广告发布时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='广告表';

/*公告表*/
DROP TABLE IF EXISTS eb_notice;
CREATE TABLE IF NOT EXISTS `eb_notice` (
  `id` INT NOT NULL AUTO_INCREMENT COMMENT '主键，自动增长',
  `img` VARCHAR(260) NOT NULL COMMENT '公告图片路径',
  `content` VARCHAR(1000) NOT NULL COMMENT '公告内容',
  `publishtime` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '公告发布时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='公告表';




/* * 论坛表 * */

/*栏目表*/
DROP TABLE IF EXISTS eb_category ;
CREATE TABLE IF NOT EXISTS `eb_category` (
  `id` INT NOT NULL AUTO_INCREMENT COMMENT '主键，自动增长',
  `name` VARCHAR(20) NOT NULL COMMENT '栏目名称',
  `comm` VARCHAR(40) NOT NULL COMMENT '栏目说明',
  `pid` INT NOT NULL DEFAULT 0 COMMENT '父id，来自主键，默认为0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='栏目表';

ALTER TABLE eb_category AUTO_INCREMENT 1;


/*文章表*/
DROP TABLE IF EXISTS eb_article;
CREATE TABLE IF NOT EXISTS `eb_article` (
  `id` INT NOT NULL AUTO_INCREMENT COMMENT '主键，自动增长',
  `categoryid` INT NOT NULL COMMENT '栏目id，category表外键',
  `authorid` INT NOT NULL COMMENT '作者id，vip表外键',
  `title` VARCHAR(100) NOT NULL COMMENT '文章标题',
  `content` VARCHAR(20000) NOT NULL COMMENT '文章内容',
  `publishtime` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '文章发布时间',
  `replynum` INT NOT NULL COMMENT '评论数',
  `lastreplyer` VARCHAR(100) NOT NULL COMMENT '最后评论人',
  `reviewnum` INT NOT NULL COMMENT '查看数量',
  PRIMARY KEY (`id`),
  KEY `fk_categoryid_article` (`categoryid`),
  KEY `fk_authorid_article` (`authorid`),
  CONSTRAINT `fk_categoryid_article` FOREIGN KEY (`categoryid`)
  REFERENCES `eb_category` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_authorid_article` FOREIGN KEY (`authorid`)
  REFERENCES `eb_vip` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='文章表';

/* 评论表 */
DROP TABLE IF EXISTS eb_review;
CREATE TABLE IF NOT EXISTS `eb_review` (
  `id` INT NOT NULL AUTO_INCREMENT COMMENT '主键，自动增长',
  `articleid` INT NOT NULL COMMENT '文章id，article表外键',
  `reviewerid` INT NOT NULL COMMENT '评论者id，vip表外键',
  `content` VARCHAR(2000) NOT NULL COMMENT '评论内容',
  `commenttime` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '评论时间',
  PRIMARY KEY (`id`),
  KEY `fk_articleid_review` (`articleid`),
  KEY `fk_reviewerid_review` (`reviewerid`),
  CONSTRAINT `fk_articleid_review` FOREIGN KEY (`articleid`)
  REFERENCES `eb_article` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_reviewerid_review` FOREIGN KEY (`reviewerid`)
  REFERENCES `eb_vip` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='评论表';



-- ****************************************************************************
-- 以下为测试用的数据

set character_set_client = gbk;		/* 插入数据时，避免中文乱码 */


/*
配置表(注：已经添加的信息 ebkey 不能修改)
*/
INSERT INTO eb_config(ebkey, ebdesc, ebvalue)
VALUES
(1, '联系我们', '<a href="http://www.baidu.com">彩虹电商</a><br>联系电话：10000000000<br>地址：彩虹村彩虹路彩虹桥888号彩虹屋'),
(2, '公告信息', '<B>公告</B><br>1、热烈祝贺彩虹电商平台成功上线。<br>2、热烈欢迎<a href="http://www.baidu.com">海外代购</a>入驻我平台'),
(3, '包月消费(chd)', '500'),
(4, '包季度消费(chd)', '1500'),
(5, '包年消费(chd)', '5000'),
(6, '共享端离线时间超过?小时，警告', '72'),
(7, '共享端离线时间超过?小时，冻结账号并扣除一定金币', '120'),
(8, '共享端离线时间超过?小时，直接删除账号', '240'),
(9, '共享端前一天在线时间不足，如需继续登录，扣除的金币数', '150'),
(10, '冻结会员账号时扣除的金币数', '2000');

/*
管理员数据
*/
INSERT INTO eb_admin (account,pwd,sn,name,idcard,tel,qq) VALUES
('admin1', MD5('88888888'), 100001, 'AA1', '123456789012345671', '13000000001', '123456781'),
('admin2', MD5('88888888'), 100002, 'AA2', '123456789012345672', '13000000002', '123456782'),
('admin3', MD5('88888888'), 100003, 'AA3', '123456789012345673', '13000000003', '123456783'),
('admin4', MD5('88888888'), 100004, 'AA4', '123456789012345674', '13000000004', '123456784'),
('admin5', MD5('88888888'), 100005, 'AA5', '123456789012345675', '13000000005', '123456788'),
('admin6', MD5('88888888'), 100006, 'AA6', '123456789012345676', '13000000006', '123456786');

/*
VIP 数据
*/
INSERT INTO eb_vip
(adminid, account, pwd, sn, name, area, address, qq, tel, isaudit, serverdate, anydeskid) 
VALUES
(1, 'account001', MD5('88888888'), 10001, 'name001', '四川省', '成都', 'qq001', '15000000001', 0, '2016-01-01', 'AnyDesk0001'),
(2, 'account002', MD5('88888888'), 10002, 'name002', '湖北省', '武汉', 'qq002', '15000000002', 0, '2016-01-01', 'AnyDesk0002'),
(3, 'account003', MD5('88888888'), 10003, 'name003', '湖南省', '长沙', 'qq003', '15000000003', 1, '2016-01-01', 'AnyDesk0003'),
(4, 'account004', MD5('88888888'), 10004, 'name004', '重庆', '重庆', 'qq004', '15000000004', 1, '2016-01-01', 'AnyDesk0004'),
(5, 'account005', MD5('88888888'), 10005, 'name005', '广东省', '广州', 'qq005', '15000000005', 1, '2016-01-01', 'AnyDesk0005'),
(6, 'account006', MD5('88888888'), 10006, 'name006', '山西省', '大同', 'qq006', '15000000006', 1, '2016-01-01', 'AnyDesk0006');

/*
权益表数据
-- 每日可连接次数

-- gjhdchdbs 挂机1小时可获得chd为 10*value
*/
INSERT INTO eb_vip_interest
(type, level, value) 
VALUES
('oncegxsd', 1, 20),
('oncegxsd', 2, 40),
('oncegxsd', 3, 40),
('oncegxsd', 4, 60),
('oncegxsd', 5, 80),
('oncegxsd', 6, 100),

('oncegxscorjg', 1, 5),
('oncegxscorjg', 2, 10),
('oncegxscorjg', 3, 10),
('oncegxscorjg', 4, 15),
('oncegxscorjg', 5, 20),
('oncegxscorjg', 6, 25),

('oncegxllorztc', 1, 2),
('oncegxllorztc', 2, 4),
('oncegxllorztc', 3, 4),
('oncegxllorztc', 4, 4),
('oncegxllorztc', 5, 4),
('oncegxllorztc', 6, 4),

('oncegxshorpj', 1, 2),
('oncegxshorpj', 2, 4),
('oncegxshorpj', 3, 4),
('oncegxshorpj', 4, 4),
('oncegxshorpj', 5, 4),
('oncegxshorpj', 6, 4),

('onhookonehouraward', 1, 10),
('onhookonehouraward', 2, 20),
('onhookonehouraward', 3, 20),
('onhookonehouraward', 4, 20),
('onhookonehouraward', 5, 20),
('onhookonehouraward', 6, 20),

('monthaward', 1, 600),
('monthaward', 2, 600),
('monthaward', 3, 600),
('monthaward', 4, 600),
('monthaward', 5, 600),
('monthaward', 6, 600),

('shopnum', 1, 1),
('shopnum', 2, 1),
('shopnum', 3, 1),
('shopnum', 4, 1),
('shopnum', 5, 1),
('shopnum', 6, 1),

('imgquality', 1, 1),
('imgquality', 2, 1),
('imgquality', 3, 2),
('imgquality', 4, 2),
('imgquality', 5, 2),
('imgquality', 6, 2),

('lastonlinetime', 1, 12),
('lastonlinetime', 2, 12),
('lastonlinetime', 3, 12),
('lastonlinetime', 4, 12),
('lastonlinetime', 5, 12),
('lastonlinetime', 6, 12),

('connecttimes', 1, 5),
('connecttimes', 2, 10),
('connecttimes', 3, 10),
('connecttimes', 4, 12),
('connecttimes', 5, 15),
('connecttimes', 6, 20),

('chargediscount', 1, 1),
('chargediscount', 2, 1),
('chargediscount', 3, 1),
('chargediscount', 4, 1),
('chargediscount', 5, 1),
('chargediscount', 6, 1),

('onceczsd', 1, 30),
('onceczsd', 2, 30),
('onceczsd', 3, 30),
('onceczsd', 4, 30),
('onceczsd', 5, 30),
('onceczsd', 6, 30),

('onceczscorjg', 1, 5),
('onceczscorjg', 2, 5),
('onceczscorjg', 3, 5),
('onceczscorjg', 4, 5),
('onceczscorjg', 5, 5),
('onceczscorjg', 6, 5),

('onceczllorztc', 1, 5),
('onceczllorztc', 2, 5),
('onceczllorztc', 3, 5),
('onceczllorztc', 4, 5),
('onceczllorztc', 5, 5),
('onceczllorztc', 6, 5),

('onceczshorpj', 1, 2),
('onceczshorpj', 2, 2),
('onceczshorpj', 3, 2),
('onceczshorpj', 4, 2),
('onceczshorpj', 5, 2),
('onceczshorpj', 6, 2),


('payfortenmin', 1, 15),
('payfortenmin', 2, 15),
('payfortenmin', 3, 15),
('payfortenmin', 4, 15),
('payfortenmin', 5, 15),
('payfortenmin', 6, 15);





/*
oncegxsd				共享端刷单一次获得
oncegxscorjg			共享端收藏/加购一次获得
oncegxllorztc			共享端流量/直通车一次获得
oncegxshorpj			共享端收货/评价一次获得
onhookonehouraward		共享端挂机一小时获得
monthaward				共享端当月在线600小时获得
shopnum					可绑定的店铺数
imgquality				远程画质 1/2
lastonlinetime			昨日在线时间 (小时)
connecttimes			每日可连接次数
chargediscount			充值折扣
onceczsd				操作端刷单一次消耗30
onceczscorjg			操作端收藏/加购一次获得5
onceczllorztc			操作端流量/直通车一次获得5
onceczshorpj			操作端收货/评价一次获得2
payfortenmin			每10分钟收费
*/




/*
在线记录数据
*/
INSERT INTO 
eb_online_record(vipid, onlinetype, onlinedate, onlinetime) 
VALUES
((SELECT id FROM eb_vip WHERE sn=10001), 0, CURDATE(), 10*60),
((SELECT id FROM eb_vip WHERE sn=10002), 0, CURDATE(), 10*60),
((SELECT id FROM eb_vip WHERE sn=10003), 0, CURDATE(), 10*60),
((SELECT id FROM eb_vip WHERE sn=10004), 0, CURDATE(), 10*60),
((SELECT id FROM eb_vip WHERE sn=10005), 0, CURDATE(), 10*60),
((SELECT id FROM eb_vip WHERE sn=10006), 0, CURDATE(), 10*60),
((SELECT id FROM eb_vip WHERE sn=10001), 1, DATE_SUB(CURDATE(), INTERVAL "1" DAY), 10*60),
((SELECT id FROM eb_vip WHERE sn=10002), 1, DATE_SUB(CURDATE(), INTERVAL "1" DAY), 10*60),
((SELECT id FROM eb_vip WHERE sn=10003), 1, DATE_SUB(CURDATE(), INTERVAL "1" DAY), 10*60),
((SELECT id FROM eb_vip WHERE sn=10004), 1, DATE_SUB(CURDATE(), INTERVAL "1" DAY), 12*60),
((SELECT id FROM eb_vip WHERE sn=10005), 1, DATE_SUB(CURDATE(), INTERVAL "1" DAY), 12*60),
((SELECT id FROM eb_vip WHERE sn=10006), 1, DATE_SUB(CURDATE(), INTERVAL "1" DAY), 12*60);


/*
小号表
*/
INSERT INTO 
eb_account(ownerid, name, accountlevel, img, sex, age, consume, category, accounttype) 
VALUES
((SELECT id FROM eb_vip WHERE sn=10001), 'xiaohao001', 1, 'img', 0, 20, 0, 'category001', 0),
((SELECT id FROM eb_vip WHERE sn=10002), 'xiaohao002', 1, 'img', 0, 20, 0, 'category001', 0),
((SELECT id FROM eb_vip WHERE sn=10003), 'xiaohao003', 1, 'img', 0, 20, 0, 'category001', 0),
((SELECT id FROM eb_vip WHERE sn=10004), 'xiaohao004', 1, 'img', 0, 20, 0, 'category001', 0),
((SELECT id FROM eb_vip WHERE sn=10005), 'xiaohao005', 1, 'img', 0, 20, 0, 'category001', 0),
((SELECT id FROM eb_vip WHERE sn=10006), 'xiaohao0061', 1, 'img', 0, 20, 0, 'category001', 0),
((SELECT id FROM eb_vip WHERE sn=10006), 'xiaohao0062', 2, 'img', 0, 20, 0, 'category001', 0);


/*
店铺表
*/
INSERT INTO 
eb_shop(ownerid, name, shoplevel, img)
VALUES
((SELECT id FROM eb_vip WHERE sn=10001), 'shopname001', 1, 'img'),
((SELECT id FROM eb_vip WHERE sn=10002), 'shopname002', 1, 'img'),
((SELECT id FROM eb_vip WHERE sn=10003), 'shopname003', 1, 'img'),
((SELECT id FROM eb_vip WHERE sn=10004), 'shopname004', 1, 'img'),
((SELECT id FROM eb_vip WHERE sn=10005), 'shopname005', 1, 'img'),
((SELECT id FROM eb_vip WHERE sn=10006), 'shopname0061', 1, 'img'),
((SELECT id FROM eb_vip WHERE sn=10006), 'shopname0062', 1, 'img');

/*
充值表
*/
INSERT INTO eb_recharge(oprid, vipid, sn, money, chicon, status, rechargetime) 
VALUES
(1, (SELECT id FROM eb_vip WHERE sn=10004), '987654321', 100, 1000, 0, '2015-12-22 20:00:00'),
(1, (SELECT id FROM eb_vip WHERE sn=10004), '987654323', 10, 100, 0, '2015-12-23 20:00:00'),
(1, (SELECT id FROM eb_vip WHERE sn=10004), '987654324', 20, 200, 0, '2015-12-20 20:00:00'),
(1, (SELECT id FROM eb_vip WHERE sn=10004), '987654325', 30, 300, 0, '2015-12-15 20:00:00'),
(1, (SELECT id FROM eb_vip WHERE sn=10004), '987654322', 40, 400, 1, '2015-12-12 20:00:00'),
(1, (SELECT id FROM eb_vip WHERE sn=10004), '987654329', 50, 500, 1, '2015-12-10 20:00:00'),
(1, (SELECT id FROM eb_vip WHERE sn=10004), '987654327', 60, 600, 1, '2015-12-21 20:00:00');



/*
刷单表
*/
INSERT INTO 
eb_sd(czid, gxid, oprtype, xh, sdtype, category, shop, orderid, money, begintime, endtime, orderstatus, evaluatetime, evaluate, status)
VALUES
((SELECT id FROM eb_vip WHERE sn=10001), (SELECT id FROM eb_vip WHERE sn=10002), 0, 'xiaohao20', 0, 'category001', 'shop001', 'orderid00001', 255, '2015-12-11 20:20:20', '2015-12-11 20:55:55', 0, '2015-12-25 22:22:22', 'evaluate001', 1),
((SELECT id FROM eb_vip WHERE sn=10001), (SELECT id FROM eb_vip WHERE sn=10002), 1, 'xiaohao21', 1, 'category001', 'shop001', 'orderid00002', 255, '2015-12-12 20:20:20', '2015-12-12 20:55:55', 1, '2015-12-25 22:22:22', 'evaluate001', 1),
((SELECT id FROM eb_vip WHERE sn=10001), (SELECT id FROM eb_vip WHERE sn=10002), 2, 'xiaohao22', 1, 'category001', 'shop001', 'orderid00003', 255, '2015-12-13 20:20:20', '2015-12-13 20:55:55', 2, '2015-12-25 22:22:22', 'evaluate001', 1),
((SELECT id FROM eb_vip WHERE sn=10001), (SELECT id FROM eb_vip WHERE sn=10002), 3, 'xiaohao23', 1, 'category001', 'shop001', 'orderid00004', 255, '2015-12-14 20:20:20', '2015-12-14 20:55:55', 3, '2015-12-25 22:22:22', 'evaluate001', 1),
((SELECT id FROM eb_vip WHERE sn=10001), (SELECT id FROM eb_vip WHERE sn=10003), 0, 'xiaohao30', 0, 'category001', 'shop001', 'orderid00005', 255, '2015-12-15 20:20:20', '2015-12-15 20:55:55', 4, '2015-12-25 22:22:22', 'evaluate001', 1),
((SELECT id FROM eb_vip WHERE sn=10001), (SELECT id FROM eb_vip WHERE sn=10003), 1, 'xiaohao31', 0, 'category001', 'shop001', 'orderid00006', 255, '2015-12-11 20:20:20', '2015-12-11 20:55:55', 0, '2015-12-25 22:22:22', 'evaluate001', 1),
((SELECT id FROM eb_vip WHERE sn=10001), (SELECT id FROM eb_vip WHERE sn=10003), 2, 'xiaohao32', 0, 'category001', 'shop001', 'orderid00007', 255, '2015-12-12 20:20:20', '2015-12-12 20:55:55', 1, '2015-12-25 22:22:22', 'evaluate001', 1),
((SELECT id FROM eb_vip WHERE sn=10001), (SELECT id FROM eb_vip WHERE sn=10003), 3, 'xiaohao33', 1, 'category001', 'shop001', 'orderid00008', 255, '2015-12-13 20:20:20', '2015-12-13 20:55:55', 2, '2015-12-25 22:22:22', 'evaluate001', 1),
((SELECT id FROM eb_vip WHERE sn=10001), (SELECT id FROM eb_vip WHERE sn=10004), 0, 'xiaohao40', 0, 'category001', 'shop001', 'orderid00009', 255, '2015-12-14 20:20:20', '2015-12-14 20:55:55', 3, '2015-12-25 22:22:22', 'evaluate001', 1),
((SELECT id FROM eb_vip WHERE sn=10001), (SELECT id FROM eb_vip WHERE sn=10004), 1, 'xiaohao41', 0, 'category001', 'shop001', 'orderid00010', 255, '2015-12-15 20:20:20', '2015-12-15 20:55:55', 4, '2015-12-25 22:22:22', 'evaluate001', 1),
((SELECT id FROM eb_vip WHERE sn=10001), (SELECT id FROM eb_vip WHERE sn=10004), 2, 'xiaohao41', 1, 'category001', 'shop001', 'orderid00011', 255, '2015-12-11 20:20:20', '2015-12-11 20:55:55', 0, '2015-12-25 22:22:22', 'evaluate001', 1),
((SELECT id FROM eb_vip WHERE sn=10001), (SELECT id FROM eb_vip WHERE sn=10004), 3, 'xiaohao41', 1, 'category001', 'shop001', 'orderid00012', 255, '2015-12-12 20:20:20', '2015-12-12 20:55:55', 1, '2015-12-25 22:22:22', 'evaluate001', 1),
((SELECT id FROM eb_vip WHERE sn=10001), (SELECT id FROM eb_vip WHERE sn=10004), 0, 'xiaohao41', 0, 'category001', 'shop001', 'orderid00013', 255, '2015-12-13 20:20:20', '2015-12-13 20:55:55', 0, '2015-12-25 22:22:22', 'evaluate001', 1),
((SELECT id FROM eb_vip WHERE sn=10001), (SELECT id FROM eb_vip WHERE sn=10004), 1, 'xiaohao42', 0, 'category001', 'shop001', 'orderid00014', 255, '2015-12-14 20:20:20', '2015-12-14 20:55:55', 2, '2015-12-25 22:22:22', 'evaluate001', 1),
((SELECT id FROM eb_vip WHERE sn=10001), (SELECT id FROM eb_vip WHERE sn=10005), 0, 'xiaohao51', 1, 'category001', 'shop001', 'orderid00015', 255, '2015-12-15 20:20:20', '2015-12-15 20:55:55', 0, '2015-12-25 22:22:22', 'evaluate001', 1),
((SELECT id FROM eb_vip WHERE sn=10001), (SELECT id FROM eb_vip WHERE sn=10005), 1, 'xiaohao51', 1, 'category001', 'shop001', 'orderid00016', 255, '2015-12-11 20:20:20', '2015-12-11 20:55:55', 3, '2015-12-25 22:22:22', 'evaluate001', 1),
((SELECT id FROM eb_vip WHERE sn=10001), (SELECT id FROM eb_vip WHERE sn=10005), 2, 'xiaohao51', 1, 'category001', 'shop001', 'orderid00017', 255, '2015-12-12 20:20:20', '2015-12-12 20:55:55', 0, '2015-12-25 22:22:22', 'evaluate001', 1),
((SELECT id FROM eb_vip WHERE sn=10001), (SELECT id FROM eb_vip WHERE sn=10005), 3, 'xiaohao52', 0, 'category001', 'shop001', 'orderid00018', 255, '2015-12-13 20:20:20', '2015-12-13 20:55:55', 0, '2015-12-25 22:22:22', 'evaluate001', 1),
((SELECT id FROM eb_vip WHERE sn=10001), (SELECT id FROM eb_vip WHERE sn=10005), 0, 'xiaohao50', 0, 'category001', 'shop001', 'orderid00019', 255, '2015-12-14 20:20:20', '2015-12-14 20:55:55', 4, '2015-12-25 22:22:22', 'evaluate001', 1),
((SELECT id FROM eb_vip WHERE sn=10001), (SELECT id FROM eb_vip WHERE sn=10006), 0, 'xiaohao60', 1, 'category001', 'shop001', 'orderid00020', 255, '2015-12-15 20:20:20', '2015-12-15 20:55:55', 0, '2015-12-25 22:22:22', 'evaluate001', 1),
((SELECT id FROM eb_vip WHERE sn=10001), (SELECT id FROM eb_vip WHERE sn=10006), 1, 'xiaohao61', 0, 'category001', 'shop001', 'orderid00021', 255, '2015-12-11 20:20:20', '2015-12-11 20:55:55', 0, '2015-12-25 22:22:22', 'evaluate001', 1),
((SELECT id FROM eb_vip WHERE sn=10001), (SELECT id FROM eb_vip WHERE sn=10006), 2, 'xiaohao62', 0, 'category001', 'shop001', 'orderid00022', 255, '2015-12-12 20:20:20', '2015-12-12 20:55:55', 1, '2015-12-25 22:22:22', 'evaluate001', 1),
((SELECT id FROM eb_vip WHERE sn=10001), (SELECT id FROM eb_vip WHERE sn=10006), 3, 'xiaohao62', 1, 'category001', 'shop001', 'orderid00023', 255, '2015-12-13 20:20:20', '2015-12-13 20:55:55', 0, '2015-12-25 22:22:22', 'evaluate001', 1),
((SELECT id FROM eb_vip WHERE sn=10001), (SELECT id FROM eb_vip WHERE sn=10006), 0, 'xiaohao63', 0, 'category001', 'shop001', 'orderid00024', 255, '2015-12-14 20:20:20', '2015-12-14 20:55:55', 2, '2015-12-25 22:22:22', 'evaluate001', 1),
((SELECT id FROM eb_vip WHERE sn=10001), (SELECT id FROM eb_vip WHERE sn=10006), 0, 'xiaohao63', 1, 'category001', 'shop001', 'orderid00025', 255, '2015-12-15 20:20:20', '2015-12-15 20:55:55', 4, '2015-12-25 22:22:22', 'evaluate001', 1);


/*
栏目表
*/
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



