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

$GLOBALS['web'] = $web;



function web_map($lv,$index){
 $web = $GLOBALS['web'];

 for($i=0;$i<$lv;$i++){
   $tmp[$i] = $web[$i];
 }

 $tmp[$i] = $index;

 $GLOBALS['web'] = $tmp;
 return $GLOBALS['web'];
}

function get_map(){
  return $GLOBALS['web'];
}