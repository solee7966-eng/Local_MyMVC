package index.controller;

import java.sql.SQLException;
import java.util.List;

import common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import myshop.domain.ImageDTO;
import myshop.model.ProductDAO;
import myshop.model.ProductDAO_imple;

public class IndexController extends AbstractController {
	// 필드를 불러오면서 생성해도 되고,
	// private ProductDAO pdDao = new ProductDAO_imple();
	//-- 또는
	// 기본생성자를 이용해 생성해도 됨
	private ProductDAO pdDao;
	public IndexController() {pdDao = new ProductDAO_imple();}
	
	
	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		try {
			List<ImageDTO> imgList = pdDao.imageSelectAll();
			request.setAttribute("imgList", imgList);
			
			// System.out.println(imgList.size());
			
			super.setRedirect(false);
			super.setViewPage("/WEB-INF/index.jsp");
			
		} catch (SQLException e) {
			e.printStackTrace();
			super.setRedirect(true);
			super.setViewPage(request.getContextPath()+"/error.up");
		}
	}//end of execute()-----

}
