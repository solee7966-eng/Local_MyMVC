package myshop.controller;

import java.util.Map;

import org.json.JSONObject;

import common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import myshop.model.ProductDAO;
import myshop.model.ProductDAO_imple;

public class LikeDislikeCount extends AbstractController {
	private ProductDAO proDao = new ProductDAO_imple();
	
	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String pnum = request.getParameter("pnum");
		//System.out.println(pnum);
		
		Map<String, Integer> map = proDao.getLikeDislikeCount(pnum);
		
		JSONObject jsonObj = new JSONObject();
		
		jsonObj.put("likecnt", map.get("likecnt"));
		jsonObj.put("dislikecnt", map.get("dislikecnt"));
		
		String json = jsonObj.toString(); // "{"likecnt":1, "dislikecnt":0}"
		
		request.setAttribute("json", json);
		
		super.setRedirect(false);
		super.setViewPage("/WEB-INF/jsonview.jsp");
	}//end of execute()-----

}
