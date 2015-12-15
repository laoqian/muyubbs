/*
*
*
*
* 数据数据分页设计
*
* */

//paged js 实现


//数据分页 输入数组数据 和 每页数据条数
function data_paged(data,per_page_num){
    var i=0;
    var paged= new Object();
    
    //计算总的页数
    paged.per_page_num = per_page_num;
    paged.total = data.length/num;
    if(paged.total*per_page_num<data.length){
        paged.total++;
    }

    paged.cur = 0;
    paged.source = data;


    //翻页设计,可以使用'up' 'down' 或者页数进行
    paged.page_turn = function (turn){
        var start=0;
        if(turn == "up"){
            if(paged.cur >= paged.total){
                return;
            }else{
                paged.cur++;
            }
        }else if(turn == "down"){
            if(paged.cur <= 1){
                return;
            }else{
                paged.cur--;
            }
        }else{
            var num = parseInt(turn);
            if(num>0 && num <=paged.total){
                paged.cur = num;
            }else{
                return;
            }
        }

        start = (paged.cur-1)*paged.per_page_num;
        for(var i=0;i<paged.per_page_num;i++){
            paged.data[i]=paged.source[start++];
        }

        paged.cur++;
    }

    //翻书到第一页
    paged.page_turn("up");

    return paged;
}