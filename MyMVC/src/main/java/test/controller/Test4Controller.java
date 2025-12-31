package test.controller;

import common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class Test4Controller extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		request.setAttribute("name", "카리나");
		request.setAttribute("img", "karina.jpg");
		
		super.setRedirect(false); // forward 방식. 뭐뭐.jsp 파일을 만들어 주어야 함!!
		super.setViewPage("/WEB-INF/test/test4.jsp"); // 이 안에 보낼 jsp 파일을 넣어주면 됨!
	}

}
