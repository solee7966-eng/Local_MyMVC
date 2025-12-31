package member.controller;

import common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import member.domain.MemberDTO;

public class CoinPurchaseEnd extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		//원포트(구 아임포트) 결제창을 띄우기 위한 전제조건은 우선 로그인을 해야 함
		if(super.checkLogin(request)) {
			//로그인을 한 경우
			String userid = request.getParameter("userid");
			
			HttpSession session = request.getSession();
			MemberDTO loginUser = (MemberDTO)session.getAttribute("loginUser");
			
			//System.out.println("userid: " + userid);
			//System.out.println("loginUser.getUserid(): " + loginUser.getUserid());
			
			if(loginUser.getUserid().equals(userid)) {
				//세션에 저장된 유저아이디(로그인한 유저아이디)와 페이지에서 넘어온 유저아이디가 같은 경우
				//즉, 로그인한 유저가 본인의 코인을 충전하는 경우
				String productName = "코인충전";  // "새우깡"
				
				String s_coinmoney = request.getParameter("coinmoney");
				//int productPrice = Integer.parseInt(s_coinmoney);
				int coinmoney = Integer.parseInt(s_coinmoney);
				
				request.setAttribute("productName", productName);
				//request.setAttribute("productPrice", productPrice);
				request.setAttribute("productPrice", 100);
				
				request.setAttribute("coinmoney", coinmoney);
				request.setAttribute("email", loginUser.getEmail());
				request.setAttribute("name", loginUser.getName());
				request.setAttribute("mobile", loginUser.getMobile());
				request.setAttribute("userid", userid);
				
				super.setRedirect(false);
				super.setViewPage("/WEB-INF/member/paymentGateway.jsp");
			} else {
				//로그인한 사용자가 다른 사용자의 코인을 결제하려고 시도하는 경우
				String message = "다른 사용자의 코인 결제는 불가능합니다!";
				String loc = "javascript:history.back()";
				
				request.setAttribute("message", message);
				request.setAttribute("loc", loc);
				super.setRedirect(false);
				super.setViewPage("/WEB-INF/msg.jsp");
			}
			
			
		} else {
			//로그인을 하지 않은 경우
			String message = "코인충전 결제를 하기 위해 로그인을 하세요!";
			String loc = "javascript:history.back()";
			
			request.setAttribute("message", message);
			request.setAttribute("loc", loc);
			super.setRedirect(false);
			super.setViewPage("/WEB-INF/msg.jsp");
		}
	}//end of execute()-----

}
