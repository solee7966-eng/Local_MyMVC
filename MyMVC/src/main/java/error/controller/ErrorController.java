package error.controller;

import common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class ErrorController extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		// super.setRedirect(false);	// 부모클래스에서 setRedirect 는 기본값이 false이므로 지정해주지 않아도 상관없음!
		super.setViewPage("/WEB-INF/error.jsp"); 
	}

}
