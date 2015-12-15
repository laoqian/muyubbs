<?php
namespace Home\Controller;
use Think\Controller;
class AdminController extends Controller {

  function __construct() {
    parent::__construct();
    //构造函数
    $state = session('state');
    if($state){
      session('state', "1");
      $user = session('user');
      session('user', $user);
    }
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


  public  function  config(){

//    $config = M("config");
//
//    $data = $config->select();
//
//    $this->assign("config",$data);

    $this->show();
  }

  public  function  config_get(){
    $config = M("config");

    $data = $config->select();
    if($data){
      $ret["status"] =1;
      $ret["config"]=$data;
    }else{
      $ret["status"]=0;
    }

    $this->ajaxReturn($ret);
  }

  public  function  config_post(){

    $len = count($_POST["key"]);

    for($i=0;$i<$len;$i++){
      $data[$i]['ebkey']= $_POST["key"][$i];
      $data[$i]['ebvalue']= $_POST["value"][$i];
    }


    $config = M("config");

    $ret = $config->addAll($data);

    if($ret==true){
      $dd["status"]=1;
    }else{
      $dd["status"]=0;
    }
    $this->ajaxReturn($dd);
  }
}