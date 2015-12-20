<?php
namespace Home\Controller;
use Think\Controller;
class ArticleController extends Controller {



  function __construct() {
    parent::__construct();
    //构造函数

  }

  //发表新文章
  public function publish(){
    $user = session('user');
    if(!user){
      $this->error("没有权限发表文章");
      return;
    }

    $article = M("article");

    //检查重名不能发表名字一样作者一样的文章
    $query['title']= $_POST['title'];
    $query['authorid'] =$user['id'];
    $ret = $article->where($query)->select();
    if($ret){
      $data['status'] = 0;
      $data['error'] = '文章已经发表，重复发表无效！';
      $this->ajaxReturn($data);
      return;
    }

    //检查通过。保存数据库

    $pub['title'] = $_POST['title'];
    $pub['categoryid'] = $_POST['categoryid'];
    $pub['content'] = $_POST['content'];
    $pub['authorid'] = $user['id'];
    $pub['replynum'] = 0;
    $pub['lastreplyer'] = $user['name'];
    $pub['reviewnum'] = 1;

    $ret = $article->data($pub)->add();

    if($ret){
      $data['status'] = 1;

      $ret = $article->where($query)->select();
      if($ret){
        $data['next'] = 'thread.html?articleid='.''.$ret[0]['id'];
      }
      $this->ajaxReturn($data);
    }else{
      $data['status'] = 0;
      $data['error'] = '发表失败！';
      $this->ajaxReturn($data);
      return;
    }

  }
}