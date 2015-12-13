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

    $map["phone"] = $params["phone"];

    $user = $Model->where($map)->select();
    if($user[0]){
      //测试用存在就删除，方便重新插入
      $Model->where($map)->delete();
      //$this->ajaxReturn("failed");
    }

    $Model->phone = $params["phone"];
    $Model->passwd = $params["passwd"];
    $Model->level = 7;
    $Model->name = sprintf("user_%d",rand(1000,10000));
    $Model->vmoney = 456;
    $Model->charged = 456;
    $Model->signup_date  = date('Y-m-d H:i:s');
    $Model->admin = 0;

    $res = $Model->add();
    if ($res != true) {
      //注册失败
      $this->ajaxReturn("添加用户到数据库失败！");
    }


    //注册成功就保存状态本次不再登录
    session('state', "2");
    session('phone', $params["phone"] );

    $this->ajaxReturn("success");
  }

  //登录处理
  public function login_post(){

    $params = json_decode(file_get_contents('php://input'),true);

    $Model = M('user');

    $map["phone"] = $params["phone"];

    $User = $Model->where($map)->select();

    if($params['passwd']==$User[0]['password']){

      session('state', "1");
      session('phone', $params["phone"]);

      $this->ajaxReturn( "登录成功!");
    }else{
      $this->ajaxReturn( "用户名或者密码错误！");
    }
  }

  public function logout_post(){
    session('state', "1");
    session('phone', $params["phone"]);
  }
  public function login_verify(){
    if(session("state")==1){
      $this->ajaxReturn( "success");
    }else{
      $this->ajaxReturn( "failed");
    }
  }

    private function active_code_rand($num){
     $arr = array("0", "1", "2", '3',
                  "4", "5", "6", '7',
                  "8", "9", "a", 'b',
                  "c", "d", "e", 'f',
                  "g", "h", "i", 'j',
                  "k", "l", "m", 'n',
                  "o", "p", "q", 'r',
                  "s", "t", "u", 'v',
                  "w", "x", "y", 'z',
                );


    for ($i = 0; $i < 15; $i++) {
      $result[$i] = rand(0, 1000) % 36;
    }

    $sum = 0;
    for ($i = 0; $i < 15; $i++) {
      $sum += $result[$i];
      if ($sum >= 35) {
        $sum = $sum - 35;
      }
    }

    $result[15] = 35 - $sum;

    $str = $arr[$result[0]];

    for ($i = 1; $i < 16; $i++) {
      $str = $str . "" . $arr[$result[$i]];
    }
    return $str;
  }

  private function active_code_rand_by($num){
    for($i=0;$i<$num;$i++){
      $arr[$i]=$this->active_code_rand();
    }

    return $arr;
  }

  public function active_code()
  {

    $num = $_POST["num"];

    if($num>20) $num=20;
    elseif($num<=0) $num=1;
    $arr = $this->active_code_rand_by($num);

    $ret["status"] = 1;
    $ret["act_code"] = $arr;

    $this->ajaxReturn($ret);

  }
}


