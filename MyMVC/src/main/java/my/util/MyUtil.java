package my.util;

import jakarta.servlet.http.HttpServletRequest;

public class MyUtil {
	// *** URL 주소에서 ? 다음의 데이터까지 포함한 현재 URL 주소를 알려주는 메소드를 생성 *** //
	public static String getCurrentURL(HttpServletRequest request) {
		String currentURL = request.getRequestURL().toString();
		
		//System.out.println("currentURL: " +currentURL);
		//currentURL: http://localhost:9090/MyMVC/shop/prodView.up
		
		String queryString = request.getQueryString();
		//System.out.println("queryString: " +queryString);
		//queryString: pnum=119
		//queryString: null  ==> post 방식일 때
		
		if(queryString != null) {
			//GET 방식인 경우
			currentURL += "?"+queryString;
			//System.out.println("currentURL: " +currentURL);
			//currentURL: http://localhost:9090/MyMVC/shop/prodView.up?pnum=119
		}
		
		String ctxPath = request.getContextPath();
		int beginIndex = currentURL.indexOf(ctxPath) + ctxPath.length();
		//21(http://localhost:9090) + 6(/MyMVC)
		
		currentURL = currentURL.substring(beginIndex);
		//System.out.println("currentURL: " + currentURL);
		//shop/prodView.up?pnum=119
		
		return currentURL;
	}
}
