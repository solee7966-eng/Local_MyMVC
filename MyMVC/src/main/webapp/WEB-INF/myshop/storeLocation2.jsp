<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>


<jsp:include page="../header1.jsp" />

<style type="text/css">

	div#map_container > div#tab {
	 /*	border: solid 1px red !important; */ 
		
		width: 90%;
		border: solid 1px #ccc;
		background-color: #f1f1f1; 
		overflow: hidden;
	}
	
	div#tab > button {
		width: 20%;
		border: none;
		outline: none;
		cursor: pointer;
		padding: 14px 16px; 
		font-size: 17px;
		float: left; /* 버튼과 버튼사이의 여백없이 계속해서 붙여가면서 하려고 하는 것임 */
	}

	div#map_container > div.map {
	   	border: 1px solid #ccc; 
	   	border-top: none; 
	   	margin-top: 0.5%;
	}
	
	.tab_active {
		background-color: navy;
		color: white;
	}

/*******************************************/

	div#title {
		font-size: 20pt;
	 /* border: solid 1px red; */
		padding: 12px 0;
	}
	
	div.mycontent {
  		width: 300px;
  		padding: 5px 3px;
  	}
  	
  	div.mycontent>.title {
  		font-size: 12pt;
  		font-weight: bold;
  		background-color: #d95050;
  		color: #fff;
  	}
  	
  	div.mycontent>.title>a {
  		text-decoration: none;
  		color: #fff;
  	}
  	  	
  	div.mycontent>.desc {
  	 /* border: solid 1px red; */
  		padding: 10px 0 0 0;
  		color: #000;
  		font-weight: normal;
  		font-size: 9pt;
  	}
  	
  	div.mycontent>.desc>img {
  		width: 50px;
  		height: 50px;
  	}
  	
