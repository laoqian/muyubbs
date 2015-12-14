<?php
namespace Home\Controller;
use Think\Controller;
class IndexController extends Controller {

  function __construct() {
    parent::__construct();

    $this->assign('bbs_title','木鱼网络');
    $state = session('state');
    if($state){
      session('state', "1");
      $user = session('user');
      session('user', $user);
    }
  }

  public function index(){

    //读取栏目表
    $Model = M('category');
    $category = $Model->select();

    $i=$j=0;

    //解析目录结构,只能支持2级目录
    foreach($category as $value){
      if($value['pid']==0){
        $menu[$i++] = $value;
        $sub_menu[$value['name']] = array();
        foreach($category as $sub_value){
          if($sub_value['pid']==$value['id']){
            array_push( $sub_menu[$value['name']],$sub_value);
          }
        }
      }
    }

    $this->assign('menu',$menu);
    $this->assign('sub_menu',$sub_menu);


    //$this->ajaxReturn($sub_menu);

    $this->show();
  }


  public function  artcle_main(){
    $this->show();
  }

  public function  register(){
    if(session("state") =="2"){

      $map['phone'] = session('phone');
      $User= M("user")->where($map)->select();

      $this->assign("user",$User[0]);
      $this->assign("reg_res",'注册成功');
      session("state","1",600);
    }elseif(session("state") =="1"){

      $map['phone'] = session('phone');
      $User= M("user")->where($map)->select();

      $this->assign("user",$User[0]);
      $this->assign("reg_res",'当前用户信息');
    }

    $this->show();
  }

  public function  login(){
    $this->show();
  }

  public function  artcle_add(){
    $this->show();
  }

  public function  article_show(){

    $this->display("a/data/6.html");
  }



}