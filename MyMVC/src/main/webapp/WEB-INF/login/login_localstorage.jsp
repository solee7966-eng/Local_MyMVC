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
    	  /*   !!!!!! 필수로 기억해야 합니다. !!!!!!
          >>>> 로컬 스토리지(localStorage)와 세션 스토리지(sessionStorage) <<<< 
          로컬 스토리지와 세션 스토리지는 HTML5에서 추가된 저장소이다.
          간단한 키와 값을 저장할 수 있다. 키-밸류 스토리지의 형태이다.
        
        ※ 로컬 스토리지와 세션 스토리지의 차이점은 데이터의 영구성이다. 
           로컬 스토리지의 데이터는 사용자가 지우지 않는 이상 계속 브라우저에 남아 있게 된다. 
           만료 기간을 설정할 수 없다.
           하지만 세션 스토리지의 데이터는 윈도우나 브라우저 탭을 닫을 경우 자동적으로 제거된다.
           지속적으로 필요한 데이터(자동 로그인 등)는 로컬 스토리지에 저장하고, 
           잠깐 동안 필요한 정보(일회성 로그인 정보라든가)는 세션 스토리지에 저장하도록 한다. 
           그러나 비밀번호같은 중요한 정보는 절대로 저장하면 안된다.
           왜냐하면 클라이언트 컴퓨터 브라우저에 저장하는 것이기 때문에 타인에 의해 도용당할 수 있기 때문이다.

           로컬 스토리지랑 세션 스토리지가 나오기 이전에도 브라우저에 저장소 역할을 하는 게 있었다.
           바로 쿠키인데 쿠키는 만료 기한이 있는 키-값 저장소이다.

           쿠키는 4kb 용량 제한이 있고, 매번 서버 요청마다 서버로 쿠키가 같이 전송된다.
           만약 4kb 용량 제한을 거의 다 채운 쿠키가 있다면, 요청을 할 때마다 기본 4kb의 데이터를 사용한다. 
           4kb 중에는 서버에 필요하지 않은 데이터들도 있을 수 있다. 
           그러므로 데이터 낭비가 발생할 수 있게 된다. 
           바로 그런 데이터들을 이제 로컬 스토리지와 세션 스토리지에 저장할 수 있다. 
           이 두 저장소의 데이터는 서버로 자동 전송되지 않는다.

       >> 로컬 스토리지(localStorage) <<
          로컬 스토리지는 window.localStorage에 위치한다. 
          키 밸류 저장소이기 때문에 키와 밸류를 순서대로 저장하면 된다. 
          값으로는 문자열, boolean, 숫자, null, undefined 등을 저장할 수 있지만, 
          모두 문자열로 변환된다. 키도 문자열로 변환된다.

          localStorage.setItem('name', '이순신');
          localStorage.setItem('birth', 1994);

          localStorage.getItem('name');        // 이순신
          localStorage.getItem('birth');       // 1994 (문자열)

          localStorage.removeItem('birth');    // birth 삭제
          localStorage.getItem('birth');       // null (삭제됨)

          localStorage.clear();                // 전체 삭제

          localStorage.setItem(키, 값)으로 로컬스토리지에 저장함.
          localStorage.getItem(키)로 조회함. 
          localStorage.removeItem(키)하면 해당 키가 지워지고, 
          localStorage.clear()하면 스토리지 전체가 비워진다.

          localStorage.setItem('object', { userid : 'leess', name : '이순신' });
          localStorage.getItem('object');   // [object Object]
             객체는 제대로 저장되지 않고 toString 메소드가 호출된 형태로 저장된다. 
             [object 생성자]형으로 저장되는 것이다. 
             객체를 저장하려면 두 가지 방법이 있다. 
             그냥 키-값 형식으로 풀어서 여러 개를 저장할 수도 있다. 
             한 번에 한 객체를 통째로 저장하려면 JSON.stringify를 해야된다. 
             객체 형식 그대로 문자열로 변환하는 것이다. 받을 때는 JSON.parse하면 된다.

          localStorage.setItem('object', JSON.stringify({ userid : 'leess', name : '이순신' }));
          JSON.parse(localStorage.getItem('object')); // { userid : 'leess', name : '이순신' }
         
             이와같이 데이터를 지우기 전까지는 계속 저장되어 있기 때문에 
             사용자의 설정(보안에 민감하지 않은)이나 데이터들을 넣어두면 된다.  

       >> 세션 스토리지(sessionStorage) <<
           세션 스토리지는 window.sessionStorage에 위치한다. 
           clear, getItem, setItem, removeItem, key 등 
           모든 메소드가 로컬 스토리지(localStorage)와 같다. 
           단지 로컬스토리지와는 다르게 데이터가 영구적으로 보관되지는 않을 뿐이다. 
                
       >> 로컬 스토리지(localStorage)와 세션 스토리지(sessionStorage) 에 저장된 데이터를 보는 방법 << 
           크롬인 경우 F12(개발자도구) Application 탭에 가면 Storage - LocalStorage 와 SessionStorage 가 보여진다.
           거기에 들어가서 보면 Key 와 Value 값이 보여진다.
     */     
