package myshop.controller;

import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.JSONObject;

import common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import mail.controller.GoogleMail;
import member.domain.MemberDTO;
import myshop.domain.ProductDTO;
import myshop.model.ProductDAO;
import myshop.model.ProductDAO_imple;

public class OrderAdd extends AbstractController {
	private ProductDAO proDao = new ProductDAO_imple();
	
	
	// === 전표(주문코드)를 생성해주는 메소드 생성하기 === //
	private String getOdrcode() {
		// 전표(주문코드) 형식 : s+날짜+sequence
		
		// 날짜 생성
	    Date now = new Date();
	    SimpleDateFormat smdatefm = new SimpleDateFormat("yyyyMMdd"); 
	    String today = smdatefm.format(now);
	    //20260115
	    
	    int seq = 0;
	    try {
	    	// pdao.get_seq_tbl_order(); 는 시퀀스 seq_tbl_order 값("주문코드(명세서번호) 시퀀스")을 채번해오는 것.
	    	seq = proDao.get_seq_tbl_order();
			
		} catch (SQLException e) {
			e.printStackTrace();
		}
	    
		return "s"+today+"-"+seq;
	}//end of private String getOdrcode()-----
	
	
	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String method = request.getMethod();
	      
		if(!"POST".equalsIgnoreCase(method)) {
			//GET 방식이라면
			String message = "비정상적인 경로로 들어왔습니다";
			String loc = "javascript:history.back()";
	         
			request.setAttribute("message", message);
			request.setAttribute("loc", loc);
	         
			super.setViewPage("/WEB-INF/msg.jsp");
			return;
			
		} else if("POST".equalsIgnoreCase(method) && super.checkLogin(request)) {
			//POST 방식이로 로그인을 했다면
			//String cartno = request.getParameter("cartno");
			
			String totalPrice = request.getParameter("n_sum_totalPrice");		//주문총액
			String totalPoint = request.getParameter("n_sum_totalPoint");		//포인트총액
			String str_pnum_join = request.getParameter("str_pnum_join");			//제품번호를 문자열로 합한 것
			String str_oqty_join = request.getParameter("str_oqty_join");			//주문량을 문자열로 합한 것
			String str_totalPrice_join = request.getParameter("str_totalPrice_join");	//주문가격을 합한 것
			String str_cartno_join = request.getParameter("str_cartno_join");		//장바구니 번호를 합한 것
	        
			System.out.println(totalPrice+"\n"+      //596000
					totalPoint+"\n"+                 //650
					str_pnum_join+"\n"+              //119,68,65
					str_oqty_join+"\n"+              //8,4,2
					str_totalPrice_join+"\n"+        //96000,480000,20000
					str_cartno_join);                //7,5,4
			
			// ===== Transaction 처리하기 ===== //
	        // 1. 주문 테이블에 입력되어야할 주문전표를 채번(select)하기  
	        // 2. 주문 테이블에 채번해온 주문전표, 로그인한 사용자, 현재시각을 insert 하기(수동커밋처리) 
	        // 3. 주문상세 테이블에 채번해온 주문전표, 제품번호, 주문량, 주문금액을 insert 하기(수동커밋처리) 
	        // 4. 제품 테이블에서 제품번호에 해당하는 잔고량을 주문량 만큼 감하기 update 하기(수동커밋처리)
	                 
	        // 5. 장바구니 테이블에서 str_cartno_join 값에 해당하는 행들을 삭제(delete)하기(수동커밋처리)
	        // >> 장바구니에서 주문을 한 것이 아니라 특정제품을 바로주문하기를 한 경우에는 장바구니 테이블에서 행들을 삭제할 작업은 없다. <<
	                 
	        // 6. 회원 테이블에서 로그인한 사용자의 coin 액을 sum_totalPrice 만큼 감하고, point 를 sum_totalPoint 만큼 더하기(update)(수동커밋처리) 
	        // 7. **** 모든처리가 성공되었을시 commit 하기(commit) **** 
	        // 8. **** SQL 장애 발생시 rollback 하기(rollback) ****
	                 
	        // === Transaction 처리가 성공시 세션에 저장되어져 있는 loginuser 정보를 새로이 갱신하기 ===
	        // === 주문이 완료되었을시 주문이 완료되었다라는 email 보내주기  === //
			
			Map<String, Object> paraMap = new HashMap<>();
			
			// === 주문테이블(tbl_order)에 insert 할 데이터 ===
			String odrcode = getOdrcode();
			//getOdrcode() 메소드는 위에서 정의한 전표(주문코드)를 생성해주는 것이다. 
			
			
			HttpSession session = request.getSession();
			MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
			paraMap.put("odrcode", odrcode); //주문코드(명세서번호) s+날짜+sequence
			paraMap.put("userid", loginUser.getUserid()); //회원아이디
			paraMap.put("totalPrice", totalPrice); //주문총액
			paraMap.put("totalPoint", totalPoint); //주문총포인트
			
			// === 주문상세테이블(tbl_orderdetail)에 insert 할 데이터 ===
			String[] arr_pnum = str_pnum_join.split("\\,"); //여러 개 제품을 주문한 경우
															//장바구니에서 제품 1개만 주문한 경우
															//특정제품을 바로 주문하기 한 경우
			String[] arr_oqty = str_oqty_join.split("\\,");
			String[] arr_totalPrice = str_totalPrice_join.split("\\,");
			
			paraMap.put("arr_pnum", arr_pnum); //제품번호
			paraMap.put("arr_oqty", arr_oqty); //제품 주문량
			paraMap.put("arr_totalPrice", arr_totalPrice); //제품당 가격
			
			
			// === 장바구니테이블(tbl_cart)에 delete 할 데이터 ===
			if(str_cartno_join != null) {
				//특정제품을 바로주문하기를 한 경우라면 str_cartno_join 의 값은 null 이 된다.
				String[] arr_cartno = str_cartno_join.split("\\,");
				paraMap.put("arr_cartno", arr_cartno); //삭제해야 할 장바구니 번호
			}
			
			// *** Transaction 처리를 해주는 메소드 호출하기 *** //
			int isSuccess = proDao.orderAdd(paraMap);
			
			//주문이 완료되었을시 세션에 저장되어져 있는 loginuser 정보를 갱신하고
	        // 이어서 주문이 완료되었다라는 email 보내주기
			if(isSuccess == 1) {
				// === 세션에 저장되어져 있는 loginuser 정보를 갱신하기 ===
				loginUser.setCoin(loginUser.getCoin()- Integer.parseInt(totalPrice));
				loginUser.setPoint(loginUser.getPoint()+ Integer.parseInt(totalPoint));
				
				
				////////// === 주문이 완료되었다는 email 보내기 시작 === ///////////
				GoogleMail mail = new GoogleMail();
				
				StringBuilder sb = new StringBuilder();
				sb.append("주문코드번호 : <span style='color: blue; font-weight: bold;'>"+odrcode+"</span><br><br>");
				sb.append("<주문상품><br>");
				
				//----------------------------//
				//str_pnum_join: 119,68,65
				
				String pnums = "'" + String.join("','", str_pnum_join.split("\\,")) + "'";
				//{"119","68","65"} => 처음은 문자열 형태의 배열
				//119','68','65 => 맨앞뒤에 ' 가 없음
				//'119','68','65' => 하나의 문자열 상태가 됨!
				
				System.out.println("확인용 주문한 제품번호 pnums: "+pnums);
				
				// 주문한 제품에 대해 email 보내기시 email 내용에 넣을 주문한 제품번호들에 대한 제품정보를 얻어오는 것.
				List<ProductDTO> jumunProductList = proDao.getJumunProductList(pnums);
				
				for(int i=0; i<jumunProductList.size(); i++) {
					sb.append(jumunProductList.get(i).getPname()+"&nbsp;"+arr_oqty[i]+"개&nbsp;&nbsp;");
					sb.append("<img src='http://127.0.0.1:9090/MyMVC/images/"+jumunProductList.get(i).getPimage1()+"'/>");
					sb.append("<br>");
				}//end of for()-----
				sb.append("<br>이용해 주셔서 감사합니다.");
				String emailContents = sb.toString();
				//----------------------------//
				
				mail.sendmail_OrderFinish(loginUser.getEmail(), loginUser.getName(), emailContents);
				
				////////// === 주문이 완료되었다는 email 보내기 끝 === ///////////
			}//end of if(isSuccess == 1)-----
			
			

	        JSONObject jsobj = new JSONObject(); // {}
	        jsobj.put("isSuccess", isSuccess); // 성공:{"isSuccess":1}  실패:{"isSuccess":0} 
	        
	        String json = jsobj.toString(); //json 객체를 문자열로 변환
	        request.setAttribute("json", json);
	        
	        super.setRedirect(false);
	        super.setViewPage("/WEB-INF/jsonview.jsp");
		}
		
	}//end of execute()-----

	
}
