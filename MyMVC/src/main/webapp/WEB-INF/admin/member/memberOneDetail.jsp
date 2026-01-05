<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>  

<jsp:include page="../../header2.jsp" /> 

<style type="text/css">
  table.table-bordered > tbody > tr > td:nth-child(1) {
      width: 25%;
      font-weight: bold;
      text-align: right;
  }
</style>

<script type="text/javascript">
	$(function() {
		$("div#smsResult").hide();
		$("button#btnSend").click(() => {
			//console.log($("input#reservedate").val()+" " +$("input#reservetime").val());
			//2026-01-05 11:50
			//202601051150 => 기호들을 다 뺴주어야 제대로 작동함!
			
			let reservedate = $("input#reservedate").val();
			reservedate = reservedate.split("-").join(""); //"-"를 기준으로 나누고, ""를 이용해 합침.
			//["2026", "01", "05"] => 20260105
			
			let reservetime = $("input#reservetime").val();
			reservetime = reservetime.split(":").join("");
			
			const datetime = reservedate + reservetime;
			//console.log(datetime);
			//202601051150
			
			//전화번호와 문자내용, 예약문자일 경우 시간까지 포함한 객체
			let dataObj;
			
			if(reservedate == "" || reservetime == "") {
				//문자를 바로 보낼 경우
				dataObj = {"mobile":"${mbDto.mobile}",
						   "smsContent":$("textarea#smsContent").val()};
			} else {
				//예약하여 문자를 보낼 경우
				dataObj = {"mobile":"${mbDto.mobile}",
						   "smsContent":$("textarea#smsContent").val(),
						   "datetime":datetime};
			}
			
			
			$.ajax({
				url: "${pageContext.request.contextPath}/admin/member/smsSend.up",
				// type:"get", 명시하지 않으면 디폴트: get방식
				data: dataObj,
				datatype:"json",
				success:function(json){
					// json 은 {"group_id":"R2GWPBT7UoW308sI","success_count":1,"error_count":0} 처럼 된다.
					if(json.success_count == 1) {
						$("div#smsResult").html("<span style='color:red; font-weight:bold;'>문자전송이 성공되었습니다.^^</span>");
					}
					else if(json.error_count != 0) {
						$("div#smsResult").html("<span style='color:red; font-weight:bold;'>문자전송이 실패되었습니다.ㅜㅜ</span>");
					}
					
					$("div#smsResult").show();
					$("textarea#smsContent").val("");
				},
				error:function(request, status, error){
					alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
		        }
			});
			
		});//end of $("button#btnSend").click((){})-----
		
		<%--  .jsp 파일에서 사용되어지는 것들 
	        console.log('${pageContext.request.contextPath}');  // 컨텍스트패스   /MyMVC
	        console.log('${pageContext.request.requestURL}');   // 전체 URL     http://localhost:9090/MyMVC/WEB-INF/member/admin/memberList.jsp
	        console.log('${pageContext.request.scheme}');       // http        http
	        console.log('${pageContext.request.serverName}');   // localhost   localhost
	        console.log('${pageContext.request.serverPort}');   // 포트번호      9090
	        console.log('${pageContext.request.requestURI}');   // 요청 URI     /MyMVC/WEB-INF/member/admin/memberList.jsp 
	        console.log('${pageContext.request.servletPath}');  // 파일명       /WEB-INF/member/admin/memberList.jsp 
	    --%>
	});//end of $(function)-----
</script>

