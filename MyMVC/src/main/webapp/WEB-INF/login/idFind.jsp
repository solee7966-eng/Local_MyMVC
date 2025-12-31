<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%String ctxPath = request.getContextPath();%>

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
			$("input:text[name='name']").val("${name}");
			$("input:text[name='email']").val("${email}");
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
	});//end of $(function(){})-----
	
	// Function Decalaration
	function goFind() {
		const name = $("input:text[name='name']").val().trim();
		if(name == "") {
			alert("이름을 입력하세요!");
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
		const frm = document.idFindFrm;
		<%-- frm.action = "<%=ctxPath%>/login/idFind.up"; --%> // 명시해놓지 않으면 자기 자신에게 감!
		frm.method = "post";
		frm.submit();
	};//end of function goFind()-----
	
	// 아이디 찾기 모달창에 입력한 input 태그 value 값 초기화 시켜주는 함수 생성하기
	function func_form_reset_empty() {
		document.querySelector("form[name='idFindFrm']").reset();
		$("div#div_findResult").empty();
	}

</script>

<form name="idFindFrm">

   <ul style="list-style-type: none;">
      <li style="margin: 25px 0">
          <label style="display: inline-block; width: 90px;">성명</label>
          <input type="text" name="name" size="25" autocomplete="off" />
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
	ID: <span style="color: red; font-size: 15pt; font-weight: bold">${userid}</span>
</div>