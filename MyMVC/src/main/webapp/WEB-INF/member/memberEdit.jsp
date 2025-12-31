<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%String ctxPath = request.getContextPath();%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>내 정보 수정하기</title>

<%-- Required meta tags --%>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

<%-- Bootstrap CSS --%>
<link rel="stylesheet" type="text/css" href="<%= ctxPath%>/bootstrap-4.6.2-dist/css/bootstrap.min.css" > 

<%-- 직접 만든 CSS --%>
<link rel="stylesheet" type="text/css" href="<%= ctxPath%>/css/member/memberEdit.css" />

<%-- Optional JavaScript --%>
<script type="text/javascript" src="<%= ctxPath%>/js/jquery-3.7.1.min.js"></script>
<script type="text/javascript" src="<%= ctxPath%>/bootstrap-4.6.2-dist/js/bootstrap.bundle.min.js" ></script>

<%-- 우편번호 검색 JS(daum) --%>
<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

<%-- 직접 만든 JS --%>
<script type="text/javascript" src="<%= ctxPath%>/js/member/memberEdit.js"></script>
</head>

<body>
	<div class="row" id="divEditFrm">
	   <div class="col-md-12">
	      <form name="editFrm">
	         <table id="tblMemberEdit">
	             <thead>
	                <tr>
	                   <th colspan="2">::: 회원수정 <span style="font-size: 10pt; font-style: italic;">(<span class="star">*</span>표시는 필수입력사항)</span> :::</th>
	                </tr>
	             </thead>
	             
	             <tbody>
	                <tr>
	                    <td colspan="2" style="line-height: 50%;">&nbsp;</td>
	                </tr>
	                
	                <tr> <!-- 성명입력란 -->
	                    <td>성명&nbsp;<span class="star">*</span></td>
	                    <td>
						   <input type="hidden" name="userid" value="${sessionScope.loginUser.userid}"/>
	                       <input type="text" name="name" id="name" maxlength="30" class="requiredInfo" value="${sessionScope.loginUser.name}"/>
	                       <span class="error">성명은 필수입력 사항입니다.</span>
	                    </td>
	                </tr>
	                
	                <tr> <!-- 비밀번호 입력란 -->
	                    <td>비밀번호&nbsp;<span class="star">*</span></td>
	                    <td>
	                       <input type="password" name="pwd" id="pwd" maxlength="15" class="requiredInfo" />
	                       <span class="error">암호는 영문자,숫자,특수기호가 혼합된 8~15 글자로 입력하세요.</span>
	                       <!-- 중복검사(이전에 입력한 비밀번호와 달라야 함! -->
	                       <span id="duplicate_Pwd" style="color: red;"></span>
	                    </td>
	                </tr>
	                
	                <tr>
	                    <td>비밀번호확인&nbsp;<span class="star">*</span></td>
	                    <td>
	                       <input type="password" id="pwdcheck" maxlength="15" class="requiredInfo" />
	                       <span class="error">암호가 일치하지 않습니다.</span>
	                    </td>
	                </tr>
	                
	                <tr> <!-- 이메일 입력란 -->
	                    <td>이메일&nbsp;<span class="star">*</span></td>
	                    <td>
	                       <input type="text" name="email" id="email" maxlength="60" class="requiredInfo" value="${sessionScope.loginUser.email}"/>
	                       <span class="error">이메일 형식에 맞지 않습니다.</span>
	                       
	                       <%-- 이메일중복체크 --%>
	                       <span id="emailcheck">이메일중복확인</span>
	                       
	                       <span id="emailCheckResult"></span>
	                    </td>
	                </tr>
	                
	                <tr> <!-- 연락처 입력란 -->
	                    <td>연락처&nbsp;</td>
	                    <td>
	                       <input type="text" name="hp1" id="hp1" size="6" maxlength="3" value="010" readonly />&nbsp;-&nbsp; 
	                       <input type="text" name="hp2" id="hp2" size="6" maxlength="4" 
	                       		 value="${fn:substring(sessionScope.loginUser.mobile, 3, 7)}" />&nbsp;-&nbsp;
	                       <input type="text" name="hp3" id="hp3" size="6" maxlength="4"
	                       	     value="${fn:substring(sessionScope.loginUser.mobile, 7, 11)}"/>
	                       	     
	                       <span class="error">휴대폰 형식이 아닙니다.</span>
	                    </td>
	                </tr>
	                
	                <tr> <!-- 우편번호 입력란 -->
	                    <td>우편번호</td>
	                    <td>
	                       <input type="text" name="postcode" id="postcode" size="6" maxlength="5" value="${sessionScope.loginUser.postcode}"/>&nbsp;&nbsp;
	                       <%-- 우편번호 찾기 --%>
	                       <img src="<%= ctxPath%>/images/b_zipcode.gif" id="zipcodeSearch" />
	                       <span class="error">우편번호 형식에 맞지 않습니다.</span>
	                    </td>
	                </tr>
	                
	                <tr> <!-- 주소 입력란 -->
	                    <td>주소</td>
	                    <td>
	                       <input type="text" name="address" id="address" size="40" maxlength="200" placeholder="주소" value="${sessionScope.loginUser.address}"/><br>
	                       <input type="text" name="detailaddress" id="detailAddress" size="40" maxlength="200" placeholder="상세주소" value="${sessionScope.loginUser.detailaddress}"/>&nbsp;
	                       <input type="text" name="extraaddress" id="extraAddress" size="40" maxlength="200" placeholder="참고항목" value="${sessionScope.loginUser.extraaddress}"/>            
	                       <span class="error">주소를 입력하세요.</span>
	                    </td>
	                </tr>
	                
	                <tr>
	                    <td colspan="2" class="text-center">
	                       <input type="button" class="btn btn-success btn-lg mr-5" value="확인" onclick="goEdit()" />
	                       <input type="reset"  class="btn btn-danger btn-lg" value="취소" onclick="self.close()" />
	                    </td>
	                </tr>
	                 
	             </tbody>
	          </table>   
	      </form>
	   </div>
	</div>
</body>












