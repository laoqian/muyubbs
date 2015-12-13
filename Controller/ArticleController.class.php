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

    $article = M('article');

    $article->phone  = "老大我们再等你";
    $article->title = $params['title'];
    $article->content = $params['content'];
    $article->posttime = date('Y-m-d H:i:s');
    $article->reply = 100;
    $article->skim = 1000;
    $article->lastreplyer =  "你是老大";


    //生成文章索引
    $user_data = M("user_data");

    $query['id'] = 1;
    $res = $user_data->where($query)->select();

    $magic = 556677;
    $res[0]['article_total']++;
    $name = sprintf("./Application/Home/View/Data/%d.html",$magic+$res[0]['article_total']);


    //将新建文章索引存进数据库
    $article->index = sprintf("Data/%d",$magic+$res[0]['article_total']);
    $ret= $article->add();


    //保存统计信息
    $user_data->data($res[0])->save();

    //生成模板
    $tpl["title"]=$params['title'];
    $tpl["content"]=$params['content'];
    $tpl["phone"]  ="老大我们再等你";
    $tpl["posttime"]=date('Y-m-d H:i:s');
    $tpl["skim"]=1123;
    $tpl["header"]="<include file=\"./Application/Home/View/Index/header.html\" />";
    $tpl["footer"]="<include file=\"./Application/Home/View/Index/footer.html\" />";
    $this->assign($tpl);
    $content = $this->view->fetch("art_tpl");

    $fd = fopen($name,"w");
    if(!$fd){
      $this->ajaxReturn($name);
    }

    if(fwrite($fd,$content)===false){
      $this->ajaxReturn("写文件出错！");
    }

    fclose($fd);

    $data['status'] ="success";
    $data["url"] =sprintf("../Data/%d.html",$magic+$res[0]['article_total']);

    $this->ajaxReturn($data);
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
}