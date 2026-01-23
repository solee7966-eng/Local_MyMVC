package common.controller;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import member.domain.MemberDTO;
import my.util.MyUtil;

/*	=== 다음의 나오는 것은 우리끼리한 약속이다. ===
    	※ view 단 페이지(.jsp)로 이동시 forward 방법(dispatcher)으로 이동시키고자 한다라면 
       	   자식클래스(/webapp/WEB-INF/Command.properties 파일에 기록된 클래스명들)에서는 부모클래스에서 생성해둔 메서드 호출시 아래와 같이 하면 되게끔 한다.

	    super.setRedirect(false); 
	    super.setViewPage("/WEB-INF/index.jsp");
    
    
     	※ URL 주소를 변경하여 페이지 이동시키고자 한다라면. 즉, sendRedirect 를 하고자 한다라면    
           자식클래스에서는 부모클래스에서 생성해둔 메소드 호출시 아래와 같이 하면 되게끔 한다.
          
    	super.setRedirect(true);
    	super.setViewPage("registerMember.up");               
*/
public abstract class AbstractController implements InterCommand {
	/*
		@Override
		public void execute(HttpServletRequest request, HttpServletResponseresponse) throws Exception {}
		- AbstractController 클래스는 부모클래스이므로 오버라이딩을 해야 하지만 자식 클래스에선 어차피 각 내용들이 실행되므로 이렇게 할 필요 없음
		- 여기선 abstract를 이용해 미완성 클래스로 정의하고 자식 클래스에서 각각 오버라이딩 하도록 한다.
	 */

	private boolean isRedirect = false;
	// isRedirect 변수의 값이 false 이라면 view단 페이지(.jsp)로 forward 방법(dispatcher)으로 이동시키겠다.
    // isRedirect 변수의 값이 true 이라면 sendRedirect 로 페이지이동을 시키겠다.

	private String viewPage;
	// viewPage 는 isRedirect 값이 false 이라면 view단 페이지(.jsp)의 경로명 이고,
    // isRedirect 값이 true 이라면 이동해야할 페이지 URL 주소 이다.

	
	public boolean isRedirect() {
		return isRedirect;
	}
	public void setRedirect(boolean isRedirect) {
		this.isRedirect = isRedirect;
	}
	public String getViewPage() {
		return viewPage;
	}
	public void setViewPage(String viewPage) {
		this.viewPage = viewPage;
	}
	
	
	//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
	//로그인 유무를 검사해서 로그인 했으면 true 를 리턴해주고
    //로그인 안했으면 false 를 리턴해주도록 한다.
	public boolean checkLogin(HttpServletRequest request) {
		//세션을 받아와서 loginUser 라는 세션이 있는지, 없는지를 검사하기
		//loginUser는 아이디와 비밀번호를 입력받아 DB에서 조회한 후 가져온 행
		HttpSession session = request.getSession();
		MemberDTO loginUser = (MemberDTO)session.getAttribute("loginUser");
		
		if(loginUser != null) {return true;} //로그인을 한 경우
		else {return false; } //로그인을 하지 않은 경우
		
	}//end of checkLogin()-----
	
	
	// 로그인 또는 로그아웃을 하면 시작페이지로 가는 것이 아니라 방금 보았던 그 페이지로 그대로 가기 위한 것임.
	public void goBackURL(HttpServletRequest request) {
		HttpSession session = request.getSession();
		session.setAttribute("goBackURL", MyUtil.getCurrentURL(request)); 
	}
	
	
	
	
}//end of public abstract class AbstractController implements InterCommand-----
