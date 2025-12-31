package login.controller;

import java.util.HashMap;
import java.util.Map;

import common.controller.AbstractController;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import member.domain.MemberDTO;
import member.model.MemberDAO;
import member.model.MemberDAO_imple;

public class Login extends AbstractController {
	private MemberDAO mbDao = new MemberDAO_imple();
	
	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String method = request.getMethod();
		
		if("GET".equalsIgnoreCase(method)) {
			// GET 방식으로 들어온 경우
			String message = "비정상적인 접근입니다!";
			String loc = "javascript:history.back()"; // 이전 페이지로 되돌려보낸다!
			
			request.setAttribute("message", message);
			request.setAttribute("loc", loc);
			
			super.setRedirect(false);
			super.setViewPage("WEP-INF/msg.jsp");
			return; // execute() 메서드를 종료함!
		}
		
		// System.out.println("post 방식이네요...");
		String userid = request.getParameter("userid");
		String pwd = request.getParameter("pwd");
		
		
		// ~~~~~~~~~~ "아이디저장" 을 쿠기(Cookie)를 사용하여 처리하기 위한 것 시작 ~~~~~~~~~~ //
		String saveid = request.getParameter("saveid");
		//System.out.println("###### 확인용: " +saveid);
		// ###### 확인용: null ==> 체크박스에 체크가 해제된 상태
		// ###### 확인용: on ==> 체크박스가 체크된 상태
		// ~~~~~~~~~~ "아이디저장" 을 쿠기(Cookie)를 사용하여 처리하기 위한 것 끝 ~~~~~~~~~~ //
		
		
		
		// ===== 클라이언트의 IP 주소를 알아오는 것 ===== //
		String clientip = request.getRemoteAddr(); // 내 서버로 들어온 IP를 알아오는 것임!
		// JSP 파일 실행시켰을 때 IP 주소.. .txt 파일을 참조할 것!
		