/*      	$("button#temp").click(()=> {
     		localStorage.setItem('name1', "안태훈");
    		localStorage.setItem('birth1', 2000);
    		const name1 = localStorage.getItem("name1");
    		const birth1 = localStorage.getItem("birth1");
    		console.log("name1: ", name1);
    		console.log("birth1: ", birth1);
    		const person = {"id": "leess"
    					   ,"passwd":"qwer1234"
    					   ,"name":"이순신"
    					   ,"addr":"서울시 강남구"};
    		localStorage.setItem('person', JSON.stringify(person)); //JSON.stringify => 객체(object)를 문자열로 바꿔주는 것!! 
    		const person_val = JSON.parse(localStorage.getItem("person")); //JSON.parse => 바뀐 문자열을 다시 객체로 변환해주는 것!!
    		console.log("person_val: " , person_val)
    		console.log("person_val.name: " , person_val.name)
    		//localStorage.removeItem('birth1');    // birth 삭제
    		localStorage.clear();                // 전체 삭제
    	// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ //
    		sessionStorage.setItem('name2', "엄정화"); // 엄정화
    		sessionStorage.setItem('birth2', 1968);  // 1968(문자열)
    		const name2 = sessionStorage.getItem("name2");
    		const birth2 = sessionStorage.getItem("birth2");
    		console.log("name2: ", name2);
    		console.log("birth2: ", birth2);
    		//sessionStorage.removeItem('birth2');    // birth 삭제
    		sessionStorage.clear();                // 전체 삭제
     	}); */
     	
     	// === 로그인을 하지 않은 상태일 때 
        //     로컬스토리지(localStorage)에 저장된 key가 'saveid' 인 userid 값을 불러와서 
        //     input 태그 userid 에 넣어주기 ===
	$(function() {      
        if(${empty sessionScope.loginUser}) {
        	const loginUserid = localStorage.getItem("saveid");
        	if(loginUserid != null) {
        		$("input#loginUserid").val(loginUserid);
        		$("input:checkbox[id='saveid']").prop("checked", true);
        	}
        }
        
        
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
        
        
	});//end of $(function(){})----- 
	

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
          	  <tr>
          	     <td>ID</td>
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
                  	 <%-- "아이디저장" 체크박스에 localStorage만 이용하는 경우 --%>
                     <input type="checkbox" id="saveid"/>&nbsp;<label for="saveid">아이디저장</label>
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
        <%-- Modal은 이미 있지만 감춰져있는 것! --%>
        <div class="modal-body">
          <div id="pwFind">
             <iframe style="border: none; width: 100%; height: 350px;" src="<%= ctx_Path%>/login/pwdFind.up">  
             </iframe>
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





