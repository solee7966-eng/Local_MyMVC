package myshop.controller;

import java.util.List;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONObject;

import common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import myshop.model.ProductDAO;
import myshop.model.ProductDAO_imple;

public class MyPurchase_byCategoryJSON extends AbstractController {
	private ProductDAO proDao = new ProductDAO_imple();
	
	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		//=== 로그인 유무 검사하기 === //
		//나의 카테고리별주문 통계 보기는 반드시 해당사용자가 로그인을 해야만 볼 수 있다.
		if(!super.checkLogin(request)) {
			//로그인 하지 않은 경우이라면
	         
	        request.setAttribute("message", "나의 카테고리별주문 통계를 보려면 먼저 로그인 부터 하세요!!");
	        request.setAttribute("loc", "javascript:history.back()"); 
	        
	        super.setRedirect(false);
	        super.setViewPage("/WEB-INF/msg.jsp");
	        return; // 종료
	        
		} else { // 로그인 한 경우이라면 
			String userid = request.getParameter("userid");
			//System.out.println(userid);
			
			//나의 카테고리별주문 통계정보 알아오기
			List<Map<String, String>> myPurchase_map_List =  proDao.myPurchase_byCategory(userid);
			JSONArray json_arr = new JSONArray();
			
			if(myPurchase_map_List.size() > 0 ) {
				for(Map<String, String> map : myPurchase_map_List) {
					JSONObject json_obj = new JSONObject();
					String cname = map.get("cname");
		            String cnt = map.get("cnt");
		            String sumpay = map.get("sumpay");
		            String sumpay_pct = map.get("sumpay_pct");
		            
		            //System.out.println(cname+" "+cnt+" "+sumpay+" "+sumpay_pct);
		            
		            json_obj.put("cname", cname);
		            json_obj.put("cnt", cnt);
		            json_obj.put("sumpay", sumpay);
		            json_obj.put("sumpay_pct", sumpay_pct);
		            
					json_arr.put(json_obj);
					
				}//end of for()-----
			}
			String json = json_arr.toString();
			
			request.setAttribute("json", json);
			
	        super.setRedirect(false);
	        super.setViewPage("/WEB-INF/jsonview.jsp");
		}
	}

}
