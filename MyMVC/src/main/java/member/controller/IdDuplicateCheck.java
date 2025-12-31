package member.controller;

import org.json.JSONObject;

import common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import member.model.MemberDAO;
import member.model.MemberDAO_imple;

public class IdDuplicateCheck extends AbstractController {
	private MemberDAO mbDao = new MemberDAO_imple();
	
	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String method = request.getMethod();
		
		// DB 접근이므로 보안 중요 ==> POST 방식으로만 접근
		if("POST".equalsIgnoreCase(method)) {
			String userid = request.getParameter("userid");
			boolean isExists = mbDao.idDuplicateCheck(userid);
			// System.out.println("확인용: " +isExists);
			
			JSONObject jsonObj = new JSONObject(); // 생성된 빈 객체 {}
			jsonObj.put("isExists", isExists); // 생성된 객체 {"isExists":true} 또는 {"isExists":false}
			
			String json = jsonObj.toString(); // 문자열 형태인 "{'isExists':true}" 또는 "{'isExists':false}" 로 바꿔주기
			// System.out.println("확인용 json: "+json); // 확인용 json: {"isExists":true}
			
			request.setAttribute("json", json);
			super.setRedirect(false);
			super.setViewPage("/WEB-INF/jsonview.jsp");
		}
	}//end of execute() 메서드 종료-----

}
