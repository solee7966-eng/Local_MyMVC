package admin.member.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import member.domain.MemberDTO;
import member.model.MemberDAO;
import member.model.MemberDAO_imple;

//관리자가 회원관리하는 것
public class MemberList extends AbstractController {
	private MemberDAO mbDao = new MemberDAO_imple();
	
	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		//관리자(admint)로 로그인했을 때만 회원조회가 가능하도록 
		HttpSession session = request.getSession();
		MemberDTO loginUser = (MemberDTO)session.getAttribute("loginUser");
		
		if(loginUser != null && "admin".equals(loginUser.getUserid()) ) {
			//관리자로 로그인한 경우
			String searchType = request.getParameter("searchType");
			String searchWord = request.getParameter("searchWord");
			String sizePerPage = request.getParameter("sizePerPage");
			String currentShowPageNo = request.getParameter("currentShowPageNo"); //페이지바를 눌렀을 때의 값
			
			if(searchType == null ||
			 (!"name".equals(searchType) &&
			  !"userid".equals(searchType) &&
			  !"email".equals(searchType))) {
				searchType = "";
			}
			//System.out.println("확인용: searchType=>" +searchType);
			
			if(searchWord == null || searchWord.isBlank()) {
				searchWord = "";
			}
			//System.out.println("확인용: searchWord=>" +searchWord);
			
			if(sizePerPage == null ||
			 (!"10".equals(sizePerPage) &&
			  !"5".equals(sizePerPage) &&
			  !"3".equals(sizePerPage))) {
				sizePerPage = "10";
			}
			//System.out.println("확인용: sizePerPage=>" +sizePerPage);
			
			if(currentShowPageNo == null) {
				//기본값은 항상 1로 설정하겠다
				currentShowPageNo = "1";
			}
			//System.out.println("확인용: currentShowPageNo=>" +currentShowPageNo);
			
			Map<String, String> paraMap = new HashMap<>();
			paraMap.put("searchType", searchType);
			paraMap.put("searchWord", searchWord);
			
			//페이징처리를 위한 값들
			paraMap.put("sizePerPage", sizePerPage);
			paraMap.put("currentShowPageNo", currentShowPageNo);

			//페이징 처리를 위한 검색이 있는 또는 검색이 없는 회원에 대한 총 페이지수 알아오기
			int totalPage = mbDao.getTotalPage(paraMap);
			//System.out.println("totalPage: "+totalPage);
			
			
			// === GET 방식이므로 사용자가 웹브라우저 주소창에서 currentShowPageNo 에 totalPage 값 보다 더 큰값을 입력하여 장난친 경우
	        // === GET 방식이므로 사용자가 웹브라우저 주소창에서 currentShowPageNo 에 0 또는 음수를 입력하여 장난친 경우
	        // === GET 방식이므로 사용자가 웹브라우저 주소창에서 currentShowPageNo 에 숫자가 아닌 문자열을 입력하여 장난친 경우 
	        // 아래처럼 막아주도록 하겠다
			try {
				if(Integer.parseInt(currentShowPageNo) > totalPage ||
				   Integer.parseInt(currentShowPageNo) <= 0) {
					currentShowPageNo = "1";
					paraMap.put("currentShowPageNo", currentShowPageNo);
				}
				
				//입력받은 currentShowPageNo가 숫자로 변환할 수 없는 값일 경우 예외처리
			} catch (NumberFormatException e) {
				//예외처리된 currentShowPageNo는 무조건 1로 변경해주기
				currentShowPageNo = "1";
				//paraMap에 잘못 들어간 값도 다시 넣어주기
				paraMap.put("currentShowPageNo", currentShowPageNo);
			}
			
	        /* // *** ======= 페이지바 만들기 시작 ======= *** //
	         * 
	            1개 블럭당 10개씩 잘라서 페이지를 만든다.
	            1개 페이지당 3개행 또는 5개행 또는 10개행을 보여주는데
	                만약에 1개 페이지당 5개행을 보여준다라면 
	                총 몇개 블럭이 나와야 할까? 
	                총 회원수가 207명 이고, 1개 페이지당 보여줄 회원수가 5 이라면
	            207/5 = 41.4 ==> 42(totalPage)        
	                
	            1블럭       [맨처음]  1  2  3  4  5  6  7  8  9  10 [다음][마지막]
	           2블럭   [맨처음][이전] 11 12 13 14 15 16 17 18 19 20 [다음][마지막]
	           3블럭   [맨처음][이전] 21 22 23 24 25 26 27 28 29 30 [다음][마지막]
	           4블럭   [맨처음][이전] 31 32 33 34 35 36 37 38 39 40 [다음][마지막]
	           5블럭   [맨처음][이전] 41 42 [마지막] 
	        */
	         
	        /*  // ==== !!! pageNo 구하는 공식 !!! ==== //
	         * 
	          1  2  3  4  5  6  7  8  9  10  -- 첫번째 블럭의 페이지번호 시작값(pageNo)은  1 이다.
	          11 12 13 14 15 16 17 18 19 20  -- 두번째 블럭의 페이지번호 시작값(pageNo)은 11 이다.   
	          21 22 23 24 25 26 27 28 29 30  -- 세번째 블럭의 페이지번호 시작값(pageNo)은 21 이다.
	          
	           currentShowPageNo   pageNo  ==> ( (currentShowPageNo - 1)/blockSize ) * blockSize + 1 
	          ----------------------------------------------------------------------------------------
	                 1              1 = ( (1 - 1)/10 ) * 10 + 1 
	                 2              1 = ( (2 - 1)/10 ) * 10 + 1 
	                 3              1 = ( (3 - 1)/10 ) * 10 + 1 
	                 4              1 = ( (4 - 1)/10 ) * 10 + 1  
	                 5              1 = ( (5 - 1)/10 ) * 10 + 1 
	                 6              1 = ( (6 - 1)/10 ) * 10 + 1 
	                 7              1 = ( (7 - 1)/10 ) * 10 + 1 
	                 8              1 = ( (8 - 1)/10 ) * 10 + 1 
	                 9              1 = ( (9 - 1)/10 ) * 10 + 1 
	                10              1 = ( (10 - 1)/10 ) * 10 + 1 
	                 
	                11             11 = ( (11 - 1)/10 ) * 10 + 1 
	                12             11 = ( (12 - 1)/10 ) * 10 + 1
	                13             11 = ( (13 - 1)/10 ) * 10 + 1
	                14             11 = ( (14 - 1)/10 ) * 10 + 1
	                15             11 = ( (15 - 1)/10 ) * 10 + 1
	                16             11 = ( (16 - 1)/10 ) * 10 + 1
	                17             11 = ( (17 - 1)/10 ) * 10 + 1
	                18             11 = ( (18 - 1)/10 ) * 10 + 1 
	                19             11 = ( (19 - 1)/10 ) * 10 + 1
	                20             11 = ( (20 - 1)/10 ) * 10 + 1
	                 
	                21             21 = ( (21 - 1)/10 ) * 10 + 1 
	                22             21 = ( (22 - 1)/10 ) * 10 + 1
	                23             21 = ( (23 - 1)/10 ) * 10 + 1
	                24             21 = ( (24 - 1)/10 ) * 10 + 1
	                25             21 = ( (25 - 1)/10 ) * 10 + 1
	                26             21 = ( (26 - 1)/10 ) * 10 + 1
	                27             21 = ( (27 - 1)/10 ) * 10 + 1
	                28             21 = ( (28 - 1)/10 ) * 10 + 1 
	                29             21 = ( (29 - 1)/10 ) * 10 + 1
	                30             21 = ( (30 - 1)/10 ) * 10 + 1                    
	        */
			
			String pageBar = "";
			int blockSize = 10; //블럭당 보여지는 페이지 번호의 개수
			int loop =1; //loop는 1부터 증가하여 1개 블럭을 이루는 페이지번호의 개수(현재는 10개)
			
			//==== 페이징 처리를 하지 않은 검색한 모든 회원목록 보여주기 ===//
			//List<MemberDTO> memberList = mbDao.selectMemberNopaing(paraMap);
			
			
			// ==== !!! 다음은 pageNo 구하는 공식이다. !!! ==== // 
	        int pageNo  = ( (Integer.parseInt(currentShowPageNo) - 1)/blockSize ) * blockSize + 1; 
	        // pageNo 는 페이지바에서 보여지는 첫번째 번호이다.
			
	         
	        //**** [이전] / [맨처음] 만들기 ****//
	        pageBar += "<li class='page-item'><a class='page-link' "
	        		+ "href='memberList.up?searchType="+searchType+""
	        		+ "&searchWord="+searchWord+""
	        		+ "&sizePerPage="+sizePerPage+""
	        		+ "&currentShowPageNo=1'>[맨처음]</a></li>";
	        
	        if(pageNo != 1) {
	        	pageBar += "<li class='page-item'><a class='page-link' "
	        			+ "href='memberList.up?searchType="+searchType+""
	        			+ "&searchWord="+searchWord+""
	        			+ "&sizePerPage="+sizePerPage+""
	        			+ "&currentShowPageNo="+(pageNo-1)+"'>[이전]</a></li>";
	        }
	         
	         
	         //아래 반복문을 실행하면 처음엔 페이지바에 1부터 10까지 하나씩 뜨게 됨 
	        while(!(loop > blockSize || pageNo > totalPage) ) {
	       	 //아래 코드는 GET 방식으로 값을 넘겨주는 것임! 
	       	 if(pageNo == Integer.parseInt(currentShowPageNo)) {
	       		 //보고자하는 페이지가 현재 페이지인 경우 클래스에 active를 주어 색상변경!
	       		 pageBar += "<li class='page-item active'><a class='page-link' "
	       				 + "href='#'>"+pageNo+"</a></li>";
	       	 } else {
	       		 //보고자하는 페이지가 아닌 경우는 active를 빼기
	       		 pageBar += "<li class='page-item'><a class='page-link' "
	       				 + "href='memberList.up?searchType="+searchType+""
	       				 + "&searchWord="+searchWord+""
	       				 + "&sizePerPage="+sizePerPage+""
	       				 + "&currentShowPageNo="+pageNo+"'>"+pageNo+"</a></li>";
	       	 }
	       	 //loop는 한 페이지당 뜨게 할 페이지바의 개수
	       	 loop++;	//1 2 3 4 5 6 7..10
	       	 
	       	 pageNo++;  //1  2  3  4  5  6 ... 10
	       	 			//11  12  13  14  15 ... 20
	       	 			//21  22  23  24  25 ... 30
	       	 			//31  32  33  34  35 ... 40
	        }//end of while()-----
	         
	        //**** [다음] / [마지막] 만들기 ****//
	        //위의 while문을 빠져나오면 아래의 pageBar는 11이 될 것임!
	        //그렇기에 아래의 [다음]을 클릭하게 되면 이제 pageBar가 11인 상태로 위의 반복문이 진행됨!
	        //처음엔 1 2 ... 10 으로 페이지바가 떠 있다면 아래의 [다음]을 클릭하면 첫번째 페이지바는 11부터 다시 나열됨!
	        //pageNo ==> 11
	        if(pageNo <= totalPage) {
	       	 //마지막 페이지에선 [다음]버튼이 필요없기 때문에 위 조건문을 걸면 됨
	       	 pageBar += "<li class='page-item'><a class='page-link' "
	       			 + "href='memberList.up?searchType="+searchType+""
	       			 + "&searchWord="+searchWord+""
	       			 + "&sizePerPage="+sizePerPage+""
	       			 + "&currentShowPageNo="+pageNo+"'>[다음]</a></li>";
	        }
	        	// *** ======= 페이지바 만들기 끝 ======= *** //
	        
	        pageBar += "<li class='page-item'><a class='page-link' "
        		 + "href='memberList.up?searchType="+searchType+""
        		 + "&searchWord="+searchWord+""
        		 + "&sizePerPage="+sizePerPage+""
        		 + "&currentShowPageNo="+totalPage+"'>[마지막]</a></li>";
			
			//==== 페이징 처리를 하여 검색한 모든 회원목록 보여주기 ===//
			List<MemberDTO> memberList = mbDao.selectMemberpaing(paraMap);
			
			request.setAttribute("memberList", memberList);
			//뷰단 페이지에서 다시 값을 사용하기 위해 이것들도 보내주기
			request.setAttribute("searchType", searchType); //검색대상
			request.setAttribute("searchWord", searchWord); //검색어
			request.setAttribute("sizePerPage", sizePerPage); //페이지당 회원출력수
			request.setAttribute("pageBar", pageBar); //페이지바
			
			
			
			/* >>> 뷰단(memberList.jsp)에서 "페이징 처리시 보여주는 순번 공식" 에서 사용하기 위해 
            검색이 있는 또는 검색이 없는 회원의 총개수 알아오기 시작 <<< */
			int totalMemberCount = mbDao.getTotalMemberCount(paraMap);
			//System.out.println("totalMemberCount: "+totalMemberCount);
			
			request.setAttribute("totalMemberCount", totalMemberCount);
			request.setAttribute("currentShowPageNo", currentShowPageNo);
			
			
			
			super.setRedirect(false);
			super.setViewPage("/WEB-INF/admin/member/memberList.jsp");
		} else {
			//로그인을 안 한 경우 혹은 관리자가 아닌 경우
			String message = "관리자만 접근이 가능합니다.";
			String loc = "javascript:history.back()";
			
			request.setAttribute("message", message);
			request.setAttribute("loc", loc);
					
			super.setRedirect(false);
			super.setViewPage("/WEB-INF/msg.jsp");
		}
		
	}

}
