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

  public  function  config_load(){
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
    $data = $_POST["config"];

    $config = M("config");
    foreach($data as $value){
      $ret = $config->save($value);
    }


    $dd["status"]=1;

    $this->ajaxReturn($dd);
  }


  public function  bbs_blk_load(){

    $config = M("category");

    $data = $config->select();
    if($data){
      $ret["status"] =1;
      $ret["config"]=$data;
    }else{
      $ret["status"]=0;
    }

    $this->ajaxReturn($ret);
  }

  public  function  bbs_blk_post(){
    $data = $_POST["config"];

    $config = M("category");
    foreach($data as $value){

      if($value['attr'] != "new"){
        $config->save($value);
      }else{
        $map['name']= $value['name'];
        if($config->where($map)->select()){
          continue;
        }

        $config->name=$value["name"];
        $config->pid=$value["pid"];
        $config->comm=$value["comm"];
        $config->add();
      }

    }

    $dd["status"]=1;

    $this->ajaxReturn($dd);
  }
}