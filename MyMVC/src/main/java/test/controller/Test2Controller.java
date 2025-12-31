package test.controller;

import common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class Test2Controller extends AbstractController {
	// 원래는 기본생성자가 생략되어 있음! 여기선 확인차로 기본생성자를 만들어보기
	public Test2Controller() {
		// System.out.println("#확인용2: Test2Controller 클래스 생성자");
	}
		
	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		// System.out.println("#확인용2: Test2Controller execute() 메서드 호출");
		super.setRedirect(true);
		super.setViewPage(request.getContextPath()+"/test1.up");
	}

}
