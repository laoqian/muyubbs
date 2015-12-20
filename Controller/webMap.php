<?php
/**
 * Created by PhpStorm.
 * User: gg
 * Date: 2015/12/20
 * Time: 11:48
 */

$web[0] = array(
    "index"=>"index.html",
    "name" =>"网站首页"
  );

session('web',$web);

function web_map($lv,$index){
 $web = session('web');

 for($i=0;$i<$lv;$i++){
   $tmp[$i] = $web[$i];
 }

 $tmp[$i] = $index;
 session('web',$tmp) ;
 return session('web');
}

function get_map(){
  return session('web');
}




function paged($th){

  $menu_num = $th['menu_num'];

  if($th['cur_page']>$th["page_total"] || $th['cur_page']<1){
    $th["cur_page"]=1;
  }

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


  return $th;
}