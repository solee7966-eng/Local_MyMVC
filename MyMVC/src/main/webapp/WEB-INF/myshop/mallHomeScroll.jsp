<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<jsp:include page="../header1.jsp"/>

<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/myshop/mallHomeMore.css" /> 
<script type="text/javascript" src="${pageContext.request.contextPath}/js/myshop/mallHomeScroll.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/myshop/categoryList.js"></script>

<%-- === HIT 상품을 모두 가져와서 디스플레이(스크롤 방식으로 페이징 처리한 것) === --%>
<div>
      <p class="h3 my-3 text-center">- HIT 상품(스크롤) -</p>
      
      <div class="row" id="displayHIT" style="text-align: left;"></div>
      
      <div>
         <p class="text-center">
           <span id="end" style="display:block; margin:20px; font-size: 14pt; font-weight: bold; color: red;"></span>
           <span id="totalHITCount">${requestScope.totalHITCount}</span>
           <span id="countHIT">0</span>
         </p>
      </div>
      
      <div style="display: flex;">
         <div style="margin: 20px 0 20px auto;">
            <button class="btn btn-info" onclick="goTop()">맨위로가기(scrollTop 1로 설정함)</button>
         </div>
      </div>
      
</div>


<jsp:include page="../footer1.jsp"/>
