

$(function(){
	$("button#btnSubmit").click(e => {
		// goLogin_cookies(); // 로그인 처리(아이디 저장은 Cookie 를 사용)
		goLogin_LocalStorage()
		//goLogin_LocalStorage(); // 로그인 처리(아이디 저장은 Localstorage 를 사용)
	});
	
	
	
	//$("input#loginPwd").bind("keydown", e => {})
	$("input#loginPwd").keydown(e => {
		if(e.keyCode == 13) { // 암호입력란에 엔터를 했을 경우
			// 키코드를 사용한 것인데 엔터의 경우 키코드는 13
			goLogin_cookies(); // 로그인 처리(아이디 저장은 Cookie 를 사용)
			//goLogin_LocalStorage(); // 로그인 처리(아이디 저장은 Localstorage 를 사용)
		}
	});
	
	//$("input#loginPwd").bind("keydown", e => {})
	$("input#loginPwd").keydown(e => {
		if(e.keyCode == 13) { // 암호입력란에 엔터를 했을 경우
			// 키코드를 사용한 것인데 엔터의 경우 키코드는 13
			goLogin_LocalStorage(); // 로그인 처리(아이디 저장은 Cookie 를 사용)
			//goLogin_LocalStorage(); // 로그인 처리(아이디 저장은 Localstorage 를 사용)
		}
	});
});//end of $(function()---------------


// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

// Function Declaration
// ====== 로그인 처리 함수(아이디 저장은 Cookie 를 사용함) ====== //
function goLogin_cookies() {
	if($("input#loginUserid").val().trim() == "") {
		// 값이 없는데 이 함수가 호출됐다면 종료!
		alert("아이디를 입력하세요");
		$("input#loginUserid").val("").focus();
		return; // goLogin_cookies() 함수 종료!
	}
	
	if($("input#loginPwd").val().trim() == "") {
			// 값이 없는데 이 함수가 호출됐다면 종료!
			alert("비밀번호를 입력하세요");
			$("input#loginPwd").val("").focus();
			return; // goLogin_cookies() 함수 종료!
	}
		
	const frm = document.loginFrm;
	// action 과 method 는 JSP 파일에서 다 정의해놨음!
	// action의 기본값은 현재페이지,  method의 기본값은 get
	frm.submit();	
}//end of function goLogin_cookies()-----



function goLogin_LocalStorage() {
	if($("input#loginUserid").val().trim() == "") {
		// 값이 없는데 이 함수가 호출됐다면 종료!
		alert("아이디를 입력하세요");
		$("input#loginUserid").val("").focus();
		return; // goLogin_cookies() 함수 종료!
	}

	if($("input#loginPwd").val().trim() == "") {
			// 값이 없는데 이 함수가 호출됐다면 종료!
			alert("비밀번호를 입력하세요");
			$("input#loginPwd").val("").focus();
			return; // goLogin_cookies() 함수 종료!
	}
	
	if($("input:checkbox[id='saveid']").prop("checked")) {
		// 아이디저장 체크박스에 체크가 된 경우로 로그인했을 때
		localStorage.setItem("saveid", $("input#loginUserid").val());
	} else {
		// 아이디저장 체크박스에 체크가 해제된 경우로 로그인했을 때
		localStorage.removeItem("saveid");
	}
		
	const frm = document.loginFrm;
	// action 과 method 는 JSP 파일에서 다 정의해놨음!
	// action의 기본값은 현재페이지,  method의 기본값은 get
	frm.submit();
}
// ====== 로그인 처리 함수(아이디 저장은 LocalStorage 를 사용함) ====== // 



// ==== 로그아웃 처리 함수 ==== //
function goLogOut(ctx_Path) {
	// 로그아웃을 처리해주는 페이지로 이동
	//location.href = ctx_Path+"/login/logout.up";
	//또는
	location.href = `${ctx_Path}/login/logout.up`;
	
}//end of function goLogOut()-----




