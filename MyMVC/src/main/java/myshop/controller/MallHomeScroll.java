package myshop.controller;

import common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import myshop.model.ProductDAO;
import myshop.model.ProductDAO_imple;

public class MallHomeScroll extends AbstractController {
	private ProductDAO pdDao;
	public MallHomeScroll(){
		pdDao = new ProductDAO_imple();
	}
	
	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		//HIT 상품의 전체 개수를 알아오기
		int totalHITCount = pdDao.totalPspecCount(1);
		//System.out.println("확인용 totalHITCount: " +totalHITCount);
		
		request.setAttribute("totalHITCount", totalHITCount);
		
		
		super.setRedirect(false);
		super.setViewPage("/WEB-INF/myshop/mallHomeScroll.jsp");
		
	}

}
