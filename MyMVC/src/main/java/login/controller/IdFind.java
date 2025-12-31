package login.controller;

import java.util.HashMap;
import java.util.Map;

import common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import member.model.MemberDAO;
import member.model.MemberDAO_imple;

public class IdFind extends AbstractController {
	private MemberDAO mbDao = new MemberDAO_imple();
	
	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String method = request.getMethod();
		
		if("POST".equalsIgnoreCase(method)) {
			// 아이디 찾기 modal 창에서 "찾기" 버튼을 클릭했을 경우
			String name = request.getParameter("name");
			String email = request.getParameter("email");
			
			Map<String, String> paraMap = new HashMap<>();
			paraMap.put("name", name);
			paraMap.put("email", email);
			
			// form 태그에서 넘어온 값을 그대로 view 단 페이지에 주기 위해 사용!
			request.setAttribute("name", name);
			request.setAttribute("email", email);
			
			String userid = mbDao.findUserid(paraMap);
			if(userid != null) {
				request.setAttribute("userid", userid);
			} else {
				request.setAttribute("userid", "존재하지 않는 ID입니다.");
			}
		}//end of if()-----
		
		request.setAttribute("method", method);
		super.setRedirect(false);
		super.setViewPage("/WEB-INF/login/idFind.jsp");
	}//end of execute()-----

}
