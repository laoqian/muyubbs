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
    paged.total = parseInt(data.length/per_page_num);
    if(paged.total*per_page_num<data.length){
        paged.total++;
    }

    paged.cur = 0;
    paged.source = data;


    //翻页设计,可以使用'up' 'down' 或者页数进行
    paged.page_turn = function (turn){
        if(turn === "up"){
            if(paged.cur < paged.total)
                paged.cur++;
        }else if(turn === "down"){
            if(paged.cur > 1)
               paged.cur--;
        }else{
            var num = parseInt(turn);
            if(num>0 && num <=paged.total){
                paged.cur = num;
            }else{
                return;
            }
        }

        paged.cur_index = (paged.cur-1)*paged.per_page_num;
        paged.data=[];

        var len = (paged.per_page_num>(paged.source.length-paged.cur_index))?(paged.source.length-paged.cur_index):paged.per_page_num;
        for(var i=0;i<len;i++){
            paged.data[i] = paged.source[paged.cur_index+i];
        }
    }



    paged.repage= function(){
        paged.total = parseInt(paged.source.length/paged.per_page_num);
        if(paged.total*paged.per_page_num<paged.source.length){
            paged.total++;
        }
    };

    paged.add = function(data){
        paged.source[paged.source.length] = data;
        paged.repage();
    };

    //翻书到第一页
    paged.page_turn("up");

    return paged;
}