package member.controller;

import java.sql.SQLException;
import java.text.DecimalFormat;
import java.util.HashMap;
import java.util.Map;

import org.json.JSONObject;

import common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import member.domain.MemberDTO;
import member.model.MemberDAO;
import member.model.MemberDAO_imple;

//결제를 했을 경우 DB의 코인 값을 변경해주기
public class CoinUpdateLoginUser extends AbstractController {
	private MemberDAO mbDao = new MemberDAO_imple();
	
	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String method = request.getMethod();
		String message = "";
		String loc = "";
		int n = 0;
		
		if("POST".equalsIgnoreCase(method)) {
			//POST 방식인 경우
			String userid = request.getParameter("userid");
			String coinmoney = request.getParameter("coinmoney");
			
			Map<String, String> paraMap = new HashMap<>();
			paraMap.put("userid", userid);
			paraMap.put("coinmoney", coinmoney);
			
			try {
				n = mbDao.coinUpdateLoginUser(paraMap);

				if(n==1) {
					HttpSession session = request.getSession();
					MemberDTO loginUser = (MemberDTO)session.getAttribute("loginUser");
					
					//세션 값을 변경해주기!
					loginUser.setCoin(loginUser.getCoin() + Integer.parseInt(coinmoney));
					loginUser.setPoint(loginUser.getPoint() + (int)(Integer.parseInt(coinmoney)*0.01));
					
					DecimalFormat df = new DecimalFormat("#,###");
					//df.format(3000000) => 3,000,000
					
					message = loginUser.getName()+ "님의 " +df.format(Long.parseLong(coinmoney))+ "원 결제가 완료되었습니다.";
					loc = request.getContextPath() + "/index.up";
				}
			} catch (SQLException e) {
				message = "코인 결제가 DB 오류로 인해 실패되었습니다.";
				loc = "javascript:history.back()";
			}
			
		} else {
			//GET방식으로 들어온 경우
			message = "올바른 접근 방식이 아닙니다.";
			loc = "javascript:history.back()";
		}
		
		JSONObject jsonObj = new JSONObject(); // {}
		jsonObj.put("n", n); // {"n":1} 또는 {"n":0}
		jsonObj.put("message", message); //{"n":1, "message":"안태훈님의 300,000원 결제가 완료되었습니다."}
		jsonObj.put("loc", loc); //{"n":1, "message":"안태훈님의 300,000원 결제가 완료되었습니다.", "loc": /MyMVC/index.up}
		
		String json = jsonObj.toString(); //"{"n":1, "message":"안태훈님의 300,000원 결제가 완료되었습니다.", "loc": /MyMVC/index.up}"
		request.setAttribute("json", json);
		
		super.setRedirect(false);
		super.setViewPage("/WEB-INF/jsonview.jsp");
	}//end of execute()-----

}
