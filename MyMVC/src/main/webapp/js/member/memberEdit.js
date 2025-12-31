
/*
  --- JavaScript --
  window.onload = function(){};
  
  --- jQuery ---
  $(document).ready(function(){});
  $(function(){});
*/

let b_zipcodeSearch_click = false;
// "우편번호찾기" 를 클릭했는지 클릭을 안 했는지 여부를 알아오기 위한 용도


let b_emailcheck_click = false;
// "이메일중복확인" 을 클릭했는지 클릭을 안 했는지 여부를 알아오기 위한 용도

$(function(){
	$('span.error').hide();
	$('input#name').focus();
	$('input#name').blur((e)=>{
		const name = $(e.target).val().trim();
		
		if(name == "") {
		   $('table#tblMemberRegister :input').prop("disabled", true);
		   $(e.target).prop("disabled", false).val("").focus();
		   $(e.target).parent().find('span.error').show();
		} 
		else {
			$('table#tblMemberRegister :input').prop("disabled", false);
		    $(e.target).parent().find('span.error').hide();
		}
	});// end of 아이디가 name 인 것에 포커스를 잃어버렸을 경우(blur) 이벤트 처리를 해주는 것 
	
	
	$('input#pwd').blur((e)=>{
		
		const regExp_pwd = /^.*(?=^.{8,15}$)(?=.*\d)(?=.*[a-zA-Z])(?=.*[^a-zA-Z0-9]).*$/g;
		// 숫자/문자/특수문자 포함 형태의 8~15자리 이내의 암호 정규표현식 객체 생성
		
		const bool = regExp_pwd.test($(e.target).val());
				
		if(!bool) {
		   // 암호가 정규표현식에 위배된 경우
		   
		   $('table#tblMemberRegister :input').prop("disabled", true);
		   $(e.target).prop("disabled", false).val("").focus();
		   
		// $(e.target).next().show();
		// 또는
		   $(e.target).parent().find('span.error').show();
		} 
		else {
			// 암호가 정규표현식에 맞는 경우
			$('table#tblMemberRegister :input').prop("disabled", false);
		  
		 // $(e.target).next().hide();
		 // 또는	  
			$(e.target).parent().find('span.error').hide();
		}
		
	});// end of 아이디가 pwd 인 것에 포커스를 잃어버렸을 경우(blur) 이벤트 처리를 해주는 것
	
	
	$('input#pwdcheck').blur((e)=>{
				
		if( $('input#pwd').val() != $(e.target).val() ) {
		   // 암호와 암호확인 값이 틀린 경우
		   
		   $('table#tblMemberRegister :input').prop("disabled", true);
		   
		   $('input#pwd').prop("disabled", false).val("").focus();
		   $(e.target).prop("disabled", false).val("");
		   
		// $(e.target).next().show();
		// 또는
		   $(e.target).parent().find('span.error').show();
		} 
		else {
			// 암호와 암호확인 값이 같은 경우
			$('table#tblMemberRegister :input').prop("disabled", false);
		  
		 // $(e.target).next().hide();
		 // 또는	  
			$(e.target).parent().find('span.error').hide();
		}
		
	});// end of 아이디가 pwdcheck 인 것에 포커스를 잃어버렸을 경우(blur) 이벤트 처리를 해주는 것	
	
	
	$('input#email').blur((e)=>{
			
		const regExp_email = /^[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,3}$/i;  
		// 이메일 정규표현식 객체 생성
		
		const bool = regExp_email.test($(e.target).val());
				
		if(!bool) {
		   // 이메일이 정규표현식에 위배된 경우
		   
		   $('table#tblMemberRegister :input').prop("disabled", true);
		   $(e.target).prop("disabled", false).val("").focus();
		   
		// $(e.target).next().show();
		// 또는
		   $(e.target).parent().find('span.error').show();
		} 
		else {
			// 이메일이 정규표현식에 맞는 경우
			$('table#tblMemberRegister :input').prop("disabled", false);
		  
		 // $(e.target).next().hide();
		 // 또는	  
			$(e.target).parent().find('span.error').hide();
		}
		
	});// end of 아이디가 email 인 것에 포커스를 잃어버렸을 경우(blur) 이벤트 처리를 해주는 것	
	

	$('input#hp2').blur((e)=>{
				
		const regExp_hp2 = /^[1-9][0-9]{3}$/;  
		// 연락처 국번( 숫자 4자리인데 첫번째 숫자는 1-9 이고 나머지는 0-9) 정규표현식 객체 생성
		
		const bool = regExp_hp2.test($(e.target).val());
				
		if(!bool) {
		   // 연락처 국번이 정규표현식에 위배된 경우
		   
		   $('table#tblMemberRegister :input').prop("disabled", true);
		   $(e.target).prop("disabled", false).val("").focus();
		   
		// $(e.target).next().show();
		// 또는
		   $(e.target).parent().find('span.error').show();
		} 
		else {
			// 연락처 국번이 정규표현식에 맞는 경우
			$('table#tblMemberRegister :input').prop("disabled", false);
		  
		 // $(e.target).next().hide();
		 // 또는	  
			$(e.target).parent().find('span.error').hide();
		}
		
	});// end of 아이디가 hp2 인 것에 포커스를 잃어버렸을 경우(blur) 이벤트 처리를 해주는 것	
	

	$('input#hp3').blur((e)=>{
					
		const regExp_hp3 = /^[0-9]{4}$/;
	//  또는 
	// 	const regExp_hp3 = /^\d{4}$/;
		// 연락처 마지막 4자리(숫자만 되어야 함) 정규표현식 객체 생성
		
		const bool = regExp_hp3.test($(e.target).val());
				
		if(!bool) {
		   // 마지막 전화번호 4자리가 정규표현식에 위배된 경우
		   
		   $('table#tblMemberRegister :input').prop("disabled", true);
		   $(e.target).prop("disabled", false).val("").focus();
		   
		// $(e.target).next().show();
		// 또는
		   $(e.target).parent().find('span.error').show();
		} 
		else {
			// 마지막 전화번호 4자리가 정규표현식에 맞는 경우
			$('table#tblMemberRegister :input').prop("disabled", false);
		  
		 // $(e.target).next().hide();
		 // 또는	  
			$(e.target).parent().find('span.error').hide();
		}
		
	});// end of 아이디가 hp3 인 것에 포커스를 잃어버렸을 경우(blur) 이벤트 처리를 해주는 것	
	
	
	/*	
    >>>> .prop() 와 .attr() 의 차이 <<<<	         
         .prop() ==> form 태그내에 사용되어지는 엘리먼트의 disabled, selected, checked 의 속성값 확인 또는 변경하는 경우에 사용함. 
         .attr() ==> 그 나머지 엘리먼트의 속성값 확인 또는 변경하는 경우에 사용함.
	*/
	// 우편번호를 읽기전용(readonly)로 만들기
	$('input#postcode').attr('readonly', true);
	
	// 주소를 읽기전용(readonly)로 만들기
	$('input#address').attr('readonly', true);
		
	// 참고항목을 읽기전용(readonly)로 만들기
	$('input#extraAddress').attr('readonly', true);
			
	
	// ===== "우편번호찾기"를 클릭했을 때 이벤트 처리하기 시작 ====== //
 /*	
	$('img#zipcodeSearch').bind('click', function(){});
	$('img#zipcodeSearch').click(function(){});
	$('img#zipcodeSearch').click(()=>{});
 */
	$('img#zipcodeSearch').click(()=>{
		b_zipcodeSearch_click = true; // "우편번호찾기"를 클릭했다는 증빙.
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
    
                // 우편번호와 주소 정보를 해당 필드에 넣는다.
                document.getElementById('postcode').value = data.zonecode;
                document.getElementById("address").value = addr;
                // 커서를 상세주소 필드로 이동한다.
                document.getElementById("detailAddress").focus();
            }
        }).open();
		
		// ==== 참고 ==== //
		// 주소를 비활성화로 만들기
	//	$('input#address').prop('disabled', true);
	
	    // 주소를 활성화로 만들기
	//	$('input#address').removeAttr('disabled');
	
	    // 주소를 쓰기가능으로 만들기
	//	$('input#address').removeAttr('readonly');
	
	    // 주소를 읽기전용(readonly)로 만들기
	//	$('input#address').attr('readonly', true);
				
	});
	// ===== "우편번호찾기"를 클릭했을 때 이벤트 처리하기 끝 ====== //

