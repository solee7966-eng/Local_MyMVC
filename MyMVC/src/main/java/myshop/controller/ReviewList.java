package myshop.controller;

import java.util.List;

import org.json.JSONArray;
import org.json.JSONObject;

import common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import myshop.domain.PurchaseReviewsDTO;
import myshop.model.ProductDAO;
import myshop.model.ProductDAO_imple;

public class ReviewList extends AbstractController {
	private ProductDAO proDao = new ProductDAO_imple();
	
	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String fk_pnum = request.getParameter("fk_pnum"); // 제품번호
	      
		List<PurchaseReviewsDTO> reviewList = proDao.reviewList(fk_pnum);
		
		JSONArray jsArr = new JSONArray(); // []
	      
	      if(reviewList.size() > 0) {
	         for(PurchaseReviewsDTO reviewsDto : reviewList) {
	            JSONObject jsonObj = new JSONObject();
	            jsonObj.put("contents", reviewsDto.getContents()); 
	            jsonObj.put("name", reviewsDto.getmDto().getName());
	            jsonObj.put("writeDate", reviewsDto.getWriteDate());
	            jsonObj.put("userid", reviewsDto.getFk_userid());
	            jsonObj.put("review_seq", reviewsDto.getReview_seq());
	            
	            jsArr.put(jsonObj);
	         }//end of for()---
	         
	      }//end of if()----
	      
	      String json = jsArr.toString();  // 문자열 형태로 변환해줌.
	      
	      //System.out.println(json);
	      request.setAttribute("json", json);
	      
	      super.setRedirect(false);
	      super.setViewPage("/WEB-INF/jsonview.jsp");
		
	}//end of execute()-----

}
