package myshop.controller;

import java.util.HashMap;
import java.util.Map;

import org.json.JSONObject;

import common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import myshop.model.ProductDAO;
import myshop.model.ProductDAO_imple;

public class IsOrder extends AbstractController {
	private ProductDAO proDao = new ProductDAO_imple();

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String pnum = request.getParameter("pnum");
		String userid = request.getParameter("userid");
		
		
		Map<String, String> paraMap = new HashMap<>();
	      
		paraMap.put("pnum", pnum);
		paraMap.put("userid", userid);
	      
		boolean bool = proDao.isOrder(paraMap);
		
		JSONObject jsonObj = new JSONObject();
		jsonObj.put("isOrder", bool);
		
		String json = jsonObj.toString();
		request.setAttribute("json", json);
		
		super.setRedirect(false);
		super.setViewPage("/WEB-INF/jsonview.jsp");
	}//end of execute()-----

}