// ======================================================================================== //
	    /*
		// js에선 DAO 파일로 갈 수 없는데 이 때 사용하는 것이 Ajax	
       Ajax (Asynchronous JavaScript and XML)란?
      ==> 이름만 보면 알 수 있듯이 '비동기 방식의 자바스크립트와 XML' 로서
          Asynchronous JavaScript + XML 인 것이다.
          한마디로 말하면, Ajax 란? Client 와 Server 간에 XML 데이터를 JavaScript 를 사용하여 비동기 통신으로 주고 받는 기술이다.
          하지만 요즘에는 데이터 전송을 위한 데이터 포맷방법으로 XML 을 사용하기 보다는 JSON(Javascript Standard Object Notation) 을 더 많이 사용한다. 
          참고로 HTML은 데이터 표현을 위한 포맷방법이다.
          그리고, 비동기식이란 어떤 하나의 웹페이지에서 여러가지 서로 다른 다양한 일처리가 개별적으로 발생한다는 뜻으로서,
          어떤 하나의 웹페이지에서 서버와 통신하는 그 일처리가 발생하는 동안 일처리가 마무리 되기전에 또 다른 작업을 할 수 있다는 의미이다.
	    */
	// === "이메일중복확인" 을 클릭했을 때 이벤트 처리하기 시작 === //
	 $('span#emailcheck').click(function(){
		b_emailcheck_click = true;
		// "이메일중복확인" 을 클릭했는지 클릭을 안 했는지 여부를 알아오기 위한 용도
		
		// 안에 내용물이 있는 경우에만 실행!
		if($("input#email").val().trim() != ""){
			// ==== jQuery Ajax 를 사용한 두번째 방법 ==== //
			//ajax를 이용해 바로 java 파일 즉 .up 경로에 해당하는 파일에 데이터를 보냄
			$.ajax({
				url:"emailDuplicateCheck2.up",
				data:{"email":$('input#email').val(),
					  "userid":$("input:hidden[name='userid']").val()},
					  // data 속성은 http://localhost:9090/MyMVC/member/idDuplicateCheck.up 로 전송해야할 데이터를 말한다.
					  
				type:"post", // type 을 생략하면 type:"get" 이다.
			//	async:true,  // async:true 가 비동기 방식을 말한다. async 을 생략하면 기본값이 비동기 방식인 async:true 이다.
				             // async:false 가 동기 방식이다. 지도를 할때는 반드시 동기방식인 async:false 을 사용해야만 지도가 올바르게 나온다.
			dataType:"json", // Javascript Standard Object Notation.  dataType은 /MyMVC/member/emailDuplicateCheck.up 로 부터 실행되어진 결과물을 받아오는 데이터타입을 말한다.  
						     // 만약에 dataType:"xml" 으로 해주면 /MyMVC/member/emailDuplicateCheck.up 로 부터 받아오는 결과물은 xml 형식이어야 한다. 
						     // 만약에 dataType:"json" 으로 해주면 /MyMVC/member/emailDuplicateCheck.up 로 부터 받아오는 결과물은 json 형식이어야 한다.
		    success:function(json){
					if(json.isExists) {
						// 입력한 email 이 이미 사용중이라면 
						$('span#emailCheckResult').html($('input#email').val() + "은 다른 사용자가 이미 사용중입니다.").css({"color":"red"});                 
						$('input#email').val("");       
					}
					else {
						// 입력한 email 이 존재하지 않는 경우라면 
						$('span#emailCheckResult').html($('input#email').val() + "은 사용 가능합니다").css({"color":"green"}); 
					}
				},
				error:function(request, status, error){
				    alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
			    }			      
			});
		}//end of if($("input#userid").val().trim() != "") 내용물이 있는 경우에만 실행!-----
					
	 });
	 // === "이메일중복확인" 을 클릭했을 때 이벤트 처리하기 끝 === //
	 
	 // --- 이메일 값이 변경되고 가입하기 버튼을 클릭시 "이메일중복확인" 을 클릭했는지를 위한 확인변수 초기화하기 --- //
	 $("input#email").bind("change", function(){
	 	b_emailcheck_click = false;
	 });
	 
	 
}); // end of $(function(){})------------------------------------


