package myshop.controller;

import java.sql.SQLIntegrityConstraintViolationException;

import org.json.JSONObject;

import common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import myshop.domain.PurchaseReviewsDTO;
import myshop.model.ProductDAO;
import myshop.model.ProductDAO_imple;

public class ReviewRegister extends AbstractController {
	private ProductDAO proDao = new ProductDAO_imple();
	
	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String method = request.getMethod();
	      
		if("POST".equalsIgnoreCase(method)) {
	        // **** POST 방식으로 넘어온 것이라면 **** //
			String fk_userid = request.getParameter("fk_userid");
			String fk_pnum = request.getParameter("fk_pnum");
			String contents = request.getParameter("contents");

			// **** 크로스 사이트 스크립트 공격에 대응하는 안전한 코드(시큐어 코드) 작성하기 **** // 
	        contents = contents.replaceAll("<", "&lt;");
	        contents = contents.replaceAll(">", "&gt;");
	        
	        // 입력한 내용에서 엔터는 <br>로 변환시키기
	        contents = contents.replaceAll("\r\n", "<br>");
	         
	        PurchaseReviewsDTO reviewDto = new PurchaseReviewsDTO();
	        reviewDto.setFk_userid(fk_userid);
	        reviewDto.setFk_pnum(Integer.parseInt(fk_pnum));
	        reviewDto.setContents(contents);

	        int n = 0;
	        
			try {
				n = proDao.addReview(reviewDto);
			} catch (SQLIntegrityConstraintViolationException e) {
				//해당 예외처리는 제약 조건에 걸렸을 때를 검사
				// 제약조건에 위배된 경우 (동일한 제품에 대하여 동일한 회원이 제품후기를 2번 쓴 경우 unique 제약에 위배됨)
				e.printStackTrace();
				n = -1;
			} catch (Exception e) {
				e.printStackTrace();
			}
			
			JSONObject jsonObj = new JSONObject();
			jsonObj.put("n", n); 
			
			String json = jsonObj.toString(); // "{"n":"1"}" "{"n":"-1"}" "{"n":"0"}" 
			request.setAttribute("json", json);
			
			super.setRedirect(false);
			super.setViewPage("/WEB-INF/jsonview.jsp");
			
		} else {
			
	        // **** POST 방식으로 넘어온 것이 아니라면 **** //
	        
	        String message = "비정상적인 경로를 통해 들어왔습니다.!!";
	        String loc = "javascript:history.back()";
	        
	        request.setAttribute("message", message);
	        request.setAttribute("loc", loc);
	        
	        super.setRedirect(false);
	        super.setViewPage("/WEB-INF/msg.jsp");
		}
		
		
		
		
	}//end of execute()-----

}
