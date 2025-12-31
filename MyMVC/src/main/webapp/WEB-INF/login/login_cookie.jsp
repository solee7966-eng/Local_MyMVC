<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>    

<%
    String ctx_Path = request.getContextPath();
    //    /MyMVC
    // 앞선 header1과 request.getContextPath(); 를 담는 변수명을 다르게 해야
    //  서로 경로가 곂치지 않고 잘 작동함!!
    
    // 무언가 경로를 설정할 때 라이브러리는 한 번만 호출하도록 한다!! 그렇지 않으면 삑난다
%>

<link rel="stylesheet" type="text/css" href="<%= ctx_Path%>/css/login/login.css">

<!-- 직접 만든 JS -->
<script type="text/javascript" src="<%= ctx_Path%>/js/login/login.js"></script>

<script type="text/javascript">
      $(function() {
      <%-- === 쿠키(Cookie) 값을 읽어올 때 자바스크립트를 이용하는 경우 시작 === --%>
         const cookies = document.cookie;// 자바스크립트에서 접근 가능한 쿠키값을 읽어오는 것   
                                  // HttpOnly 쿠키(예: JSESSIONID)는 JavaScript 로 접근할 수 없다.
          console.log("쿠키 : ", cookies);   
         
         if(cookies != ""){
            const arrCookie = cookies.split("; ");
            
            for(let i=0; i<arrCookie.length; i++){
               const cookie_name = arrCookie[i].substring(0, arrCookie[i].indexOf("="));
               console.log("쿠키명 : " + cookie_name);
               
               if(cookie_name == "saveid"){
                  const cookie_value = arrCookie[i].substring(arrCookie[i].indexOf("=")+1);
                  $('input#loginUserid').val(cookie_value);
                  $('input#checkbox[name="saveid"]').prop("checked", true);
                  break;
               }
               
            }// EoP for
         }
         <%-- === 쿠키(Cookie) 값을 읽어올 때 자바스크립트를 이용하는 경우 끝 === --%>
         
         //-------------------------------------------------------------------------------------------------------------//
         // == 아이디 찾기에서 close 버튼 또는 x버튼을 클릭하면 iframe 의 form 태그에 입력된 값을 지우기 == //
         $('button.idFindClose').click(function(){
           const iframe_idFind = document.getElementById("iframe_idFind"); 
           // 대상 아이프레임을 선택한다.
           <%-- 선택자를 잡을때 jQuery를 사용한 ${} 으로 잡으면 안되고, 순수한 자바스크립트를 사용하여 선택자를 잡아야 한다. --%> 
           <%-- .jsp 파일속에 주석문을 만들때 ${} 을 넣고자 한다라면 반드시 JSP 주석문으로 해야 하지, 스크립트 주석문으로 해주면 ${} 때문에 오류가 발생한다. --%>
           
           const iframe_window = iframe_idFind.contentWindow;
           // iframe 요소에 접근하는 contentWindow 와 contentDocument 의 차이점은 아래와 같다.
           // contentWindow 와 contentDocument 둘 모두 iframe 하위 요소에 접근 할 수 있는 방법이다.
           // contentWindow 는 iframe의 window(전체)을 의미하는 것이다.
           // 참고로, contentWindow.document 은 contentDocument 와 같은 것이다.
           // contentWindow 가 contentDocument 의 상위 요소이다.
           
           iframe_window.func_form_reset_empty();// func_form_reset_empty() 함수는 idFind.jsp 파일에 정의해 둠.
           
         });//EoP$('button.idFindClose').click(function(){}
         //-------------------------------------------------------------------------------------------------------------//
     	
     	$("button.passwdFindClose").click(function() {
        	javascript:history.go(0);
        	//현재 페이지를 새로고침 함으로써 모달 창에 입력한 userid와 email의 값이 텍스트박스 값에 남아있지 않고 삭제되는 효과를 가짐
        	
        	/* === 새로고침(다시읽기) 방법 3가지 차이점 ===
            >>> 1. 일반적인 다시읽기 <<<
            window.location.reload();
            ==> 이렇게 하면 컴퓨터의 캐시에서 우선 파일을 찾아본다.
                없으면 서버에서 받아온다. 
            
            >>> 2. 강력하고 강제적인 다시읽기 <<<
            window.location.reload(true);
            ==> true 라는 파라미터를 입력하면, 무조건 서버에서 직접 파일을 가져오게 된다.
                캐시는 완전히 무시된다.
            
            >>> 3. 부드럽고 소극적인 다시읽기 <<<
            history.go(0);
            ==> 이렇게 하면 캐시에서 현재 페이지의 파일들을 항상 우선적으로 찾는다.
         */
        })
     	
      });
