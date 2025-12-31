package common.controller;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebInitParam;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.lang.reflect.Constructor;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

@WebServlet(
		description = "사용자가 웹에서 *.up 을 했을 경우 이 서블릿이 응답을 해주도록 한다.", 
		urlPatterns = { "*.up" }, 
		initParams = { 
				@WebInitParam(name = "propertyConfig", value = "C:/NCS/workspace_jsp/MyMVC/src/main/webapp/WEB-INF/Command.properties", description = "*.up 에 대한 클래스의 매핑파일")
		})
public class FrontController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private Map<String, Object> cmdMap = new HashMap<>();

	public void init(ServletConfig config) throws ServletException {
/*
    웹브라우저 주소창에서 *.up 을 하면 FrontController 서블릿이 응대를 해오는데 
    맨 처음에 자동적으로 실행되어지는 메소드가 init(ServletConfig config)이다.
    여기서 중요한 것은 init(ServletConfig config) 메소드는 WAS(톰캣)가 구동되어진 후
    딱 1번만 init(ServletConfig config) 메소드가 실행되어지고, 그 이후에는 실행이 되지 않는다. 
    그러므로 init(ServletConfig config) 메소드에는 FrontController 서블릿이 동작해야할 환경설정을 잡아주는데 사용된다.
*/
		// *** 확인용 *** //
		// System.out.println("확인용: 서블릿 FrontController 의 init(ServletConfig config) 메서드가 실행됨.");
		// 확인용: 서블릿 FrontController 의 init(ServletConfig config) 메서드가 실행됨.
		
		// 특정 파일에 있는 내용을 읽어오기 위한 용도로 쓰이는 객체
		FileInputStream fis = null;
		String props = config.getInitParameter("propertyConfig");
		//System.out.println("확인용 props: " + props);
		// 확인용 props: C:/NCS/workspace_jsp/MyMVC/src/main/webapp/WEB-INF/Command.properties
	    try {
	    	// 실제 이 경로에 있는 파일을 읽어오게 됨!!
	    	// 즉, 여기선 fis가 Command.properties 파일의 내용을 읽어오는 객체이다!
			fis = new FileInputStream(props);
			
			// Properties 는 Collection 중 HashMap 계열중의 하나로써
	        // "key","value"으로 이루어져 있는것이다.
	        // 그런데 중요한 것은 Properties 는 key도 String 타입이고, value도 String 타입만 가능하다는 것이다.
	        // key는 중복을 허락하지 않는다. value 값을 얻어오기 위해서는 key값 만 알면 된다.
			Properties pr = new Properties();
			
	        // pr.load(fis); 은 fis 객체를 사용하여 C:/NCS/workspace_jsp/MyMVC/src/main/webapp/WEB-INF/Command.properties 파일의 내용을 읽어다가   
	        // Properties 클래스의 객체인 pr 에 로드시킨다.
	        // 그러면 pr 은 읽어온 파일(Command.properties)의 내용에서 
	        // = 을 기준으로 왼쪽은 key로 보고, 오른쪽은 value 로 인식한다.
			pr.load(fis);
			
	        // pr.keys(); 은 C:/NCS/workspace_jsp/MyMVC/src/main/webapp/WEB-INF/Command.properties 파일의 내용물에서 
	        // = 을 기준으로 왼쪽에 있는 모든 key 들만 가져오는 것이다.   
			Enumeration<Object> en = pr.keys();
			
			while(en.hasMoreElements()) {
				//en 에 값들이 있는가?
				String key = (String)en.nextElement();
				//System.out.println("확인용 key: " +key+ " | 확인용 value: " +pr.getProperty(key));
				// 확인용 key: /test/test2.up | 확인용 value: test.controller.Test2Controller
				// 확인용 key: /test3.up | 확인용 value: test.controller.Test3Controller
				// 확인용 key: /test1.up | 확인용 value: test.controller.Test1Controller
				
				String className = pr.getProperty(key);
				if(className != null) {
					className = className.trim();
					
					// <?> 은 generic 인데 어떤 클래스 타입인지는 모르지만 하여튼 클래스 타입이 들어온다는 뜻이다.
	                // String 타입으로 되어진 className 을 클래스화 시켜주는 것이다.
	                // 주의할 점은 실제로 String 으로 되어져 있는 문자열이 클래스로 존재해야만 한다는 것이다.
					Class<?> cls = Class.forName(className);
					
					// 생성자 만들기
					Constructor<?> construct = cls.getDeclaredConstructor();
					
					// 생성자로부터 실제 객체(인스턴스)를 생성해주는 것
					Object obj = construct.newInstance();
					// 각 클래스에서 기본생성자에 기술한 println() 구문이 출력되는 모습! => 즉, 각 클래스가 호출되었음
					// #확인용2: Test2Controller 클래스 생성자
					// $확인용3: Test3Controller 클래스 생성자
					// @확인용1: Test1Controller 클래스 생성자
					
					// 여기서 key 값은 URL 주소, obj 값은 각 클래스
					// cmdMap 속에 obj를 넣을 때 key는 Command.properties 파일에 있는 URL 주소를 사용!!
					cmdMap.put(key, obj);
				}//end of if()----- 
			}//end of while()-----
		}
	    catch (FileNotFoundException e) {e.printStackTrace();} 
	    catch (IOException e) {e.printStackTrace();}
	    catch (ClassNotFoundException e) {
	    	//Command.properties에는 정의했지만 실제로 만든 클래스가 없는 경우 예외처리
	    	System.out.println("문자열로 정의된 클래스가 존재하지 않습니다.");
	    	e.printStackTrace();
	    } catch (Exception e) {e.printStackTrace();} // 귀찮으니 모든 예외처리를 받아준다
	}//end of public void init(ServletConfig config) throws ServletException-----
	
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// 웹 브라우저 주소 입력창에서 http://localhost:9090/MyMVC/member/idDuplicateCheck.up?userid=leess 와 같이 입력되었더라면
		//String url = request.getRequestURL().toString();
		// System.out.println("확인용 url: " +url);
		// 확인용 url: http://localhost:9090/MyMVC/member/idDuplicateCheck.up
		// 확인용 url: http://localhost:9090/MyMVC/test1.up
		// 확인용 url: http://localhost:9090/MyMVC/test/test2.up
		// 확인용 url: http://localhost:9090/MyMVC/test3.up
		// ? 이후의 데이터는 출력되지 않는 모습!
		
		// 웹 브라우저 주소 입력창에서 http://localhost:9090/MyMVC/member/idDuplicateCheck.up?userid=leess 와 같이 입력되었더라면
		String uri = request.getRequestURI();
		//System.out.println("확인용 uri: " +uri);
		// 확인용 uri: /MyMVC/member/idDuplicateCheck.up
		// 확인용 uri: /MyMVC/test1.up
		// 확인용 uri: /MyMVC/test/test2.up
		// 확인용 uri: /MyMVC/test3.up
		// URI 는 contextPath 부터 나온다! URL처럼 http://localhost:9090 는 굳이 볼 필요 없어서 URI를 많이 사용한다고 함!
		
		
		// /member/idDuplicateCheck.up 처럼만 띄울 예정! ==> 즉, contextPath 는 출력하지 않기
		// 아래처럼 하면 /MyMVC 까지 잘리게 되고 그 이후 /부터 시작!
		String key = uri.substring(request.getContextPath().length());
		// /member/idDuplicateCheck.up
		// /test1.up
		// /test/test2.up
		// /test3.up

		
		AbstractController action = (AbstractController)cmdMap.get(key);
		if(action == null) {
			System.out.println(">> "+key+" 의 URI 패턴에 매핑된 클래스가 없습니다. <<");
		} else {
			try {
				// 이제 웹브라우저 입력창에 주소를 입력하면 그 주소에 매핑된 각 클래스의 execute() 메서드가 호출됨!!
				// 만약 존재하지 않는 주소를 입력하면 위의 action == null 조건에 걸리게 되어 해당 구문이 콘솔에 출력됨!!
				// 즉, 입력된 주소는 cmdMap에서 key 값이 되고 그 key 값과 매핑된 클래스가 Object 가 된다는 것!!
				action.execute(request, response);
				
				boolean bool = action.isRedirect();
				String viewPage = action.getViewPage();
				
				if(!bool) {
					// viewPage 에 명기된 view단 페이지로 forward(dispatcher)를 하겠다는 말이다.
	                // forward 되어지면 웹브라우저의 URL주소 변경되지 않고 그대로 이면서 화면에 보여지는 내용은 forward 되어지는 jsp 파일이다.
	                // 또한 forward 방식은 forward 되어지는 페이지로 데이터를 전달할 수 있다는 것이다.
					if(viewPage != null) {
						RequestDispatcher dispatcher = request.getRequestDispatcher(viewPage);
						dispatcher.forward(request, response);
					}
				} else {
					// viewPage 에 명기된 주소로 sendRedirect(웹브라우저의 URL주소 변경됨)를 하겠다는 말이다.
	                // 즉, 단순히 페이지이동을 하겠다는 말이다. 
	                // 암기할 내용은 sendRedirect 방식은 sendRedirect 되어지는 페이지로 데이터를 전달할 수가 없다는 것이다.
					if(viewPage != null) {response.sendRedirect(viewPage);}
				}
			} catch (Exception e) {e.printStackTrace();}
		}
		
	}//end of doGet()-----

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

	
	
}//end of public class FrontController extends HttpServlet-----
