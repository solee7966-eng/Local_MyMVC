package myshop.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONObject;

import common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import myshop.domain.ProuctDTO;
import myshop.model.ProductDAO;
import myshop.model.ProductDAO_imple;

public class MallDisplayJSON extends AbstractController {
	private ProductDAO pdDao;
	public MallDisplayJSON(){
		pdDao = new ProductDAO_imple();
	}
	
	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String sname = request.getParameter("sname");
		String start = request.getParameter("start");
		String len = request.getParameter("len");
		/*
	       맨 처음에는 sname("HIT")상품을  start("1") 부터 len("8")개를 보여준다.
	       더보기... 버튼을 클릭하면  sname("HIT")상품을  start("9") 부터 len("8")개를 보여준다.
	       또  더보기... 버튼을 클릭하면 sname("HIT")상품을  start("17") 부터 len("8")개를 보여준다.      
	    */
		Map<String, String> paraMap = new HashMap<String, String>();
		paraMap.put("sname", sname); //"HIT"  "NEW"  "BEST"
		paraMap.put("start", start); //start "1" "9" "17" "25" "33"
		
		//end = start + len - 1
		//end => 1 + 8 - 1 = 8
		//end => 9 + 8 - 1 = 16
		//end => 17 + 8 - 1 = 24
		//end => 25 + 8 - 1 = 32
		String end = String.valueOf((Integer.parseInt(start) + Integer.parseInt(len) - 1));
		paraMap.put("end", end);
		
		List<ProuctDTO> productList = pdDao.selectBySpecName(paraMap);
		
		//json 형태의 배열로 변환해주기
		JSONArray jsonArr = new JSONArray(); // []
		if(productList.size() > 0) {
			//DB에서 조회해온 결과물이 있는 경우
			for(ProuctDTO proDto : productList ) {
				JSONObject jsonObj = new JSONObject();
				jsonObj.put("pnum", proDto.getPnum());
				jsonObj.put("pname", proDto.getPname());
				jsonObj.put("cname", proDto.getCategdto().getCname());
				jsonObj.put("pcompany", proDto.getPcompany());
				jsonObj.put("pimage1", proDto.getPimage1());
				jsonObj.put("pimage2", proDto.getPimage2());
				jsonObj.put("pqty", proDto.getPqty());
				jsonObj.put("price", proDto.getPrice());
				jsonObj.put("saleprice", proDto.getSaleprice());
	            jsonObj.put("sname", proDto.getSpdto().getSname());
	            jsonObj.put("pcontent", proDto.getPcontent());
	            jsonObj.put("point", proDto.getPoint());
	            jsonObj.put("pinputdate", proDto.getPinputdate());
	            jsonObj.put("discountPercent", proDto.getDiscountPercent());
	            //jsonObj ==> {"pnum":36, "pname":"노트북30", "cname":"전자제품"... "pinputdate":"2026-01-06"}
	            
	            jsonArr.put(jsonObj);
			}//end of for()-----
			
		}//end of if()-----
		
