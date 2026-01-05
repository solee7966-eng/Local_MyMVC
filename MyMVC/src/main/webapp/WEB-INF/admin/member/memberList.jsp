<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<jsp:include page="../../header2.jsp"/>

<style type="text/css">
   table#memberTbl {
      width: 80%;
      margin: 0 auto;
   }
   
   table#memberTbl th {
      text-align: center;
      font-size: 14pt;
   }
   
   table#memberTbl tr.memberInfo:hover {
      background-color: #e6ffe6;
      cursor: pointer;
   }
   
   form[name="member_search_frm"] {
      border: solid 0px red;
      width: 80%;
      margin: 0 auto 3% auto;
   }
   
   form[name="member_search_frm"] button.btn-secondary {
      margin-left: 2%;
      margin-right: 32%;
   }
   
   div#pageBar {
      border: solid 0px red;
      width: 80%;
      margin: 3% auto 0 auto;
      display: flex;
   }
   
   div#pageBar > nav {
      margin: auto;
   }
</style>

<script type="text/javascript">
	$(function(){
		//엔터를 눌렀을 때 이벤트 적용해주기
		$("input:text[name='searchWord']").keydown(e => {
			if(e.keyCode == 13) {
				goSearch();
			}
		});
		
		
		//검색대상과 검색단어가 ""(빈문자열)이 아닌 경우라면 입력받은 값을 해당태그에 다시 넣어준다
		if("${searchType}" != "" &&
		   "${searchWord}" != "") {
			$("select[name='searchType']").val("${searchType}");
			$("input:text[name='searchWord']").val("${searchWord}");
		}
		
		
		//sizePerPage 또한 입력받은 값을 해당태그에 다시 넣어준다
		$("select[name='sizePerPage']").val("${sizePerPage}");
		
		
		// **** select 태그에 대한 이벤트는 click 이 아니라 change 이다. **** // 
		$("select[name='sizePerPage']").change(() => {
			const frm = document.member_search_frm
			frm.method = "get"; 
			frm.submit();
		})
		
		
		// **** 특정 회원을 클릭하면 그 회원의 상세정보를 보여주도록 한다. **** //
		$("table#memberTbl tr.memberInfo").click(e => {
			//alert($(e.target).parent().html());
			//const userid = $(e.target).parent().find(".userid").text();
			//--- 또는
			const userid = $(e.target).parent().children(".userid").text();
			//alert(userid);
			
			const frm = document.memberOneDetailFrm;
			frm.userid.value = userid; 
			<%-- frm.action = <%=ctxPath%>; --%>
			frm.action =  "${pageContext.request.contextPath}/admin/member/memberOneDetail.up";
			frm.method = "post";
			frm.submit();
		<%--  .jsp 파일에서 사용되어지는 것들 
	        console.log('${pageContext.request.contextPath}');  // 컨텍스트패스   /MyMVC
	        console.log('${pageContext.request.requestURL}');   // 전체 URL     http://localhost:9090/MyMVC/WEB-INF/member/admin/memberList.jsp
	        console.log('${pageContext.request.scheme}');       // http        http
	        console.log('${pageContext.request.serverName}');   // localhost   localhost
	        console.log('${pageContext.request.serverPort}');   // 포트번호      9090
	        console.log('${pageContext.request.requestURI}');   // 요청 URI     /MyMVC/WEB-INF/member/admin/memberList.jsp 
	        console.log('${pageContext.request.servletPath}');  // 파일명       /WEB-INF/member/admin/memberList.jsp 
	    --%>
		})
		
		
	});//end of $(function()-----
			
			
//Function Decalaration
	//======= 검색하기 함수 =======
	function goSearch(){
		const searchType = $("select[name='searchType']").val();

		/* if(searchType == "") {
			alert("검색 대상을 선택하세요.");
			return; //goSearch() 함수 종료
		} */
		
		const searchWord = $("input:text[name='searchWord']").val().trim();
		if(searchType != "" && searchWord == "") {
			alert("검색어를 입력하세요.")
			return;
		}
		
		const frm = document.member_search_frm
		//frm.action = "memberList.up";  // form 태그에 action 이 명기되지 않았으면 현재보이는 URL 경로로 submit 되어진다. 
		frm.method = "get";  // form 태그에 method 를 명기하지 않으면 "get" 방식이다. 
		frm.submit();
	}//end of goSearch()-----
</script>



<div class="container" style="padding: 3% 0;">
   <h2 class="text-center mb-5">::: 회원전체 목록 :::</h2>
   
   <form name="member_search_frm">
      <select name="searchType">
         <option value="">검색대상</option>
         <option value="name">회원명</option>
         <option value="userid">아이디</option>
         <option value="email">이메일</option>
      </select>
      &nbsp;
      <input type="text" name="searchWord" />
