<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%String ctxPath = request.getContextPath();//=> /MyMVC %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<title>:::HOMEPAGE:::</title> 

<!-- Required meta tags -->
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

<!-- Bootstrap CSS -->
<link rel="stylesheet" type="text/css" href="<%= ctxPath%>/bootstrap-4.6.2-dist/css/bootstrap.min.css"> 

<!-- Font Awesome 6 Icons -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.1/css/all.min.css">

<!-- 직접 만든 CSS -->
<link rel="stylesheet" type="text/css" href="<%= ctxPath%>/css/template/template.css"/>

<!-- Optional JavaScript -->
<script type="text/javascript" src="<%= ctxPath%>/js/jquery-3.7.1.min.js"></script>
<script type="text/javascript" src="<%= ctxPath%>/bootstrap-4.6.2-dist/js/bootstrap.bundle.min.js" ></script>

<%-- jQueryUI CSS 및 JS --%>
<link rel="stylesheet" type="text/css" href="<%= ctxPath%>/jquery-ui-1.13.1.custom/jquery-ui.min.css" />
<script type="text/javascript" src="<%= ctxPath%>/jquery-ui-1.13.1.custom/jquery-ui.min.js"></script>

<!-- 직접 만든 JS -->
<script type="text/javascript" src="<%= ctxPath%>/js/template/template.js"></script>


</head>
<body>

<!-- 상단 네비게이션 시작 -->
<nav class="navbar navbar-expand-lg navbar-light bg-light fixed-top mx-4 py-3">
   
   <!-- Brand/logo --> <!-- Font Awesome 6 Icons -->
	<a class="navbar-brand" href="<%= ctxPath %>/index.up" style="margin-right: 10%;"><img src="<%= ctxPath %>/images/sist_logo.png" /></a>
	
	<!-- 아코디언 같은 Navigation Bar 만들기 -->
	<button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#collapsibleNavbar">
	<span class="navbar-toggler-icon"></span>
	</button>

	<div class="collapse navbar-collapse" id="collapsibleNavbar">
		<ul class="navbar-nav" style="font-size: 16pt;">
			<li class="nav-item active">
				<a class="nav-link menufont_size" href="<%=ctxPath%>/index.up">Home</a>
			</li>
			<li class="nav-item active">
				<a class="nav-link menufont_size" href="<%=ctxPath%>/member/memberRegister.up">회원가입</a>
			 </li>
			<li class="nav-item">
				<a class="nav-link menufont_size" href="<%=ctxPath%>/shop/mallHomeMore.up">쇼밍몰홈[더보기]</a>
			</li>
			<li class="nav-item">
				<a class="nav-link menufont_size" href="<%=ctxPath%>/shop/mallHomeScroll.up">쇼밍몰홈[스크롤]</a>
			</li>
			<li class="nav-item dropdown">
              <a class="nav-link dropdown-toggle menufont_size text-info" href="#" id="navbarDropdown" data-toggle="dropdown"> 
                 매장찾기                                  <%-- .text-info 는 글자색으로 청록색임 --%>  
              </a>
              <div class="dropdown-menu" aria-labelledby="navbarDropdown">
                 <a class="dropdown-item text-info" href="<%= ctxPath %>/shop/storeLocation1.up">매장찾기1</a>
                 <a class="dropdown-item text-info" href="<%= ctxPath %>/shop/storeLocation2.up">매장찾기2</a>
                 <div class="dropdown-divider"></div>
                 <a class="dropdown-item text-info" href="<%= ctxPath %>/shop/latLngSearch.up">위.경도 찾기</a>
              </div>
          	</li>
			
			
			<!-- admin이 아닌 일반 사용자로 로그인한 경우에만 뜨도록 하기 -->
			<!-- 추가로 경로로 인해 관리자 페이지에 접속할 수도 있으므로 이에 대한 코딩작업도 해주어야 함! -->
			<c:if test="${not empty sessionScope.loginUser && sessionScope.loginUser.userid != 'admin'}">
				<li class="nav-item dropdown">
					<a class="nav-link dropdown-toggle menufont_size text-info" href="#" id="navbarDropdown" data-toggle="dropdown">
						장바구니/주문
					</a>
					<div class="dropdown-menu" aria-labelledby="navbarDropdown">
						<a class="dropdown-item text-info" href="<%=ctxPath%>/shop/cartList.up">장바구니</a>
						<a class="dropdown-item text-info" href="<%=ctxPath%>/shop/orderList.up">나의주문내역</a>
					<div class="dropdown-divider"></div>
						<a class="dropdown-item text-info" href="<%=ctxPath%>/shop/chart.up">주문통계차트보기</a>
					</div>
				</li>
			</c:if>
			
			
			
			<!-- admin으로 로그인한 경우에만 뜨도록 하기 -->
			<!-- 추가로 경로로 인해 관리자 페이지에 접속할 수도 있으므로 이에 대한 코딩작업도 해주어야 함! -->
			<c:if test="${not empty sessionScope.loginUser && sessionScope.loginUser.userid == 'admin'}">
				<li class="nav-item dropdown">
					<a class="nav-link dropdown-toggle menufont_size text-primary" href="#" id="navbarDropdown" data-toggle="dropdown">
						관리자전용
					</a>
					<div class="dropdown-menu" aria-labelledby="navbarDropdown">
						<a class="dropdown-item text-primary" href="<%=ctxPath%>/admin/member/memberList.up">회원목록</a>
						<a class="dropdown-item text-primary" href="<%=ctxPath%>/admin/shop/productRegister.up">제품등록</a>
					<div class="dropdown-divider"></div>
						<a class="dropdown-item text-primary" href="<%=ctxPath%>/shop/orderList.up">전체주문내역</a>
					</div>
				</li>
			</c:if>
			
			
			
			
		</ul>
	</div>
</nav>
<!-- 상단 네비게이션 끝 -->

<hr style="background-color: gold; height: 1.2px; position: relative; top:85px; margin: 0 1.7%;"> 

<div class="container-fluid" id="container" style="position: relative; top:90px; padding: 0.1% 2.5%;">
	<div class="row">
		<div class="col-md-3" id="sideinfo">
			<%-- 유트브 넣기 header1.jsp 에만 있음 --%>
	        <div class="row">
	          <div class="col-md-10 offset-md-1 mt-3 embed-responsive embed-responsive-16by9">
	               <iframe class="embed-responsive-item" src="https://www.youtube.com/embed/pSUydWEqKwE" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe> 
	          </div>
	        </div>
		
			<div style="height: 200px; text-align: left; padding: 20px;">
				<%-- 로그인 처리하기 --%>
				<%--<%@include file="/WEB-INF/login/login_cookie.jsp" %>--%>
				<%@include file="/WEB-INF/login/login_localstorage.jsp" %>
				
				<%-- == 쇼핑몰 카테고리목록만을 보여주는 부분 (header1.jsp 에만 있음) == --%>
	            <div id="categoryList" style="margin-top: 100px;">
	            
	         	</div> 
			</div>
		<div id="sidecontent" style="text-align: left; padding: 20px;"></div>
		</div>
		
	<div class="col-md-9" id="maininfo" align="center">
		<div id="maincontent">