		String json = jsonArr.toString();
		//System.out.println("확인용 json: " +json);
		/*
		확인용 json: [{"pnum":98,"discountPercent":17,"pname":"노트북30","pcompany":"삼성전자","cname":"전자제품","saleprice":1000000,"point":60,"pinputdate":"2026-01-06","pimage1":"59.jpg","pqty":100,"pimage2":"60.jpg","pcontent":"30번 노트북","price":1200000,"sname":"HIT"},
		           {"pnum":97,"discountPercent":17,"pname":"노트북29","pcompany":"레노버","cname":"전자제품","saleprice":1000000,"point":60,"pinputdate":"2026-01-06","pimage1":"57.jpg","pqty":100,"pimage2":"58.jpg","pcontent":"29번 노트북","price":1200000,"sname":"HIT"},
		           {"pnum":96,"discountPercent":17,"pname":"노트북28","pcompany":"아수스","cname":"전자제품","saleprice":1000000,"point":60,"pinputdate":"2026-01-06","pimage1":"55.jpg","pqty":100,"pimage2":"56.jpg","pcontent":"28번 노트북","price":1200000,"sname":"HIT"},
		           {"pnum":95,"discountPercent":17,"pname":"노트북27","pcompany":"애플","cname":"전자제품","saleprice":1000000,"point":60,"pinputdate":"2026-01-06","pimage1":"53.jpg","pqty":100,"pimage2":"54.jpg","pcontent":"27번 노트북","price":1200000,"sname":"HIT"},
		           {"pnum":94,"discountPercent":17,"pname":"노트북26","pcompany":"MSI","cname":"전자제품","saleprice":1000000,"point":60,"pinputdate":"2026-01-06","pimage1":"51.jpg","pqty":100,"pimage2":"52.jpg","pcontent":"26번 노트북","price":1200000,"sname":"HIT"},
		           {"pnum":93,"discountPercent":17,"pname":"노트북25","pcompany":"삼성전자","cname":"전자제품","saleprice":1000000,"point":60,"pinputdate":"2026-01-06","pimage1":"49.jpg","pqty":100,"pimage2":"50.jpg","pcontent":"25번 노트북","price":1200000,"sname":"HIT"},
		           {"pnum":92,"discountPercent":17,"pname":"노트북24","pcompany":"한성컴퓨터","cname":"전자제품","saleprice":1000000,"point":60,"pinputdate":"2026-01-06","pimage1":"47.jpg","pqty":100,"pimage2":"48.jpg","pcontent":"24번 노트북","price":1200000,"sname":"HIT"},
		           {"pnum":91,"discountPercent":17,"pname":"노트북23","pcompany":"DELL","cname":"전자제품","saleprice":1000000,"point":60,"pinputdate":"2026-01-06","pimage1":"45.jpg","pqty":100,"pimage2":"46.jpg","pcontent":"23번 노트북","price":1200000,"sname":"HIT"}]
		*/
		/*
		확인용 json: [{"pnum":90,"discountPercent":17,"pname":"노트북22","pcompany":"에이서","cname":"전자제품","saleprice":1000000,"point":60,"pinputdate":"2026-01-06","pimage1":"43.jpg","pqty":100,"pimage2":"44.jpg","pcontent":"22번 노트북","price":1200000,"sname":"HIT"},
					{"pnum":89,"discountPercent":17,"pname":"노트북21","pcompany":"한성컴퓨터","cname":"전자제품","saleprice":1000000,"point":60,"pinputdate":"2026-01-06","pimage1":"41.jpg","pqty":100,"pimage2":"42.jpg","pcontent":"21번 노트북","price":1200000,"sname":"HIT"},
					{"pnum":88,"discountPercent":17,"pname":"노트북20","pcompany":"LG전자","cname":"전자제품","saleprice":1000000,"point":60,"pinputdate":"2026-01-06","pimage1":"39.jpg","pqty":100,"pimage2":"40.jpg","pcontent":"20번 노트북","price":1200000,"sname":"HIT"},
					{"pnum":87,"discountPercent":17,"pname":"노트북19","pcompany":"LG전자","cname":"전자제품","saleprice":1000000,"point":60,"pinputdate":"2026-01-06","pimage1":"37.jpg","pqty":100,"pimage2":"38.jpg","pcontent":"19번 노트북","price":1200000,"sname":"HIT"},
					{"pnum":86,"discountPercent":17,"pname":"노트북18","pcompany":"레노버","cname":"전자제품","saleprice":1000000,"point":60,"pinputdate":"2026-01-06","pimage1":"35.jpg","pqty":100,"pimage2":"36.jpg","pcontent":"18번 노트북","price":1200000,"sname":"HIT"},
					{"pnum":85,"discountPercent":17,"pname":"노트북17","pcompany":"레노버","cname":"전자제품","saleprice":1000000,"point":60,"pinputdate":"2026-01-06","pimage1":"33.jpg","pqty":100,"pimage2":"34.jpg","pcontent":"17번 노트북","price":1200000,"sname":"HIT"},
					{"pnum":84,"discountPercent":17,"pname":"노트북16","pcompany":"한성컴퓨터","cname":"전자제품","saleprice":1000000,"point":60,"pinputdate":"2026-01-06","pimage1":"31.jpg","pqty":100,"pimage2":"32.jpg","pcontent":"16번 노트북","price":1200000,"sname":"HIT"},
					{"pnum":83,"discountPercent":17,"pname":"노트북15","pcompany":"한성컴퓨터","cname":"전자제품","saleprice":1000000,"point":60,"pinputdate":"2026-01-06","pimage1":"29.jpg","pqty":100,"pimage2":"30.jpg","pcontent":"15번 노트북","price":1200000,"sname":"HIT"}]
		*/
		request.setAttribute("json", json);
		
		super.setRedirect(false);
		super.setViewPage("/WEB-INF/jsonview.jsp");
	}//end of execute()-----

}
