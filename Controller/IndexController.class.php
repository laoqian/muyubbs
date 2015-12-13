<?php
namespace Home\Controller;
use Think\Controller;
class IndexController extends Controller {

  function __construct() {
    parent::__construct();

    $this->assign('bbs_title','木鱼网络');
  }

  public function index(){
    $Model = M('article');
    $article=$Model->limit(50)->select();
    $this->assign('article',$article);

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