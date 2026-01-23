package login.controller;

import common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import member.domain.MemberDTO;

public class Logout extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		// ==== 로그아웃 처리하기 ====
		
		HttpSession session = request.getSession(); // 세션 불러오기
		//MemberDTO loginUser = (MemberDTO)session.getAttribute("loginUser");
		
		super.setRedirect(true); //페이지 이동을 시키기
		
		String referer = request.getHeader("referer");
		//System.out.println("referer: " +referer);
		
		String userid = ((MemberDTO)session.getAttribute("loginUser")).getUserid();
		
		if(!"admin".equals(userid) && referer != null) {
			//관리자가 아니라면 이전페이지로 복귀
			if(referer.contains("cartList.up") || 
			   referer.contains("chart.up") ||
			   referer.contains("orderList.up")) {
				//관리자가 아닌 일반 사용자로 들어와서 referer 페이지가 개인정보를 나타내는 것이라면 /MyMVC/index.up 페이지로 돌아간다.   
				super.setViewPage(request.getContextPath()+"/index.up");
			} else {
				//관리자가 아닌 일반 사용자로 들어와서 referer 페이지가 개인정보를 나타내는 것이 아니라면 referer 페이지로 돌아간다.
				super.setViewPage(referer);
			}
			
		} else if("admin".equals(userid) && referer != null || referer == null) {
			//관리자이면서 레퍼러가 null이 아니거나, 레퍼러가 null이거나
			super.setViewPage(request.getContextPath()+"/index.up");
		}

		// 첫번째 방법 : 세션을 그대로 존재하게끔 해두고, 세션에 저장되어진 어떤 값(지금은 로그인 되어진 회원객체)을 삭제하기
		//session.removeAttribute("loginUser");
		
		// 두번째 방법 : WAS 메모리 상에서 세션에 저장된 모든 데이터를 삭제하는 것(이 방식을 더 많이 사용)
		session.invalidate();
	}//end of execute()-----
}
