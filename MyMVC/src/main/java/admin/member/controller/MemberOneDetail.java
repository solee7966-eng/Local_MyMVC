package admin.member.controller;

import common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import member.domain.MemberDTO;
import member.model.MemberDAO;
import member.model.MemberDAO_imple;

public class MemberOneDetail extends AbstractController {
	private MemberDAO mbDao = new MemberDAO_imple();
	
	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		//관리자(admint)로 로그인했을 때만 회원조회가 가능하도록 
		HttpSession session = request.getSession();
		MemberDTO loginUser = (MemberDTO)session.getAttribute("loginUser");
		
		if(loginUser != null && "admin".equals(loginUser.getUserid()) ) {
			//관리자로 로그인한 경우
			
			String method = request.getMethod();
			
			if("POST".equalsIgnoreCase(method)) {
				//POST 방식
				String userid = request.getParameter("userid");

				String referer = request.getHeader("Referer");
			/*  request.getHeader("Referer"); 은 
	            현재 페이지 주소인 http://localhost:9090/MyMVC/member/memberOneDetail.up 페이지 주소로 접근하려고 시도하였던 
	            이전 페이지 URL 주소를 알려주는 것이다.

	            request.getHeader("Referer"); 값이 null 이 나오는 경우가 있는데 
	            이것은 사용자가 웹브라우저 주소창에 URL주소 (http://localhost:9090/MyMVC/admin/member/memberOneDetail.up) 를 직접 입력하고 들어온 경우이다.
	        */
				// System.out.println("확인용 referer: "+referer);
				
				// 뷰단에서 받아온 userid를 이용해 해당 userid에 맞는 회원정보 가져오기
				MemberDTO mbDto = mbDao.selectOneMember(userid);
				request.setAttribute("mbDto", mbDto);
				
				request.setAttribute("referer", referer);
				
				super.setRedirect(false);
				super.setViewPage("/WEB-INF/admin/member/memberOneDetail.jsp");
				
			}
		} else {
			//로그인을 안 한 경우 혹은 관리자가 아닌 경우
			String message = "관리자만 접근이 가능합니다.";
			String loc = "javascript:history.back()";
			
			request.setAttribute("message", message);
			request.setAttribute("loc", loc);
					
			super.setRedirect(false);
			super.setViewPage("/WEB-INF/msg.jsp");
		}
		
	}//end of excute()-----

}
