package myshop.controller;


import common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import myshop.model.ProductDAO;
import myshop.model.ProductDAO_imple;

public class MallHomeMore extends AbstractController {
	// 필드를 불러오면서 생성해도 되고,
	// private ProductDAO pdDao = new ProductDAO_imple();
	//-- 또는
	// 기본생성자를 이용해 생성해도 됨
	private ProductDAO pdDao;
	public MallHomeMore(){
		pdDao = new ProductDAO_imple();
	}
	
	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		//super.goBackURL(request); //HttpSession session에 "goBackURL"이라는 키값으로 현재 상품페이지 정보 URL 값을 저장해둠
		
		//HIT 상품의 전체 개수를 알아오기
		int totalHITCount = pdDao.totalPspecCount(1);
		//System.out.println("확인용 totalHITCount: " +totalHITCount);
		
		request.setAttribute("totalHITCount", totalHITCount);
		
		
		super.setRedirect(false);
		super.setViewPage("/WEB-INF/myshop/mallHomeMore.jsp");
	}//end of execute()-----

}
