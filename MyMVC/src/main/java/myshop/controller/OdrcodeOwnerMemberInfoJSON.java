package myshop.controller;

import org.json.JSONObject;

import common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import member.domain.MemberDTO;
import myshop.model.ProductDAO;
import myshop.model.ProductDAO_imple;

public class OdrcodeOwnerMemberInfoJSON extends AbstractController {

	private ProductDAO pdao = new ProductDAO_imple();
	
	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

		// === 로그인 유무 검사하기 === //
		if(!super.checkLogin(request)) {
			request.setAttribute("message", "주문내역을 조회하려면 먼저 로그인 부터 하세요!!");
			request.setAttribute("loc", "javascript:history.back()"); 
			
		//	super.setRedirect(false);
			super.setViewPage("/WEB-INF/msg.jsp");
			return;
		}
		else {
			HttpSession session = request.getSession();
			
			MemberDTO loginuser = (MemberDTO)session.getAttribute("loginUser");
			String userid = loginuser.getUserid();
			
			if(!"admin".equals(userid) ) {
				String message = "접근불가!! 관리자가 아닙니다.";
				String loc = "javascript:history.back()";
				
				request.setAttribute("message", message);
				request.setAttribute("loc", loc);
				
				super.setRedirect(false);
				super.setViewPage("/WEB-INF/msg.jsp");
				
				return;
			}
			
			else {
				// "admin" 으로 로그인 한 경우(관리자)이라면
				
				String odrcode = request.getParameter("odrcode");
				
				MemberDTO mDto = pdao.odrcodeOwnerMemberInfo(odrcode);
				// 영수증전표(odrcode)소유주에 대한 사용자 정보를 조회해오는 것.
				
				JSONObject jsonObj = new JSONObject();
				 
				jsonObj.put("userid", mDto.getUserid());
				jsonObj.put("name", mDto.getName());
				jsonObj.put("email", mDto.getEmail());
				jsonObj.put("mobile", mDto.getMobile());
				jsonObj.put("postcode", mDto.getPostcode());
				jsonObj.put("address", mDto.getAddress());
				jsonObj.put("detailaddress", mDto.getDetailaddress());
				jsonObj.put("extraaddress", mDto.getExtraaddress());
				jsonObj.put("gender", mDto.getGender());
				jsonObj.put("birthday", mDto.getBirthday());
				jsonObj.put("coin", mDto.getCoin());
				jsonObj.put("point", mDto.getPoint());
				jsonObj.put("registerday", mDto.getRegisterday());
				
				String json = jsonObj.toString();
				request.setAttribute("json", json);	
				
			//	super.setRedirect(false);
				super.setViewPage("/WEB-INF/jsonview.jsp");	
						
			}
		}		

	}

}
