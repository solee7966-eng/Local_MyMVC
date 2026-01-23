package myshop.controller;

import java.util.List;

import common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import myshop.domain.ProductDTO;
import myshop.model.ProductDAO;
import myshop.model.ProductDAO_imple;

public class ProdView extends AbstractController {
	private ProductDAO pdDao;
	public ProdView(){
		pdDao = new ProductDAO_imple();
	}


	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		//super.goBackURL(request); //HttpSession session에 "goBackURL"이라는 키값으로 현재 상품페이지 정보 URL 값을 저장해둠
		
		
		//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
		// **** GET 방식을 막는 또 다른 방법 ==> 웹브라우저 주소창에서 직접입력하지 못하게 막아버리면 된다. **** //
		//이것의 단점은 웹브라우저에서 북마크(즐겨찾기)를 했을 경우 접속이 안된다는 것이다.
		//왜냐하면 이전 페이지가 없이 웹브라우저 주소창에서 직접입력한 것과 동일하기 때문이다.
		
		String referer = request.getHeader("referer");
		
		//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
		/*  request.getHeader("Referer"); 은
        현재 페이지 주소인 http://localhost:9090/MyMVC/shop/prodView.up 페이지 주소로 접근하려고 시도하였던 
		이전 페이지 URL 주소를 알려주는 것이다.
      
		request.getHeader("Referer"); 값이 null 이 나오는 경우가 있는데 
		이것은 사용자가 웹브라우저 주소창에 URL주소 (http://localhost:9090/MyMVC/shop/prodView.up?pnum=62) 와 같이 직접 입력하고 들어온 경우이다. 
		System.out.println("확인용 referer: "+referer);
		 */
		if(referer == null) {
			// referer가 null값인 경우는 키보드로 URL을 입력받은 경우임!
			super.setRedirect(true);
			super.setViewPage(request.getContextPath()+"/index.up");
			return;
		}
		
		String pnum = request.getParameter("pnum");
		//System.out.println("확인용 pnum: " +pnum);
		
		//제품번호를 가지고서 해당 제품의 정보를 조회해오기
		ProductDTO proDto = pdDao.selectOneProductByPnum(pnum);
		
		//제품번호를 이용해 해당 제품의 추가된 이미지 정보를 조회해오기
		List<String> imgList = pdDao.getImagesByPnum(pnum);
		proDto.setImgList(imgList);
		
		request.setAttribute("proDto", proDto);

		super.setRedirect(false);
		super.setViewPage("/WEB-INF/myshop/prodView.jsp");
		
		
	}//execute()-----

}
