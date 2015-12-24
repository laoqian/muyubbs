<?php
namespace Home\Controller;
use Think\Controller;

require "webMap.php";

class UserController extends Controller {

  function __construct() {
    parent::__construct();
    //构造函数

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
      $data['status'] = 0;
      $data['error'] = "上传图片失败，请稍后重试。";
      $this->ajaxReturn($data);
      return;
    }


    $invite = M("invitecode");

    $query['code'] = session("register")['offer'];

    $ret = $invite->where($query)->select();
    if(!$ret){
      $data['status'] = 0;
      $data['error'] = "服务器异常，请稍后重试。";
      $this->ajaxReturn($data);
      return;
    }

    //保存用户表
    $user = M('vip');

    $vip['adminid'] =$ret[0]['adminid'];
    $vip['account'] =$_POST['account'];
    $vip['pwd'] = md5($_POST['password']);

    $vip['name'] =$_POST['name'];

    if($_POST['sex-man']=="on"){
      $vip['sex'] =0;
    } else{
      $vip['sex'] =1;
    }

    $vip['area'] =$_POST['area'];
    $vip['address'] =$_POST['address'];
    $vip['qq'] =$_POST['qq'];
    $vip['referrerqq'] =$_POST['refer-qq'];
    $vip['tel'] =$_POST['phone'];
    $vip['serverdate'] = date("Y-m-d h:i:sa");
    $vip['isaudit'] =  0;
    $vip['status'] =1;

    $vip['handidpath'] = __ROOT__.'/'. "Application/Home/View/image/"."".$info["user-hand-id"]['savepath']."".$info["user-hand-id"]['savename'];
    $vip['useridpath'] = __ROOT__.'/'."Application/Home/View/image/"."".$info["user-id"]['savepath']."".$info["user-id"]['savename'];

    //先检查重复
    $query=[];
    $query['account'] = $vip['account'];

    $acc = $user->where($query)->select();
    if($acc){
      $data['status'] = 0;
      $data['error'] = "用户名重复,请更改后重试。";
      $this->ajaxReturn($data);
      return;
    }

    //qq号码检查重复
    $query=[];
    $query['qq'] = $vip['qq'];

    $acc = $user->where($query)->select();
    if($acc){
      $data['status'] = 0;
      $data['error'] = "QQ号码重复,请更改后重试。";
      $this->ajaxReturn($data);
      return;
    }

    //手机号码检查重复
    $query=[];
    $query['tel'] = $vip['phone'];

    $acc = $user->where($query)->select();
    if($acc){
      $data['status'] = 0;
      $data['error'] = "手机号码重复,请更改后重试。";
      $this->ajaxReturn($data);
      return;
    }

    //编号生成
    $acc = $user->order('sn DESC')->limit(1)->select();
    if($acc){
      $vip['sn'] = $acc[0]['sn']+1;
    }else{
      $vip['sn'] = 77556688;
    }

