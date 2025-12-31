package test.controller;

import common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class Test3Controller extends AbstractController {
	// 원래는 기본생성자가 생략되어 있음! 여기선 확인차로 기본생성자를 만들어보기
	public Test3Controller() {
		// System.out.println("$확인용3: Test3Controller 클래스 생성자");
	}

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		// System.out.println("$확인용3: Test3Controller execute() 메서드 호출");
		// System.out.println("@확인용1: Test1Controller execute() 메서드 호출");
				request.setAttribute("center", "쌍용교육센터 6강의장");
				
				// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ //
				
				super.setRedirect(false);
				super.setViewPage("/WEB-INF/test/test3.jsp");
	}

}
