<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%String ctxPath = request.getContextPath();%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Required meta tags -->
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

<!-- Bootstrap CSS -->
<link rel="stylesheet" type="text/css" href="<%= ctxPath%>/bootstrap-4.6.2-dist/css/bootstrap.min.css"> 


<!-- Optional JavaScript -->
<script type="text/javascript" src="<%= ctxPath%>/js/jquery-3.7.1.min.js"></script>
<script type="text/javascript" src="<%= ctxPath%>/bootstrap-4.6.2-dist/js/bootstrap.bundle.min.js" ></script>

<script type="text/javascript">
	$(function() {
		const method = "${method}";
		//console.log("method: ", method)
		
		if(method == "GET") {
			$("div#div_findResult").hide();
		}
		if(method == "POST") {
			$("input:text[name='userid']").val("${userid}");
			$("input:text[name='email']").val("${email}");
			// console.log("안녕하세요? 비밀번호 찾기 버튼 클릭하셨습니다.");
			
			if(${isUserExists == true && sendMailSuccess == true }) {
				$("button.btn-success").hide();
			}
		}
		
		// 이름 입력하고, 이메일까지 입력한 후 엔터를 눌렀을 경우
		$("input:text[name='email']").bind("keyup", function(e) {
			if(e.keyCode == 13) {
				goFind();
			}
		});
			
		// "찾기" 버튼을 눌렀을 경우
		$("button.btn-success").click(() => {
			goFind();
		});
		
		
		// === 인증하기 버튼 클릭시 이벤트 처리해주기 시작 === //
		$("button.btn-info").click(() => {
			const input_confirmCode = $("input:text[name='input_confirmCode']").val().trim();
			if(input_confirmCode == ""){
				alert("인증코드를 입력하세요!");
				return;
			}
			const frm = document.verifyCertificationFrm;
			frm.userCertificationCode.value = input_confirmCode;
			frm.userid.value = $("input:text[name='userid']").val();
			
			frm.action = "<%=ctxPath%>/login/verifyCertification.up";
			frm.method = "post";
			frm.submit();
		});
		// === 인증하기 버튼 클릭시 이벤트 처리해주기 끝 === //
		
		
	});//end of $(function(){})-----
	
	

	
	
	// Function Decalaration
	function goFind() {
		const userid = $("input:text[name='userid']").val().trim();
		if(userid == "") {
			alert("아이디를 입력하세요!");
			return; //gofind() 함수 종료
		}
		
		const email = $("input:text[name='email']").val();
		// 이메일 정규표현식(정규표현식정리.txt 파일 참고)
		const reqExp_email = /^[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,3}$/i;
		const bool = reqExp_email.test(email);
		if(!bool) {
			// 입력받은 이메일이 정규표현식에 위배된 경우
			alert("올바른 형식의 이메일을 입력하세요!")
			return; //goFind() 함수 종료
		}
		
		//document.name 을 하기 위해선 document 뒤의 . 이후 값이 name 값이어야만 함!
		const frm = document.pwdFindFrm;
		<%-- frm.action = "<%=ctxPath%>/login/pwdFindFrm.up"; --%> // 명시해놓지 않으면 자기 자신에게 감!
		frm.method = "post";
		frm.submit();
	};//end of function goFind()-----

</script>

<form name="pwdFindFrm">

   <ul style="list-style-type: none;">
      <li style="margin: 25px 0">
          <label style="display: inline-block; width: 90px;">아이디</label>
          <input type="text" name="userid" size="25" autocomplete="off" />
      </li>
      <li style="margin: 25px 0">
          <label style="display: inline-block; width: 90px;">이메일</label>
          <input type="text" name="email" size="25" autocomplete="off" /> 
      </li>
   </ul> 

   <div class="my-3 text-center">
      <button type="button" class="btn btn-success">찾기</button>
   </div>

</form>


<div class="my-3 text-center" id="div_findResult">
	<c:if test="${isUserExists == false}">
		<span style="color: red;">사용자 정보가 없습니다</span>
	</c:if>
	
	<c:if test="${isUserExists == true && sendMailSuccess == true}">
		<span style="font-size: 10pt;">
          인증코드가 ${requestScope.email}로 발송되었습니다.<br>
          인증코드를 입력해주세요
        </span>
        <br>
        <input type="text" name="input_confirmCode" />
        <br><br> 
        <button type="button" class="btn btn-info">인증하기</button>
	</c:if>
	
	<c:if test="${isUserExists == true && sendMailSuccess == false}">
		<span style="color: red;">메일발송이 실패했습니다</span>
	</c:if>
</div>



<%-- 인증하기 form --%>
<form name="verifyCertificationFrm">
   <input type="hidden" name="userCertificationCode" />
   <input type="hidden" name="userid" />
</form>