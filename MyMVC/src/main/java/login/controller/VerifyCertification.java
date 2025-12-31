package login.controller;

import common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class VerifyCertification extends AbstractController {
	
	
	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String method = request.getMethod();
	      
		if("POST".equalsIgnoreCase(method)) {
			String userCertificationCode = request.getParameter("userCertificationCode");
			String userid = request.getParameter("userid");
			
			HttpSession sesstion = request.getSession();
			String certication_code = (String)sesstion.getAttribute("certication_code");
			
			String message = "";
			String loc = "";
			
			if(certication_code.equals(userCertificationCode)) {
				// 원본인증번호와 사용자가 입력한 인증번호가 같을 경우
				message = "인증에 성공하셨습니다.";
				loc = request.getContextPath()+"/login/pwdUpdateEnd.up?userid="+userid; 
			} else {
				message = "발급된 인증코드가 아닙니다.\\n인증코드를 다시 발급받으세요!!";
				loc = request.getContextPath()+"/login/pwdFind.up";
			}
			request.setAttribute("message", message);
	        request.setAttribute("loc", loc);
	        
	        super.setRedirect(false);
	        super.setViewPage("/WEB-INF/msg.jsp");
	        
	        
	        // !!!! 중요 !!!! //
	        // !!!! 세션에 저장된 인증코드 삭제하기 !!!! //
	        sesstion.removeAttribute("certication_code");
		}//end of if()-----
		
	}//end of execute()-----

}
