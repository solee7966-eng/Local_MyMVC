<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%String ctxPath = request.getContextPath();%>

<jsp:include page="../header1.jsp" />

<style type="text/css">
          
   li {margin-bottom: 10px;} 
   
   div#viewComments {width: 80%;
                      margin: 1% 0 0 0; 
                     text-align: left;
                     max-height: 300px;
                     overflow: auto;
                     /* border: solid 1px red; */
   }
   
   span.markColor {color: #ff0000; }
   
   div.customDisplay {display: inline-block;
                      margin: 1% 3% 0 0;
   }
                   
   div.spacediv {margin-bottom: 5%;}
   
   div.commentDel {font-size: 8pt;
                   font-style: italic;
                   cursor: pointer; }
   
   div.commentDel:hover {background-color: navy;
                         color: white;   }
   
   
   /* ~~~~ 일반적으로 태블릿 PC 가로 및 일반적으로 데스크탑 PC 에서만 CSS transform 을 사용하여 3D 효과를 주는 flip-card 를 만들어 보기 시작 ~~~~ */
   @media screen and (min-width:1024px){
      
      .flip-card {
            background-color: transparent; /* 투명 */
            perspective: 2000px; /* perspective는 3D 환경을 만들때 사용하는 것으로서 원근감을 주는 것이다. 
                               이 값이 작으면 작을 수록 보고있는 사람의 위치를 더 가까이에서 보는 것으로 처리하므로 엘리먼트(요소)가 커 보이게 된다.  
                               이 값이 크면 클수록 보고있는 사람의 위치를 더 멀리 떨어져서 보는 것으로 처리하므로 엘리먼트(요소)가 작게 보이게 된다. */ 
      }
      
      .flip-card-inner {
            position: relative;
            width: 100%;  
            height: 100%; 
            text-align: center;
         /* transition: transform 2.6s; */ /* 요소(엘리먼트)를 transform(변형) 시키는데 걸리는 시간(단위는 초) 2.6초 */
            transition: transform 1.2s;    /* 요소(엘리먼트)를 transform(변형) 시키는데 걸리는 시간(단위는 초) 0.6초 */
            transform-style: preserve-3d;  /* 요소(엘리먼트)의 자식요소들(엘리먼트들)을 3D 공간에 배치 시킨다. */
         /* box-shadow: 0 4px 8px 0 rgba(0,0,0,1.0); */ /* rgba(빨강, 초록, 파랑, 투명도) */
            box-shadow: 0 4px 8px 0 rgba(0,0,0,0.2);
      }
      
      .flip-card:hover .flip-card-inner {
        /* transform: rotateX(540deg); */  /* transform 은 요소(엘리먼트)를 변형시키는 것이다.
                                                                                 요소를 회전(rotate), 확대 또는 축소(scale), 기울이기(skew), 이동(translate) 효과를 부여할 수 있다. 
                                                                                 이를 통해 CSS 시각적 서식 모델의 좌표 공간을 변경한다.
                                              transform 이 지원되는 웹브라우저는 IE는 버전 10 이상부터 지원한다.
                                              
                                              rotateX는 x축을 기준으로 요소(엘리먼트)를 회전시키는 것이다. 
                                              1회전이 360deg 이므로 540deg 는 1바퀴 반을 회전시키는 것이다.*/
                                              
            transform: rotateY(180deg);    /* rotateY는 y축을 기준으로 회전한다. 180deg 반바퀴를 도는 것이다.*/
      }
      
      .flip-card-front, .flip-card-back {
        /* position: static; */
        /* position: relative;*/
           position: absolute;  /* .flip-card-front 엘리먼트(앞면)와  .flip-card-back 엘리먼트(뒷면)가 서로 겹쳐야 하므로 
                                   position 을 반드시 absolute; 로  주어야 한다. */
           width: 100%;  
           height: 100%; 
        /* backface-visibility: visible; */ /* backface-visibility 을 생략하더라도 기본값은 visible 이다. */
           backface-visibility: hidden;     /* 3D Transform에서 요소의 뒷면을 숨기는 역할을 한다.
                                                                                   이것을 hidden 처리하지 않으면 앞면/뒷면이 함께 보이기 때문에 이상하게 나오게 된다. */
      }
      
      .flip-card-front {
           background-color: #bbb;
           color: black;
           z-index: 2; /* position 속성을 이용하다 보면 엘리먼트(요소)를 겹치게 놓게될 수 있다. 
                                         이때 엘리먼트(요소)들의 수직 위치(쌓이는 순서)를 z-index 속성으로 정한다. 
                                         값은 정수이며, 숫자가 클 수록 위로 올라오고, 숫자가 작을 수록 아래로 내려간다. */
      }
      
      .flip-card-back {
        /* background-color: #2980b9; 파랑 */
           background-color: #ff8080; /* 빨강 */
           color: white;
        /* transform: rotateX(540deg); */   /* transform 은 IE는 버전 10 이상부터 지원한다.
                                               rotateX는 x축을 기준으로 요소(엘리먼트)를 회전시킨다. 
                                               1회전이 360deg 이므로 540deg 는 1바퀴 반을 회전시키는 것이다.*/
           transform: rotateY(180deg);      /* rotateY는 y축을 기준으로 요소(엘리먼트)를 회전시킨다. 
                                               180deg 반바퀴를 회전시키는 것이다.*/
           z-index: 1; /* position 속성을 이용하다 보면 엘리먼트(요소)를 겹치게 놓게될 수 있다. 
                                           이때 엘리먼트(요소)들의 수직 위치(쌓이는 순서)를 z-index 속성으로 정한다. 
                                           값은 정수이며, 숫자가 클 수록 위로 올라오고, 숫자가 작을 수록 아래로 내려간다. */
      }

   }   
   /* ~~~~ 일반적으로 태블릿 PC 가로 및 일반적으로 데스크탑 PC 에서만 CSS transform 을 사용하여 3D 효과를 주는 flip-card 를 만들어 보기 끝 ~~~~ */         

    /* ==== 추가이미지 캐러젤로 보여주기 시작 ==== */
      .carousel-inner .carousel-item.active,
      .carousel-inner .carousel-item-next,
      .carousel-inner .carousel-item-prev {
        display: flex;
      }
      
      .carousel-inner .carousel-item-right.active,
      .carousel-inner .carousel-item-next {
      /* transform: translate(25%, 0); */
      /* 또는 */
         transform: translateX(25%);
         
      /* transform: translate(0, 25%);
         또는
         transform: translateY(25%); */  
      }
      
      .carousel-inner .carousel-item-left.active, 
      .carousel-inner .carousel-item-prev {
         transform: translateX(-25%); 
      }
        
      .carousel-inner .carousel-item-right,
      .carousel-inner .carousel-item-left{ 
         transform: translateX(0);
      }
   /* ==== 추가이미지 캐러젤로 보여주기 끝 ==== */   

/* -- CSS 로딩화면 구현 시작(bootstrap 에서 가져옴) 시작 -- */    
  div.loader {
   /* border: 16px solid #f3f3f3; */
     border: 12px solid #f3f3f3;
     border-radius: 50%;
   /* border-top: 16px solid #3498db; */
      border-top: 12px dotted blue;
      border-right: 12px dotted green;
      border-bottom: 12px dotted red;
      border-left: 12px dotted pink;
      
     width: 120px;
     height: 120px;
     -webkit-animation: spin 2s linear infinite; /* Safari */
     animation: spin 2s linear infinite;
   }

/* Safari */
   @-webkit-keyframes spin {
     0% { -webkit-transform: rotate(0deg); }
     100% { -webkit-transform: rotate(360deg); }
   }
   
   @keyframes spin {
     0% { transform: rotate(0deg); }
     100% { transform: rotate(360deg); }
   }
/* -- CSS 로딩화면 구현 끝(bootstrap 에서 가져옴) 끝 -- */
</style>




<script type="text/javascript" src="${pageContext.request.contextPath}/js/myshop/categoryList.js"></script>

<script type="text/javascript">
	$(function(){
		$("div.loader").hide(); //CSS 로딩화면 감추기
		
		// ======= 추가이미지 캐러젤로 보여주기(Bootstrap Carousel 4개 표시 하되 1번에 1개 진행) 시작 ======= //
        $('div#recipeCarousel').carousel({
            interval : 2000  <%-- 2000 밀리초(== 2초) 마다 자동으로 넘어가도록 함(2초마다 캐러젤을 클릭한다는 말이다.) --%>
        });

        $('div.carousel div.carousel-item').each(function(index, elmt){
           <%--
                console.log($(elmt).html());
           --%>    
           <%--      
               <img class="d-block col-3 img-fluid" src="/MyMVC/images/berkelekle단가라포인트033.jpg">
               <img class="d-block col-3 img-fluid" src="/MyMVC/images/berkelekle덩크043.jpg">
               <img class="d-block col-3 img-fluid" src="/MyMVC/images/berkelekle트랜디053.jpg">
               <img class="d-block col-3 img-fluid" src="/MyMVC/images/berkelekle디스트리뷰트063.jpg">
           --%>
           
            let next = $(elmt).next();      <%--  다음엘리먼트    --%>
	        <%-- console.log(next.length); --%>  <%--  다음엘리먼트개수 --%>
	        <%--  1  1  1  0   --%>
	        
	        <%-- console.log("다음엘리먼트 내용 : " + next.html()); --%>
	        <%--     
	            다음엘리먼트 내용 : <img class="d-block col-3 img-fluid" src="/MyMVC/images/berkelekle덩크043.jpg">
	            다음엘리먼트 내용 : <img class="d-block col-3 img-fluid" src="/MyMVC/images/berkelekle트랜디053.jpg">
	            다음엘리먼트 내용 : <img class="d-block col-3 img-fluid" src="/MyMVC/images/berkelekle디스트리뷰트063.jpg">
	            다음엘리먼트 내용 : undefined
	        --%>    
              if (next.length == 0) { <%-- 다음엘리먼트가 없다라면 --%>
                <%--           
                  console.log("다음엘리먼트가 없는 엘리먼트 내용 : " + $(elmt).html());
                 --%>  
                 <%-- 
                      다음엘리먼트가 없는 엘리먼트 내용 : <img class="d-block col-3 img-fluid" src="/MyMVC/images/berkelekle디스트리뷰트063.jpg">
                 --%>
              
              //  next = $('div.carousel div.carousel-item').eq(0);
              //  또는   
              //  next = $(elmt).siblings(':first'); <%-- 해당엘리먼트의 형제요소중 해당엘리먼트를 제외한 모든 형제엘리먼트중 제일 첫번째 엘리먼트 --%>
              //  또는 
                  next = $(elmt).siblings().first(); <%-- 해당엘리먼트의 형제요소중 해당엘리먼트를 제외한 모든 형제엘리먼트중 제일 첫번째 엘리먼트 --%>
                  <%-- 
                       선택자.siblings() 는 선택자의 형제요소(형제태그)중 선택자(자기자신)을 제외한 나머지 모든 형제요소(형제태그)를 가리키는 것이다.
                       :first   는 선택된 요소 중 첫번째 요소를 가리키는 것이다.
                       :last   는 선택된 요소 중 마지막 요소를 가리키는 것이다. 
                       참조사이트 : https://stalker5217.netlify.app/javascript/jquery/
                       
                       .first()   선택한 요소 중에서 첫 번째 요소를 선택함.
                       .last()   선택한 요소 중에서 마지막 요소를 선택함.
                       참조사이트 : https://www.devkuma.com/docs/jquery/%ED%95%84%ED%84%B0%EB%A7%81-%EB%A9%94%EC%86%8C%EB%93%9C-first--last--eq--filter--not--is-/ 
                  --%> 
              }
              
              $(elmt).append(next.children(':first-child').clone());
              <%-- next.children(':first-child') 은 결국엔 img 태그가 되어진다. --%>
              <%-- 선택자.clone() 은 선택자 엘리먼트를 복사본을 만드는 것이다 --%>
              <%-- 즉, 다음번 클래스가 carousel-item 인 div 의 자식태그인 img 태그를 복사한 img 태그를 만들어서 
                   $(elmt) 태그속에 있는 기존 img 태그 뒤에 붙여준다. --%>
              
              for(let i=0; i<2; i++) { // 남은 나머지 2개를 위처럼 동일하게 만든다.
                  next = next.next(); 
                  
                  if (next.length == 0) {
                  // next = $(elmt).siblings(':first');
                  //  또는
                     next = $(elmt).siblings().first();
                  }
                  
                  $(elmt).append(next.children(':first-child').clone());
              }// end of for--------------------------
            
            //console.log(index+" => "+$(elmt).html()); 
          
          }); // end of $('div.carousel div.carousel-item').each(function(index, elmt)----
         // ======= 추가이미지 캐러젤로 보여주기(Bootstrap Carousel 4개 표시 하되 1번에 1개 진행) 끝 ======= //
		
         // 주문개수에 스피너 달아주기 //
         $("input#spinner").spinner( {
            spin: function(event, ui) {
               if(ui.value > 100) {
                  $(this).spinner("value", 100);
                  return false;
               }
               else if(ui.value < 1) {
                  $(this).spinner("value", 1);
                  return false;
               }
            }
         });// end of $("input#spinner").spinner({});----------------
         
         
         
	});//end of $(function(){})-----
	
	
	// ***** 장바구니 담기(ajax 사용하지 않고 form 태그를 사용하기) *****//
	function goCart(){
		if(${sessionScope.loginUser == ""}) {
			//로그인하지 않은 상태일 경우
			alert("로그인 후 이용이 가능합니다.");
	        frm.oqty.value = "1";
	        frm.oqty.focus();
	        return; // 종료
		}
		
		// === 주문량에 대한 유효성 검사 === //
		const frm = document.cartOrderFrm;
		
		const regExp = /^[1-9][0-9]*$/;
		let oqty = frm.oqty.value;
		const bool = regExp.test(oqty);
		if(!bool) {
			// 숫자 이외의 값이 들어오거나 첫번째 숫자가 0 인 경우
	         alert("주문개수는 1개 이상이어야 합니다.");
	         frm.oqty.value = "1";
	         frm.oqty.focus();
	         return; // 종료
		}
		
		if(Number(oqty) >  Number(${proDto.pqty})){
			// 주문개수가 잔고개수 보다 클 경우
	         alert("주문개수가 잔고개수 보다 더 커서 진행할 수 없습니다.");
	         frm.oqty.value = "1";
	         frm.oqty.focus();
	         return; // 종료
		}
		
		
		//주문 개수가 1개 이상인 경우 보내주기
		frm.method = "post";
		frm.action ="${pageContext.request.contextPath}/shop/cartAdd.up";
		frm.submit();
	};
	
	
	
	// *** 바로주문하기 (form 태그를 사용하지 않고 Ajax 를 사용하여 처리해 보겠습니다.) ***//
	function goOrder() {
		$("div.loader").show(); //CSS 로딩화면 보여주기
	};//end of function goOrder()-----
	
	
	// ** 캐러샐 안의 추가이미지를 클릭했을 때 모달 이벤트 **//
	function modal_content(img) {
		//alert("모달창 안에 이미지를 넣어주어야 합니다.");
		//alert(img.src);
		/* $("div#add_image_modal-body").html("<img class='d-block img-fluid' src='"+img.src+"' />"); */
		$("div#add_image_modal-body").html(`<img class='d-block img-fluid' src="\${img.src}"/>`);
														/* JSP 파일 안에 있는 달러기호 이므로 역슬래시를 꼭 사용해주어야 제대로 적용됨 */
	};//end of function modal_content(this)----- 
	
</script>



<div style="width: 95%;">
   <div class="my-3">
      <p class="h4 text-center">&raquo;&nbsp;&nbsp;제품 상세 정보&nbsp;&nbsp;&laquo;</p>
   </div>
   
   <div class="row my-3 text-left">
      <div class="col-md-6">
          <div class="flip-card">
              <div class="flip-card-inner">         
              <div class="flip-card-front">
              	  <!-- <h1>전면</h1> -->
                  <img src="${pageContext.request.contextPath}/images/${requestScope.proDto.pimage1}" class="img-fluid" style="width:100%;" />
               </div>
               <div class="flip-card-back">
               	  <!-- <h1>후면</h1> -->
                  <img src="${pageContext.request.contextPath}/images/${requestScope.proDto.pimage2}" class="img-fluid" style="width: 100%;" />
               </div>
            </div>
         </div>
      </div>
      
      <div class="col-md-6 pl-5">
          <ul class="list-unstyled">
            <li><span style="color: red; font-size: 12pt; font-weight: bold;">${requestScope.proDto.spdto.sname}</span></li>
            <li>제품번호: ${requestScope.proDto.pnum}</li>
            <li>제품이름: ${requestScope.proDto.pname}</li>
            <li>제조회사: ${requestScope.proDto.pcompany}</li>
            <li>제품설명서: 
              <c:if test="${requestScope.proDto.prdmanual_orginFileName ne '없음'}">
                 <a href="${pageContext.request.contextPath}/shop/fileDownload.up?pnum=${requestScope.proDto.pnum}">${requestScope.proDto.prdmanual_orginFileName}</a>
              </c:if>
              <c:if test="${requestScope.proDto.prdmanual_orginFileName eq '없음'}">
                 첨부파일없음
              </c:if>
            </li>
              <li>제품정가: <span style="text-decoration: line-through;"><fmt:formatNumber value="${requestScope.proDto.price}" pattern="###,###" />원</span></li>
              <li>제품판매가: <span style="color: blue; font-weight: bold;"><fmt:formatNumber value="${requestScope.proDto.saleprice}" pattern="###,###" />원</span></li>
              <li>할인율: <span style="color: maroon; font-weight: bold;">[${requestScope.proDto.discountPercent}% 할인]</span></li>
              <li>포인트: <span style="color: green; font-weight: bold;">${requestScope.proDto.point} POINT</span></li>
              <li>잔고갯수: <span style="color: maroon; font-weight: bold;">${requestScope.proDto.pqty} 개</span></li>
              <li>총주문액: <span id="totalSaleprice" style="color: maroon; font-weight: bold;"></span></li>          
          </ul>
          
          <%-- ==== 장바구니담기 또는 바로주문하기 폼 ==== --%>
          <form name="cartOrderFrm">       
             <ul class="list-unstyled mt-3">
                <li>
                    <label for="spinner">주문개수&nbsp;</label>
                    <input id="spinner" name="oqty" value="1" style="width: 110px;">
               </li>
               <li>
                  <button type="button" class="btn btn-secondary btn-sm mr-3" onclick="goCart()">장바구니담기</button>
                  <button type="button" class="btn btn-danger btn-sm" onclick="goOrder()">바로주문하기</button>
               </li>
            </ul>
            <input type="hidden" name="pnum" value="${requestScope.proDto.pnum}" />
         </form>

      </div>
   </div>
   
   
   
   <%-- CSS 로딩화면 구현한것--%>
    <div style="display: flex; position: absolute; top: 30%; left: 37%; border: solid 0px blue;">
      <div class="loader" style="margin: auto"></div>
   </div>
   
   
   <%-- === 추가이미지 보여주기 시작 === --%>
   <c:if test="${not empty requestScope.proDto.imgList}">
   
	     <%-- /////// 추가이미지 캐러젤로 보여주는 것 시작 //////// --%>
	     <div class="row mx-auto my-auto" style="width: 100%;">
	          <div id="recipeCarousel" class="carousel slide w-100" data-ride="carousel">
	              <div class="carousel-inner w-100" role="listbox">
	                  <c:forEach var="imgfilename" items="${proDto.imgList}" varStatus="status">
	                     <c:if test="${status.index == 0}">
	                        <div class="carousel-item active">
	                            <img class="d-block col-3 img-fluid" src="${pageContext.request.contextPath}/images/${imgfilename}" style="cursor: pointer;"
	                            data-toggle="modal" data-target="#add_image_modal_view" data-dismiss="modal" onclick="modal_content(this)" />     
	                        </div>
	                     </c:if>
	                     <c:if test="${status.index > 0}">
	                        <div class="carousel-item">
	                            <img class="d-block col-3 img-fluid" src="${pageContext.request.contextPath}/images/${imgfilename}" style="cursor: pointer;"
	                            data-toggle="modal" data-target="#add_image_modal_view" data-dismiss="modal" onclick="modal_content(this)" />      
	                        </div>
	                     </c:if>
	                  </c:forEach>
	              </div>
	              <a class="carousel-control-prev" href="#recipeCarousel" role="button" data-slide="prev">
	                  <span class="carousel-control-prev-icon" aria-hidden="true"></span>
	                  <span class="sr-only">Previous</span>
	              </a>
	              <a class="carousel-control-next" href="#recipeCarousel" role="button" data-slide="next">
	                  <span class="carousel-control-next-icon" aria-hidden="true"></span>
	                  <span class="sr-only">Next</span>
	              </a>
	          </div>
	      </div>
	      <%-- /////// 추가이미지 캐러젤로 보여주는 것 끝 //////// --%>
   </c:if>
   <%-- === 추가이미지 보여주기 끝 === --%>
   
   
   
   <div>
        <p id="order_error_msg" class="text-center text-danger font-weight-bold h4"></p>
   </div>
      
   <div class="jumbotron mt-5">
       	<div class="text-left" style="margin-top: -5%;">
           <p class="h4 bg-secondary text-white w-50">${requestScope.proDto.pname} 제품의 특징</p>
           <p>${requestScope.proDto.pcontent}</p>   
       	</div>
    
		<div class="row">
		<div class="col" style="display: flex">
			<h3 style="margin: auto">
			   <i class="fas fa-thumbs-up fa-2x" style="cursor: pointer;" onclick="golikeAdd('${requestScope.proDto.pnum}')"></i> 
			   <span id="likeCnt" class="badge badge-primary"></span>
			</h3>
		</div>
		
		<div class="col" style="display: flex">
		    <h3 style="margin: auto">
		       <i class="fas fa-thumbs-down fa-2x" style="cursor: pointer;" onclick="godisLikeAdd('${requestScope.proDto.pnum}')"></i> 
		       <span id="dislikeCnt" class="badge badge-danger"></span>
		    </h3>       
		</div>
		</div>
   </div>
   
   <div class="text-left">
       <p class="h4 text-muted">${requestScope.proDto.pname} 제품 사용후기</p>
       
       <div id="viewComments">
          <%-- 여기가 제품사용 후기 내용이 들어오는 곳이다. --%>
       </div>
    </div>
     
    <div class="row">
        <div class="col-lg-10">
          <form name="commentFrm">
              <textarea name="contents" style="font-size: 12pt; width: 100%; height: 150px;"></textarea>
              <input type="hidden" name="fk_userid" value="${sessionScope.loginUser.userid}" />
                  <input type="hidden" name="fk_pnum" value="${requestScope.proDto.pnum}" />
          </form>
       </div>
       <div class="col-lg-2" style="display: flex;">
          <button type="button" class="btn btn-outline-secondary w-100 h-100" id="btnCommentOK" style="margin: auto;"><span class="h5">후기등록</span></button>
       </div>
    </div>
   
   
   
</div>
   
<%-- ****** 추가이미지 보여주기 Modal 시작 ****** --%>
<div class="modal fade" id="add_image_modal_view"> <%-- 만약에 모달이 안보이거나 뒤로 가버릴 경우에는 모달의 class 에서 fade 를 뺀 class="modal" 로 하고서 해당 모달의 css 에서 zindex 값을 1050; 으로 주면 된다. --%> 
	 <div class="modal-dialog modal-lg">
	   <div class="modal-content">
		   <!-- Modal header -->
		   <div class="modal-header">
		     <h4 class="modal-title">추가 이미지 원래크기 보기</h4>
		     <button type="button" class="close idFindClose" data-dismiss="modal">&times;</button>
		   </div>
		   
		   <!-- Modal body -->
		   <div class="modal-body" id="add_image_modal-body">
		   </div>
		   
		   <!-- Modal footer -->
		   <div class="modal-footer">
		     <button type="button" class="btn btn-danger idFindClose" data-dismiss="modal">Close</button>
		   </div>
	   </div>
	   
	 </div>
</div>
<%-- ****** 추가이미지 보여주기 Modal 끝 ****** --%> 
   
   
   





<jsp:include page="../footer1.jsp" />