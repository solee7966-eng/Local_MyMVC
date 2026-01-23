package myshop.controller;

import common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class Chart extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		// === 로그인 유무 검사하기 === //
		if(!super.checkLogin(request)) {
	        //로그인 하지 않은 경우이라면
	        
	        request.setAttribute("message", "주문통계를 조회하려면 먼저 로그인 부터 하세요!!");
	        request.setAttribute("loc", "javascript:history.back()"); 
	        
	        super.setRedirect(false);
	        super.setViewPage("/WEB-INF/msg.jsp");
	        return; // 종료
		} else { // 로그인 한 경우이라면 
	         
			super.setRedirect(false);
			super.setViewPage("/WEB-INF/chart/chart.jsp");
		}
	      
	}//end of execute()-----
}