</script>

<%------------ 로그인을 하기 위한 form 태그 생성하기 시작, [로그인 하기 전 form 태그]------------%>
<%-- sessionScope. => session 저장소! 이것은 생략할 수 없고 반드시 명시해주어야 함! --%>
<%-- <c:if test=" ${empty sessionScope.loginuser} "> 와 같이 test="" 에 test=" " 와 같이 공백을 넣어주면 꽝이다.!!! --%>
<c:if test="${empty sessionScope.loginUser}">
	<form name="loginFrm" action="<%= ctx_Path%>/login/login.up" method="post">
		<table id="loginTbl">
          <thead>
              <tr>
                 <th colspan="2">LOGIN</th>
              </tr>
          </thead>
          
          <tbody>
<%--
	// 쿠기값을 읽어올 때 자바를 이용하는 경우 시작
	String saveid = "";
	Cookie[] arrCookie = request.getCookies();
	if(arrCookie != null) {
		for(Cookie cookie : arrCookie) {
			System.out.println("쿠키명: "+cookie.getName() + ", 쿠키값: " +cookie.getValue());
			// 쿠키명 JSESSIONID 는 Java 웹 애플리케이션(Servlet, JSP) 에서 세션을 식별하기 위해 자동으로 생성되는 쿠키 이름이다. 
            // JSESSIONID 는 서버(Servlet 컨테이너)가 자동으로 생성 및 관리된다.
            // JSESSIONID 사용목적은 로그인 상태, 장바구니, 사용자 데이터 등 세션 기반 상태 유지를 하기 위함이다.
            if("saveid".equals(cookie.getName())) {
            	// login.controller.Login 클래스에서 Cookie(쿠키)를 클래스 객체를 생성할때 쿠키명을 "saveid" 라고 해두었음.
            	saveid = cookie.getValue();
            }
		}//end of for()-----
	}
	// 쿠기값을 읽어올 때 자바를 이용하는 경우 끝
--%>          
          	  <tr>
          	     <td>ID</td>
          	     <%-- "아이저장" 체크박스에 쿠기(Cookie) 값을 읽어올 때 자바를 이용하는 경우 --%>
          	     <%-- <td><input type="text" name="userid" id="loginUserid" size="20" autocomplete="off" value="<%=saveid%>"/></td> --%>

          	     <%-- "아이저장" 체크박스에 쿠기(Cookie) 값을 읽어올 때 자바 스크립트를 이용하는 경우 --%>
          	     <td><input type="text" name="userid" id="loginUserid" size="20" autocomplete="off" /></td>
          	  </tr>
          	  <tr>
                 <td>암호</td>
                 <td><input type="password" name="pwd" id="loginPwd" size="20" /></td>
              </tr>
              
              <%-- ==== 아이디 찾기, 비밀번호 찾기 ==== --%>
              <tr>
                  <td colspan="2">
                     <a style="cursor: pointer;" data-toggle="modal" data-target="#userIdfind" data-dismiss="modal">아이디찾기</a> / 
                     <a style="cursor: pointer;" data-toggle="modal" data-target="#passwdFind" data-dismiss="modal" data-backdrop="static">비밀번호찾기</a>
                  </td>
              </tr>
              
              <tr>
                  <td colspan="2">
                  	 <%-- "아이저장" 체크박스에 쿠기(Cookie) 값을 읽어올 때 자바를 이용하는 경우 --%>
                  	 <%-- <input type="checkbox" id="saveid" name="saveid" <%=saveid.isEmpty()?"":"checked" %>/>&nbsp;<label for="saveid">아이디저장</label> --%>
                  	 
                  	 <%-- "아이저장" 체크박스에 쿠기(Cookie) 값을 읽어올 때 자바 스크립트를 이용하는 경우 --%>
                     <input type="checkbox" id="saveid" name="saveid" />&nbsp;<label for="saveid">아이디저장</label>
                     <button type="button" id="btnSubmit" class="btn btn-primary btn-sm ml-3">로그인</button> 
                  </td>
              </tr>
          </tbody>
        </table>
	</form>
<%------------ 로그인을 하기 위한 form 태그 생성하기 끝, [로그인 하기 전 form 태그]------------%>
	
