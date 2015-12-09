<?php
namespace Home\Controller;
use Think\Controller;
class IndexController extends Controller {

  function __construct() {
    parent::__construct();

    $this->assign('bbs_title','木鱼网络');
    $login['state']= cookie("state");
    $login['phone']= cookie("phone");
    $this->assign('login',$login);
  }

  public function index(){
    $Model = M('article');
    $article=$Model->limit(10)->select();
    $this->assign('article',$article);

    $this->show();
  }


  public function  artcle_main(){
    $this->show();
  }

  public function  register(){
    if(cookie("state") =="2"){
      $User= M("user")->where(cookie("phone"))->select();
      $this->assign("user",$User[0]);
      $this->assign("reg_res",'注册成功');
      cookie("state","1",600);
    }elseif(cookie("state") =="1"){
      $User= M("user")->where(cookie("phone"))->select();
      $this->assign("user",$User[0]);
      $this->assign("reg_res",'当前用户信息');
      cookie("state","1",600);
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