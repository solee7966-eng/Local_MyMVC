package myshop.controller;

import java.util.HashMap;
import java.util.Map;

import org.json.JSONObject;

import common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import myshop.model.ProductDAO;
import myshop.model.ProductDAO_imple;

public class LikeAdd extends AbstractController {
	private ProductDAO proDao = new ProductDAO_imple(); 
	
	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String pnum = request.getParameter("pnum");
		String userid = request.getParameter("userid");
	      
		Map<String,String> paraMap = new HashMap<>();
		paraMap.put("pnum", pnum);
		paraMap.put("userid", userid);
		
		//System.out.println(pnum);
		//System.out.println(userid);
		
		int n = proDao.likeAdd(paraMap);
		// n => 1 이라면 정상투표,  n => 0 이라면 중복투표
		
		String msg = "";
		
		if(n==1) {
		   msg = "해당제품에\n 좋아요를 클릭하셨습니다.";
		}
		else {
		   msg = "이미 좋아요를 클릭하셨기에\n 두번 이상 좋아요는 불가합니다.";
		}
		
		JSONObject jsonObj = new JSONObject();
		jsonObj.put("msg", msg); // {"msg":"해당제품에\n 좋아요를 클릭하셨습니다."}{"msg":"이미 좋아요를 클릭하셨기에\n 두번 이상 좋아요는 불가합니다."} 
		
		
		String json = jsonObj.toString(); // "{"msg":"해당제품에\n 좋아요를 클릭하셨습니다."}" "{{"msg":"이미 좋아요를 클릭하셨기에\n 두번 이상 좋아요는 불가합니다."}}" 
		
		//System.out.println("1"+json);
		
		request.setAttribute("json", json);
		
		super.setRedirect(false);
		super.setViewPage("/WEB-INF/jsonview.jsp");
		
		
	}//end of execute()-----

}
