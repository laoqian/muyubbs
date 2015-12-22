<?php
namespace Home\Controller;
use Think\Controller;
class ArticleController extends Controller {



  function __construct() {
    parent::__construct();
    //构造函数

  }

  public function search(){
    $model = M("article");
    if($_POST["title"])
      $query['title'] = $_POST["title"];
    if($_POST["phone"])
      $query['phone'] = $_POST["phone"];
    $res = $model->where($query)->select();
    if($res){
      $ret["article"] = $res;
      $ret["status"] =1;
    }else{
      $ret["status"] = 0;
    }
    $this->ajaxReturn($ret);
  }
  public function delete(){
    $model = M("article");
    $article = $_POST["article"];
    if($article){
      $query["phone"] = $article["phone"];
      $query["title"] = $article["title"];
      $query["posttime"] = $article["posttime"];
      $ret = $model->where($query)->delete();
    }
    if($ret==true){
      $tpl["status"] = 1;
    }else{
      $tpl["status"] = 0;
    }
    $this->ajaxReturn($tpl);
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


//评论功能
  public  function reply(){

    //先判断登录状态
    $user = session('user');
    if(!$user){
      $data['status'] = 0;
      $data['error'] = '没有登录不能发表评论！';
      $this->ajaxReturn($data);
      return;
    }

    $review = M("review");

    $reply['articleid']  = $user['articleid'];
    $reply['reviewerid'] = $user['id'];
    $reply['content'] = $_POST['content'];

    if(!$reply['articleid'] || !$reply['content']){
      $data['status'] = 0;
      $data['error'] = '服务器错误,请稍后重试！';
      $this->ajaxReturn($data);
      return;
    }

    $ret = $review->data($reply)->add();

    if(!$ret){
      $data['status'] = 0;
      $data['error'] = '发表评论失败,请稍后重试！';
      $this->ajaxReturn($data);
      return;
    }

    //作者评论数据保存统计
    $article = M("article");
    $query['id'] = $user['articleid'];

    $ret = $article->where($query)->select();
    if(!$ret){
      $data['status'] = 0;
      $data['error'] = '服务器异常,请稍后重试！';
      $this->ajaxReturn($data);
      return;
    }

    $art = $ret[0];
    $article->where($query)->setInc('replynum');
    $q['lastreplyer'] = $user['name'];
    $article->where($query)->data($q)->save();

    $data['status'] = 1;
    $data['next'] ='thread.html?articleid='.''.$user['articleid'].'&page=-1';
    $this->ajaxReturn($data);
  }
}