		// System.out.println("확인용 userid: " + userid);  => 확인용 userid: solee7966
		// System.out.println("확인용 pwd: " + pwd);   => 확인용 pwd: qwer1234!
		// System.out.println("확인용 clientip: " + clientip);  => 확인용 clientIp: 127.0.0.1 (내 IP 주소)
		
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("userid", userid);
		paraMap.put("pwd", pwd);
		paraMap.put("clientip", clientip);
		
		
		// !!!! session(세션) 이라는 저장소에 로그인 되어진 loginuser 을 저장시켜두어야 한다.!!!! //
        // session(세션) 이란 ? WAS 컴퓨터의 메모리(RAM)의 일부분을 사용하는 것으로 접속한 클라이언트 컴퓨터에서 보내온 정보를 저장하는 용도로 쓰인다. 
        // 클라이언트 컴퓨터가 WAS 컴퓨터에 웹으로 접속을 하기만 하면 무조건 자동적으로 WAS 컴퓨터의 메모리(RAM)의 일부분에 session 이 생성되어진다.
        // session 은 클라이언트 컴퓨터 웹브라우저당 1개씩 생성되어진다. 
        // 예를 들면 클라이언트 컴퓨터가 크롬웹브라우저로 WAS 컴퓨터에 웹으로 연결하면 session이 하나 생성되어지고 ,
        // 또 이어서 동일한 클라이언트 컴퓨터가 엣지웹브라우저로 WAS 컴퓨터에 웹으로 연결하면 또 하나의 새로운 session이 생성되어진다.  
        /*
           -------------
           | 클라이언트    |             ---------------------
           | A 웹브라우저  | ----------- |   WAS 서버         |
           -------------             |                   |
                                     |  RAM (A session)  |
           --------------            |      (B session)  | 
           | 클라이언트     |           |                   |
           | B 웹브라우저   | ----------|                   |
           ---------------           --------------------
           
        !!!!세션(session)이라는 저장 영역에 loginuser 를 저장시켜두면
            Command.properties 파일에 기술된 모든 클래스 및 모든 JSP 페이지(파일)에서 
            세션(session)에 저장되어진 loginuser 정보를 사용할 수 있게 된다. !!!! 
            그러므로 어떤 정보를 여러 클래스 또는 여러 jsp 페이지에서 공통적으로 사용하고자 한다라면
            세션(session)에 저장해야 한다.!!!!          
        */
		
		
		MemberDTO loginUser = mbDao.login(paraMap); // 로그인 한 회원정보 가져오기
		if(loginUser != null) {
			// null 값이 아니라면 로그인에 성공했다는 것!
			//System.out.println("확인용 로그인 성공!!");
			
			// *** WAS 메모리에 저장되어 있느 세션을 불러오기!! ***
			// 세션은 우리가 만든 것이 아닌, 연결되기만 하면 알아서 생성되는 것임!!
			HttpSession session = request.getSession();
			
			// session(세션)에 로그인 되어진 사용자 정보인 loginuser 를 키이름을 "loginuser" 으로 저장시켜두는 것이다.
			session.setAttribute("loginUser", loginUser);
			
			
			// 마지막으로 로그인 한것이 1년 이상 지난 경우 
			if(loginUser.getIdle() == 1) {
																// alert 에서 줄바꿈은 \\ 을 사용!
				String message = "로그인을 한지 1년이 지나서 휴면상태로 되었습니다.\\n휴면을 풀어주는 페이지로 이동합니다!!";
	            String loc = request.getContextPath()+"/index.up";
	            // 원래는 위와같이 index.up 이 아니라 휴면인 계정을 풀어주는 페이지로 URL을 잡아주어야 한다.!!
	            
	            request.setAttribute("message", message);
	            request.setAttribute("loc", loc);
	            
	            super.setRedirect(false); 
	            super.setViewPage("/WEB-INF/msg.jsp");
	            
	            return; // 메소드 종료
			}
			
			
			// ~~~~~~~~~~ "아이디저장" 을 쿠기(Cookie)를 사용하여 처리하기 위한 것 시작 ~~~~~~~~~~ //
			if(saveid != null) {
				// "아이디저장" 체크박스가 체크됐을 때 실행
				Cookie cookie = new Cookie("saveid", userid);
								// new Cookie(쿠키명, 쿠키값);
				// Cookie 클래스 임포트시 jakarta.servlet.http.Cookie 임.
				cookie.setMaxAge(24*60*60); // 쿠키 수명을 설정하기(1일로 지정)
				cookie.setPath("/"); // 쿠키가 브라우저에서 전송될 URL 경로 범위(Path)를 지정하는 설정임
				/* Path를 /로 설정하면:
	                /, /login, /user/profile, /admin 등 모든 서브경로에 대해 이 쿠키가 브라우저에서 자동으로 전송된다.
	            
	               Path를 /login으로 설정하면:
	                /login, /login/check, /login/form 등 /login으로 시작하는 경로에서만 쿠키가 전송된다.
	                /, /main, /user 등의 다른 경로에서는 이 쿠키는 사용되지 않음.   
	            */
				response.addCookie(cookie); // 접속한 클라이언트 PC의 웹브라우저로 쿠키를 보내줌
				
	            Cookie cookie2 = new Cookie("test", "TEST");
	            cookie2.setMaxAge(12*60*60);
	            cookie2.setPath("/");
	            response.addCookie(cookie2);
	            
	            Cookie cookie3 = new Cookie("example", "EXAMPLE");
	            cookie3.setMaxAge(12*60*60);
	            cookie3.setPath("/");
	            response.addCookie(cookie3);
	         
			} else {
				// 아이디저장 체크박스에 체크가 해제 되어진 상태
	            // Java Servlet에서 saveid 쿠키의 MaxAge를 0으로 설정하여 접속한 클라이언트 PC로 쿠키를 보내어
	            // 클라이언트 PC 브라우저에서 saveid 쿠키를 삭제한다.
				Cookie cookie = new Cookie("saveid", null); // 값은 NULL 또는 빈 문자열
				cookie.setMaxAge(0); // 0초 ==> 즉시 만료
				cookie.setPath("/");
				response.addCookie(cookie); // 접속한 클라이언트 PC의 웹브라우저에 쿠키를 보내줌
				
				Cookie cookie2 = new Cookie("test", null);
	            cookie2.setMaxAge(0);
	            cookie2.setPath("/");
	            response.addCookie(cookie2);
	            
	            Cookie cookie3 = new Cookie("example", null);
	            cookie3.setMaxAge(0);
	            cookie3.setPath("/");
	            response.addCookie(cookie3);
			}
			// ~~~~~~~~~~ "아이디저장" 을 쿠기(Cookie)를 사용하여 처리하기 위한 것 끝 ~~~~~~~~~~ //
			
			
			// 비밀번호를 변경한 지 3개월 이상이 된 경우
			if(loginUser.isRequirePwdChange()) {
				String message = "비밀번호를 변경하신지 3개월이 지났습니다.\\n암호 변경 페이지로 이동합니다.";
				String loc = request.getContextPath()+"/index.up";
	            // 원래는 위와같이 index.up 이 아니라 휴면인 계정을 풀어주는 페이지로 URL을 잡아주어야 한다.!!
	            
	            request.setAttribute("message", message);
	            request.setAttribute("loc", loc);
	            
	            super.setRedirect(false); 
	            super.setViewPage("/WEB-INF/msg.jsp");
	            
	            return; // 메소드 종료
			}
			
			
			super.setRedirect(true); // 페이지를 이동시킨다! 
			super.setViewPage(request.getContextPath()+"/index.up"); // 시작페이지로 이동해주기!
		} else {
			//System.out.println("확인용 로그인 실패..");
			String message = "로그인 실패";
			String loc = "javascript:history.back()";
			
			request.setAttribute("message", message);
			request.setAttribute("loc", loc);
			
			setRedirect(false);
			setViewPage("/WEB-INF/msg.jsp");
		}
		
	}//end of execute()-----

}
