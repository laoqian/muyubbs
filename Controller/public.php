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

  $th['page_total'] = intval($th['data_count'])/$th["per_page_num"];
  if(floor($th['page_total'])<$th['page_total']){
    $th['page_total']=(int)(floor($th['page_total']));
    $th['page_total']++;
  }

  if($th['page_total']==0) $th['page_total']++;

  $menu_num = $th['menu_num'];

  //如果是-1就是返回最后一页
  if($th['cur_page']==-1){
    $th['cur_page'] = $th["page_total"];
  }else if($th['cur_page']>$th["page_total"] || $th['cur_page']<1){
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

  $th['index_start'] = ($th['cur_page']-1)*$th['per_page_num'];

  //为js模块实现按钮方法
  $j=0;
  for($i=$th['menu_start'];$i<$th['menu_end'];$i++){
    $th['menus'][$j++] = $i;
  }

  return $th;
}


//curl get方法
function m_get($url, $post_data = '', $timeout = 5){//curl
  $ch = curl_init();

  $this_header = array(
    "content-type: application/x-www-form-urlencoded;charset=GB2312"
  );

  curl_setopt($ch,CURLOPT_HTTPHEADER,$this_header);

  curl_setopt ($ch, CURLOPT_URL, $url);
  if($post_data != ''){
    curl_setopt($ch, CURLOPT_POSTFIELDS, $post_data);
  }
  curl_setopt ($ch, CURLOPT_RETURNTRANSFER, 1);
  curl_setopt ($ch, CURLOPT_CONNECTTIMEOUT, $timeout);
  curl_setopt($ch, CURLOPT_HEADER, false);
  $file_contents = curl_exec($ch);
  curl_close($ch);
  return $file_contents;
}


function post_code($tel){

  if(strlen($tel)!= 11) {
    return -1;
  }

  $corpid = 'LKSDK0005501';
  $pwd = '5412852lzp@qq';

  $code  = rand(100000,999999);

  $varify = '尊敬的彩虹桥新用户，您的验证码：'.''.$code.''.'，此验证码只能用于注册账号使用，请勿泄露。【彩虹桥云端】';
  $varify = mb_convert_encoding($varify,'GB2312','UTF-8');
  $str = 'http://125.69.81.40:83/wsn/BatchSend.aspx?CorpID='.''.$corpid.''.'&Pwd='.''.$pwd.''.'&Mobile='.''.$tel.''.'&Content=' .''.$varify;

  $ret = m_get($str);

  if($ret<0) return $ret;

  return $code;
}



function user_info_format($user){
  $sex = array(
    0=>'男',
    1=>'女',
  );

  $audit = array(
    0=>'未审核',
    1=>'已通过',
  );

  $status = array(
    0=>'正常',
    1=>'冻结',
  );

  $statusgx = $statuscz = array(
    '0'=>'离线',
    '1'=>'空闲',
    '2'=>'忙碌',
  );

  $user['sex'] = $sex[$user['sex']];
  $user['isaudit'] = $audit[$user['isaudit']];
  $user['status'] = $status[$user['status']];
  $user['statuscz'] = $statuscz[$user['statuscz']];
  $user['statusgx'] = $statusgx[$user['statusgx']];

  return $user;
}


function acc_info_format($acc){
  $sex = array(
    0=>'男',
    1=>'女',
  );

  $age = array(
    0=>'70后',
    1=>'80后',
    2=>'90后',
    3=>'00后',
  );


  $statuscz = array(
    '0'=>'0-100',
    '1'=>'101-200',
    '2'=>'201-400',
    '3'=>'401以上',
  );

  $type = array(
    '0'=>'淘宝',
    '1'=>'京东',
  );

  $acc['sex'] = $sex[$acc['sex']];
  $acc['age'] = $age[$acc['age']];
  $acc['accounttype'] = $type[$acc['accounttype']];
  $acc['consume'] = $statuscz[$acc['consume']];

  return $acc;
}


function ad_info_format($ad){
  $pos = array(
    '0'=>'中上大图',
    '1'=>'中上小图1',
    '2'=>'中上小图2',
    '3'=>'中上小图3',
    '4'=>'中上小图4',
  );

  $ad['pos'] = $pos[$ad['pos']];

  return $ad;
}

function rights_format($rights){

  $name =array(
    'oncegxsd'=>'共享端刷单一次获得20*x',
    'oncegxscorjg'=>'共享端收藏/加购一次获得5*x',
    'oncegxllorztc'=>'共享端流量/直通车一次获得5*x',
    'oncegxshorpj'=>'共享端收货/评价一次获得2*x',
    'onhookonehouraward'=>'共享端挂机一小时获得10*x',
    'monthaward'=>'共享端当月在线600小时获得x',
    'shopnum'=>'可绑定的店铺数x',
    'imgquality'=>'远程画质x 1/2',
    'lastonlinetime'=>'昨日在线时间x hour',
    'connecttimes'=>'每日可连接次数',
    'chargediscount'=>'充值折扣',
    'onceczsd'=>'操作端刷单一次消耗30',
    'onceczscorjg'=>'操作端收藏/加购一次获得5',
    'onceczllorztc'=>'操作端流量/直通车一次获得5',
    'onceczshorpj'=>'操作端收货/评价一次获得2',
	'payfortenmin'=>'每10分钟收费',
  );


  foreach($rights as $key=>$value){
    $mate[$value['type']]['name'] = $name[$value['type']];
    $mate[$value['type']]['item'][$value['level']]['value'] = $value['value'];
    $mate[$value['type']]['item'][$value['level']]['id'] = $value['id'];
  }

  $i=0;
  foreach($mate as $key=>$value){
    $ret[$i++] = $value;
  }

  return $ret;
}



function set_path($str,$name,$level){

  $url = $_SERVER["REQUEST_URI"];

  $pos = strrpos($url,ACTION_NAME);
  $url = substr($url,0,$pos);
  $url ='http://'.$_SERVER['SERVER_NAME'].$url.$str;

  $path['url'] = $url;
  $path['name'] = $name;

  $bbs = session('bbs_path');

  $bbs[$level] = $path;

  session('bbs_path',$bbs);
}


function get_path($level){
  $path = session('bbs_path');

  foreach($path as $key => $value){
    if($key<=$level){
      $_path[$key] = $value;
    }
  }

  return $_path;
}




function sd_format($sd){

  $optype =array(
    0=>'刷单',
    1=>'收藏/加购',
    2=>'流量/直通车',
    3=>'评价收货',
  );

  $sdtype =array(
    0=>'淘宝',
    1=>'京东',
  );
  $orderstatus =array(
    0=>'已收藏',
    1=>'已下单',
    2=>'已付款',
    3=>'已收货',
  );

  $sdstatus =array(
    0=>'失败',
    1=>'成功',
  );


  foreach($sd as $k=>$item){
    $item['oprtype'] = $optype[$item['oprtype']];
    $item['sdtype'] = $sdtype[$item['sdtype']];
    $item['orderstatus'] = $orderstatus[$item['orderstatus']];
    $item['status'] = $sdstatus[$item['status']];

    $sd[$k] = $item;
  }

  return $sd;
}



















