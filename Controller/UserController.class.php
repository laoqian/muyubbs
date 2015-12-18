<?php
namespace Home\Controller;
use Think\Controller;
class UserController extends Controller {

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


  public function  register()
  {
    $upload = new \Think\Upload();// 实例化上传类
    $upload->maxSize   =     2*1024*1024 ;// 设置附件上传大小
    $upload->exts      =     array('jpg', 'gif', 'png', 'jpeg');// 设置附件上传类型
    $upload->rootPath  =     './Application/Home/View/image/'; // 设置附件上传根目录
    $upload->savePath  =     ''; // 设置附件上传（子）目录

    // 上传文件
    $info   =   $upload->upload();
    if(!$info) {// 上传错误提示错误信息
      $this->ajaxReturn("11111");
      return;
    }


    $invite = M("invitecode");

    $query['code'] =session("register")['offer'];

    $ret = $invite->where($query)->select();
    if(!$ret){
      $this->ajaxReturn("22222");
      return;
    }

    //保存用户表
    $user = M('vip');
    $vip['adminid'] =$ret[0]['adminid'];
    $vip['account'] =$_POST['account'];
    $vip['pwd'] =$_POST['password'];
    $vip['sn'] = 111;
    $vip['name'] =$_POST['name'];
    $vip['sex'] =$_POST['sex-man'];
    $vip['area'] =$_POST['area'];
    $vip['address'] =$_POST['address'];
    $vip['referrerqq'] =$_POST['refer-qq'];
    $vip['serverdate'] = date("Y-m-d h:i:sa");
    $vip['isaudit'] =  0;
    $vip['status'] =1;


    $ret = $user->add();
    if($ret){
      $this->display("../index/register-step-3");
    }else{
      $this->ajaxReturn("3333");
    }
  }

  //登录处理
  public function login_post(){

    $params = json_decode(file_get_contents('php://input'),true);

    $Model = M('user');

    $map["phone"] = $params["phone"];

    $User = $Model->where($map)->select();

    if($params['passwd']==$User[0]['password']){

      session('state', "1");
      session('user', $params["phone"]);

      $this->ajaxReturn( "登录成功!");
    }else{
      $this->ajaxReturn( "用户名或者密码错误！");
    }
  }

  public function logout_post(){
    session('state', null);
    session('user', null);

    $data["status"] =1;
    $this->success($data,"Index/index");
  }

  public function login_verify(){
    if(session("state")==1){
      $this->ajaxReturn( "success");
    }else{
      $this->ajaxReturn( "failed");
    }
  }
    //通过算法生成14位邀请码
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


    for ($i = 0; $i < 14; $i++) {
      $result[$i] = rand(0, 1000) % 36;
    }

    $sum = 0;
    for ($i = 0; $i < 14; $i++) {
      $sum += $result[$i];
      if ($sum >= 35) {
        $sum = $sum - 35;
      }
    }

    $result[14] = 35 - $sum;

    $str = $arr[$result[0]];

    for ($i = 1; $i < 15; $i++) {
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

    $invite = M('invitecode');

    foreach($arr as $value){
      $invite->adminid = 1;
      $invite->code= $value;
      $invite->add();
    }

    $ret["status"] = 1;
    $ret["act_code"] = $arr;

    $this->ajaxReturn($ret);
  }

  public  function login_get(){
    if(session("state")==1){
      $data["status"]=1;
    }else{
      $data["status"]=0;
    }

    $this->ajaxReturn($data);
  }


  public  function offer_verify(){
    //校验邀请码

    $invite = M('invitecode');

    $query['code'] = $_POST["offer"];

    //$query['status'] = 0; //测试用先关闭。可以重复使用这个激活码
    $ret = $invite->where($query)->select();

    //理论上查询成功的话，就只有一条数据
    if(count($ret)!=1){
      $this->$data['status'] = 0;
    }else{
        //校验成功保存数据库
        $invite->id = $ret[0]['id'];
        $invite->status = 1;
        $invite->save();

        //校验成功保存在session，后面还要使用
        $register['offer'] = $_POST['offer'];
        session("register",$register);

        $data['status'] = 1;
    }

    $this->ajaxReturn($data);
  }
}


