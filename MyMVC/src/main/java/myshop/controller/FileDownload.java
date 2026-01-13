package myshop.controller;

import java.io.File;
import java.io.FileInputStream;
import java.net.URLEncoder;
import java.util.Map;

import common.controller.AbstractController;
import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletOutputStream;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import myshop.model.ProductDAO;
import myshop.model.ProductDAO_imple;

public class FileDownload extends AbstractController {
	private ProductDAO pdDao;
	public FileDownload(){
		pdDao = new ProductDAO_imple();
	}
	
	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String pnum = request.getParameter("pnum");
		
		// **** 시스템에 업로드 되어진 파일설명서 첨부파일명 및 오리지널파일명 알아오기 **** //
		Map<String, String> map = pdDao.getPrdmanualFileName(pnum);
		
		HttpSession session = request.getSession();
		
		// 다운로드 할 파일의 경로를 구하고 File 객체를 생성함  
		ServletContext svlCtx = session.getServletContext();
		String uploadFileDir = svlCtx.getRealPath("/images");
		//System.out.println("=== 첨부되어지는 이미지 파일이 올라가는 실제경로 uploadFileDir ==> " + uploadFileDir);
		// === 첨부되어지는 이미지 파일이 올라가는 실제경로
		//uploadFileDir ==> C:\NCS\workspace_jsp\.metadata\.plugins\org.eclipse.wst.server.core\tmp0\wtpwebapps\MyMVC\images
		
		//File 객체 생성하기
		String pathName = uploadFileDir + File.separator + map.get("PRDMANUAL_SYSTEMFILENAME");
		//map.get("PRDMANUAL_SYSTEMFILENAME") 은 파일서버에 업로드 되어진 제품설명서 파일명임.
		
		File file = new File(pathName);
		
		//MIME TYPE 설정하기 
		//(구글에서 검색어로 MIME TYPE 을 해보면 MIME TYPE에 따른 문서종류가 쭉 나온다)
		String mimeType = svlCtx.getMimeType(pathName);
		//System.out.println("~~~~ 확인용 mimeType => " + mimeType);
		//~~~~ 확인용 mimeType => application/pdf  => 확장자가 .pdf
		//~~~~ 확인용 mimeType => image/jpeg		 => 확장자가 .jpeg
		//~~~~ 확인용 mimeType => application/vnd.openxmlformats-officedocument.spreadsheetml.sheet  => 엑셀파일
		
		if(mimeType == null) {
			mimeType = "application/octet-stream";
			//"application/octet-stream" 은 일반적으로 잘 알려지지 않은 모든 종류의 이진 데이터를 뜻하는 것임.
		}

		response.setContentType(mimeType);

		// 다운로드 되어질 파일명 알아와서 설정해주기
		String prdmanual_orginfilename = map.get("PRDMANUAL_ORGINFILENAME");
		// map.get("PRDMANUAL_ORGINFILENAME")은 웹클라이언트의 웹브라우저에서 파일을 업로드 할때 올린 제품설명서 파일명임. 
		
		// prdmanual_orginfilename(다운로드 되어지는 파일명)이 한글일때  
		// 한글 파일명이 깨지지 않도록 하기위한 웹브라우저 별로 encoding 하기 및  다운로드 파일명 설정해주기
		String downloadFileName = "";
		String header = request.getHeader("User-Agent");
		
		if (header.contains("Edge")){
		downloadFileName = URLEncoder.encode(prdmanual_orginfilename, "UTF-8").replaceAll("\\+", "%20");
			response.setHeader("Content-Disposition", "attachment;filename=" + downloadFileName);
		} else if (header.contains("MSIE") || header.contains("Trident")) { // IE 11버전부터는 Trident로 변경됨.
			downloadFileName = URLEncoder.encode(prdmanual_orginfilename, "UTF-8").replaceAll("\\+", "%20");
			response.setHeader("Content-Disposition", "attachment;filename=" + downloadFileName);
		} else if (header.contains("Chrome")) {
			downloadFileName = new String(prdmanual_orginfilename.getBytes("UTF-8"), "ISO-8859-1");
			response.setHeader("Content-Disposition", "attachment; filename=" + downloadFileName);
		} else if (header.contains("Opera")) {
			downloadFileName = new String(prdmanual_orginfilename.getBytes("UTF-8"), "ISO-8859-1");
			response.setHeader("Content-Disposition", "attachment; filename=" + downloadFileName);
		} else if (header.contains("Firefox")) {
			downloadFileName = new String(prdmanual_orginfilename.getBytes("UTF-8"), "ISO-8859-1");
			response.setHeader("Content-Disposition", "attachment; filename=" + downloadFileName);
		}
		
		// *** 다운로드할 요청 파일을 읽어서 클라이언트로 파일을 전송하기 *** //
		//실제 파일을 읽어오는 객체
	    FileInputStream finStream = new FileInputStream(file);
	    // 1 byte 기반 파일 입력 노드스트림 생성

	    ServletOutputStream srvOutStream = response.getOutputStream();
	    // 1byte 기반 파일 출력 노드스트림 생성 
	    // ServletOutputStream 은 바이너리 데이터를 웹 브라우저로 전송할 때 사용함.
		
	    
	    byte arrb[] = new byte[4096]; //한 번 읽을 때 4KB씩 읽기(이 크기는 개발자 취향 /8KB)
		int data_length = 0;
		
		//위에서 정의한대로 4KB씩 읽어오다가 다 읽고 더 이상 읽을 내용이 없다면 -1을 반환함
		while( (data_length = finStream.read(arrb, 0, arrb.length)) != -1 ) {
		   srvOutStream.write(arrb, 0, data_length);
		}// end of while-------------------------
		
		srvOutStream.flush();
		
		srvOutStream.close(); // 자원반납
		finStream.close();    // 자원반납
		
	}//end of execute()-----

}
