package myshop.controller;

import java.util.List;

import org.json.JSONArray;
import org.json.JSONObject;

import common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import myshop.domain.CategoryDTO;
import myshop.model.ProductDAO;
import myshop.model.ProductDAO_imple;

public class CategoryListJSON extends AbstractController {
	private ProductDAO pdDao;
	public CategoryListJSON(){
		pdDao = new ProductDAO_imple();
	}
	
	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		List<CategoryDTO> categoryList = pdDao.getCategoryList();
		
		JSONArray jsonArr = new JSONArray(); // []
	      
	      if(categoryList.size() > 0) {
	         // DB에서 조회해온 결과물이 있을 경우
	         
	         for(CategoryDTO cvo : categoryList) {
	            JSONObject jsonObj = new JSONObject(); // {}
	            jsonObj.put("cnum", cvo.getCnum());   // {"cnum":1}
	            jsonObj.put("code", cvo.getCode());   // {"cnum":1, "code":"100000"} 
	            jsonObj.put("cname", cvo.getCname()); // {"cnum":1, "code":"100000", "cname":"전자제품"}  

	            jsonArr.put(jsonObj);  // [{"cnum":1, "code":"100000", "cname":"전자제품"},
	                                   //  {"cnum":2, "code":"200000", "cname":"의류"},
	                                   //  {"cnum":3, "code":"300000", "cname":"도서"}]
	         	}// end of for------------------------
	         
	      }// end of if-----------------------------
	      
	      String json = jsonArr.toString(); // 문자열로 변환 
	      // 데이터가 없을시 "[]" 로 된다.
	      
	      //System.out.println("~~~ 확인용 json => " + json);
	      /*
	      ~~~ 확인용 json => [{"code":"100000","cname":"전자제품","cnum":1},
	      					{"code":"200000","cname":"의류","cnum":2},
	      					{"code":"300000","cname":"도서","cnum":3}]
	      */
	      request.setAttribute("json", json);
	      
	      //super.setRedirect(false);
	      super.setViewPage("/WEB-INF/jsonview.jsp");
	}

}
