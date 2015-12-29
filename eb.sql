  -- ******************************************************--
-- ******************************************************--

-- �汾��¼
--	ver-1.0		2015-12-13		hanjun		���δ���
--	ver-1.01	2015-12-13		yuqixian	�޸�eb_category����comm�ֶΣ�Ϊ��Ŀ˵�� �޸�eb_article����artindex�ֶΣ�Ϊ���� -----
--	ver-1.02	2015-12-15		wanghaowen	����һЩ��������(�ѱ�ע��);
--											�޸ı� eb_vip �ֶ� deadline ��Ϊ serverdate;  
-- 											�޸ı� eb_online_record �ֶ� onlinetimes Ϊ onlinetime, �����ֶ� connecttimes; �������ΨһԼ��
--											�޸ı� eb_vip_interest �ֶ� interesttype ��������Ψһ
--											��Ͷ�߱�ϲ���ˢ����¼����
--	ver-1.03	2015-12-22		wanghaowen	�޸�Ȩ���

-- ******************************************************--
-- ******************************************************--

/*�������ݿ�*/

DROP DATABASE IF EXISTS eb;			/*ɾ�����ݿ�*/
CREATE DATABASE IF NOT EXISTS eb;	/*�������ݿ�*/
ALTER DATABASE eb CHARSET=utf8;
USE eb;								/*ʹ�����ݿ�*/


/*������*/

