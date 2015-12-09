<?php
namespace Home\Controller;
use Think\Controller;
class ArticleController extends Controller {

  function __construct() {
    parent::__construct();
    //构造函数

  }

  //文章发表
  public function  article_add_post(){
    $params = json_decode(file_get_contents('php://input'),true);

    $Model = M('article');

    $Model->phone  = 'laoqian';
    $Model->articletitle = $params['title'];
    $Model->articlecontent = $params['content'];
    $Model->articletime = date('Y-m-d H:i:s');
    $Model->articlereply = 100;
    $Model->articleskim = 1000;
    $Model->articlelastreplyer = "韩总";
    $res= $Model->add();


    $article["title"]=$params['title'];
    $article["content"]=$params['content'];

    $this->assign("article",$article);

    //生成文章索引
    $Model = M("user_data");
    $res = $Model->where("id=1")->select();


    $res[0]['article_total']++;
    $Model->data($res[0])->save();


    $this->assign("header","<include file=\"./Application/Home/View/Index/header.html\" />");
    $this->assign("footer","<include file=\"./Application/Home/View/Index/footer.html\" />");

    $content = $this->view->fetch("article_display");

    $name = sprintf("a/data/%d.html",$res[0]['article_total']);

    $fd = fopen($name,"w");
    if(!$fd){
      $this->ajaxReturn($name);
    }

    if(fwrite($fd,$content)===false){
      $this->ajaxReturn("写文件出错！");
    }

    fclose($fd);

    $this->ajaxReturn("生成文章成功");
  }
}