<%--	!!!!!!!!!! 매우 중요 !!!!!!!!!
       form 태그내에서 데이터를 전송해야 할 input 태그가 만약에 1개 밖에 없을 경우에는
       input 태그내에 값을 넣고나서 그냥 엔터를 해버리면 submit 되어져 버린다.
       그래서 유효성 검사를 거친후 submit 을 하고 싶어도 input 태그가 만약에 1개 밖에 없을 경우라면 
       유효성검사가 있더라도 유효성검사를 거치지 않고 바로 submit 되어진다. 
       이것을 막으려면 input 태그가 2개 이상 존재하면 된다.  
       그런데 실제 화면에 보여질 input 태그는 1개 이어야 한다.
       이럴 경우 아래와 같이 해주면 된다. 
       또한 form 태그에 action 이 명기되지 않았으면 현재보이는 URL 경로로 submit 되어진다.   
--%>
	<!-- 위 내용에 기반하여 input 태그가 하나만 있을 때 엔터키 적용되는 것을 막기 위해
		 아래의 input 태그를 하나 더 생성하여 idsplay를 none으로 설정해 최종적으로 input 태그를 두 개 사용하기 -->
	  <input type="text" style="display: none;" /> <%-- 조심할 것은 type="hidden" 이 아니다. --%> 
      
      <button type="button" class="btn btn-secondary" onclick="goSearch()">검색</button>
      
      <span style="font-size: 12pt; font-weight: bold; margin-right: 5px">페이지당 회원수</span>
      <select name="sizePerPage">
         <option value="10">10명</option>
         <option value="5">5명</option>
         <option value="3">3명</option>
      </select>
   </form>


   <table class="table table-bordered" id="memberTbl">
       <thead>
           <tr>
              <th>번호</th>
              <th>아이디</th>
              <th>회원명</th>
              <th>이메일</th>
              <th>성별</th>
           </tr>
       </thead>
       
       <tbody>
       	  <c:if test="${not empty requestScope.memberList}">
			 <c:forEach items="${memberList}" var="memberDto" varStatus="status">
			     <tr class="memberInfo">
			     <%-- >>> 페이징 처리시 보여주는 순번 공식 <<<
                     데이터개수 - (페이지번호 - 1) * 1페이지당보여줄개수 - 인덱스번호 => 순번 
                  
                     <예제>
                     데이터개수 : 12
                     1페이지당보여줄개수 : 5
                  
                     ==> 1 페이지       
                     12 - (1-1) * 5 - 0  => 12
                     12 - (1-1) * 5 - 1  => 11
                     12 - (1-1) * 5 - 2  => 10
                     12 - (1-1) * 5 - 3  =>  9
                     12 - (1-1) * 5 - 4  =>  8
                  
                     ==> 2 페이지
                     12 - (2-1) * 5 - 0  =>  7
                     12 - (2-1) * 5 - 1  =>  6
                     12 - (2-1) * 5 - 2  =>  5
                     12 - (2-1) * 5 - 3  =>  4
                     12 - (2-1) * 5 - 4  =>  3
                  
                     ==> 3 페이지
                     12 - (3-1) * 5 - 0  =>  2
                     12 - (3-1) * 5 - 1  =>  1 	--%>
                     
                    <!-- 값을 받아올 때 String 형식이었으므로 fmt:parseNumber를 이용해 숫자타입으로 바꿔주기 -->
                    <fmt:parseNumber value="${currentShowPageNo}" var="currentShowPageNo"/>
                    <fmt:parseNumber value="${sizePerPage}" var="sizePerPage"/>
                    
			        <td>${(requestScope.totalMemberCount) - (currentShowPageNo-1) * sizePerPage - status.index}</td>
			        <td class="userid">${memberDto.userid}</td>
			        <td>${memberDto.name}</td>
			        <td>${memberDto.email}</td>
			        <td>
			           <c:choose>
					      <c:when test="${memberDto.gender == '1'}">남성</c:when>
					      <c:otherwise>여성</c:otherwise>
			           </c:choose>
			        </td>
			     </tr>
			 </c:forEach>
       	  </c:if>
       
       
       	  <c:if test="${empty requestScope.memberList}">
       	  	<tr>
       	  		<td colspan="5">데이터가 존재하지 않습니다.</td>
       	  	</tr>
       	  </c:if>
       </tbody>
   </table>
   
   <div id="pageBar">
      <nav>
        <ul class="pagination">${pageBar}</ul>
      </nav>
   </div>
   
</div>



<form name="memberOneDetailFrm">
	<input type="hidden" name="userid"/>
</form>




<jsp:include page="../../footer2.jsp"/>