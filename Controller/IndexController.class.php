<?php
namespace Home\Controller;
use Think\Controller;

require "public.php";

class IndexController extends Controller {

  function __construct() {
    parent::__construct();

    $this->assign('bbs_title','彩虹桥云端淘宝精准补单平台');
    $this->assign('user',session('user'));
    set_path('index.html','网站首页',0);


    $ad = M('ad');
    $data = $ad->select();
    foreach($data as $key=>$value){
      //先判断广告有否过期，过期就不要展示了
      $str = $value['publishtime'].' +'.''.$value['displaydays'].' month';
      $time = strtotime($str,$value['publishtime']);
      $now = strtotime('now');
      if($time>$now){
        $str = 'ad'.$value['pos'];
        $this->assign($str,$value);
      }
    }
  }

  public function index(){
    //读取栏目表
    $Model = M('category');
    $category = $Model->select();

    $article = M('article');
    $review  =  M('review');

    //提取每个版块主题数据，帖子数据
    foreach($category as $key=>$cate){
      $query =[];
      $query['categoryid'] = $cate['id'];
      $cate['th_num'] = $article->where($query)->count();

      //首页版块信息下显示的文章提取
      $hotest = $article->where($query)->order('reviewnum DESC')->limit(1)->select();
      if(mb_strwidth($hotest[0]['title'],'utf-8')>30)
        $cate['hot_name'] =mb_strimwidth($hotest[0]['title'],0,30,'...','utf-8');
      else
        $cate['hot_name'] =$hotest[0]['title'];

      $cate['hot_path'] = 'thread.html?articleid='.''.$hotest[0]['id'];

      //统计最近24小时发帖数
      //根据时区走 不然时间判断不准时
      date_default_timezone_set("Asia/Shanghai");
      $time=date("Y-m-d 00:00:00");
      $news=strtotime($time);
      $cate['last_day_ths']=$article->where($query)->where("publishtime > $news")->count();

      $art = $article->where($query)->select();
      $cate['reply_num'] = 0;
      foreach($art as $i => $value){
        $query =[];
        $query['articleid']= $value['id'];
        $cate['reply_num']+=$review->where($query)->count();
      }

      $cate['comm'] ='└─'.''.$cate['comm'];

      $category[$key] = $cate;
    }


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

    //定义首页展示链接条数
    $link_num = 15;

    //生成最新文章链接
    $article = M("article");
    $news = $article->order('id DESC')->limit($link_num)->select();
    foreach($news as $key=>$value){
      $value['path'] = "thread.html?articleid=".''.$value['id'];

      if(mb_strwidth($value['title'],'utf-8')>40)
        $value['title'] =mb_strimwidth($value['title'],0,40,'...','utf-8');
      $news[$key] = $value;
    }

    //生成热门文章链接
    $article = M("article");
    $hots = $article->order('reviewnum DESC')->limit($link_num)->select();
    foreach($hots as $key=>$value){
      $value['path'] = "thread.html?articleid=".''.$value['id'];
      if(mb_strwidth($value['title'],'utf-8')>40)
        $value['title'] =mb_strimwidth($value['title'],0,40,'...','utf-8');
      $hots[$key] = $value;
    }
    //生成随机文章链接
    $article = M("article");
    $rands = $article->order('rand()')->limit($link_num)->select();
    foreach($rands as $key=>$value){
      $value['path'] = "thread.html?articleid=".''.$value['id'];
      if(mb_strwidth($value['title'],'utf-8')>40)
        $value['title'] =mb_strimwidth($value['title'],0,40,'...','utf-8');
      $rands[$key] = $value;
    }

    $this->assign('news',$news);
    $this->assign('hots',$hots);
    $this->assign('rands',$rands);

    $this->assign('path',get_path(0));

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
    $per_page_num = 25;

    $art_sum = $art->where($map)->count();
    $page = intval($art_sum)/$per_page_num;
    if(floor($page)<$page){
      $page=(int)(floor($page));
      $page++;
    }

    $th['page_total'] = $page; //总页数
    $th["per_page_num"] = $per_page_num; //
    $th["menu_num"] = 6;
    $th = paged($th);

    //读取当前页数据
    $query  =$th["cur_page"].",".$per_page_num;
    $ret = $art->where($map)->page($query)->select();

    $this->assign("paged",$th);
    $this->assign("theme",$ret);


    $article = M("article");
    $hots = $article->order('reviewnum DESC')->limit(10)->select();
    foreach($hots as $key=>$value){
      $value['path'] = "thread.html?articleid=".''.$value['id'];
      $value['content'] = strip_tags($value['content']);
      $value['title'] =  mb_substr( $value['title'], 0, 9, 'utf-8' ) ;
      $value['content'] =  mb_substr( $value['content'], 0, 20, 'utf-8' ) ;
      $hots[$key] = $value;
    }

    $this->assign('hots',$hots);
    //生成网站索引
    $url = "theme.html?".''."category=".''.$map['categoryid']."&page=".$th['cur_page'];
    $query = [];
    $query['id'] = $map['categoryid'];
    $cate = M("category");
    $c = $cate->where($query)->select();
    set_path($url,$c[0]['name'],1);
    $this->assign('path',get_path(1));

    //生成发表主题链接
    $the = 'newth.html?categoryid='.''.$map['categoryid'];
    $this->assign('newth',$the);

    $this->show();
  }

