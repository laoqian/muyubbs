<?php
namespace Home\Controller;
use Think\Controller;


require "public.php";

class AdminController extends Controller {

  function __construct() {
    parent::__construct();
    //构造函数

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


  public function art_search(){
    $model = M("article");

    $key = $_POST["key"];

    $vip = M("vip");
    if($key["write"]){
      $query['name'] = $key["write"];

      $ret = $vip->where($query)->select();
      $query=[];
      if($ret){
        $query['authorid'] = $ret[0]['id'];
      }
    }

    if($key["article"])
      $query['title'] = $key["article"];


    //计算分页数据
    $th["per_page_num"] = $key['per_page_num']; //每页条数
    $th["menu_num"] =  $key['menu_num']; //每页页码数量
    $th["cur_page"] =  $key['cur_page']; //每页页码数量

    $th['data_count'] = $model->where($query)->count();

    $th = paged($th);

    $str =$key['cur_page'].','.$key['per_page_num'];

    $res = $model->where($query)->page($str)->select();
    if($res){
      //查询到数据后。读取文章作者信息
      foreach($res as $key=>$value){
        $query =[];
        $query['id'] = $value['authorid'];

        $auth = $vip->where($query)->select();
        if($auth){
          $value['author'] = $auth[0]['name'];
        }

        $res[$key] = $value;
      }

      $ret["article"] = $res;
      $ret['paged'] =$th;
      $ret["status"] =1;
    }else{
      $ret["status"] = 0;
    }
    $this->ajaxReturn($ret);
  }


  public  function user_search(){

    $key = $_POST['key'];

    if(!$key){
      $data["status"] =0;
      $data["error"] ="数据错误。";
      $this->ajaxReturn($data);
    }
    if($key['name'])
      $query['name'] = $key['name'];
    if($key['audit']<2)
      $query['isaudit'] = $key['audit'];
    if($key['status']<2)
      $query['status'] = $key['status'];
    if($key['op_status']<3)
      $query['statuscz'] = $key['op_status'];
    if($key['share_status']<3)
      $query['statusgx'] = $key['share_status'];

    $vip = M("vip");

    $th['data_count'] = $vip->where( $query)->count();
    $th['cur_page'] = $key['cur_page'];
    $th['per_page_num'] = $key['per_page_num'];
    $th['menu_num'] = $key['menu_num'];

    $th = paged($th);

    $str = $th['cur_page'].','.$th['per_page_num'];
    $user = $vip->where($query)->page($str)->select();
    if(!$user){
      $ret["status"] = 0;
      $data["error"] ="没有查询到用户数据。";
      $this->ajaxReturn($ret);
      return;
    }

    foreach($user as $k=>$value){
      $user[$k] = user_info_format($value);
    }

    $ret["user"] = $user;
    $ret['paged'] =$th;
    $ret["status"] =1;

    $this->ajaxReturn($ret);
  }

  public  function audit()
  {
    if ($_GET['id']) {
      $query['id'] = $_GET['id'];
    }else {
      $this->ajaxReturn("get error");
      return;
    }

    //读取用户表
    $vip = M("vip");
    $user = $vip->where($query)->select();
    if(!$user){
      $this->ajaxReturn("no this error");
      return;
    }

    $this->assign('user',$user[0]);

    //读取小号数据
    $query=[];
    $query['ownerid'] = $_GET['id'];

    $tb = M("account");
    $tb_accout = $tb->where($query)->select();
    if($tb_accout){
      $this->assign('tb',$tb_accout);
    }

    //读取店铺数据
    $shop = M("shop");
    $sh = $shop->where($query)->select();
    if($sh){
      $this->assign('sh',$sh[0]);
    }

    //读取电脑配置数据
    $hardware = M("hardware");
    $hd = $hardware->where($query)->select();
    if($hd){
      $this->assign('hd',$hd[0]);
    }

    $this->show();
  }

  public  function  audit_pass(){

    if ($_POST['id']) {
      $query['id'] = $_POST['id'];
    }else {
      $data['status'] = 0;
      $data['error'] = "通过审核发生错误。";
      $this->ajaxReturn($data);
      return;
    }

    $vip = M("vip");
    $ret = $vip->where($query)->select();
    if(!$ret){
      $data['status'] = 0;
      $data['error'] = "没有这个用户。";
      $this->ajaxReturn($data);
      return;
    }

    if($ret[0]['isaudit']==1){
      $data['status'] = 0;
      $data['error'] = "该用户已经通过审核。";
      $this->ajaxReturn($data);
      return;
    }

    $user['isaudit'] =1;

    $ret = $vip->where($query)->data($user)->save();
    if(!$ret){
      $data['status'] = 0;
      $data['error'] = "服务器异常。";
      $this->ajaxReturn($data);
      return;
    }

    $data['status'] =1;
    $this->ajaxReturn($data);
    return;
  }


  public  function adshow(){

    $ad = M('ad');
    $ret = $ad->select();

    foreach($ret as $key=>$value){

      $str = $value['publishtime'].' +'.''.$value['displaydays'].' month';
      $time = strtotime($str,$value['publishtime']);

      $value['publishtime'] = date('Y-m-d G:i:s',$time);
      $value = ad_info_format($value);
      $ret[$key] = $value;
    }

    $this->assign('ads',$ret);

    $this->show();
  }

  public  function ad_add(){
    // 上传文件
    $upload = new \Think\Upload();// 实例化上传类
    $upload->maxSize   =     2*1024*1024 ;// 设置附件上传大小
    $upload->exts      =     array('jpg', 'gif', 'png', 'jpeg');// 设置附件上传类型
    $upload->rootPath  =     './Application/Home/View/image/'; // 设置附件上传根目录
    $upload->savePath  =     ''; // 设置附件上传（子）目录
    $info   =   $upload->upload();

    if(!$info){
      $data['status'] = 0;
      $data['error'] = '提交资料失败';
      $this->ajaxReturn($data);
      return;
    }

    $ad = M('ad');

    $query['pos'] = $_POST['pos'];

    $ret = $ad->where($query)->select();

    $new['img'] = __ROOT__.'/'."Application/Home/View/image/"."".$info["img"]['savepath']."".$info["img"]['savename'];;
    $new['url'] = $_POST['url'];
    $new['pos'] = $_POST['pos'];
    $new['displaydays'] = $_POST['displaydays'];

    if($ret){
      $new['publishtime'] = date('Y-m-d G:i:s');
      $ret = $ad->where($query)->save($new);
    }else{
      $ret = $ad->add($new);
    }

    if(!$ret){
      $data['status'] = 0;
      $data['error'] = '服务器错误';
      $this->ajaxReturn($data);
      return;
    }

    $data['status'] = 1;
    $data['error'] = '提交成功';
    $data['ad'] = $ret;
    $this->ajaxReturn($data);
  }

  public function rights_load(){

    $rights = M('vip_interest');

    $ret = $rights->select();
    if(!$ret){
      $data['status'] =0;
      $this->ajaxReturn($data);
      return;
    }

    $right = rights_format($ret);

    $data['status'] =1;
    $data['rights'] =$right;
    $this->ajaxReturn($data);
  }

  public function rights_post(){

    $rights = M('vip_interest');

    $rgh= $_POST['rights'];
    if(!$rgh){
      $data['status'] =0;
      $data['error'] ='没有数据';
      $this->ajaxReturn($data);
      return;
    }

    foreach($rgh as $key=>$value){
      $query['id'] = $value['id'];
      $merge['value'] = $value['value'];

      $rights->where($query)->data($merge)->save();
    }

    $data['status'] =1;
    $data['error'] ="保存成功。";
    $this->ajaxReturn($data);
  }


  public function user_op(){

    $user_id = $_POST['userid'];
    $user_op = $_POST['opcode'];


    if(!$user_id || !$user_op ){
      $data['status'] =0;
      $data['error'] ='没有数据';
      $this->ajaxReturn($data);
    }

    $vip =M('vip');

    $query['id'] =$user_id;
    if($user_op=='delete'){
      $vip->where($query)->delete();
    }elseif($user_op=='freeze'){
      $merge['status'] = 1;
      $vip->where($query)->data($merge)->save();
    }else{
      $merge['status'] = 0;
      $vip->where($query)->data($merge)->save();
    }

    $data['status'] =1;
    $data['error'] ="操作成功。";
    $this->ajaxReturn($data);
  }

  public function article_op(){

    $art_id = $_POST['artid'];
    $art_op = $_POST['opcode'];


    if(!$art_id || !$art_op ){
      $data['status'] =0;
      $data['error'] ='没有数据';
      $this->ajaxReturn($data);
    }

    $article =M('article');

    $query['id'] =$art_id;
    if($art_op=='delete'){
      $article->where($query)->delete();
    }

    $data['status'] =1;
    $data['error'] ="操作成功。";
    $this->ajaxReturn($data);
  }

  public function reply_search(){

    $key = $_POST["key"];

    $vip = M("vip");
    //没有查询关键词就查询全部回复
    if(strlen($key['name'])>0){
      if($key['first']==0){
        $query['name'] = $key["name"];

        $ret = $vip->where($query)->select();
        if(!$ret){
          $data['status'] =0;
          $data['error'] = '该用户不存在';
          $this->ajaxReturn($data);
          return;
        }
        $query=[];
        $query['authorid'] = $ret[0]['id'];
      }else{
        $query['title'] = $key["name"];
        $article= M("article");
        $ret = $article->where($query)->select();
        if(!$ret){
          $data['status'] =0;
          $data['error'] = '该主题不存在';
          $this->ajaxReturn($data);
          return;
        }

        $query=[];
        $query['articleid'] = $ret[0]['id'];
      }
    }

    //计算分页数据
    $th["per_page_num"] = $key['per_page_num']; //每页条数
    $th["menu_num"] =  $key['menu_num']; //每页页码数量
    $th["cur_page"] =  $key['cur_page']; //每页页码数量

    $model = M("review");

    if(strlen($key['name'])>0){
      $th['data_count'] = $model->where($query)->count();
    }else{
      $th['data_count'] = $model->count();
    }


    $th = paged($th);

    $str =$key['cur_page'].','.$key['per_page_num'];

    if(strlen($key['name'])>0){
      $res = $model->where($query)->page($str)->select();
    }else{
      $res = $model->page($str)->select();
    }

    if($res){
      //查询到数据后。读取文章作者信息
      foreach($res as $key=>$value){
        $query =[];
        $query['id'] = $value['reviewerid'];

        $auth = $vip->where($query)->select();
        if($auth){
          $value['author'] = $auth[0]['name'];
        }

        $res[$key] = $value;
      }

      $ret["reply"] = $res;
      $ret['paged'] =$th;
      $ret["status"] =1;
    }else{
      $ret["status"] = 0;
      $ret['error'] ='该主题没有回复';
    }

    $this->ajaxReturn($ret);
  }

  public function reply_op(){

    $art_id = $_POST['replyid'];
    $art_op = $_POST['opcode'];


    if(!$art_id || !$art_op ){
      $data['status'] =0;
      $data['error'] ='没有数据';
      $this->ajaxReturn($data);
    }

    $article =M('review');

    $query['id'] =$art_id;
    if($art_op=='delete'){
      $article->where($query)->delete();
    }

    $data['status'] =1;
    $data['error'] ="操作成功。";
    $this->ajaxReturn($data);
  }


  public function charged_search(){
    $key = $_POST["key"];

    $vip = M("vip");
    //没有查询关键词就查询全部回复
    if($key['last_days'] ==0){
      $query = 'DATE_SUB(CURDATE(), INTERVAL 7 DAY) <= rechargetime';
    }elseif ($key['last_days'] ==1){
      $query = 'DATE_SUB(CURDATE(), INTERVAL 30 DAY) <= rechargetime';
    }else{
      $query = 'DATE_SUB(CURDATE(), INTERVAL 90 DAY) <= rechargetime';
    }

    //计算分页数据
    $th["per_page_num"] = $key['per_page_num']; //每页条数
    $th["menu_num"] =  $key['menu_num']; //每页页码数量
    $th["cur_page"] =  $key['cur_page']; //每页页码数量

    $model = M("recharge");


    $th['data_count'] = $model->where($query)->count();

    $th = paged($th);
    $str =$key['cur_page'].','.$key['per_page_num'];

    $res = $model->where($query)->page($str)->select();

    if($res){
      //查询到数据后。读取充值人信息
      foreach($res as $key=>$value){
        $query =[];
        $query['id'] = $value['vipid'];

        $auth = $vip->where($query)->select();
        if($auth){
          $value['author'] = $auth[0]['name'];
        }

        if($value['status']==0){
          $value['status']='失败';
        }else{
          $value['status']='成功';
        }

        $res[$key] = $value;
      }

      $ret["charge"] = $res;
      $ret['paged'] =$th;
      $ret["status"] =1;
    }else{
      $ret["status"] = 0;
      $ret['error'] ='没有查询到充值记录';
    }

    $this->ajaxReturn($ret);
  }
}