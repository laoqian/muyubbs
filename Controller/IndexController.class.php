<?php
namespace Home\Controller;
use Think\Controller;
class IndexController extends Controller {

  function __construct() {
    parent::__construct();

    $this->assign('bbs_title','木鱼网络');
    $login['state']= cookie("state");
    $login['username']= cookie("username");
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
      $User= M("user")->where(cookie("username"))->select();
      $this->assign("user",$User[0]);
      $this->assign("reg_res",'注册成功');
      cookie("state","1",600);
    }elseif(cookie("state") =="1"){
      $User= M("user")->where(cookie("username"))->select();
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

  public function  artcle_display(){
    $this->show();
  }

  public function  register_post()
  {
    $params = json_decode(file_get_contents('php://input'), true);

    $map["username"] = $params["phone"];

    $Model = M('user');
    $User = $Model->where($map)->select();

    if (!$User) {
      $Model->username = $params["phone"];
      $Model->password = $params["password"];
      $Model->viplevel = 7;
      $Model->userpoints = 456;
      $Model->admin = 0;

      $res = $Model->add();
      if ($res != true) {
        //注册失败
        $this->ajaxReturn("添加用户到数据库失败！");
      }
    }else{
      $this->ajaxReturn("用户已经存在数据库中！");
      return;
    }

    //注册成功就保存状态本次不再登录
    cookie('state', "2", 600);
    cookie('username', $params["phone"],600 );

    $this->ajaxReturn("success");
  }
  //登录处理
  public function login_post(){

    $params = json_decode(file_get_contents('php://input'),true);

    $Model = M('user');

    $map["username"] = $params["phone"];

    $User = $Model->where($map)->select();

    if($params['password']==$User[0]['password']){

      cookie('state', "1", 600);
      cookie('username', $params["phone"],600 );

      $this->ajaxReturn( "登录成功!");
    }else{
      $this->ajaxReturn( "用户名或者密码错误！");
    }

  }
  //文章发表
  public function  article_add_post(){
    $params = json_decode(file_get_contents('php://input'),true);

    $Model = M('article');

    $Model->username  = 'laoqian';
    $Model->articletitle = $params['title'];
    $Model->articlecontent = $params['content'];
    $Model->articletime = date('Y-m-d H:i:s');
    $Model->articlereply = 100;
    $Model->articleskim = 1000;
    $Model->articlelastreplyer = "韩总";
    $res= $Model->add();


    $article["title"]=$params['title'];
    $article["content"]=$params['content'];

    $content = $this->view->fetch("article_display",$article);


    $fd = fopen("mytest","w");
    if(!$fd){
      $this->ajaxReturn("打开文件失败！");
    }

    if(fwrite($fd,$content)===false){
      $this->ajaxReturn("写文件出错！");
    }

    fclose($fd);

    $this->ajaxReturn("生成文章成功");
  }
}