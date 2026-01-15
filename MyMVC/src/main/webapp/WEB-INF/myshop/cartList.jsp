<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%String ctxPath = request.getContextPath();%>

<jsp:include page="../header1.jsp"/>

<style type="text/css">
   table#tblCartList {width: 90%;
                      border: solid gray 1px;
                      margin-top: 20px;
                      margin-left: 10px;
                      margin-bottom: 20px;}
                      
   table#tblCartList th {border: solid gray 1px;}
   table#tblCartList td {border: dotted gray 1px;} 
   
   label.label_pnum:hover{
         cursor: pointer;
         background-color: #ccc;
   }
   
 /* -- CSS 로딩화면 구현 시작(bootstrap 에서 가져옴) 시작 -- */    
  div.loader {
   /* border: 16px solid #f3f3f3; */
     border: 12px solid #f3f3f3;
     border-radius: 50%;
   /* border-top: 12px solid #3498db; */
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
	const arr_oqty = []; //원래의 주문수량을 담을 배열

	$(function() {
		//원래의 주문수량을 가져오기 위한 반복문
		$("input.oqty").each(function(index, elmt) {
			arr_oqty.push($(elmt).val());
			
		});
		
		
		$("div.loader").hide(); // CSS 로딩화면 감추기
	    $("p#order_error_msg").css({'display':'none'}); // 코인잔액 부족시 주문이 안된다는 표시를 해주는 곳. 
	     
	    $("input.spinner").spinner({
        	spin: function(event, ui) {
	            if(ui.value > 100) {
	              	$(this).spinner("value", 100);
	                return false;
	            } else if(ui.value < 0) {
	                $(this).spinner("value", 0);
	                return false;
	            }
        	}
	    });//end of $(".spinner").spinner({});-----------------
	    
	    
	    //제품번호의 모든 체크박스가 체크가 되었다가 그 중 하나만 이라도 체크를 해제하면 전체선택 체크박스에도 체크를 해제하도록 한다.
	    $("input:checkbox[name=pnum]").click(function() {
	    	let bFlag = false;
	    	
	    	$("input:checkbox[name=pnum]").each(function(index, elmt) {
	    		const is_checked = $(elmt).prop("checked");
	    		if(!is_checked) {
	    			$("input:checkbox[id=allCheckOrNone]").prop("checked", false);
	    			bFlag = true;
	    			return false;
	    		}
	    	});
	    	
    		//전부 다 체크가 된 상태라면 전체선택 체크박스를 체크해추기
	    	if(!bFlag){
	    		$("input:checkbox[id=allCheckOrNone]").prop("checked", true);
	    	}
	    });//end of $("input:checkbox[name=pnum]").click(function(){})-----
	    
	    
	    // === 현재 주문수량에 키보드로 값을 입력할 경우 === //
	    // 숫자가 아니거나, 0~100 범위 내의 값이 아닐 경우의 유효성 검사
	    $("input.oqty").on("keyup", function(e){
	    	//alert("ㅎㅎㅎ");
	    	const regExp = /^[0-9]+$/g; //숫자만 체크하는 정규표현식
	    	const bool = regExp.test($(e.target).val());
	    	if(!bool) {
	    		alert("0~100 이내의 숫자만 입력이 가능합니다.");
	    		$(e.target).val("1");
	    	} else {
	    		if($(e.target).val() > 100) {
	    			alert("0~100 이내의 숫자만 입력이 가능합니다.")
	    			$(e.target).val("1");
	    		}
	    	}
	    });
	    
	    
	    
	    
	});//end of $(function(){})-----
	
	
	//===== 전체선택/전체해제 =====//
	function allCheckBox() {
		//체크가 되었다면 true, 안됐다면 false
		const bool = $("input:checkbox[id=allCheckOrNone]").prop("checked");
		$("input:checkbox[name=pnum]").prop("checked", bool);
	};//end of function allCheckBox()----- 
	
	
	//==== 장바구니 현재주문수량 수정하기 ====//
	function goOqtyEdit(btn) {
		const idx = $("button.updateBtn").index(btn);
		//alert(idx);

		const cartno = $("input:text[class='cartno']").eq(idx).val(); //장바구니 번호
		//alert(cartno);
		
		const oqty = $("input.oqty").eq(idx).val(); //수정개수
		//alert(oqty);
		
		const pqty = $("input.pqty").eq(idx).val(); //잔고량
		
		if(Number(oqty) > Number(pqty)) {
			//수정할 개수가 잔고량보다 클 경우(막아주기)
			alert("잔고량 부족으로 주문수량 수정이 불가합니다.");
			//alert("원래 잔고량: " + arr_oqty[idx]);
			$("input.oqty").eq(idx).val(arr_oqty[idx]); //원래 잔고량으로 되돌리기
			return;
		}
		
		if(oqty == "0") {
			//해당 장바구니 번호를 비우기
			goDel(cartno); //해당 장바구니 비우기
		} else {
			$.ajax({
				url:"${pageContext.request.contextPath}/shop/cartEdit.up",
				type:"post",
				data:{
					"cartno":cartno,
					"oqty":oqty
				},
				dataType:"json",
				success:function(json){
					console.log("확인용: ", JSON.stringify(json));
					// 확인용: {"n":1}
					if(json.n == 1){
						alert("주문 수량이 변경되었습니다.");
						//장바구니 페이지로 이동하기
						location.href="${pageContext.request.contextPath}/shop/cartList.up";
					}
				},
				error: function(request, status, error){
	               alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
	            }
			});
		}
		
		
	}//end of function goOqtyEdit(btn)-----
	
	
	// === 장바구니에서 특정 제품을 비우기 === //
	function goDel(cartno) {
		//$(event.target) 은 goDel(cartno) 함수를 호출한 엘리먼트(태그)를 가리키는 것이다.
	    //즉, 삭제버튼(<button>)를 말하는 것이다.
		const pname = $(event.target).parent().parent().find("span.cart_pname").text();
		
		if(confirm(`"\${pname}"을(를) 장바구니에서 제거하시겠습니까?`)) {
			$.ajax({
				url:"${pageContext.request.contextPath}/shop/cartDel.up",
				type:"post",
				data:{"cartno":cartno},
				dataType:"json",
				success:function(json){
					console.log("확인용: ", JSON.stringify(json));
					// 확인용: {"n":1}
					if(json.n == 1){
						//alert("주문 수량이 변경되었습니다.");
						//장바구니 페이지로 이동하기
						location.href="${pageContext.request.contextPath}/shop/cartList.up";
					}
				},
				error: function(request, status, error){
	               alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
	            }
			});
		} else {
			alert(`장바구니에서 "\${pname}" 제품의 삭제를 취소했습니다.`);
		}
	}//end of function goDel(cartno)-----
	
	
	// === 장바구니에서 제품 주문하기 === //
	function goOrder() {
		// ==체크박스의 체크된 개수(checked 속성 이용)==
	 	const checkCtn = $("input:checkbox[name=pnum]:checked").length;
		if(checkCtn < 1) {
			//체크된 체크박스가 하나도 없다면 함수 종료
			alert("주문할 제품을 선택하세요");
			return;
			
		} else {
			//// === 체크박스의 체크된 value값(checked 속성이용) === ////
	        //// === 체크가 된 것만 읽어와서 배열에 넣어준다. === ////
	        const allCnt = $("input:checkbox[name=pnum]").length;
			
			const arr_pnum = [];
			const arr_oqty = [];
			const arr_pqty = [];
			const arr_cartno = [];
			const arr_totalPrice = [];
			const arr_totalPoint = [];
			
			for(let i=0; i<allCnt; i++){
				if($("input:checkbox[name=pnum]").eq(i).prop("checked")){
					<%-- 
					console.log("제품번호: ", $("input:checkbox[name=pnum]").eq(i).val());
					console.log("주문량: ", $("input.oqty").eq(i).val());
					console.log("잔고량: ", $("input.pqty").eq(i).val());
					console.log("삭제해야할 장바구니 번호: ", $("input.cartno").eq(i).val());
					console.log("주문한 제품의 개수에 따른 가격합계: ", $("input.totalPrice").eq(i).val());
					console.log("주문한 제품의 개수에 따른 포인트합계: ", $("input.totalPoint").eq(i).val());
					console.log("========================================")
					--%>
					arr_pnum.push($("input:checkbox[name=pnum]").eq(i).val());
					arr_oqty.push($("input.oqty").eq(i).val());
					arr_pqty.push($("input.pqty").eq(i).val());
					arr_cartno.push($("input.cartno").eq(i).val());
					arr_totalPrice.push($("input.totalPrice").eq(i).val());	
					arr_totalPoint.push($("input.totalPoint").eq(i).val());
				}//end of if()-----
			}//end of for()-----
			
			<%-- [확인용 배열들 출력]
			for(let i=0; i<checkCtn; i++){
				console.log("확인용 제품번호: " + arr_pnum[i] + ", 주문량: " + arr_oqty[i] + ", 잔고량: " +
						arr_pqty[i] + ", 장바구니번호 : " + arr_cartno[i] + ", 주문금액: " + arr_totalPrice[i] + ", 포인트: " + arr_totalPoint[i]);
	            /*  
	             확인용 제품번호: 3, 주문량: 2, 잔고량: 20, 장바구니번호 : 7, 주문금액: 20000, 포인트: 10
	             확인용 제품번호: 36, 주문량: 1, 잔고량: 100, 장바구니번호 : 6, 주문금액: 1000000, 포인트: 60
	             확인용 제품번호: 57, 주문량: 3, 잔고량: 20, 장바구니번호 : 5, 주문금액: 30000, 포인트: 30 */
	        }// end of for------------------
	        --%>
	        
	        //잔고량과 주문량을 확인하여 유효성 검사해주기(잔고량은 주문량보다 많아야 함)
	        for(let i=0; i<checkCtn; i++){
	        	if(Number(arr_pqty[i]) < Number(arr_oqty[i])) {
	        		//주문할 제품 중 어느 것 하나가 잔고량이 주문량보다 적을 경우
	        		alert("제품번호 " +arr_pnum[i]+ "의 주문개수가 잔고개수보다 많으므로 진행할 수 없습니다.")
	        		location.href="javascript:history.go(0)";
	        		return; //goOrder() 함수 종료
	        	}
	        }// end of for------------------
	        
	        let n_sum_totalPrice = 0; //주문 총액
	        for(let i=0; i<arr_totalPrice.length; i++){
	        	n_sum_totalPrice += Number(arr_totalPrice[i]);
	        }//end of for()-----
	        
	        
	        const current_coin = ${sessionScope.loginUser.coin};
	        if(current_coin < n_sum_totalPrice) {
	        	//회원 보유 코인이 총합의 코인보다 작을 경우
	        	$("p#order_error_msg").html("코인잔액이 부족하므로 주문이 불가합니다.<br>주문총액 : "+ n_sum_totalPrice.toLocaleString('en') +"원 / 코인잔액 : "+ current_coin.toLocaleString('en') +"원").css({'display':''});
	        	// 숫자.toLocaleString('en') 이 자바스크립트에서 숫자 3자리마다 콤마 찍어주기 이다.
	        	return; //goOrder() 함수 종료
	        	
	        } else {
	        	$("p#order_error_msg").css({'display':'none'});
	        	if(confirm("총주문액 "+ n_sum_totalPrice.toLocaleString('en') + "원을 주문하시겠습니까?")){
	        		//css 화면 보여주기
	        		$("div.loader").show(); // CSS 로딩화면 보여주기
	        		
	        		let n_sum_totalPoint = 0; //주문 총포인트
	    	        for(let i=0; i<arr_totalPoint.length; i++){
	    	        	n_sum_totalPoint += Number(arr_totalPoint[i]);
	    	        }//end of for()-----
	        		
	        		$.ajax({
	        			url:"${pageContext.request.contextPath}/shop/orderAdd.up",
	        			type:"post",
	        			data:{
	        				"n_sum_totalPrice":n_sum_totalPrice,		//주문총액
	        				"n_sum_totalPoint":n_sum_totalPoint,		//포인트총액
			        		"str_pnum_join":arr_pnum.join(),			//제품번호를 문자열로 합한 것
			        		"str_oqty_join":arr_oqty.join(),			//주문량을 문자열로 합한 것
			        		"str_totalPrice_join":arr_totalPrice.join(),	//주문가격을 합한 것
			        		"str_cartno_join":arr_cartno.join()			//장바구니 번호를 합한 것
	        			},
	        			dataType:"json",
	        			success:function(json){ // json ==> {"isSuccess":1} 또는 {"isSuccess":0}
							if(json.isSuccess == 1){
	                            location.href="${pageContext.request.contextPath}/shop/orderList.up"; 
							} else {
								location.href="${pageContext.request.contextPath}/shop/orderError.up";
							}
						},
						error: function(request, status, error){
							alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
						}
	        		});
	        	}
	        	
	        }//end of if(current_coin < n_sum_totalPrice)-----
	        
		}//end of if~else()-----
	}//end of function goOrder()-----
	
</script>






<div class="container-fluid" style="border: solid 0px red">
   <div class="my-3">
      <p class="h4 text-center">&raquo;&nbsp;&nbsp;${sessionScope.loginUser.name} [${sessionScope.loginUser.userid}]님 장바구니 목록&nbsp;&nbsp;&laquo;</p>
   </div>
   <div>
       <table id="tblCartList" class="mx-auto" style="width: 90%">
         <thead>
            <tr>
             <th style="border-right-style: none;">
                 <input type="checkbox" id="allCheckOrNone" onclick="allCheckBox()" />
                 <span style="font-size: 10pt;"><label for="allCheckOrNone">전체선택</label></span>
             </th>
             <th colspan="5" style="border-left-style: none; font-size: 12pt; text-align: center;">
                 <marquee>주문을 하시려면 먼저 제품번호를 선택하신 후 [주문하기] 를 클릭하세요</marquee>
             </th>
            </tr>
         
            <tr style="background-color: #cfcfcf;">
              <th style="width:10%; text-align: center; height: 30px;">제품번호</th>
              <th style="width:23%; text-align: center;">제품명</th>
                 <th style="width:17%; text-align: center;">현재주문수량</th>
                 <th style="width:20%; text-align: center;">판매가/포인트(개당)</th>
                 <th style="width:20%; text-align: center;">주문총액/총포인트</th>
                 <th style="width:10%; text-align: center;">비우기</th>
            </tr>   
         </thead>
       
         <tbody>
            <c:if test="${empty requestScope.cartList}">
              <tr>
                 <td colspan="6" align="center">
                   <span style="color: red; font-weight: bold;">
                      장바구니에 담긴 상품이 없습니다.
                   </span>
                 </td>   
              </tr>
            </c:if>
            
            <c:if test="${not empty requestScope.cartList}">
                 <c:forEach var="cartDTO" items="${requestScope.cartList}" varStatus="status">
                    <tr>
                        <td>
                           <input type="checkbox" name="pnum" id="pnum${status.index}" value="${cartDTO.fk_pnum}" />&nbsp;<label for="pnum${status.index}" class="label_pnum">${cartDTO.fk_pnum}</label>    
                        </td>
                        <td align="center"> <%-- 제품이미지1 및 제품명 --%>
                           <a href="<%= ctxPath%>/shop/prodView.up?pnum=${cartDTO.fk_pnum}">
                              <img src="<%= ctxPath%>/images/${cartDTO.pDto.pimage1}" class="img-thumbnail" width="130px" height="100px" />
                           </a>
                           <br>
                           <span class="cart_pname">${cartDTO.pDto.pname}</span>
                        </td>
                        <td align="center">
                              <%-- 현재주문수량 --%>
                              <input class="spinner oqty" name="oqty" value="${cartDTO.oqty}" style="width: 30px; height: 20px;">개
                              <button type="button" class="btn btn-outline-secondary btn-sm updateBtn" onclick="goOqtyEdit(this)">수정</button>
                              
                              <%-- 잔고량 --%>
                              <input type="text" class="pqty" value="${cartDTO.pDto.pqty}" />
                              
                              <%-- 장바구니 테이블에서 특정제품의 현재주문수량을 변경하여 적용하려면 먼저 장바구니번호(시퀀스)를 알아야 한다 --%>
                              <input type="text" class="cartno" value="${cartDTO.cartno}" /> 
                        </td>
                        <td align="right"> <%-- 판매가/포인트(개당) --%>
                              <fmt:formatNumber value="${cartDTO.pDto.saleprice}" pattern="###,###" /> 원<br>
                            <fmt:formatNumber value="${cartDTO.pDto.point}" pattern="###,###" /> POINT
                        </td>
                        <td align="right"> <%-- 주문총액/총포인트 --%> 
                            <fmt:formatNumber value="${cartDTO.pDto.totalPrice}" pattern="###,###" /> 원<br>
                            <fmt:formatNumber value="${cartDTO.pDto.totalPoint}" pattern="###,###" /> POINT
                            <input type="text" class="totalPrice" value="${cartDTO.pDto.totalPrice}" />
                            <input type="text" class="totalPoint" value="${cartDTO.pDto.totalPoint}" />
                        </td>
                        <td align="center"> <%-- 장바구니에서 해당 특정 제품 비우기 --%> 
                           <button type="button" class="btn btn-outline-danger btn-sm" onclick="goDel('${cartDTO.cartno}')">삭제</button>  
                      </td>
                    </tr>
                 </c:forEach>
            </c:if>
            
            <tr>
                 <td colspan="3" align="right">
                     <span style="font-weight: bold;">장바구니 총액 :</span>
                  <span style="color: red; font-weight: bold;"><fmt:formatNumber value="${requestScope.sumMap.SUMTOTALPRICE}" pattern="###,###" /></span> 원  
                     <br>
                     <span style="font-weight: bold;">총 포인트 :</span> 
                  <span style="color: red; font-weight: bold;"><fmt:formatNumber value="${requestScope.sumMap.SUMTOTALPOINT}" pattern="###,###" /></span> POINT 
                 </td>
                 <td colspan="3" align="center">
                  <button type="button" class="btn btn-outline-dark btn-sm mr-3" onclick="goOrder()">주문하기</button>
                    <a class="btn btn-outline-dark btn-sm" href="<%=ctxPath%>/shop/mallHomeMore.up" role="button">계속쇼핑</a>
                 </td>
            </tr>
            
         </tbody>
      </table> 
   </div>
   
   <div>
        <p id="order_error_msg" class="text-center text-danger font-weight-bold h4"></p>
    </div>
   
   <%-- CSS 로딩화면 구현한것--%>
    <div style="display: flex; position: absolute; top: 30%; left: 37%; border: solid 0px blue;">
      <div class="loader" style="margin: auto"></div>
    </div>
   
 </div>






<jsp:include page="../footer1.jsp"/>