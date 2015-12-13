

//admin js 实现






$(document).ready(function(){

    //$(".ad-head").text("用户管理");
    //$(".ad-content").load("usercenter.html");


    $(".next").click(function(){
        $(".next").css("border-right","0");
        $(".next").css("font-size","1em");
        $(this).css("border-right","solid 2px #FD6440");
        $(this).css("font-size","1.2em");
        $(".ad-head").text($(this).text());
        $(".ad-content").load(this.href);

    });
});