<?php
namespace Home\Controller;
use Think\Controller;
class AdminController extends Controller {

  function __construct() {
    parent::__construct();
    //构造函数
  }

  public  function  actcode(){

    $this->show();
  }


  public  function  charge(){

    $tpl["bit"] = 100;

    $this->assign($tpl);

    $this->show();
  }

  public  function  userinfo(){

    $Model = M('user');

    $map["phone"] = session("phone");

    $User = $Model->where($map)->select();
    if($User){
      $this->assign("user",$User[0]);
    }else{
      $this->error('没有登录', 'Index/login');
    }

    $this->show();
  }
}