<div class="container">
	<c:if test="${empty mbDto}">
		<div class="text-center h4 my-5">존재하지 않는 회원입니다.</div>
	</c:if>
	
	
	<c:if test="${not empty mbDto}">
		<p class="text-center h3 mt-5 mb-4">::: <span style="color: blue;">${mbDto.name}</span>&nbsp;님의 회원 상세정보 :::</p>
		
		<table class="table table-bordered" style="width: 60%; margin: 0 auto;">
	         <tr>
	            <td class="text-center">아이디&nbsp;&nbsp;</td>
	            <td>${requestScope.mbDto.userid}</td>
	         </tr>
	         <tr>
	            <td class="text-center">회원명&nbsp;&nbsp;</td>
	            <td>${requestScope.mbDto.name}</td>
	         </tr>
	         <tr>
	            <td class="text-center">이메일&nbsp;&nbsp;</td>
	            <td>${requestScope.mbDto.email}</td>
	         </tr>
	         <tr>
	            <td class="text-center">휴대폰&nbsp;&nbsp;</td>
	            <c:set var="mobile" value="${requestScope.mbDto.mobile}" />   
	            <td>${fn:substring(mobile, 0, 3)}-${fn:substring(mobile, 3, 7)}-${fn:substring(mobile, 7, 11)}</td> 
	         </tr>
	         <tr>
	            <td class="text-center">우편번호&nbsp;&nbsp;</td>
	            <td>${requestScope.mbDto.postcode}</td>
	         </tr>
	         <tr>
	            <td class="text-center">주소&nbsp;&nbsp;</td>
	            <td>${requestScope.mbDto.address}&nbsp;
	                ${requestScope.mbDto.detailaddress}&nbsp;
	                ${requestScope.mbDto.extraaddress}
	            </td>
	         </tr>
	         <tr>
	            <td class="text-center">성별&nbsp;&nbsp;</td>
	            <td>
	               <c:choose>
	                  <c:when test="${requestScope.mbDto.gender == '1'}">남</c:when> 
	                  <c:otherwise>여</c:otherwise>
	               </c:choose>
	            </td>
	         </tr>
	         <tr>
	            <td class="text-center">생년월일&nbsp;&nbsp;</td>
	            <td>${requestScope.mbDto.birthday}</td>
	         </tr>
	         <tr>
	            <td class="text-center">만나이&nbsp;&nbsp;</td>
	            <td>${requestScope.mbDto.age}&nbsp;세</td>
	         </tr>
	         <tr>
	            <td class="text-center">코인액&nbsp;&nbsp;</td>
	            <td>
	               <fmt:formatNumber value="${requestScope.mbDto.coin}" pattern="###,###" />&nbsp;원
	            </td>
	         </tr>
	         <tr>
	            <td class="text-center">포인트&nbsp;&nbsp;</td>
	            <td>
	               <fmt:formatNumber value="${requestScope.mbDto.point}" pattern="###,###" />&nbsp;POINT 
	            </td>
	         </tr>
	         <tr>
	            <td class="text-center">가입일자&nbsp;&nbsp;</td>
	            <td>${requestScope.mbDto.registerday}</td>
	         </tr>
       </table>
       
       <%-- ==== 휴대폰 SMS(문자) 보내기 ==== --%>
       <div class="border my-5 text-center" style="width: 60%; margin: 0 auto;">
           <p class="h5 bg-info text-white">
             &gt;&gt;&nbsp;&nbsp;휴대폰 SMS(문자) 보내기 내용 입력란&nbsp;&nbsp;&lt;&lt;
           </p>
           
           <div class="mt-4 mb-3">
              <span class="bg-danger text-white" style="font-size: 14pt;">문자발송 예약일자</span>
              <input type="date" id="reservedate" class="mx-2" />
              <input type="time" id="reservetime" />
           </div>
           
           <div style="display: flex;">
              <div style="border: solid 0px red; width: 81%; margin: auto;">
                 <textarea rows="4" id="smsContent" style="width: 100%;"></textarea>
              </div>
              <div style="border: solid 0px blue; width: 19%; margin: auto;">
                 <button id="btnSend" class="btn btn-secondary">문자전송</button>
              </div>
           </div>
           
           <div id="smsResult" class="p-3"></div>
       </div>   
       
       
	</c:if>
	
	<div class="text-center mt-3 mb-5">
		<button type="button" class="btn btn-secondary" onclick="javascript:location.href='memberList.up'">회원목록[처음으로]</button>
		<button type="button" class="btn btn-success mx-5" onclick="javascript:history.back()">회원목록[history.back()]</button>
															<!-- history.back()는 스냅샷으로 이전 페이지에 돌려보내기 때문에 상세페이지를 보는 도중에 
																 데이터값이 삭제됐다고 가정한다면 이전 페이지로 돌아가도 삭제된 값이 그대로 보이게 됨 -->
		<button type="button" class="btn btn-primary mx-5" onclick="javascript:location.href='${referer}'">회원목록[검색된결과]</button>
	</div>
	
</div>





<jsp:include page="../../footer2.jsp"/>