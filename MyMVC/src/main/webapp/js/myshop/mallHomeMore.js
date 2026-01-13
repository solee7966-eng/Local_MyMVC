$(function(){
   
  $('span#totalHITCount').hide();
  $('span#countHIT').hide();
  
  // HIT상품 게시물을 더보기 위하여 "더보기..." 버튼 클릭액션에 대한 초기값 호출하기 
  // 즉, 맨처음에는 "더보기..." 버튼을 클릭하지 않더라도 클릭한 것 처럼 8개의 HIT상품을 게시해주어야 한다는 말이다.   
     displayHIT(1);
  
  // HIT 상품 게시물을 더보기 위하여 "더보기..." 버튼 클릭액션 이벤트 등록하기
     $('button#btnMoreHIT').click(function(){
		
      if($(this).text() == "처음으로") {
		  $('div#displayHIT').empty();
		  $('span#end').empty();
		  displayHIT(1);
		  $(this).text("더보기...");
		  $(window).scrollTop(0);
	  } else {
      	  displayHIT(Number($(this).val()));
      /*
         displayHIT(9);   첫번째로 더보기를 클릭한 경우 
         displayHIT(17);  두번째로 더보기를 클릭한 경우 
         displayHIT(25);  세번째로 더보기를 클릭한 경우
         displayHIT(33);  네번째로 더보기를 클릭한 경우
      */
	  }
      
    });// end of $('button#btnMoreHIT').click(function(){})-------------------
  
});// end of $(function(){})-------------------------------


