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
	$(function() {
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
	    
	    
	    
	});//end of $(function(){})-----
	
	
	//===== 전체선택/전체해제 =====//
	function allCheckBox() {
		//체크가 되었다면 true, 안됐다면 false
		const bool = $("input:checkbox[id=allCheckOrNone]").prop("checked");
		$("input:checkbox[name=pnum]").prop("checked", bool);
	};//end of function allCheckBox()----- 
	
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
                           <input type="checkbox" name="pnum" id="pnum${status.index}" value="${cartDTO.fk_pnum}" />&nbsp;<label for="pnum${status.index}" class="label_pnum">${cartvo.fk_pnum}</label>    
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
                              <input type="hidden" class="pqty" value="${cartDTO.pDto.pqty}" />
                              
                              <%-- 장바구니 테이블에서 특정제품의 현재주문수량을 변경하여 적용하려면 먼저 장바구니번호(시퀀스)를 알아야 한다 --%>
                              <input type="hidden" class="cartno" value="${cartDTO.cartno}" /> 
                        </td>
                        <td align="right"> <%-- 판매가/포인트(개당) --%>
                              <fmt:formatNumber value="${cartDTO.pDto.saleprice}" pattern="###,###" /> 원<br>
                            <fmt:formatNumber value="${cartDTO.pDto.point}" pattern="###,###" /> POINT
                        </td>
                        <td align="right"> <%-- 주문총액/총포인트 --%> 
                            <fmt:formatNumber value="${cartDTO.pDto.totalPrice}" pattern="###,###" /> 원<br>
                            <fmt:formatNumber value="${cartDTO.pDto.totalPoint}" pattern="###,###" /> POINT
                            <input type="hidden" class="totalPrice" value="${cartDTO.pDto.totalPrice}" />
                            <input type="hidden" class="totalPoint" value="${cartDTO.pDto.totalPoint}" />
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