    //用户数据存进数据库
    $ret = $user->data($vip)->add();
    if($ret){

      //注册成功后就自动进入登录状态
      $query=[];
      $query["tel"] = $vip['tel'];
      $vip = $user->where($query)->select();
      session("user",$vip[0]);

      //返回注册成功信息
      $data['status'] = 1;
      $data['next'] = "register-step-3.html";
      $this->ajaxReturn($data);
    }else{
      $data['status'] = 0;
      $data['error'] = "注册失败，请稍后重试。";
      $this->ajaxReturn($data);
      return;
    }
  }

  //登录处理
  public function login(){
    $vip = M('vip');

    $query['account'] = $_POST['account'];
    $query['pwd']= md5($_POST['pwd']);

    $user = $vip->where($query)->select();
    if(!$user){
      $data['status'] =0;
      $this->ajaxReturn($data);
      return;
    }


    $data['status'] =1;
    $user[0]['login'] = 1;
    $data['user'] = $user[0];
    session('user',$user[0]);

    $this->ajaxReturn($data);
  }

  //返回登录状态
  public function state(){
   $data['status']=1;
   $data['user']= session('user');
   $this->ajaxReturn($data);
  }


  public function logout(){
    session("user",null);
    $data['status'] = 1;


    //用于退出登录后，是否要进行页面跳转
    if(session('logout_next')){
      $data['next'] = 1;
    }else{
      $data['next'] = 0;
    }

    $this->ajaxReturn($data);
  }

  public function login_verify(){
    if(session("state")==1){
      $this->ajaxReturn( "success");
    }else{
      $this->ajaxReturn( "failed");
    }
  }
    //通过算法生成15位邀请码
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
    $query['status'] = 0;
    $ret = $invite->where($query)->select();

    //理论上查询成功的话，就只有一条数据
    if(count($ret)!=1){
      $data['status'] = 0;
      $data['error'] = "邀请码无效.";
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


  public function  submit_tb()
  {
    //先判断是否登录，不能登录不能进行操作。登录成功后，会将改用户信息保存在session的user字段中
    $user = session("user");
    if(!$user){
      $data['status'] = 0;
      $data['error'] = "没有登录，请先登录。";
      $this->ajaxReturn($data);
      return;
    }

    // 上传文件
    $upload = new \Think\Upload();// 实例化上传类
    $upload->maxSize   =     2*1024*1024 ;// 设置附件上传大小
    $upload->exts      =     array('jpg', 'gif', 'png', 'jpeg');// 设置附件上传类型
    $upload->rootPath  =     './Application/Home/View/image/'; // 设置附件上传根目录
    $upload->savePath  =     ''; // 设置附件上传（子）目录
    $info   =   $upload->upload();

    if(!$info) {// 上传错误提示错误信息
      $data['status'] = 0;
      $data['error'] = "上传图片失败，请稍后重试。";
      $this->ajaxReturn($data);
      return;
    }

    $account = M("account");

    $acc['ownerid'] = $user['id'];
    $acc['name'] = $_POST['tb-name'];
    $acc['accountlevel'] = $_POST['level'];
    $acc['img'] = __ROOT__.'/'."Application/Home/View/image/"."".$info["tb-img"]['savepath']."".$info["tb-img"]['savename'];
    $acc['sex'] = $_POST['sex'];
    $acc['age'] = $_POST['age'];
    $acc['consume'] = $_POST['consume'];
    $acc['category'] = "初出茅庐";
    $acc['accounttype'] = $_POST['accounttype'];

    $query['name'] = $acc["name"];

    $ret = $account->where($query)->select();
    if($ret){
      $data['status'] = 0;
      $data['error'] = "该小号已存在,请更改后重试。";
      $this->ajaxReturn($data);
      return;
    }

    //保存数据库
    $ret = $account->data($acc)->add();
    if($ret){
      $data['status'] = 1;
      $data['next'] = "register-step-4.html";
      $this->ajaxReturn($data);
    }else{
      $data['status'] = 0;
      $data['error'] = "上传小号资料失败，请稍后重试。";
      $this->ajaxReturn($data);
      return;
    }
  }


  public function  submit_shop()
  {

    //先判断是否登录，不能登录不能进行操作。登录成功后，会将改用户信息保存在session的user字段中
    $user = session("user");
    if(!$user){
      $data['status'] = 0;
      $data['error'] = "没有登录，请先登录。";
      $this->ajaxReturn($data);
      return;
    }

    //登录成功后才能处理
    // 上传文件
    $upload = new \Think\Upload();// 实例化上传类
    $upload->maxSize   =     2*1024*1024 ;// 设置附件上传大小
    $upload->exts      =     array('jpg', 'gif', 'png', 'jpeg');// 设置附件上传类型
    $upload->rootPath  =     './Application/Home/View/image/'; // 设置附件上传根目录
    $upload->savePath  =     ''; // 设置附件上传（子）目录
    $info   =   $upload->upload();

    if(!$info) {// 上传错误提示错误信息
      $data['status'] = 0;
      $data['error'] = "上传图片失败，请稍后重试。";
      $this->ajaxReturn($data);
      return;
    }

    $shop = M("shop");

    $acc['ownerid'] = $user['id'];
    $acc['name'] = $_POST['name'];
    $acc['shoplevel'] = $_POST['level'];
    $acc['img'] = __ROOT__.'/'."Application/Home/View/image/"."".$info["img"]['savepath']."".$info["img"]['savename'];

    $query['ownerid'] = $acc["ownerid"];
    $ret = $shop->where($query)->select();
    if($ret){
      $data['status'] = 0;
      $data['error'] = "该用户店铺资料已存在,请更改后重试。";
      $this->ajaxReturn($data);
      return;
    }

    //保存数据库
    $ret = $shop->data($acc)->add();
    if($ret){
      $data['status'] = 1;
      $data['next'] = "register-step-5.html";
      $this->ajaxReturn($data);
    }else{
      $data['status'] = 0;
      $data['error'] = "保存店铺资料失败，请稍后重试。";
      $this->ajaxReturn($data);
      return;
    }
  }

  public function  submit_com()
  {
    //先判断是否登录，不能登录不能进行操作。登录成功后，会将改用户信息保存在session的user字段中
    $user = session("user");
    if(!$user){
      $data['status'] = 0;
      $data['error'] = "没有登录，请先登录。";
      $this->ajaxReturn($data);
      return;
    }

    //登录成功后才能处理

    // 上传文件
    $upload = new \Think\Upload();// 实例化上传类
    $upload->maxSize   =     2*1024*1024 ;// 设置附件上传大小
    $upload->exts      =     array('jpg', 'gif', 'png', 'jpeg');// 设置附件上传类型
    $upload->rootPath  =     './Application/Home/View/image/'; // 设置附件上传根目录
    $upload->savePath  =     ''; // 设置附件上传（子）目录
    $info   =   $upload->upload();

    if(!$info) {// 上传错误提示错误信息
      $data['status'] = 0;
      $data['error'] = "上传图片失败，请稍后重试。";
      $this->ajaxReturn($data);
      return;
    }

    $hd = M("hardware");

    $acc['ownerid'] = $user['id'];
    $acc['img1config'] = __ROOT__.'/'."Application/Home/View/image/"."".$info["com1-img"]['savepath']."".$info["com1-img"]['savename'];
    $acc['img2config'] = __ROOT__.'/'."Application/Home/View/image/"."".$info["com2-img"]['savepath']."".$info["com2-img"]['savename'];
    $acc['imgpc'] = __ROOT__.'/'."Application/Home/View/image/"."".$info["com-to-img"]['savepath']."".$info["com-to-img"]['savename'];
    $acc['imgmodem'] = __ROOT__.'/'."Application/Home/View/image/"."".$info["cat-to-img"]['savepath']."".$info["cat-to-img"]['savename'];

    //检查是否有重复
    $query['ownerid'] = $acc["ownerid"];
    $ret = $hd->where($query)->select();
    if($ret){
      $data['status'] = 0;
      $data['error'] = "电脑配置资料已存在,无法上传。";
      $this->ajaxReturn($data);
      return;
    }

    //保存数据库
    $ret = $hd->data($acc)->add();
    if($ret){
      $data['status'] = 1;
      $register = session('register');
      $register['reg_result'] = 1;
      session('register',$register);
      $data['next'] = "../user/register_result.html";
      $this->ajaxReturn($data);
    }else{
      $data['status'] = 0;
      $data['error'] = "保存电脑配置失败，请稍后重试。";
      $this->ajaxReturn($data);
      return;
    }
  }

  public function register_result(){
    $reg_result = session("register")["reg_result"];

    if($reg_result){
      $this->display("index/register_result");
    }else{
      $this->error("访问错误");
    }
  }

  public function reg_tel_verify_step_1 (){
    $tel = $_POST['phone'];

    if(strlen($tel)!=11){
      $data['status']=0;
      $data['error'] ='手机号码长度错误';
      $this->ajaxReturn($data);
      return;
    }

    //检查手机号码是否已经使用。
    $query['tel'] = $tel;
    $vip = M('vip');

    $ret = $vip->where($query)->select();
    if($ret){
      $data['status']=0;
      $data['error'] = "手机号码已经使用.";
      $this->ajaxReturn($data);
      return;
    }

    //发送验证码要手机
    $ret = post_code($tel);
    if($ret<0){
      $data['status']=0;
      $data['error'] = "发送验证码失败.";
      $data['error_code'] = $ret;
      $this->ajaxReturn($data);
      return;
    }

    //保存发送验证码，用于收到用户的反馈后进行校验
    $code['verify_count'] = 0;
    $code['verify_num'] = $ret;

    session('reg_tel_verify_code',$code);

    $data['status']=1;
    $data['error'] = "发送验证码成功.";
    $data['code'] = $ret;
    $this->ajaxReturn($data);
  }

  //校验用户收到的验证码
  public function reg_tel_verify_step_2 (){

    $code = $_POST['code'];
    if(strlen($code)!= 6){
      $data['status'] = 0;
      $data['error']= "验证码长度不正确".''.strlen($code);
      $this->ajaxReturn($data);
      return;
    }

    $verify = session('reg_tel_verify_code');

    if(!$verify){
      $data['status'] = 0;
      $data['error']= "验证错误1";
      $this->ajaxReturn($data);
      return;
    }

    if(strcmp($code,$verify['verify_num'])!=0){
      $data['status'] = 0;
      $data['error']= "验证错误2";
      $this->ajaxReturn($data);
      return;
    }
    //校验成功销毁验证码
    session('reg_tel_verify_code',null);
    $data['status'] = 1;
    $data['error']= "验证通过";
    $this->ajaxReturn($data);
  }


  public  function service_buy(){
    if(!session('user')){
      $this->error("没有登录",'index/index');
      return;
    }

    $service = (int)($_POST['service']);

    if($service<2 ||$service>4){
      $data['status'] =0;
      $data['error'] ="不能购买该服务";
      $this->ajaxReturn($data);
      return;
    }

    $user = session('user');

    if($service<$user['viplevel']){
      $data['status'] =0;
      $data['error'] ="您不能购买该服务";
      $this->ajaxReturn($data);
      return;
    }


    if($service==2){
      $month =1;
      $query['ebkey'] ='service_month';
    }elseif($service==3){
      $month=3;
      $query['ebkey'] ='service_season';
    }else{
      $month = 12;
      $query['ebkey'] ='service_year';
    }

    $config = M('config');
    //先查询是否有足够的彩虹糖付费
    $ret = $config->where($query)->select();
    if(!$ret){
      $data['status'] =0;
      $data['error'] ="服务器错误";
      $this->ajaxReturn($data);
      return;
    }

    if($user['cht']<$ret[0]['ebvalue']){
      $data['status'] =0;
      $data['error'] ="您没有足够的彩虹糖来付费.";
      $this->ajaxReturn($data);
      return;
    }
    //有足够的资费，就先扣费
    $up['cht'] = $user['cht']- $ret[0]['ebvalue'];
    $query =[];
    $query['id'] = $user['id'];

    $vip = M('vip');
    $ret= $vip->where($query)->data($up)->save();
    if(!$ret){
      $data['status'] =0;
      $data['error'] ="扣费失败.";
      $this->ajaxReturn($data);
      return;
    }

    //更改vip记录
    $cur_time = date('y-m-d');
    if($user['serverdate']<$cur_time)
      $str = 'update eb_vip set serverdate = (date_add(curdate(), interval  '.''.$month.' month)) where id='.''.$user['id'];
    else
      $str = 'update eb_vip set serverdate = (date_add(serverdate, interval  '.''.$month.' month)) where id='.''.$user['id'];

    //更新服务到期时间
    $vip->execute($str);

    //更新vip等级
    $str = "update eb_vip set viplevel=".''.$service.' where id='.''.$user['id'];
    $vip->execute($str);

    //更新session用户数据
    $ret = $vip->where($query)->select();
    $ret[0]['login'] = 1;
    session('user',$ret[0]);

    $data['status'] =1;
    $data['error'] ="购买服务成功";
    $this->ajaxReturn($data);
  }


  public function user_info_get(){
    if(!session('user')){
      $this->error("没有登录",'index/index');
      return;
    }

    $data['status'] = 1 ;
    $data['user'] = session('user');
    $data['user'] = user_info_format($data['user']);

    $this->ajaxReturn($data);
  }
}


