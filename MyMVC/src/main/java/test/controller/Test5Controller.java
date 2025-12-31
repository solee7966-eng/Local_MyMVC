package test.controller;

import common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class Test5Controller extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		super.setRedirect(true); // redirect 방식. 웹페이지(uri)를 아래에 넣어주면 됨!
		super.setViewPage(request.getContextPath()+"/test/test4.up");
	}

}
