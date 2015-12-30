<?php
/**
 * Created by PhpStorm.
 * User: gg
 * Date: 2015/12/30
 * Time: 17:10
 */

namespace Home\Model;
use Think\Model;
class AdminModel extends Model{
  protected $tableName = 'admin';

  protected $_validate = array(
    array('account','require','账户为空或者已经存在',0,'unique',1),
    array('pwd','require','密码是必须的'),
    array('pwd1','pwd','两次密码必须一致',0,'confirm'),
    array('name','require','名字是必须的'),
    array('idcard','require','身份证号码为空或者已经存在',0,'unique',1),
    array('tel','require','电话号码为空或者已经存在',0,'unique',1),
    array('qq','require','qq号码为空或者已经存在',0,'unique',1),
    array('status',array(0,1),'状态范围不对',0,'in'),
    array('priviewvip',array(0,1),'查看会员范围不对',0,'in'),
    array('priactive',array(0,1),'激活会员范围不对',0,'in'),
    array('priaudit',array(0,1),'审核会员范围不对',0,'in'),
    array('prifrost',array(0,1),'冻结会员范围不对',0,'in'),
  );

  protected function sn_create(){
    $acc = $this->order('sn DESC')->limit(1)->select();
    if($acc){
      return  $acc[0]['sn']+1;
    }else{
      return 334455;
    }
  }

  protected $_auto = array (
    array('pwd','md5',3,'function') , // 对password字段在新增和编辑的时候使md5函数处理
    array('sn','sn_create',3,'callback'), // 对sn字段在新增和编辑的时候回调getName方法
  );
}