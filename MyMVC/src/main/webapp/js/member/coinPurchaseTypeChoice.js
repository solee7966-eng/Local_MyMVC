
$(function() {
	$("td#error").hide();

	//[충전결제하기] 에 마우스를 올리거나 마우스를 뗄 경우 이벤트
	$("td#purchase").hover(function(e) {
		//이 위치는 마우스를 올렸을 때 일어나는 이벤트
		//alert("확인용 마우스 오버");
		$(e.target).addClass("purchase");
		
	}, function(e) {
		//이 위치는 마우스가 벗어났을 때 일어나는 이벤트
		//alert("확인용 마우스 아웃");
		$(e.target).removeClass("purchase");
	})
	
	//충전금액에 해당하는 라디오를 선택하면 그에 따른 POINT에 CSS를 적용하기
	$("input:radio[name='coinmoney']").click((e) => {
		const index = $("input:radio[name='coinmoney']").index($(e.target));
		//console.log(index); // 0  1  2  중 선택한 것에 따라 값이 출력!
		
		$("td>span").removeClass("stylePoint");
		$("td>span").eq(index).addClass("stylePoint");
		// $("td>span").eq(index); ==> $("td>span")중에 index 번째의 요소인 엘리먼트를 선택자로 보는 것이다.
		//$("td>span")은 마치 배열로 보면 된다. $("td>span").eq(index) 은 배열중에서 특정 요소를 끄집어 오는 것으로 보면 된다. 예를 들면 arr[i] 와 비슷한 뜻이다.
		$("td#error").hide();
	});
		
});//end of $(function()-----


//Function Declaration
//[충전결제하기] 를 클릭했을 때 이벤트 처리하기
function goCoinPayment(ctxPath, userid) {
	const checkCnt = $("input:radio[name='coinmoney']:checked").length;
	if(checkCnt == 0) {
		//결제금액 항목을 선택하지 않았을 경우
		$("td#error").show();
		return; //goCoinPayment() 함수 종료
	} else {
		//결제금액 항목을 잘 선택한 경우
		//결제 페이지로 넘어가야 함!
		const coinMoney = $("input:radio[name='coinmoney']:checked").val(); //충전할 금액
		//alert(`${coinMoney}원을 결제하겠습니다...`)
		/* ===== 팝업창에서 부모창 함수 호출 방법 3가지 =====
		//팝업을 연 페이지가 부모창임. 즉 [코인충전]을 누르려는 페이지가 부모창
		
         1-1. 일반적인 방법
         opener.location.href = "javascript:부모창스크립트 함수명();";
                        
         1-2. 일반적인 방법
         window.opener.부모창스크립트 함수명();

         2. jQuery를 이용한 방법
         $(opener.location).attr("href", "javascript:부모창스크립트 함수명();");
      	*/
		opener.location.href = `javascript:goCoinPurchaseEnd("${ctxPath}", "${coinMoney}", "${userid}");`;
		

		//아래의 코드로 인해 현재 팝업창을 꺼버리므로 이 위치에 코딩하는 것은 의미가없다.
		//따라서 아래 코드를 실행하여 팝업창을 닫기 전에 부모창의 스크립트를 불러와 그 함수를 이용한다.
		self.close(); //자신의 팝업창을 닫는것
	}
	
}//end of function goCoinPayment()-----


