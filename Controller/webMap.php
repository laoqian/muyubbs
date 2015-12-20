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
 $web[$lv] = $index;

 for($i=0;$i<$lv;$i++){
   $index[$i] = $web[$i];
 }

 $GLOBALS['web'] = $index;
 return $GLOBALS['web'];
}

function get_map(){
  return $GLOBALS['web'];
}