</style>

 <div id="title">매장 오시는 길</div>
 <div id="map_container"></div>
  
 <%-- 
   <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=발급받은 APP KEY(JavaScript 키)를 넣으시면 됩니다."></script> 
 --%> 
 <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=a9a762e8fc2d3a4b1d49c07e1623cb53"></script> 
 
 <script type="text/javascript">
    $(document).ready(function(){
    	    	
    	// ============ 지도에 매장위치 마커 보여주기 시작 ============ //
    	// 매장 마커를 표시할 위치와 내용을 가지고 있는 객체 배열
    	var positionArr = [];
    	    	
    	$.ajax({
    		url:"${pageContext.request.contextPath}/shop/storeLocationJSON.up",
    		async:false, // !!!!! 지도는 비동기 통신이 아닌 동기 통신으로 해야 한다.!!!!!!
    		dataType:"json",
    		success:function(json){
    			
    			// console.log(JSON.stringify(json));
    			// JSON.stringify(json) 은 자바스크립트의 객체(배열)인 json 을 string 타입으로 변경시켜주는 것이다. 
    			<%--
    			  [{"storeurl":"https://place.map.kakao.com/7858517","lng":126.98187860455485,"storename":"롯데백화점 본점","storeimg":"lotte02.png","storeaddress":"서울 중구 을지로 30 (T)02-771-2500","lat":37.56511284953554,"zIndex":1}
    			  ,{"storeurl":"https://place.map.kakao.com/7969138","lng":126.98098265772731,"storename":"신세계백화점 본점","storeimg":"shinsegae.png","storeaddress":"서울 중구 소공로 63 (T)1588-1234","lat":37.56091181255155,"zIndex":2}
    			  ,{"storeurl":"https://place.map.kakao.com/13057692","lng":126.98512381778167,"storename":"미래에셋센터원빌딩","storeimg":"miraeeset.png","storeaddress":"서울 중구 을지로5길 26 (T)02-6030-0100","lat":37.567386065415086,"zIndex":3}
    			  ,{"storeurl":"https://place.map.kakao.com/21695719","lng":126.935699,"storename":"현대백화점신촌점","storeimg":"hyundai01.png","storeaddress":"서울 서대문구 신촌로 83 현대백화점신촌점 (T)02-3145-2233","lat":37.556005,"zIndex":4}
    			  ,{"storeurl":"https://place.map.kakao.com/16530319","lng":126.919557,"storename":"쌍용강북교육센터","storeimg":"sist01.jpg","storeaddress":"서울 마포구 월드컵북로 21 풍성빌딩 2~4층 (T)02-336-8546","lat":37.556583,"zIndex":5}
    			  ] 
    			--%>
    			
    			// == 탭버튼 만들기 시작 == //
    			let v_html = `<p>탭 메뉴를 선택해 보세요</p>
    	                      <div id="tab">`;
    	               
    	        json.forEach( item => {
    		        v_html += `<button>\${item.storename}</button>`;
    	        });
    	               
    	        v_html += `</div>`; 
    	        // == 탭버튼 만들기 끝 == //
    	        
    	        
    	        // == 지도를 담을 영역의 DOM 만들기 시작 == //
    	        json.forEach( (item, index) => {
    	     	    v_html += `<div class="map" style="width:90%; height:500px;" id="map\${index}"></div>`;
    	        });                
    	        
    	        $("div#map_container").html(v_html);
    	        // == 지도를 담을 영역의 DOM 만들기 끝 == //
    	        
    	        
    	        // == 지도를 담을 영역의 DOM 레퍼런스 만들기 시작 == //
    	        const arr_mapContainer = [];
    	        for(let i=0; i<json.length; i++){
    	        	let mapContainer = document.getElementById("map"+i);
    	        	arr_mapContainer.push(mapContainer);
    	        }// end of for---------------------------
    	        // == 지도를 담을 영역의 DOM 레퍼런스 만들기 끝 == //
    	        
    	        
    	        // == 지도를 생성할때 필요한 기본 옵션 만들기 시작 == //
    	        const arr_options = [];
    	        
    	        json.forEach( item => {
    	     	    let options = {center: new kakao.maps.LatLng(item.lat, item.lng), // 지도의 중심좌표. 반드시 존재해야함.
    	            	 	       /*
    	            		  	     center 에 할당할 값은 kakao.maps.LatLng 클래스를 사용하여 생성한다.
    	            		  	     kakao.maps.LatLng 클래스의 2개 인자값은 첫번째 파라미터는 위도(latitude)이고, 두번째 파라미터는 경도(longitude)이다.
    	            		       */
    	            	 	       level: 4  // 지도의 레벨(확대, 축소 정도). 숫자가 클수록 축소된다. 4가 적당함.
    	             };
    	     	    
    	     	    arr_options.push(options);
    	        });
    	        // == 지도를 생성할때 필요한 기본 옵션 만들기 끝 == //
    	        
    	        
    	        // == 지도 생성 및 생성된 지도객체 리턴 시작 == // 
    	        const arr_mapobj = [];
    	        
    	        arr_options.forEach( (item, index) => {
    	     	    
    	        	let mapobj = new kakao.maps.Map(arr_mapContainer[index], arr_options[index]);
    	        	
    	        	arr_mapobj.push(mapobj);
    	        });
    	        // == 지도 생성 및 생성된 지도객체 리턴 끝 == //
    	        
    	        
    	        // == 일반 지도와 스카이뷰로 지도 타입을 전환할 수 있는 지도타입 컨트롤을 생성함 시작 ==
    	        // == 지도 확대 축소를 제어할 수 있는 줌 컨트롤을 생성함 시작 ==	
    	        arr_mapobj.forEach( item => {
    	        	
    	        	// 일반 지도와 스카이뷰로 지도 타입을 전환할 수 있는 지도타입 컨트롤을 생성함. 	
        	        let mapTypeControl = new kakao.maps.MapTypeControl();
        	
        	        // 지도 확대 축소를 제어할 수 있는 줌 컨트롤을 생성함.	
        	        let zoomControl = new kakao.maps.ZoomControl();
    	        	
    	        	// 지도 타입 컨트롤을 지도에 표시함.
        	        // kakao.maps.ControlPosition은 컨트롤이 표시될 위치를 정의하는데 TOPRIGHT는 오른쪽 위를 의미함.
    	        	item.addControl(mapTypeControl, kakao.maps.ControlPosition.TOPRIGHT);        	
    	        	
    	        	// 지도 확대 축소를 제어할 수 있는  줌 컨트롤을 지도에 표시함.
        	    	// kakao.maps.ControlPosition은 컨트롤이 표시될 위치를 정의하는데 RIGHT는 오른쪽을 의미함.	 
        	    	item.addControl(zoomControl, kakao.maps.ControlPosition.RIGHT);   	
    	        });
    	        // == 일반 지도와 스카이뷰로 지도 타입을 전환할 수 있는 지도타입 컨트롤을 생성함 끝 ==
    	        // == 지도 확대 축소를 제어할 수 있는 줌 컨트롤을 생성함 끝 ==	
    	        
    	        
    	        // == 마커 생성하기 시작 == //
    	        const arr_marker = [];
    	        
    	        arr_mapobj.forEach( (item, index) => {
    	        	
    	        	let latitude = json[index].lat;
    	        	let longitude = json[index].lng;
    	        	
    	        	let locPosition = new kakao.maps.LatLng(latitude, longitude);
    	        	
    	        	let marker = new kakao.maps.Marker({ map: arr_mapobj[index], 
	    		                                         position: locPosition // locPosition 좌표에 마커를 생성 
	    			                                   });
    	        	
    	        	arr_marker.push(marker);
    	        });
    	        // == 마커 생성하기 끝 == //
    	    		  
    	        
    	        // == 인포윈도우를 생성하기 시작 ==  //
    	        const arr_infowindow = []; // 인포윈도우를 담을 배열
    	    	for(let i=0; i<arr_marker.length; i++){
    	    		
    	    		// == 인포윈도우에 넣을 내용물 생성하기 == 
    	    		let html_content = "<div class='mycontent'>"+ 
    					       		   "  <div class='title'>"+ 
    						           "    <a href='"+json[i].storeurl+"' target='_blank'><strong>"+json[i].storename+"</strong></a>"+  
    						           "  </div>"+
    						           "  <div class='desc'>"+ 
    						           "    <img src='${pageContext.request.contextPath}/images/"+json[i].storeimg+"'>"+  
    						           "    <span class='address'>"+json[i].storeaddress+"</span>"+ 
    						           "  </div>"+ 
    						           "</div>";	
    	    		
    						           
    			    // == 인포윈도우 생성하기 == 
    	    		let infowindow = new kakao.maps.InfoWindow({
    	    			                 content: html_content,
    	    			                 removable: true,
    	    			                 zIndex : i+1
    	    		                 });
    			    
    			    
    	    		// 인포윈도우를 배열에 담기
    	    		arr_infowindow.push(infowindow);
    	    		
    	    	}// end of for-------------------------------------
    	        // == 인포윈도우를 생성하기 끝 ==  //
    	        
    	    		
    	    	// == 마커 위에 인포윈도우를 표시하기 시작 == //
    	    	for(let i=0; i<arr_infowindow.length; i++){
    	    		arr_infowindow[i].open(arr_mapobj[i], arr_marker[i]);
    	    	}// end of for----------------------------
    	    	// == 마커 위에 인포윈도우를 표시하기 끝 == //
    	    	
    	        
    	        // == 지도에 마커를 표시한다 시작 == //
    	        for(let i=0; i<arr_marker.length; i++) {
    	        	arr_marker[i].setMap(arr_mapobj[i]);
    	        }// end of for-------------------------- 
    	        // == 지도에 마커를 표시한다 끝 == //	
    	    	
    		},
    		error: function(request, status, error){
    			alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
    	    }
    	});
     // ============ 지도에 매장위치 마커 보여주기 끝 ============ //
     
     
       // >>> === 클릭한 탭(버튼)만 내용물이 보이도록 하기 <<< ===	
       $(document).on('click', 'div#tab > button', function(e){
	   
	         const index = $("div#tab > button").index($(e.target));
	         // console.log("확인용 index : ", index);
	         /*
	            확인용 index :  0
	            확인용 index :  1
	            확인용 index :  2
	            확인용 index :  3
	            확인용 index :  4
	         */
	  
	         $("div#map_container > div.map").css('display','none');
	  
	      // $("div#map_container > div.map").eq(index).css('display','block');
	      // 또는   
	      // $("div#map_container > div.map:eq("+index+")").css('display','block');    
		  // 또는  
	         $(`div#map_container > div.map:eq(\${index})`).css('display','block');
	      // console.log("확인용 => ", $(`div#map_container > div.map:eq(\${index})`).html()); 
		   
	         $("div#tab > button").removeClass("tab_active");
	         $(e.target).addClass("tab_active");
	   
        });// end of $("div#tab > button").click(function(e){})---------
   
   
        $("div#tab > button").eq(0).trigger('click');
 
	   // 또는
	   // $("div#tab > button:eq(0)").trigger('click');
	 
	   // 또는   
	   // $(`div#tab > button:eq(0)`).trigger(`click`);
	 
	   // 또는
	   // $(`div#tab > button:eq(0)`).click();
	 
	   // 또는
	   // $("div#tab > button").eq(0).click();
	 
	   // 또는   
	   // document.querySelectorAll("button")[0].click();
    		
    });// end of $(document).ready(function(){})---------------------
    
 </script> 

<jsp:include page="../footer1.jsp" />
    