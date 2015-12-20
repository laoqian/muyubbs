<?php
namespace Home\Controller;
use Think\Controller;

require "webMap.php";

class IndexController extends Controller {

  function __construct() {
    parent::__construct();

    $this->assign('bbs_title','木鱼网络');
    $this->assign('user',session("user"));
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
            $sub_value["index"] ="theme?categoryid="."".$sub_value['id'];
            array_push( $sub_menu[$value['name']],$sub_value);
          }
        }
      }
    }

    $this->assign('menu',$menu);
    $this->assign('sub_menu',$sub_menu);

    $this->assign("map",get_map());

    $this->show();
  }


  public function theme(){

    $art = M('article');

    //如果有栏目id提取出来
    if($_GET["categoryid"]){
     $map['categoryid'] = $_GET['categoryid'];
    }else{
     $map['categoryid'] = 4;
    }

    $th['category'] = $map['categoryid'];
    if($_GET['page']){
      $th['cur_page'] = (int)($_GET['page']);
    }else{
      $th['cur_page'] = 1;
    }

    //每页数量
    $per_page_num = 20;

    $art_sum = $art->where($map)->count();
    $page = intval($art_sum)/$per_page_num;
    if(floor($page)<$page){
      $page=(int)(floor($page));
      $page++;
    }

    //
    if($th['cur_page']>$page || $th['cur_page']<1){
      $th["cur_page"]=1;
    }

    $th['page_total'] = $page;
    $th["per_page_num"] = $per_page_num;

    $menu_num = 10; //定义显示多少页按钮,定义为偶数
    if($th['page_total']<= $menu_num){
      $th["menu_start"] = 1;
      $th["menu_end"] = $th["page_total"]+1;
    }else{
      if($th['cur_page']>$menu_num/2){
        $th["menu_start"] = $th['cur_page']-$menu_num/2;

        if($th['menu_start']+$menu_num>$th['page_total']){
          $th["menu_end"] = $th["page_total"]+1;
          $th["menu_start"] =$th["menu_end"] -$menu_num;
        }else{
          $th["menu_end"] = $th["menu_start"]+$menu_num;
        }
      }else{
        $th["menu_start"] = 1;
        $th["menu_end"] = $th["menu_start"]+$menu_num;
      }
    }

    //计算列表
    if($th["menu_start"]+$menu_num>=$th['page_total']+1){
      $th["last-page-show"]=0;
    }else{
      $th["last-page-show"]=1;
    }

    //计算上一页
    if($th['cur_page']>1){
      $th['pre_page'] =$th['cur_page']-1;
    }else{
      $th['pre_page'] = 1;
    }
    //和下一页
    if($th['cur_page']<$th['page_total']){
      $th['next_page'] =$th['cur_page']+1;
    }else{
      $th['next_page'] = $th['page_total'];
    }

    $query  =$th["cur_page"].",".$per_page_num;
    $ret = $art->where($map)->page($query)->select();

    $this->assign("paged",$th);
    $this->assign("theme",$ret);

    //生成网站索引
    $m_web['index'] = "theme?".''."category=".''.$map['categoryid']."&page=".$th['cur_page'];
    $query = [];
    $query['id'] = $map['categoryid'];
    $cate = M("category");
    $c = $cate->where($query)->select();
    $m_web['name'] = $c[0]['name'];
    $this->assign("map",web_map(1,$m_web));

    //生成发表主题索引
    $the = 'newth.html?categoryid='.''.$map['categoryid'];
    $this->assign('newth',$the);

    $this->show();
  }

  public function thread(){

    if($_GET["articleid"]){
      $map['id'] = $_GET['articleid'];
    }else{
      $this->error("页面错误");
    }

    $model = M('article');

    $article = $model->where($map)->select();

    $this->assign("article",$article[0]);
    $this->show();
  }

  public function register(){

    $step = (int)($_GET['step']);
    if($step<=1 || $step>4 || !$step){
      $this->display("register-step-1");
    }else if($step == 2){
      $offer = session('offer');
      if($offer){
        $this->display("register-step-2");
      }
    }
  }

  public function newth(){
    if(!session('user')){
      $this->error("没有登录");
      return;
    }

    //生成网站索引
    $m_web['index'] = "newth.html?".''."category=".''.$_GET['categoryid'];
    $m_web['name'] ="发表主题";
    $this->assign("map",web_map(2,$m_web));

    $query = [];
    $query['id'] = $_GET['categoryid'];
    $cate = M("category");
    $c = $cate->where($query)->select();

    if(!$c){
      $this->error("该板块不能发表主题");
      return;
    }

    $query = [];
    $query['pid'] = $c[0]['pid'];

    $th = $cate->where($query)->select();

    if(!$th){
      $this->error("错误，等待返回");
      return;
    }

    $this->assign("new_blk",$th);

    $this->show();
  }
}