  public function thread(){

    if($_GET["articleid"]){
      $map['id'] = $_GET['articleid'];
    }else{
      $this->error("访问错误",'index',5);
      return;
    }

    //如果用户已经登录，将当前的文章id保存到session中
    $user = session('user');
    if($user){
      $user['articleid'] = $_GET['articleid'];
      session('user',$user);
    }

    //读取文章数据
    $model = M('article');

    //更新查看数量
    $model->where($map)->setInc('reviewnum');

    $article = $model->where($map)->select();
    if(!$article){
      $this->error("服务器错误");
      return;
    }
    $article = $article[0];
    $this->assign("article",$article);

    $th['reply_num'] =$article['replynum'];
    $th['review_num'] =$article['reviewnum'];

    //读取作者用户数据
    $vip = M('vip');
    $query['id'] = $article['authorid'];
    $user = $vip->where($query)->select();
    if(!$user){
      $this->error("服务器错误");
      return;
    }
    $user = $user[0];

    //读取作者的主题数据
    $query =[];
    $query['authorid'] = $article['authorid'];
    $user['thnum'] = $model->where($query)->count();

    //读取作者的帖子数据
    $review = M('review');
    $query =[];
    $query['reviewerid'] = $article['authorid'];
    $user['replynum'] = $review->where($query)->count();

    //生成vip地址
    if($user["viplevel"]<1) $user["viplevel"]=1;
    if($user["viplevel"]>5) $user["viplevel"]=5;
    $user['lvimg']=__ROOT__.''.'/Application/Home/View/resource/img/'.''.$user['viplevel'].''.'zuan.gif';
    $user['desc'] = $user['viplevel'].''.'钻会员';

/////////////////////////////////////////////////////////////////////////////
    //读取评论数据
    $th['articleid'] = $article['id'];
    if($_GET['page']){
      $th['cur_page'] = (int)($_GET['page']);
    }else{
      $th['cur_page'] = 1;
    }


    $th["per_page_num"] = 5; //每页评论数量
    $th["menu_num"] = 6; //每页页码数量

    $query =[];
    $query['articleid'] = $article['id'];

    $th['reply_num'] = $review->where($query)->count();
    $th['page_total'] = intval($th['reply_num'])/$th["per_page_num"];
    if(floor($th['page_total'])<$th['page_total']){
      $th['page_total']=(int)(floor($th['page_total']));
      $th['page_total']++;
    }

    $th = paged($th);

    $limit['articleid'] = $article['id'];
    $query = $th["cur_page"].",".$th["per_page_num"];
    $replyer = $review->where($limit)->page($query)->select();

    //拉取评论者的统计数据
    $vip  = M("vip");
    foreach($replyer as $key=>$value ){
      //读取评论者的vip用户数据
      $query =[];
      $query['id'] = $value['reviewerid'];
      $u = $vip->where($query)->select();
      $value['user'] = $u[0];

      //读取评论者的主题数据
      $query =[];
      $query['authorid'] = $value['reviewerid'];
      $value['user']['thnum'] = $model->where($query)->count();

      //读取评论者的帖子数据
      $query =[];
      $query['reviewerid'] = $value['reviewerid'];
      $value['user']['replynum'] = $review->where($query)->count();

      //生成评论者生成vip地址
      if($user["viplevel"]<1) $user["viplevel"]=1;
      if($user["viplevel"]>5) $user["viplevel"]=5;
      $value['user']['lvimg']=__ROOT__.''.'/Application/Home/View/resource/img/'.''.$user['viplevel'].''.'zuan.gif';
      $value['user']['desc'] = $user['viplevel'].''.'钻会员';


      $replyer[$key] = $value;
    }

    //生成网站索引
    $url = "theme.html?".''."category=".''.$article['categoryid'];
    $query = [];
    $query['id'] = $article['categoryid'];
    $cate = M("category");
    $c = $cate->where($query)->select();
    set_path($url,$c[0]['name'],1);

    $url = "thread.html?".''."articleid=".''.$article['id'];
    set_path($url,$article['title'],2);
    $this->assign('path',get_path(2));


    $the = 'newth.html?categoryid='.''.$article['categoryid'];
    $this->assign('newth',$the);

    $this->assign('paged',$th);
    $this->assign('replyer',$replyer);
    $this->assign('author',$user);
    $this->assign('user',session('user'));

    $this->show();
  }

