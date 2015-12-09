<?php
namespace Home\Controller;
use Think\Controller;
class UserController extends Controller {

  function __construct() {
    parent::__construct();
    //构造函数

  }

  public function  register_post()
  {
    $params = json_decode(file_get_contents('php://input'), true);

    $Model = M('user');

    $Model->phone = $params["phone"];
    $Model->password = $params["passwd"];
    $Model->level = 7;
    $Model->vmoney = 456;
    $Model->admin = 0;

    $res = $Model->add();
    if ($res != true) {
      //注册失败
      $this->ajaxReturn("添加用户到数据库失败！");
    }


    //注册成功就保存状态本次不再登录
    cookie('state', "2", 600);
    cookie('phone', $params["phone"],600 );

    $this->ajaxReturn("success");
  }

  //登录处理
  public function login_post(){

    $params = json_decode(file_get_contents('php://input'),true);

    $Model = M('user');

    $map["phone"] = $params["phone"];

    $User = $Model->where($map)->select();

    if($params['passwd']==$User[0]['password']){

      cookie('state', "1", 600);
      cookie('phone', $params["phone"],600 );

      $this->ajaxReturn( "登录成功!");
    }else{
      $this->ajaxReturn( "用户名或者密码错误！");
    }

  }

}