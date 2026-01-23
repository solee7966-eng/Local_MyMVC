package myshop.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import member.domain.MemberDTO;
import myshop.model.*;

public class OrderList extends AbstractController {

	private ProductDAO pdao = new ProductDAO_imple();
	
	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		/////////////////////////////////////////////////////////
		// **** GET 방식을 막는 또 다른 방법 ==> 웹브라우저 주소창에서 직접입력하지 못하게 막아버리면 된다. **** //
		// 이것의 단점은 웹브라우저에서 북마크(즐겨찾기)를 했을 경우 접속이 안된다는 것이다.
		// 왜냐하면 이전 페이지가 없이 웹브라우저 주소창에서 직접입력한 것과 동일하기 때문이다.
		
		String referer = request.getHeader("referer"); 
		// request.getHeader("referer"); 은 이전 페이지의 URL을 가져오는 것이다.
		
		if(referer == null) {
			// referer == null 은 웹브라우저 주소창에 URL 을 직접 입력하고 들어온 경우이다. 
			super.setRedirect(true);
			super.setViewPage(request.getContextPath()+"/index.up");
			return;
		}
		
		// 주문목록 보기는 반드시 해당사용자가 로그인을 해야만 볼 수 있다.
		if(!super.checkLogin(request)) {
			request.setAttribute("message", "주문내역을 조회하려면 먼저 로그인 부터 하세요!!");
			request.setAttribute("loc", "javascript:history.back()"); 
		
			super.setRedirect(false);
			super.setViewPage("/WEB-INF/msg.jsp");
			return;
		}
		else {
			// 로그인을 했을 경우 
		
			// *** 페이징 처리한 주문 목록 보여주기 *** //
		
			String currentShowPageNo = request.getParameter("currentShowPageNo");
			// currentShowPageNo 은 사용자가 보고자하는 페이지바의 페이지번호 이다.
			// 카테고리 메뉴에서 카테고리명만을 클릭했을 경우에는 currentShowPageNo 은 null 이 된다.
			// currentShowPageNo 이 null 이라면 currentShowPageNo 을 1 페이지로 바꾸어야 한다.
		
			if(currentShowPageNo == null) {
				currentShowPageNo = "1";
			}
		
			// === 페이징 처리를 위해 총페이지수 알아오기 === //
		
			// 1. 일반 사용자로 로그인 한 경우는 자신이 주문한 내역만 조회를 해오고,
			// 2. 관리자(admin)으로 로그인 한 경우 모든 사용자들의 주문한 내역을 조회해온다.
			HttpSession session = request.getSession();
			MemberDTO loginuser = (MemberDTO) session.getAttribute("loginUser");
		
			int totalCountOrder = pdao.getTotalCountOrder(loginuser.getUserid());
		//	System.out.println("~~~~ 확인용 totalCountOrder => " + totalCountOrder); 
			//  ~~~~ 확인용 totalCountOrder => 11 (admin)
			//  ~~~~ 확인용 totalCountOrder =>  7 (seoyh)
			//	~~~~ 확인용 totalCountOrder =>  4	 (eomjh)
		
			// === 한 페이지당 보여줄 주문내역의 개수는 10개로 한다.
			int sizePerPage = 10;
		
			// === 전체 페이지 개수 ===
			int totalPage = (int) Math.ceil((double) totalCountOrder/sizePerPage); 
			//  16.0/10 ==> 1.6 ==> 2.0 ==> 2
			//  15.0/10 ==> 1.5 ==> 2.0 ==> 2
			//  1.0/10  ==> 0.1 ==> 1.0 ==> 1
		
		//	System.out.println("~~~ 확인용 totalPage : " + totalPage);
		
		// === GET 방식이므로 사용자가 웹브라우저 주소창에서 currentShowPageNo 에 totalPage 값 보다 더 큰값을 입력하여 장난친 경우
		// === GET 방식이므로 사용자가 웹브라우저 주소창에서 currentShowPageNo 에 0 또는 음수를 입력하여 장난친 경우
		// === GET 방식이므로 사용자가 웹브라우저 주소창에서 currentShowPageNo 에 숫자가 아닌 문자열을 입력하여 장난친 경우 
		// 아래처럼 막아주도록 하겠다.
		try {
			if( Integer.parseInt(currentShowPageNo) > totalPage || 
				Integer.parseInt(currentShowPageNo) <= 0 ) {
				currentShowPageNo = "1";
			}
		} catch(NumberFormatException e) {
			currentShowPageNo = "1";
		}	
		
		
		// *** 관리자가 아닌 일반사용자로 로그인 했을 경우에는 자신이 주문한 내역만 페이징 처리하여 조회를 해오고, 
		//     관리자로 로그인을 했을 경우에는 모든 사용자들의 주문내역을 페이징 처리하여 조회해온다. 
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("userid", loginuser.getUserid());
		paraMap.put("currentShowPageNo", currentShowPageNo);
		
		List<Map<String, String>> order_map_List = pdao.getOrderList(paraMap);
	//	System.out.println("~~~ 확인용 order_map_List.size() => " + order_map_List.size()); 
		
		request.setAttribute("order_map_List", order_map_List);
		
		// *** ====== 페이지바 만들기 시작 ====== *** //
		/*
			1개 블럭당 10개씩 잘라서 페이지 만든다.
			1개 페이지당 10개행을 보여준다라면 총 몇개 블럭이 나와야 할까? 
			총 제품의 개수가 412개 이고, 1개 페이지당 보여줄 제품의 개수가 10개 이라면
			412/10 = 41.2 ==> 42(totalPage)        
		
			1블럭               1 2 3 4 5 6 7 8 9 10 [다음]
			2블럭   [이전] 11 12 13 14 15 16 17 18 19 20 [다음]
			3블럭   [이전] 21 22 23 24 25 26 27 28 29 30 [다음]
			4블럭   [이전] 31 32 33 34 35 36 37 38 39 40 [다음]
			5블럭   [이전] 41 42 
		*/
		
		// ==== !!! pageNo 구하는 공식 !!! ==== // 
	/*
		1  2  3  4  5  6  7  8  9  10  -- 첫번째 블럭의 페이지번호 시작값(pageNo)은  1 이다.
		11 12 13 14 15 16 17 18 19 20  -- 두번째 블럭의 페이지번호 시작값(pageNo)은 11 이다.	
		21 22 23 24 25 26 27 28 29 30  -- 세번째 블럭의 페이지번호 시작값(pageNo)은 21 이다.
		
		currentShowPageNo        pageNo  ==> ( (currentShowPageNo - 1)/blockSize ) * blockSize + 1 
		---------------------------------------------------------------------------------------------
		1                   1 = ( (1 - 1)/10 ) * 10 + 1 
		2                   1 = ( (2 - 1)/10 ) * 10 + 1 
		3                   1 = ( (3 - 1)/10 ) * 10 + 1 
		4                   1 = ( (4 - 1)/10 ) * 10 + 1  
		5                   1 = ( (5 - 1)/10 ) * 10 + 1 
		6                   1 = ( (6 - 1)/10 ) * 10 + 1 
		7                   1 = ( (7 - 1)/10 ) * 10 + 1 
		8                   1 = ( (8 - 1)/10 ) * 10 + 1 
		9                   1 = ( (9 - 1)/10 ) * 10 + 1 
		10                   1 = ( (10 - 1)/10 ) * 10 + 1 
		
		11                  11 = ( (11 - 1)/10 ) * 10 + 1 
		12                  11 = ( (12 - 1)/10 ) * 10 + 1
		13                  11 = ( (13 - 1)/10 ) * 10 + 1
		14                  11 = ( (14 - 1)/10 ) * 10 + 1
		15                  11 = ( (15 - 1)/10 ) * 10 + 1
		16                  11 = ( (16 - 1)/10 ) * 10 + 1
		17                  11 = ( (17 - 1)/10 ) * 10 + 1
		18                  11 = ( (18 - 1)/10 ) * 10 + 1 
		19                  11 = ( (19 - 1)/10 ) * 10 + 1
		20                  11 = ( (20 - 1)/10 ) * 10 + 1
		
		21                  21 = ( (21 - 1)/10 ) * 10 + 1 
		22                  21 = ( (22 - 1)/10 ) * 10 + 1
		23                  21 = ( (23 - 1)/10 ) * 10 + 1
		24                  21 = ( (24 - 1)/10 ) * 10 + 1
		25                  21 = ( (25 - 1)/10 ) * 10 + 1
		26                  21 = ( (26 - 1)/10 ) * 10 + 1
		27                  21 = ( (27 - 1)/10 ) * 10 + 1
		28                  21 = ( (28 - 1)/10 ) * 10 + 1 
		29                  21 = ( (29 - 1)/10 ) * 10 + 1
		30                  21 = ( (30 - 1)/10 ) * 10 + 1			           
	*/
		String pageBar = "";
		
		int blockSize = 10;
		// blockSize 는 블럭(토막)당 보여지는 페이지 번호의 개수이다.
		
		int loop = 1;
		// loop 는 1 부터 증가하여 1개 블럭을 이루는 페이지번호의 개수(지금은 10개)까지만 증가하는 용도이다.
		
		// ==== !!! 다음은 pageNo 구하는 공식이다. !!! ==== //
		int pageNo = ( ( Integer.parseInt(currentShowPageNo) - 1)/blockSize ) * blockSize + 1; 
		// pageNo 는 페이지바에서 보여지는 첫번째 번호이다.
		
		
		// **** [맨처음][이전] 만들기 **** //
		// 
		pageBar += "<li class='page-item'><a class='page-link' href='orderList.up?currentShowPageNo=1'>[맨처음]</a></li>"; 
		
		if( pageNo != 1 ) {
			pageBar += "<li class='page-item'><a class='page-link' href='orderList.up?currentShowPageNo="+(pageNo-1)+"'>[이전]</a></li>";
		}
		
		while( !(loop > blockSize || pageNo > totalPage) ) {
		
			if(pageNo == Integer.parseInt(currentShowPageNo)) {
				pageBar += "<li class='page-item active'><a class='page-link' href='#'>"+pageNo+"</a></li>"; 
			}
			else {
				pageBar += "<li class='page-item'><a class='page-link' href='orderList.up?currentShowPageNo="+pageNo+"'>"+pageNo+"</a></li>"; 
			}
			
			loop++;    //  1 2 3 4 5 6 7 8 9 10
			
			pageNo++;  //  1  2  3  4  5  6  7  8  9 10
					   // 11 12 13 14 15 16 17 18 19 20
					   // 21 22 23 24 25 26 27 28 29 30
					   // 31 32 33 34 35 36 37 38 39 40
					   // 41 42 
		}// end of while------------------
		
		// **** [다음][마지막] 만들기 **** //
		// pageNo ==> 11
		if( pageNo <= totalPage ) {
			pageBar += "<li class='page-item'><a class='page-link' href='orderList.up?currentShowPageNo="+pageNo+"'>[다음]</a></li>"; 
		}
		pageBar += "<li class='page-item'><a class='page-link' href='orderList.up?currentShowPageNo="+totalPage+"'>[마지막]</a></li>";
		
		// *** ====== 페이지바 만들기 끝 ====== *** //
		
		request.setAttribute("pageBar", pageBar);
		
		/* >>> 뷰단(memberList.jsp)에서 "페이징 처리시 보여주는 순번 공식" 에서 사용하기 위해 
			   주문내역 총개수 알아오기 시작 <<< */
		request.setAttribute("totalCountOrder", totalCountOrder);
		request.setAttribute("currentShowPageNo", currentShowPageNo); // 뷰단에서 "페이징 처리시 보여주는 순번 공식" 에서 사용할 용도임. 
		request.setAttribute("sizePerPage", sizePerPage);
		/* 주문내역 총개수 알아오기 끝 */
		
		super.setRedirect(false);
		super.setViewPage("/WEB-INF/myshop/orderList.jsp");	
	  }		
		
	}

}