<%-- ****** 아이디 찾기 Modal 시작 ****** --%>
<%-- <div class="modal fade" id="userIdfind"> --%> <%-- 만약에 모달이 안보이거나 뒤로 가버릴 경우에는 모달의 class 에서 fade 를 뺀 class="modal" 로 하고서 해당 모달의 css 에서 zindex 값을 1050; 으로 주면 된다. --%> 
  <div class="modal fade" id="userIdfind" data-backdrop="static"> <%-- 만약에 모달이 안보이거나 뒤로 가버릴 경우에는 모달의 class 에서 fade 를 뺀 class="modal" 로 하고서 해당 모달의 css 에서 zindex 값을 1050; 으로 주면 된다. --%>  
    <div class="modal-dialog">
      <div class="modal-content">
      
        <!-- Modal header -->
        <div class="modal-header">
          <h4 class="modal-title">아이디 찾기</h4>
          <button type="button" class="close idFindClose" data-dismiss="modal">&times;</button>
        </div>
        
        <!-- Modal body -->
        <div class="modal-body">
          <div id="idFind">
             <iframe id="iframe_idFind" style="border: none; width: 100%; height: 350px;" src="<%= ctx_Path%>/login/idFind.up"> 
             </iframe>
          </div>
        </div>
        
        <!-- Modal footer -->
        <div class="modal-footer">
          <button type="button" class="btn btn-danger idFindClose" data-dismiss="modal">Close</button>
        </div>
      </div>
      
    </div>
  </div>
<%-- ****** 아이디 찾기 Modal 끝 ****** --%>
  
  
<%-- ****** 비밀번호 찾기 Modal 시작 ****** --%>
  <div class="modal fade" id="passwdFind"> <%-- 만약에 모달이 안보이거나 뒤로 가버릴 경우에는 모달의 class 에서 fade 를 뺀 class="modal" 로 하고서 해당 모달의 css 에서 zindex 값을 1050; 으로 주면 된다. --%>
    <div class="modal-dialog">
      <div class="modal-content">
      
        <!-- Modal header -->
        <div class="modal-header">
          <h4 class="modal-title">비밀번호 찾기</h4>
          <button type="button" class="close passwdFindClose" data-dismiss="modal">&times;</button>
        </div>
        
        <!-- Modal body -->
        <div class="modal-body">
          <div id="pwFind">
             <%-- <iframe style="border: none; width: 100%; height: 350px;" src="<%= ctx_Path%>/login/pwdFind.up">  
             </iframe> --%>
          </div>
        </div>
        
        <!-- Modal footer -->
        <div class="modal-footer">
          <button type="button" class="btn btn-danger passwdFindClose" data-dismiss="modal">Close</button>
        </div>
      </div>
      
    </div>
  </div> 
<%-- ****** 비밀번호 찾기 Modal 끝 ****** --%>
</c:if>

	
	
<%------------ 로그인을 한 이후에 보여주는 form 태그 생성하기 시작 ------------%>
<c:if test="${not empty sessionScope.loginUser}">
	<table style="width: 95%; height: 130px; margin: 0 auto;">
       <tr style="background-color: #f2f2f2;">
           <td style="text-align: center; padding: 20px;">
               <span style="color: blue; font-weight: bold;">${sessionScope.loginUser.name}</span> 
               [<span style="color: red; font-weight: bold;">${sessionScope.loginUser.userid}</span>]님
               <br><br>
               <div style="text-align: left; line-height: 150%; padding-left: 20px;">
                  <span style="font-weight: bold;">코인액&nbsp;:</span>
                  &nbsp;&nbsp;<fmt:formatNumber value="${sessionScope.loginUser.coin}" pattern="###,###"/>&nbsp;원
                  <br>
                  <span style="font-weight: bold;">포인트&nbsp;:</span>
                  &nbsp;&nbsp;<fmt:formatNumber value="${sessionScope.loginUser.point}" pattern="###,###"/>&nbsp;POINT  
               </div>
               <br>로그인 중...<br><br>
               [<a href="javascript:goEditMyInfo('${(sessionScope.loginUser).userid}', '<%=ctx_Path%>')">내정보수정하기</a>]&nbsp;&nbsp;
               [<a href="javascript:goCoinPurchaseTypeChoice('${(sessionScope.loginUser).userid}', '<%=ctx_Path%>')">코인충전</a>] 
               <br><br>
               										<%-- contextPath는 변경될 수 있으므로 js에서 정의하는 것보단 jsp 파일에서 받아오는 것이 낫다! --%>
               <button type="button" class="btn btn-danger btn-sm" onclick="goLogOut('<%=ctx_Path%>')">로그아웃</button>
           </td>
       </tr>
   </table>   
</c:if>
<%------------ 로그인을 한 이후에 보여주는 form 태그 생성하기 끝 ------------%>





