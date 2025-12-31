package member.controller;

import common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import member.domain.MemberDTO;

public class CoinPurchaseTypeChoice extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		//코인충전을 하기 위한 전제조건은 우선 로그인을 해야 함
		if(super.checkLogin(request)) {
			//로그인을 한 경우
			String userid = request.getParameter("userid");
			
			HttpSession session = request.getSession();
			MemberDTO loginUser = (MemberDTO)session.getAttribute("loginUser");
			if(loginUser.getUserid().equals(userid)) {
				//세션에 저장된 유저아이디(로그인한 유저아이디)와 페이지에서 넘어온 유저아이디가 같은 경우
				//즉, 로그인한 유저가 본인의 코인을 충전하는 경우
				super.setRedirect(false);
				super.setViewPage("/WEB-INF/member/coinPurchaseTypeChoice.jsp");
				
			} else {
				//로그인한 사용자가 다른 사용자의 코인을 충전하려고 시도하는 경우
				String message = "다른 사용자의 코인 충전은 불가능합니다!";
				String loc = "javascript:history.back()";
				
				request.setAttribute("message", message);
				request.setAttribute("loc", loc);
				super.setRedirect(false);
				super.setViewPage("/WEB-INF/msg.jsp");
			}
			
			
		} else {
			//로그인을 하지 않은 경우
			String message = "코인충전을 하기 위해 로그인을 하세요!";
			String loc = "javascript:history.back()";
			
			request.setAttribute("message", message);
			request.setAttribute("loc", loc);
			super.setRedirect(false);
			super.setViewPage("/WEB-INF/msg.jsp");
		}
	}//end of execute()-----

}