// Function Declaration
function displayHIT(start) { // start가  1 이라면   1 ~  8  까지 상품 8개를 보여준다.
                             // start가  9 이라면   9 ~ 16  까지 상품 8개를 보여준다.
                             // start가 17 이라면  17 ~ 24  까지 상품 8개를 보여준다.
                             // start가 25 이라면  25 ~ 32  까지 상품 8개를 보여준다.
                             // start가 33 이라면  33 ~ 36  까지 상품 4개를 보여준다.(마지막 상품)
   
   $.ajax({
      url:"mallDisplayJSON.up",
   //   type:"get",
       data:{"sname":"HIT",
           "start":start, // 1   9   17   25   33
           "len":8},      // 8   8    8    8    8  
                           // 8 은 "더보기..." 버튼을 클릭할때 보여줄 상품의 개수(단위)크기 
       dataType:"json",
      success:function(json){
        // console.log("~~~ 확인용 json => ", json);
         /*
             ~~~ 확인용 json => [{"pnum":36,"discountPercent":17,"pname":"노트북30","pcompany":"삼성전자","cname":"전자제품","saleprice":1000000,"point":60,"pinputdate":"2026-01-06","pimage1":"59.jpg","pqty":100,"pimage2":"60.jpg","pcontent":"30번 노트북","price":1200000,"sname":"HIT"}
                             ,{"pnum":35,"discountPercent":17,"pname":"노트북29","pcompany":"레노버","cname":"전자제품","saleprice":1000000,"point":60,"pinputdate":"2026-01-06","pimage1":"57.jpg","pqty":100,"pimage2":"58.jpg","pcontent":"29번 노트북","price":1200000,"sname":"HIT"}
                             ,{"pnum":34,"discountPercent":17,"pname":"노트북28","pcompany":"아수스","cname":"전자제품","saleprice":1000000,"point":60,"pinputdate":"2026-01-06","pimage1":"55.jpg","pqty":100,"pimage2":"56.jpg","pcontent":"28번 노트북","price":1200000,"sname":"HIT"}
                             ,{"pnum":33,"discountPercent":17,"pname":"노트북27","pcompany":"애플","cname":"전자제품","saleprice":1000000,"point":60,"pinputdate":"2026-01-06","pimage1":"53.jpg","pqty":100,"pimage2":"54.jpg","pcontent":"27번 노트북","price":1200000,"sname":"HIT"}
                             ,{"pnum":32,"discountPercent":17,"pname":"노트북26","pcompany":"MSI","cname":"전자제품","saleprice":1000000,"point":60,"pinputdate":"2026-01-06","pimage1":"51.jpg","pqty":100,"pimage2":"52.jpg","pcontent":"26번 노트북","price":1200000,"sname":"HIT"}
                             ,{"pnum":31,"discountPercent":17,"pname":"노트북25","pcompany":"삼성전자","cname":"전자제품","saleprice":1000000,"point":60,"pinputdate":"2026-01-06","pimage1":"49.jpg","pqty":100,"pimage2":"50.jpg","pcontent":"25번 노트북","price":1200000,"sname":"HIT"}
                             ,{"pnum":30,"discountPercent":17,"pname":"노트북24","pcompany":"한성컴퓨터","cname":"전자제품","saleprice":1000000,"point":60,"pinputdate":"2026-01-06","pimage1":"47.jpg","pqty":100,"pimage2":"48.jpg","pcontent":"24번 노트북","price":1200000,"sname":"HIT"}
                             ,{"pnum":29,"discountPercent":17,"pname":"노트북23","pcompany":"DELL","cname":"전자제품","saleprice":1000000,"point":60,"pinputdate":"2026-01-06","pimage1":"45.jpg","pqty":100,"pimage2":"46.jpg","pcontent":"23번 노트북","price":1200000,"sname":"HIT"}
                             ]
                또는
            ~~~ 확인용 json => []                           
         */
         
         let v_html = ``;
         
         if(start == 1 && json.length == 0) {
            // 처음부터 데이터가 존재하지 않는 경우
            /*
               !!!! 주의 !!!!
               if(start == 1 && json == null) 이 아님!!!
               if(start == 1 && json.length == 0) 로 해야 함!!!
            */   
            v_html = `현재 상품 준비중 입니다...`;
            $('div#displayHIT').html(v_html);
         }
         else if(json.length > 0) {
            // 데이터가 존재하는 경우 
            /*
               // 자바스크립트를 사용하는 경우
               json.forEach(function(item, index, array){});
               
               // jQuery 를 사용하는 경우
               $.each(json, function(index, item){});
            */
            json.forEach(function(item, index, array){
               v_html += `<div class='col-md-6 col-lg-3'>
                              <div class='card mb-3'>
                                 <img src='/MyMVC/images/${item.pimage1}' class='card-img-top' style='width: 100%' />
                             <div class='card-body' style='padding: 0; font-size: 11pt;'>
                                <ul class='list-unstyled mt-3 pl-3'>
                                            <li><label class='prodInfo'>제품명</label>${item.pname}</li>
                                            <li><label class='prodInfo'>정가</label><span style='text-decoration: line-through; color: red;'>${item.price.toLocaleString('en')} 원</span></li>
                                            <li><label class='prodInfo'>판매가</label><span style='font-weight: bold; color: red;'>${item.saleprice.toLocaleString('en')} 원</span></li>
                                            <li><label class='prodInfo'>할인율</label><span style='font-weight: bold; color: blue;'>[${item.discountPercent}%]할인</span></li>
                                            <li><label class='prodInfo'>포인트</label><span style='font-weight: bold; color: orange;'>${item.point.toLocaleString('en')} POINT</span></li>
                                            <li class='text-center'><a href='/MyMVC/shop/prodView.up?pnum=${item.pnum}' class='btn btn-sm btn-outline-dark stretched-link' role='button'>자세히보기</a></li>
                                            ${''/* 카드 내부의 링크에 .stretched-link 클래스를 추가하면 전체 카드를 클릭할 수 있고 호버링할 수 있습니다(카드가 링크 역할을 함). */}  
                                 </ul>
                             </div>
                           </div>
                          </div>`;
            });// end of json.forEach(function(item, index, array){})-------------
            
            // HIT 상품 결과를 출력하기
            $('div#displayHIT').append(v_html); // 덧붙이기를 해야 하므로 append 로 해야 한다.
            
            // !!!!! 중요 !!!!!
            // 더보기... 버튼의 value 속성에 값을 지정하기
            $('button#btnMoreHIT').val(start+8);
            // 더보기... 버튼의 value 값이  "9" 로 변경된다.
            // 더보기... 버튼의 value 값이 "17" 로 변경된다.
            // 더보기... 버튼의 value 값이 "25" 로 변경된다.
            // 더보기... 버튼의 value 값이 "33" 로 변경된다.
            // 더보기... 버튼의 value 값이 "41" 로 변경된다. (존재하지 않는 것이다)
            
            // span#countHIT 에 지금까지 출력된 상품의 개수를 누적해서 기록한다.
            $('span#countHIT').text(Number($('span#countHIT').text()) + json.length); 
            
            // 더보기... 버튼을 계속해서 클릭하여 countHIT 값과 totalHITCount 값이 일치하는 경우 
            if( $('span#countHIT').text() == $('span#totalHITCount').text() ) {
               $('span#end').html("더이상 조회할 제품이 없습니다.");
               $('button#btnMoreHIT').text("처음으로");
               $('span#countHIT').text("0");
            }

         }// end of else if(json.length > 0)-----------------------

      },
      error: function(request, status, error){
         alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
      }
                          
   });                   
                      
}// end of function displayHIT(start) {}-------------------------