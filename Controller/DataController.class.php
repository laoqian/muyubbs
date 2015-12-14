<?php
namespace Home\Controller;
use Think\Controller;
class DataController extends Controller {

  function __construct() {
    parent::__construct();
    //构造函数
    $state = session('state');
    if($state){
      session('state', "1");
      $user = session('user');
      session('user', $user);
    }
  }
}