// Function Declaration
// "수정하기" 버튼 클릭시 호출되는 함수
function goEdit() {
	// *** 필수입력사항에 모두 입력이 되었는지 검사하기 시작 *** //
	let b_requiredInfo = true;
	
	// 두번째 방법 : jQuery
	$('input.requiredInfo').each((index, elmt)=>{
		const val = $(elmt).val().trim();
		if(val == ""){
			alert("*표시된 필수입력사항은 모두 입력하셔야 합니다.");
			b_requiredInfo = false;
			return false; // break; 라는 뜻이다.
		} 
	});
	
	if(!b_requiredInfo) {
		return;  // goRegister() 함수를 종료한다.
	}
	// *** 필수입력사항에 모두 입력이 되었는지 검사하기 끝*** //
	
	
	// *** "이메일중복확인" 을 클릭했는지 확인 *** //
	if(!b_emailcheck_click) { // 이 값이 false라면 클릭하지 않았다는 것임!
		alert("이메일중복확인을 클릭하셔야 합니다.");
		return;  // goRegister() 함수를 종료한다.
	}
	
	
	// *** "우편번호찾기" 를 클릭했는지 알아보기 *** // 
	if(!b_zipcodeSearch_click) { // "우편번호찾기"에 클릭을 안 했을 경우 
		alert("우편번호 찾기를 클릭하셔야 합니다.");
		return;  // goRegister() 함수를 종료한다.
	}
	else { // "우편번호찾기"에 클릭했을 경우 
		if($('input#postcode').val().trim() == "" ||
		   $('input#address').val().trim() == "" ||
		   $('input#detailAddress').val().trim() == "") {
			  alert("우편번호 및 주소를 입력하셔야 합니다.");
			  return;  // goRegister() 함수를 종료한다.
		}
	}
	
	// 변경된 암호가 현재 사용중인 암호이라면 현재 사용중인 암호가 아닌 새로운 암호로 입력해야 한다.!!! 
	let isNewPwd = true;
	$.ajax({
		url:"pwdDuplicateCheck.up",
		data:{"new_pwd":$('input:password[name="pwd"]').val(),
			  "userid":$("input:hidden[name='userid']").val()},
		type:"post",
		async: false, //반드시 동기방식이어야 함!
		dataType:"json",
    	success:function(json){
			// json ==> {"isExists" : true}       또는    {"isExists" : false} 
            //          새암호가 기존암호와 동일한 경우          새암호가 기존암호와 다른 경우
			if(json.isExists) {
				// 입력한 새 암호가 기존 암호와 동일한 경우 
				$('span#duplicate_Pwd').html("현재 사용중인 비밀번호로 비밀번호 변경은 불가합니다.");
				isNewPwd = false;   
			}
			
		},
		error:function(request, status, error){
		    alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
	    }			      
	});
	
	////////////
	
	if(isNewPwd) {
		//새 암호가 기존 암호와 다른 경우!
		alert("DB에 사용자 정보를 수정하러 감!");
	    const frm = document.editFrm;
	 	frm.action = "memberEditEnd.up";
	    frm.method = "post";
		frm.submit(); 
	}
	
}// end of function goEdit() {}----------------------------------










