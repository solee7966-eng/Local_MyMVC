package member.controller;

import common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import member.domain.MemberDTO;
import member.model.MemberDAO;
import member.model.MemberDAO_imple;

public class MemberEditEnd extends AbstractController {
	private MemberDAO mbDao = new MemberDAO_imple();
	
	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String method = request.getMethod();
		if("POST".equalsIgnoreCase(method)) {
			String userid = request.getParameter("userid");
			String name = request.getParameter("name");
			String pwd = request.getParameter("pwd");
			String email = request.getParameter("email");

			String hp1 = request.getParameter("hp1");
			String hp2 = request.getParameter("hp2");
			String hp3 = request.getParameter("hp3");
			String mobile = hp1+hp2+hp3;
			
			String postcode = request.getParameter("postcode");
			String address = request.getParameter("address");
			String detailaddress = request.getParameter("detailaddress");
			String extraaddress = request.getParameter("extraaddress");
			
			MemberDTO mbDto = new MemberDTO();
			mbDto.setUserid(userid);
			mbDto.setName(name);
			mbDto.setPwd(pwd);
			mbDto.setEmail(email);
			mbDto.setMobile(mobile);
			mbDto.setPostcode(postcode);
			mbDto.setAddress(address);
			mbDto.setDetailaddress(detailaddress);
			mbDto.setExtraaddress(extraaddress);
			
			//회원수정이 성공되면 회원정보 수정 성공! 이라는 alert 창을 띄우고
			try {
				int n = mbDao.updateMember(mbDto);
				
				if(n == 1) {
					HttpSession session = request.getSession();
					MemberDTO loginUser = (MemberDTO)session.getAttribute("loginUser");
					loginUser.setUserid(userid);
					loginUser.setName(name);
					loginUser.setPwd(pwd);
					loginUser.setEmail(email);
					loginUser.setMobile(mobile);
					loginUser.setPostcode(postcode);
					loginUser.setAddress(address);
					loginUser.setDetailaddress(detailaddress);
					loginUser.setExtraaddress(extraaddress);
					
					String message = "회원정보 수정성공!";
					String loc = request.getContextPath()+"/index.up";
					
					request.setAttribute("message", message);
					request.setAttribute("loc", loc);
					
					//부모창 새로고침 및 팝업창 닫기를 위한 용도
					request.setAttribute("popup_close", true);
					
					super.setRedirect(false);
					super.setViewPage("/WEB-INF/msg.jsp");
					
				}
			} catch (Exception e) {
				e.printStackTrace();
				super.setRedirect(true);
				super.setViewPage(request.getContextPath()+"/error.up");
			}
			
			
		}//end of if("POST")-----
	}//end of execute()-----
}