/*���ñ�*/
DROP TABLE IF EXISTS eb_config;
CREATE TABLE IF NOT EXISTS `eb_config` (
  `id` INT NOT NULL AUTO_INCREMENT COMMENT '�������Զ�����',
  `ebkey` INT NOT NULL COMMENT 'key-��',  
  `ebvalue` VARCHAR(1000) NOT NULL COMMENT 'value-ֵ',
  `ebdesc` VARCHAR(100) NOT NULL COMMENT '��ֵ˵��',
  PRIMARY KEY (`id`),
  UNIQUE KEY (`ebkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='���ñ�';

/*����Ա��*/
DROP TABLE IF EXISTS eb_admin;
CREATE TABLE IF NOT EXISTS `eb_admin` (
  `id` INT NOT NULL AUTO_INCREMENT COMMENT '�������Զ�����',
  `account` VARCHAR(20) NOT NULL UNIQUE COMMENT '�˺�',
  `pwd` VARCHAR(32) NOT NULL COMMENT '���룬MD5����',
  `sn` INT NOT NULL UNIQUE COMMENT '���',
  `name` VARCHAR(10) NOT NULL COMMENT '����',
  `idcard` VARCHAR(18) NOT NULL UNIQUE COMMENT '18λ���֤��',
  `tel` VARCHAR(11) NOT NULL UNIQUE COMMENT '�ֻ���',
  `qq` VARCHAR(20) NOT NULL UNIQUE COMMENT 'QQ��',
  `status` INT NOT NULL DEFAULT 0 COMMENT '״̬��0-������1-����',
  `priviewvip` INT NOT NULL DEFAULT 0 COMMENT 'Ȩ��-�鿴��Ա��0-�ޣ�1-��',
  `priactive` INT NOT NULL DEFAULT 0 COMMENT 'Ȩ��-�����Ա��0-�ޣ�1-��',
  `priaudit` INT NOT NULL DEFAULT 0 COMMENT 'Ȩ��-��˻�Ա��0-�ޣ�1-��',
  `prifrost` INT NOT NULL DEFAULT 0 COMMENT 'Ȩ��-�����Ա��0-�ޣ�1-��',
  `regtime` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'ע��ʱ��',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='����Ա��';


/*�������*/
DROP TABLE IF EXISTS eb_invitecode;
CREATE TABLE IF NOT EXISTS `eb_invitecode` (
  `id` INT NOT NULL AUTO_INCREMENT COMMENT '�������Զ�����',
  `adminid` INT NOT NULL COMMENT '����Աid�����',
  `code` VARCHAR(20) NOT NULL UNIQUE COMMENT '�����룬10-15������ĸ��ϣ�Ψһ',
  `maketime` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '����ʱ��',
  `status` INT NOT NULL DEFAULT 0 COMMENT '0-�����ɣ�1-��ʹ��',
  PRIMARY KEY (`id`),
  KEY `fk_adminid_invitecode` (`adminid`),
  CONSTRAINT `fk_adminid_invitecode` FOREIGN KEY (`adminid`)
  REFERENCES `eb_admin` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='�������';


/*vip�û���*/
DROP TABLE IF EXISTS eb_vip;
CREATE TABLE IF NOT EXISTS `eb_vip` (
  `id` INT NOT NULL AUTO_INCREMENT COMMENT '�������Զ�����',
  `adminid` INT NOT NULL COMMENT '����Աid�����',
  `account` VARCHAR(20) NOT NULL UNIQUE COMMENT '�˺�',
  `pwd` VARCHAR(32) NOT NULL COMMENT '���룬MD5����',
  `sn` INT NOT NULL UNIQUE COMMENT '���',
  `name` VARCHAR(10) NOT NULL COMMENT '����',
  `sex` INT NOT NULL DEFAULT 0 COMMENT '�Ա�0-�У�1-Ů',
  `photopath` VARCHAR(200) NOT NULL DEFAULT "" COMMENT '�û�ͷ����Ƭ·��',
  `handidpath` VARCHAR(200) NOT NULL DEFAULT "" COMMENT '�û��ֳ����֤��Ƭ·��',
  `useridpath` VARCHAR(200) NOT NULL DEFAULT "" COMMENT '�û����֤������Ƭ·��',
  `area` VARCHAR(16) NOT NULL COMMENT '�������Ĵ�ʡ�������С�����',
  `address` VARCHAR(100) NOT NULL COMMENT '��ַ���Ĵ�ʡ�ɶ��������������',
  `qq` VARCHAR(20) NOT NULL UNIQUE COMMENT 'QQ��',
  `referrerqq` VARCHAR(20) DEFAULT "" COMMENT '�Ƽ���QQ�ţ�����Ϊ��',
  `tel` VARCHAR(11) NOT NULL UNIQUE COMMENT '�ֻ���',
  `viplevel` INT NOT NULL DEFAULT 1 COMMENT '��Ա�ȼ�',
  `serverdate` DATE NOT NULL COMMENT '����������',
  `isaudit` INT NOT NULL DEFAULT 0 COMMENT '�Ƿ�����ˣ�0-��1-��',
  `status` INT NOT NULL DEFAULT 0 COMMENT '״̬��0-������1-����',
  `regtime` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'ע��ʱ��',
  `lastlogintime` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '���������¼ʱ��',
  `statuscz` INT NOT NULL DEFAULT 0 COMMENT '״̬-�����ˣ�0-���ߣ�1-���У�2-æµ',
  `statusgx` INT NOT NULL DEFAULT 0 COMMENT '״̬-����ˣ�0-���ߣ�1-���У�2-æµ',
  `ipcz` VARCHAR(20) NOT NULL DEFAULT "" COMMENT 'IP-������',
  `ipgx` VARCHAR(20) NOT NULL DEFAULT "" COMMENT 'IP-�����',
  `macgx` VARCHAR(24) NOT NULL DEFAULT "" COMMENT 'MAC-�����',
  `anydeskid` VARCHAR(32) NOT NULL DEFAULT "" COMMENT "AnyDesk ID��",
  `cht` INT NOT NULL DEFAULT 0 COMMENT '�ʺ���',
  `chd` INT NOT NULL DEFAULT 0 COMMENT '�ʺ綹',
  PRIMARY KEY (`id`),
  KEY `fk_adminid_vip` (`adminid`),
  CONSTRAINT `fk_adminid_vip` FOREIGN KEY (`adminid`)
  REFERENCES `eb_admin` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='vip�û���';



/*vipȨ���*/
DROP TABLE IF EXISTS eb_vip_interest;
CREATE TABLE IF NOT EXISTS `eb_vip_interest` (
  `id` INT NOT NULL AUTO_INCREMENT COMMENT '�������Զ�����',
  `type` VARCHAR(30) NOT NULL COMMENT 'Ȩ������',
  `level` INT NOT NULL COMMENT '��Ա�ȼ�',
  `value` INT NOT NULL DEFAULT 1 COMMENT 'Ȩ��ֵ',
  PRIMARY KEY (`id`),
  UNIQUE (`type`, `level`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='vipȨ���';

/*
oncegxsd				�����ˢ��һ�λ��20*x
oncegxscorjg			������ղ�/�ӹ�һ�λ��5*x
oncegxllorztc			���������/ֱͨ��һ�λ��5*x
oncegxshorpj			������ջ�/����һ�λ��2*x
onhookonehouraward		����˹һ�һСʱ���10*x
monthaward				����˵�������600Сʱ���x
shopnum					�ɰ󶨵ĵ�����x
imgquality				Զ�̻���x 1/2
lastonlinetime			��������ʱ��x hour
connecttimes			ÿ�տ����Ӵ���
chargediscount			��ֵ�ۿ�
onceczsd				������ˢ��һ������30
onceczscorjg			�������ղ�/�ӹ�һ�λ��5
onceczllorztc			����������/ֱͨ��һ�λ��5
onceczshorpj			�������ջ�/����һ�λ��2
*/


/*���߼�¼��*/
DROP TABLE IF EXISTS eb_online_record;
CREATE TABLE IF NOT EXISTS `eb_online_record` (
  `id` INT NOT NULL AUTO_INCREMENT COMMENT '�������Զ�����',
  `vipid` INT NOT NULL COMMENT 'vip id��vip�û������',
  `onlinetype` INT NOT NULL DEFAULT 0 COMMENT '�������ͣ�0-�����ˣ�1-�����',
  `onlinedate` DATE NOT NULL COMMENT '��������',
  `onlinetime` INT NOT NULL DEFAULT 0 COMMENT '����ʱ������λ����',
  `connecttimes` INT NOT NULL DEFAULT 0 COMMENT '����(��)���Ӵ���',
  `checkout` INT NOT NULL DEFAULT 0 COMMENT '�Ƿ��Ѿ����� 0-δ���� 1-�ѽ���',
  PRIMARY KEY (`id`),
  UNIQUE (`vipid`, `onlinetype`, `onlinedate`),
  KEY `fk_vipid_online_record` (`vipid`),
  CONSTRAINT `fk_vipid_online_record` FOREIGN KEY (`vipid`)
  REFERENCES `eb_vip` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='���߼�¼��';


/*Ӳ����*/
DROP TABLE IF EXISTS eb_hardware;
CREATE TABLE IF NOT EXISTS `eb_hardware` (
  `id` INT NOT NULL AUTO_INCREMENT COMMENT '�������Զ�����',
  `ownerid` INT NOT NULL COMMENT 'ӵ����id��vip�û������',
  `img1config` VARCHAR(260) NOT NULL COMMENT 'ͼƬ-��������',
  `img2config` VARCHAR(260) NOT NULL COMMENT 'ͼƬ-��������',
  `imgpc` VARCHAR(260) NOT NULL COMMENT 'ͼƬ-��̨����ͼ',
  `imgmodem` VARCHAR(260) NOT NULL COMMENT 'ͼƬ-��̨��è',
  PRIMARY KEY (`id`),
  KEY `fk_ownerid_hardware` (`ownerid`),
  CONSTRAINT `fk_ownerid_hardware` FOREIGN KEY (`ownerid`)
  REFERENCES `eb_vip` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Ӳ����';

/*С�ű�*/
DROP TABLE IF EXISTS eb_account;
CREATE TABLE IF NOT EXISTS `eb_account` (
  `id` INT NOT NULL AUTO_INCREMENT COMMENT '�������Զ�����',
  `ownerid` INT NOT NULL COMMENT 'ӵ����id��vip�û������',
  `name` VARCHAR(60) NOT NULL UNIQUE COMMENT '����',
  `accountlevel` INT NOT NULL DEFAULT 0 COMMENT 'С�ŵȼ�',
  `img` VARCHAR(260) NOT NULL COMMENT 'ͼƬ',
  `sex` INT NOT NULL DEFAULT 0 COMMENT '�Ա�0-�У�1-Ů',
  `age` INT NOT NULL DEFAULT 0 COMMENT '���䣬0-70��1-80��2-90��3-00��',
  `consume` INT NOT NULL DEFAULT 0 COMMENT '���ѷ�Χ��0-��0-100����1-��101-200����2-��201-400����3-401����',
  `category` VARCHAR(20) NOT NULL COMMENT '��Ŀ��ǩ',
  `accounttype` INT NOT NULL DEFAULT 0 COMMENT '�˺����ͣ�0-�Ա��˺ţ�1-�����˺�',
  PRIMARY KEY (`id`),
  KEY `fk_ownerid_account` (`ownerid`),
  CONSTRAINT `fk_ownerid_account` FOREIGN KEY (`ownerid`)
  REFERENCES `eb_vip` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='С�ű�';

/*���̱�*/
DROP TABLE IF EXISTS eb_shop;
CREATE TABLE IF NOT EXISTS `eb_shop` (
  `id` INT NOT NULL AUTO_INCREMENT COMMENT '�������Զ�����',
  `ownerid` INT NOT NULL COMMENT 'ӵ����id��vip�û������',
  `name` VARCHAR(60) NOT NULL UNIQUE COMMENT '����',
  `shoplevel` INT NOT NULL DEFAULT 0 COMMENT '���̵ȼ�',
  `img` VARCHAR(260) NOT NULL COMMENT 'ͼƬ',
  PRIMARY KEY (`id`),
  KEY `fk_ownerid_shop` (`ownerid`),
  CONSTRAINT `fk_ownerid_shop` FOREIGN KEY (`ownerid`)
  REFERENCES `eb_vip` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='���̱�';

/*��ֵ��*/
DROP TABLE IF EXISTS eb_recharge;
CREATE TABLE IF NOT EXISTS `eb_recharge` (
  `id` INT NOT NULL AUTO_INCREMENT COMMENT '�������Զ�����',
  `oprid` INT NOT NULL COMMENT '����Աid��admin���',
  `vipid` INT NOT NULL COMMENT '��ֵ��Աid��vip�û������',
  `sn` VARCHAR(60) NOT NULL COMMENT '��ֵ������',
  `money` DECIMAL(11,2) NOT NULL DEFAULT 0.00 COMMENT '��ֵ���',
  `chicon` INT NOT NULL DEFAULT 0 COMMENT '�ʺ��ű�',
  `status` INT NOT NULL DEFAULT 0 COMMENT '״̬��0-ʧ�ܣ�1-�ɹ�',
  `rechargetime` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '��ֵʱ��',
  PRIMARY KEY (`id`),
  KEY `fk_oprid_recharge` (`oprid`),
  KEY `fk_vipid_recharge` (`vipid`),
  CONSTRAINT `fk_oprid_recharge` FOREIGN KEY (`oprid`)
  REFERENCES `eb_admin` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_vipid_recharge` FOREIGN KEY (`vipid`)
  REFERENCES `eb_vip` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='��ֵ��';




/*ˢ����*/
-- ˢ�����������Խ���ʱ��Ϊ׼
DROP TABLE IF EXISTS eb_sd;
CREATE TABLE IF NOT EXISTS `eb_sd` (
  `id` INT NOT NULL AUTO_INCREMENT COMMENT '�������Զ�����',
  `czid` INT NOT NULL COMMENT '������id��vip�û������',
  `gxid` INT NOT NULL COMMENT '�����id��vip�û������',
  `oprtype` INT NOT NULL COMMENT '�������ͣ�0-ˢ����1-�ղ�/�ӹ���2-����/ֱͨ����3-����/�ջ�',
  `xh` VARCHAR(40) NOT NULL COMMENT 'С��',
  `sdtype` INT NOT NULL DEFAULT 0 COMMENT 'ˢ�����ͣ�0-�Ա�����1-������',
  `category` VARCHAR(20) NOT NULL COMMENT '��Ŀ',
  `shop` VARCHAR(60) NOT NULL COMMENT '������',
  `orderid` VARCHAR(60) NOT NULL COMMENT '������',
  `money` decimal(11,2) NOT NULL DEFAULT 0.00 COMMENT '���',
  `linknum` INT NOT NULL DEFAULT 0 COMMENT '���µ�������',
  `begintime` DATETIME NOT NULL COMMENT '��ʼʱ��',
  `endtime` DATETIME NOT NULL COMMENT '����ʱ��',
  `orderstatus` INT NOT NULL COMMENT '����״̬��0-���ղأ�1-���µ���2-�Ѹ��3-���ջ�',
  `evaluatetime` DATETIME NOT NULL COMMENT '����ʱ��',
  `evaluate` VARCHAR(600) NOT NULL COMMENT '����',
  `status` INT NOT NULL DEFAULT 0 COMMENT 'ˢ��״̬��0-ʧ�ܣ�1-�ɹ�',
  `complaintcontent` VARCHAR(1000) COMMENT 'Ͷ������ ����Ϊ�գ���ʾû��Ͷ��',
  `complainttime` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Ͷ��ʱ��',
  PRIMARY KEY (`id`),
  KEY `fk_czid_sd` (`czid`),
  KEY `fk_gxid_sd` (`gxid`),
  CONSTRAINT `fk_czid_sd` FOREIGN KEY (`czid`)
  REFERENCES `eb_vip` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_gxid_sd` FOREIGN KEY (`gxid`)
  REFERENCES `eb_vip` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='ˢ����';



/*Ͷ�߱�*/     -- �ϲ���ˢ����¼��
-- DROP TABLE IF EXISTS eb_complaint;
-- CREATE TABLE IF NOT EXISTS `eb_complaint` (
  -- `id` INT NOT NULL AUTO_INCREMENT COMMENT '�������Զ�����',
  -- `sdid` INT NOT NULL COMMENT 'ˢ��id��sd�����',
  -- `content` VARCHAR(1000) NOT NULL COMMENT 'Ͷ������',
  -- `complainttime` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Ͷ��ʱ��',
  -- PRIMARY KEY (`id`),
  -- KEY `fk_sdid_complaint` (`sdid`),
  -- CONSTRAINT `fk_sdid_complaint` FOREIGN KEY (`sdid`)
  -- REFERENCES `eb_sd` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
-- ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Ͷ�߱�';


/* ������ʹ�ù����ͳ�Ʊ� */
DROP TABLE IF EXISTS eb_usegx_count;
CREATE TABLE IF NOT EXISTS `eb_usegx_count` (
	`id` INT NOT NULL AUTO_INCREMENT COMMENT '�������Զ�����',
	`czid` INT NOT NULL COMMENT '������id��vip�û������',
	`gxid` INT NOT NULL COMMENT '�����id��vip�û������',
	`usetimes` INT NOT NULL DEFAULT 0 COMMENT 'ʹ�ô���',
	`lastusetime` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '���ʹ��ʱ��',
	`remark` VARCHAR(600) NOT NULL DEFAULT "" COMMENT 'ʹ�ñ�ע',
	PRIMARY KEY (`id`),
	UNIQUE (`czid`, `gxid`),
	KEY `fk_czid_use` (`czid`),
	KEY `fk_gxid_use` (`gxid`),
	CONSTRAINT `fk_czid_use` FOREIGN KEY (`czid`)
	REFERENCES `eb_vip` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT `fk_gxid_use` FOREIGN KEY (`gxid`)
	REFERENCES `eb_vip` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='������ʹ�ù����ͳ�Ʊ�';


/* ������ ���²���ˢ����¼ʱ���Զ����²�����ʹ�ù���˵�ͳ�Ʊ� */
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


/*����*/
DROP TABLE IF EXISTS eb_ad;
CREATE TABLE IF NOT EXISTS `eb_ad` (
  `id` INT NOT NULL AUTO_INCREMENT COMMENT '�������Զ�����',
  `img` VARCHAR(260) NOT NULL COMMENT '���ͼƬ·��',
  `url` VARCHAR(1000) NOT NULL COMMENT '�������url',
  `pos` VARCHAR(1000) NOT NULL COMMENT '���λ��',
  `displaydays` VARCHAR(1000) NOT NULL COMMENT 'չʾ����',
  `publishtime` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '��淢��ʱ��',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='����';

/*�����*/
DROP TABLE IF EXISTS eb_notice;
CREATE TABLE IF NOT EXISTS `eb_notice` (
  `id` INT NOT NULL AUTO_INCREMENT COMMENT '�������Զ�����',
  `img` VARCHAR(260) NOT NULL COMMENT '����ͼƬ·��',
  `content` VARCHAR(1000) NOT NULL COMMENT '��������',
  `publishtime` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '���淢��ʱ��',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='�����';




/* * ��̳�� * */

/*��Ŀ��*/
DROP TABLE IF EXISTS eb_category ;
CREATE TABLE IF NOT EXISTS `eb_category` (
  `id` INT NOT NULL AUTO_INCREMENT COMMENT '�������Զ�����',
  `name` VARCHAR(20) NOT NULL COMMENT '��Ŀ����',
  `comm` VARCHAR(40) NOT NULL COMMENT '��Ŀ˵��',
  `pid` INT NOT NULL DEFAULT 0 COMMENT '��id������������Ĭ��Ϊ0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='��Ŀ��';

ALTER TABLE eb_category AUTO_INCREMENT 1;


/*���±�*/
DROP TABLE IF EXISTS eb_article;
CREATE TABLE IF NOT EXISTS `eb_article` (
  `id` INT NOT NULL AUTO_INCREMENT COMMENT '�������Զ�����',
  `categoryid` INT NOT NULL COMMENT '��Ŀid��category�����',
  `authorid` INT NOT NULL COMMENT '����id��vip�����',
  `title` VARCHAR(100) NOT NULL COMMENT '���±���',
  `content` VARCHAR(20000) NOT NULL COMMENT '��������',
  `publishtime` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '���·���ʱ��',
  `replynum` INT NOT NULL COMMENT '������',
  `lastreplyer` VARCHAR(100) NOT NULL COMMENT '���������',
  `reviewnum` INT NOT NULL COMMENT '�鿴����',
  PRIMARY KEY (`id`),
  KEY `fk_categoryid_article` (`categoryid`),
  KEY `fk_authorid_article` (`authorid`),
  CONSTRAINT `fk_categoryid_article` FOREIGN KEY (`categoryid`)
  REFERENCES `eb_category` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_authorid_article` FOREIGN KEY (`authorid`)
  REFERENCES `eb_vip` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='���±�';

/* ���۱� */
DROP TABLE IF EXISTS eb_review;
CREATE TABLE IF NOT EXISTS `eb_review` (
  `id` INT NOT NULL AUTO_INCREMENT COMMENT '�������Զ�����',
  `articleid` INT NOT NULL COMMENT '����id��article�����',
  `reviewerid` INT NOT NULL COMMENT '������id��vip�����',
  `content` VARCHAR(2000) NOT NULL COMMENT '��������',
  `commenttime` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '����ʱ��',
  PRIMARY KEY (`id`),
  KEY `fk_articleid_review` (`articleid`),
  KEY `fk_reviewerid_review` (`reviewerid`),
  CONSTRAINT `fk_articleid_review` FOREIGN KEY (`articleid`)
  REFERENCES `eb_article` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_reviewerid_review` FOREIGN KEY (`reviewerid`)
  REFERENCES `eb_vip` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='���۱�';



-- ****************************************************************************
-- ����Ϊ�����õ�����

set character_set_client = gbk;		/* ��������ʱ�������������� */


/*
���ñ�(ע���Ѿ���ӵ���Ϣ ebkey �����޸�)
*/
INSERT INTO eb_config(ebkey, ebdesc, ebvalue)
VALUES
(1, '��ϵ����', '<a href="http://www.baidu.com">�ʺ����</a><br>��ϵ�绰��10000000000<br>��ַ���ʺ��ʺ�·�ʺ���888�Ųʺ���'),
(2, '������Ϣ', '<B>����</B><br>1������ף�زʺ����ƽ̨�ɹ����ߡ�<br>2�����һ�ӭ<a href="http://www.baidu.com">�������</a>��פ��ƽ̨'),
(3, '��������(chd)', '500'),
(4, '����������(chd)', '1500'),
(5, '��������(chd)', '5000'),
(6, '���������ʱ�䳬��?Сʱ������', '72'),
(7, '���������ʱ�䳬��?Сʱ�������˺Ų��۳�һ�����', '120'),
(8, '���������ʱ�䳬��?Сʱ��ֱ��ɾ���˺�', '240'),
(9, '�����ǰһ������ʱ�䲻�㣬���������¼���۳��Ľ����', '150'),
(10, '�����Ա�˺�ʱ�۳��Ľ����', '2000');

/*
����Ա����
*/
INSERT INTO eb_admin (account,pwd,sn,name,idcard,tel,qq) VALUES
('admin1', MD5('88888888'), 100001, 'AA1', '123456789012345671', '13000000001', '123456781'),
('admin2', MD5('88888888'), 100002, 'AA2', '123456789012345672', '13000000002', '123456782'),
('admin3', MD5('88888888'), 100003, 'AA3', '123456789012345673', '13000000003', '123456783'),
('admin4', MD5('88888888'), 100004, 'AA4', '123456789012345674', '13000000004', '123456784'),
('admin5', MD5('88888888'), 100005, 'AA5', '123456789012345675', '13000000005', '123456788'),
('admin6', MD5('88888888'), 100006, 'AA6', '123456789012345676', '13000000006', '123456786');

/*
VIP ����
*/
INSERT INTO eb_vip
(adminid, account, pwd, sn, name, area, address, qq, tel, isaudit, serverdate, anydeskid) 
VALUES
(1, 'account001', MD5('88888888'), 10001, 'name001', '�Ĵ�ʡ', '�ɶ�', 'qq001', '15000000001', 0, '2016-01-01', 'AnyDesk0001'),
(2, 'account002', MD5('88888888'), 10002, 'name002', '����ʡ', '�人', 'qq002', '15000000002', 0, '2016-01-01', 'AnyDesk0002'),
(3, 'account003', MD5('88888888'), 10003, 'name003', '����ʡ', '��ɳ', 'qq003', '15000000003', 1, '2016-01-01', 'AnyDesk0003'),
(4, 'account004', MD5('88888888'), 10004, 'name004', '����', '����', 'qq004', '15000000004', 1, '2016-01-01', 'AnyDesk0004'),
(5, 'account005', MD5('88888888'), 10005, 'name005', '�㶫ʡ', '����', 'qq005', '15000000005', 1, '2016-01-01', 'AnyDesk0005'),
(6, 'account006', MD5('88888888'), 10006, 'name006', 'ɽ��ʡ', '��ͬ', 'qq006', '15000000006', 1, '2016-01-01', 'AnyDesk0006');

/*
Ȩ�������
-- ÿ�տ����Ӵ���

-- gjhdchdbs �һ�1Сʱ�ɻ��chdΪ 10*value
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
oncegxsd				�����ˢ��һ�λ��
oncegxscorjg			������ղ�/�ӹ�һ�λ��
oncegxllorztc			���������/ֱͨ��һ�λ��
oncegxshorpj			������ջ�/����һ�λ��
onhookonehouraward		����˹һ�һСʱ���
monthaward				����˵�������600Сʱ���
shopnum					�ɰ󶨵ĵ�����
imgquality				Զ�̻��� 1/2
lastonlinetime			��������ʱ�� (Сʱ)
connecttimes			ÿ�տ����Ӵ���
chargediscount			��ֵ�ۿ�
onceczsd				������ˢ��һ������30
onceczscorjg			�������ղ�/�ӹ�һ�λ��5
onceczllorztc			����������/ֱͨ��һ�λ��5
onceczshorpj			�������ջ�/����һ�λ��2
payfortenmin			ÿ10�����շ�
*/




/*
���߼�¼����
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
С�ű�
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
���̱�
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
��ֵ��
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
ˢ����
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
��Ŀ��
*/
INSERT INTO eb_category(name,comm, pid) VALUES
('����ר��','���� �Ա��ɻ����߼��淨1', 0),
('����ר��','���� �Ա��ɻ����߼��淨2',  0),
('վ��칫','���� �Ա��ɻ����߼��淨3',  0),
('���ʱش�','���� �Ա��ɻ����߼��淨4',  1),
('��������','���� �Ա��ɻ����߼��淨5',  1),
('��������','���� �Ա��ɻ����߼��淨6',  1),
('�ٱ�ƭ��','���� �Ա��ɻ����߼��淨7',  1),
('�����г�','���� �Ա��ɻ����߼��淨8',  1),
('�����о�','���� �Ա��ɻ����߼��淨9',  2),
('�ɻ�����','���� �Ա��ɻ����߼��淨a',  2),
('΢��ר��','���� �Ա��ɻ����߼��淨b',  2),
('��Ӫ�ɻ�','���� �Ա��ɻ����߼��淨c',  2),
('վ���շѽ̳�','���� �Ա��ɻ����߼��淨d',  2),
('����ר��','���� �Ա��ɻ����߼��淨e',  2),
('�����Ӧ�é���վ','���� �Ա��ɻ����߼��淨',  2),
('����װ�ީ��ز�', '���� �Ա��ɻ����߼��淨', 2),
('���ɷ���', '���� �Ա��ɻ����߼��淨', 2),
('���񹫸�','���� �Ա��ɻ����߼��淨',  3),
('���ӻ���','���� �Ա��ɻ����߼��淨',  3);