//==== 코인 충전 결제금액 선택하기(실제 카드 결제) ==== //
function goCoinPurchaseTypeChoice(userid, ctxPath) {
	//코인충전 결제금액 선택하기(팝업창 띄우기)
	const url = `${ctxPath}/member/coinPurchaseTypeChoice.up?userid=${userid}`;
	
	//너비가 650, 높이가 570인 팝업창 화면 가운데 위치시키기
	const width = 650;
	const height = 570;
	const left = Math.ceil((window.screen.width - width)/2);
							//1400 - 650 = 750  ,  750/2 = 375
							
	const top = Math.ceil((window.screen.height- height)/2);
						    //900- 570 = 330  ,  330/2 = 165 
	window.open(url, "coinPurchaseTypeChoice",
			  `left=${left}, top=${top}, width=${width}, height=${height}`);
	
}//end of function goCoinPurchaseTypeChoice(userid)-----



//==== 포트원 결제를 해주는 함수 ====//
function goCoinPurchaseEnd(ctxPath, coinmoney, userid){
	//alert(`확인용: 부모창 함수입니다.\n결제금액: ${coinmoney}\n회원ID: ${userid}`);
	
	// >>> 포트원(구 아임포트) 결제 팝업창 띄우기 <<<
    // 너비 1000, 높이 600 인 팝업창을 화면 가운데 위치시키기
    const width = 1000;
    const height = 600;

    const left = Math.ceil( (window.screen.width - width)/2 ); // 정수로 만듦
    const top = Math.ceil( (window.screen.height - height)/2 ); // 정수로 만듦
    
    const url = `${ctxPath}/member/coinPurchaseEnd.up?coinmoney=${coinmoney}&userid=${userid}`;      

    window.open(url, "coinPurchaseEnd",
               `left=${left}, top=${top}, width=${width}, height=${height}`);
	
}//end of function goCoinPurchaseEnd()-----




// ==== DB 상의 tbl_member 테이블에 해당 사용자의 코인금액 및 포인트를 증가(update)시켜주는 함수 === //
function goCoinUpdate(ctxPath, userid, coinmoney) {
	console.log(`확인용: 회원ID: ${userid}\n코인머니: ${coinmoney}`);
	
	//DB의 데이터를 수정해야 함. 하지만 스크립트에선 DB에 직접접근을 못 하므로 Ajax를 사용!
	//페이지는 바뀌지 않으면서 DB에서 정보를 가져올 때 Ajax 사용!
	$.ajax({
		url: `${ctxPath}/member/coinUpdateLoginUser.up`,
		data:{"userid":userid, 
			  "coinmoney":coinmoney},
		type:"post", // type을 생락하면 타입은 GET
		async: true, //true라면 비동기, false 라면 동기
		dataType: "json",
		// Javascript Standard Object Notation. dataType은 /MyMVC/member/coinUpdateLoginUser.up 로 부터 실행되어진 결과물을 받아오는 데이터타입을 말한다. 
	    // 만약에 dataType:"xml" 으로 해주면 /MyMVC/member/coinUpdateLoginUser.up 로 부터 받아오는 결과물은 xml 형식이어야 한다. 
	    // 만약에 dataType:"json" 으로 해주면 /MyMVC/member/coinUpdateLoginUser.up 로 부터 받아오는 결과물은 json 형식이어야 한다.
		success: function(json) {
			console.log("확인용 json: ", json) //{"n":1, "message":"안태훈님의 300,000원 결제가 완료되었습니다.", "loc": /MyMVC/index.up}
			alert(json.message);
			location.href = json.loc;
		},
		error: function(request, status, error){
            alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
        }
	});
}//end of function goCoinUpdate()----- 



//나의 정보 수정하기
function goEditMyInfo(userid, ctxPath) {

	// >>> 나의 정보 팝업창 띄우기 <<<
	// 너비 800, 높이 680 인 팝업창을 화면 가운데 위치시키기
	const width = 850;
	const height = 680;

	const left = Math.ceil( (window.screen.width - width)/2 ); // 정수로 만듦
	const top = Math.ceil( (window.screen.height - height)/2 ); // 정수로 만듦

	const url = `${ctxPath}/member/memberEdit.up?userid=${userid}`;

	window.open(url, "memberEdit",
	           `left=${left}, top=${top}, width=${width}, height=${height}`);
	
}//end of goEditMyInfo()-----








