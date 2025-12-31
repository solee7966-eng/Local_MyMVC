package member.controller;

import java.util.HashMap;
import java.util.Map;

import org.json.JSONObject;

import common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import member.model.MemberDAO;
import member.model.MemberDAO_imple;

public class PwdDuplicateCheck extends AbstractController {
	private MemberDAO mbDao = new MemberDAO_imple(); 
	
	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		  String method = request.getMethod(); // "GET" 또는 "POST" 
	      
	      if("POST".equalsIgnoreCase(method)) {
	         
	         String new_pwd = request.getParameter("new_pwd");
	         String userid = request.getParameter("userid");
	         
	         //System.out.println(new_pwd);
	         //System.out.println(userid);
	         
	         Map<String, String> paraMap = new HashMap<>();
	         paraMap.put("new_pwd", new_pwd);
	         paraMap.put("userid", userid);
	         
	         boolean isExists = mbDao.pwdduplicatePwdCheck(paraMap);
	         // 회원정보 수정시 변경하고자 하는 암호가 현재 사용자가 사용중인지 아닌지 여부 알아오기
	         // 암호 중복검사 (현재 암호와 동일하면 true 를 리턴해주고, 현재 암호와 동일하지 않으면 false 를 리턴한다)
	         
	         JSONObject jsonObj = new JSONObject(); // {}
	         jsonObj.put("isExists", isExists);     // {"isExists" : true}  또는   {"isExists" : false} 
	         
	         String json = jsonObj.toString(); // 문자열 형태인 "{"isExists":true}" 또는 "{"isExists":false}" 으로 만들어준다. 
	      //   System.out.println(">>> 확인용 json => " + json);
	          // >>> 확인용 json => {"isExists":true}
	         // >>> 확인용 json => {"isExists":false}
	         
	         request.setAttribute("json", json);
	         
	      //   super.setRedirect(false);
	         super.setViewPage("/WEB-INF/jsonview.jsp");
	      }
		
	}

}