  public function verify_get(){
    $Verify = new \Think\Verify();
    $Verify->fontSize = 18;
    $Verify->length   = 4;
    $Verify->useNoise = false;
    $Verify->codeSet = '0123456789';
    $Verify->imageW = 120;
    $Verify->imageH = 32;
    $Verify->entry();
  }

  public function verify_check(){
    $Verify = new \Think\Verify();

    $code = $_POST['code'];

    $ret = $Verify->check($code);
    if(!$ret){
      $data['status'] =0;
    }else{
      $data['status'] =1;
    }

    $this->ajaxReturn($data);
  }

  public function register(){

    $step = session('register')['reg-step'];
    if(session('user') && !$step){
      $this->redirect('index');
      return;
    }

    if($step<=1 || $step>5 || !$step){
      $this->display("template/register-step-1");
    }else if($step == 2){
      $this->display("template/register-step-2");
    }else if($step == 3){
      $this->display("template/register-step-3");
    }else if($step == 4){
      $this->display("template/register-step-4");
    }else if($step == 5){
      $this->display("template/register-step-5");
    }
  }

  public function newth(){
    if(!session('user')){
      $this->redirect("index");
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


  public function userbuy(){
    if(!session('user')){
      $this->error("请先登录再进行此操作",'index.html',3);
      return;
    }

    session('logout_next',1);

    $user = session('user');

    $this->assign('time_to_die',$user['serverdate']);
    $this->assign('cht',$user['cht']);
    $this->assign('chd',$user['chd']);


    $config = M('config');
    $query['ebkey'] = 'service_month';

    $ret = $config->where($query)->select();
    $this->assign('month',$ret[0]['ebvalue']);
    $query['ebkey'] = 'service_season';
    $ret = $config->where($query)->select();
    $this->assign('season',$ret[0]['ebvalue']);
    $query['ebkey'] = 'service_year';
    $ret = $config->where($query)->select();
    $this->assign('year',$ret[0]['ebvalue']);

    $this->show();
  }

  public function usercharge(){
    if(!session('user')){
      $this->error("请先登录再进行此操作",'index.html',3);
      return;
    }
    $this->show();
  }

  public function userset(){
    if(!session('user')){
      $this->error("请先登录再进行此操作",'index.html',3);
      return;
    }

    $this->show();
  }


  public function shopinfo(){
    if(!session('user')){
      $this->error("请先登录再进行此操作",'index.html',3);
      return;
    }

    $user = session('user');

    $query['ownerid'] =$user['id'];

    $shop = M('shop');

    $ret = $shop->where($query)->select();
    if(!$ret){
      $this->error("没有登录");
      return;
    }

    $this->assign('shop',$ret[0]);
    $this->show();
  }

  public function tbchange(){

    if(!session('user')){
      $this->error("请先登录再进行此操作",'index.html',3);
      return;
    }

    $user = session('user');

    $query['ownerid'] =$user['id'];

    $shop = M('account');

    $ret = $shop->where($query)->select();
    if(!$ret){
      $this->error("没有登录");
      return;
    }

    foreach($ret as $key=>$value){
      $value = acc_info_format($value);
      $ret[$key] = $value;
    }

    $this->assign('account',$ret);
    $this->show();
  }

  public function pcinfo(){

    if(!session('user')){
      $this->error("请先登录再进行此操作",'index.html',3);
      return;
    }

    $user = session('user');

    $query['ownerid'] =$user['id'];

    $shop = M('hardware');

    $ret = $shop->where($query)->select();
    if(!$ret){
      $this->error("请先登录再进行此操作",'index.html',3);
      return;
    }

    $this->assign('hd',$ret[0]);
    $this->show();
  }

}