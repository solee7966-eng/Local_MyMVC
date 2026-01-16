<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
	String ctxPath = request.getContextPath();
    //     /MyMVC     
%>

<jsp:include page="../header1.jsp" />

<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script> 

<%-- 
 <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=발급받은 APP KEY(JavaScript 키)를 넣으시면 됩니다.&​libraries=services"></script> 
--%> 
 <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=a9a762e8fc2d3a4b1d49c07e1623cb53"></script> 
 
 <script type="text/javascript">
   $(document).ready(function(){
	   
	// === "주소찾기" 버튼을 클릭했을 때 이벤트 처리하기 === //
		$("button#btn_address_search").click(function(){
			
			new daum.Postcode({
	            oncomplete: function(data) {
	                // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

	                // 각 주소의 노출 규칙에 따라 주소를 조합한다.
	                // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
	                let addr = ''; // 주소 변수
	                let extraAddr = ''; // 참고항목 변수

	                //사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
	                if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
	                    addr = data.roadAddress;
	                } else { // 사용자가 지번 주소를 선택했을 경우(J)
	                    addr = data.jibunAddress;
	                }

	                // 사용자가 선택한 주소가 도로명 타입일때 참고항목을 조합한다.
	                if(data.userSelectedType === 'R'){
	                    // 법정동명이 있을 경우 추가한다. (법정리는 제외)
	                    // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
	                    if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
	                        extraAddr += data.bname;
	                    }
	                    // 건물명이 있고, 공동주택일 경우 추가한다.
	                    if(data.buildingName !== '' && data.apartment === 'Y'){
	                        extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
	                    }
	                    // 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
	                    if(extraAddr !== ''){
	                        extraAddr = ' (' + extraAddr + ')';
	                    }
	                    // 조합된 참고항목을 해당 필드에 넣는다.
	                    document.getElementById("extraAddress").value = extraAddr;
	                
	                } else {
	                    document.getElementById("extraAddress").value = '';
	                }

	                // 주소 정보를 해당 필드에 넣는다.
	                document.getElementById("address").value = addr;
	                
	                // 커서를 상세주소 필드로 이동한다.
	                document.getElementById("detailAddress").focus();
	            }
	        }).open();
	        
	        // 주소를 읽기전용(readonly) 로 만들기
	        $("input#address").attr("readonly", true);
	        
	        // 참고항목을 읽기전용(readonly) 로 만들기
	        $("input#extraAddress").attr("readonly", true);
	        
		});// end of $("button#btn_address_search").click(function(){})---------------
	   
	   ////////////////////////////////////////////////////////////////////////////////
	   
	   $("div.result").hide();
	   
	   $("button#btn_latlng_search").click(function(){
		   func_geocoder($("input#address").val());
	   });   
		  
	   $("input#address").bind("keyup", function(e){
		  if(e.keyCode == 13) {
			  func_geocoder($(e.target).val()); 
		  }
		  
		  if($(e.target).val() == "") {
			  $("div.result").hide();
		  }
		  
	   });
	   
	   $("button#btn_init").click(function(){
		   $("input#address").val("");
		   $("input#detailAddress").val("");
		   $("input#extraAddress").val("");
		   $("div.result").hide();
	   });
	   
   });// end of $(document).ready(function(){})----------------------
   
   
   function func_geocoder(address) {
	   
	   var geocoder = new kakao.maps.services.Geocoder();
	   // 주소-좌표 변환 객체를 생성한다

	   geocoder.addressSearch(address, function(result, status) {

		   if (status === kakao.maps.services.Status.OK) {
			    // 주소가 정상적으로 검색이 완료됐으면
		    	$("span#lat").text(result[0].y); // result[0].y ==> 위도
		    	$("span#lng").text(result[0].x); // result[0].x ==> 경도
		    	
		    	$("div.result").show();
		   } 
		});
	   
   }// end of function func_geocoder(address){}-----------------------

</script>
	
<div class="container">

    <div class="my-5">
        <p><button type="button" id="btn_address_search" class="btn btn-primary">주소찾기</button></p>
        <p><input type="text" name="address" id="address" size="40" maxlength="200" placeholder="주소" /></p>
        <p><input type="text" name="detailaddress" id="detailAddress" size="40" maxlength="200" placeholder="상세주소" /></p>
        <p><input type="text" name="extraaddress" id="extraAddress" size="40" maxlength="200" placeholder="참고항목" /></p>            
    </div>                

	<div class="my-5">
		<button type="button" id="btn_latlng_search" class="btn btn-success mr-2">위/경도조회</button>
		<button type="button" id="btn_init" class="btn btn-danger">초기화</button>
	</div>

	<div class="h5 result">
		<p>위도 : <span id="lat"></span></p>
		<p>경도 : <span id="lng"></span></p>
	</div>
</div>

<jsp:include page="../footer1.jsp" />    
    