package member.controller;

import java.util.HashMap;
import java.util.Map;

import org.json.JSONObject;

import common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import member.model.MemberDAO;
import member.model.MemberDAO_imple;

public class EmailDuplicateCheck2 extends AbstractController {
	private MemberDAO mbDao = new MemberDAO_imple();
	
	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String method = request.getMethod();
		//System.out.println("GET방식");
		
		// DB 접근이므로 보안 중요 ==> POST 방식으로만 접근
		if("POST".equalsIgnoreCase(method)) {
			String email = request.getParameter("email");
			String userid = request.getParameter("userid");
			Map<String, String> paraMap = new HashMap<String, String>();
			paraMap.put("email", email);
			paraMap.put("userid", userid);
			
			//System.out.println(email);
			//System.out.println(userid);
			
			// 회원정보 수정시 변경하고자 하는 이메일이 다른 사용자가 현재 사용중인지 아닌지 여부 알아오기
	        // 이메일 중복검사 (tbl_member 테이블에서 email 이 존재하면 true 를 리턴해주고, email 이 존재하지 않으면 false 를 리턴한다)
			boolean isExists = mbDao.emailDuplicateCheck2(paraMap);
			
			JSONObject jsonObj = new JSONObject(); // 생성된 빈 객체 {}
			jsonObj.put("isExists", isExists); // 생성된 객체 {"isExists":true} 또는 {"isExists":false}
			
			//System.out.println(isExists);
			
			String json = jsonObj.toString(); // 문자열 형태인 "{'isExists':true}" 또는 "{'isExists':false}" 로 바꿔주기
			// System.out.println("확인용 json: "+json); // 확인용 json: {"isExists":true}
			
			request.setAttribute("json", json);
			super.setRedirect(false);
			super.setViewPage("/WEB-INF/jsonview.jsp");
		}
	}//end of execute() 메서드 종료-----

}
