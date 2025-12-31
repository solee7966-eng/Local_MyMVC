package mail.controller;

import java.util.Properties;
import javax.mail.*;
import javax.mail.internet.*;


public class GoogleMail {
	public void send_certification_code(String recipient, String certification_code) throws Exception { 
			// recipient: 수신자
			// certification_code: 인증코드
		
		// 1. 정보를 담기 위한 객체
	       Properties prop = new Properties(); 
	       
	       // 2. SMTP(Simple Mail Transfer Protocoal) 서버의 계정 설정
	       //    Google Gmail 과 연결할 경우 Gmail 의 email 주소를 지정 
	       prop.put("mail.smtp.user", "solee7966@gmail.com");
	             
	       // 3. SMTP 서버 정보 설정
	       //    Google Gmail 인 경우  smtp.gmail.com
	       prop.put("mail.smtp.host", "smtp.gmail.com");
	            
	       
	       prop.put("mail.smtp.port", "465");
	       prop.put("mail.smtp.starttls.enable", "true");
	       prop.put("mail.smtp.auth", "true");
	       prop.put("mail.smtp.debug", "true");
	       prop.put("mail.smtp.socketFactory.port", "465");
	       prop.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
	       prop.put("mail.smtp.socketFactory.fallback", "false");
	       
	       prop.put("mail.smtp.ssl.enable", "true");
	       prop.put("mail.smtp.ssl.trust", "smtp.gmail.com");
	       prop.put("mail.smtp.ssl.protocols", "TLSv1.2"); // MAC 에서도 이메일 보내기 가능하도록 한것임. 또한 만약에 SMTP 서버를 google 대신 naver 를 사용하려면 이것을 해주어야 함.
	         
	    /*  
	       혹시나 465 포트에 연결할 수 없다는 에러메시지가 나오면 아래의 3개를 넣어주면 해결된다.
	       prop.put("mail.smtp.starttls.enable", "true");
	       prop.put("mail.smtp.starttls.required", "true");
	       prop.put("mail.smtp.ssl.protocols", "TLSv1.2");
	    */ 
	       
	       Authenticator smtpAuth = new MySMTPAuthenticator();
	       Session ses = Session.getInstance(prop, smtpAuth);
	          
	       // 메일을 전송할 때 상세한 상황을 콘솔에 출력한다.
	       ses.setDebug(true);
	               
	       // 메일의 내용을 담기 위한 객체생성
	       MimeMessage msg = new MimeMessage(ses);

	       // 보내는 메일의 제목 설정
	       String subject = "localhost:9090/MyMVC/index.up 회원님의 비밀번호를 찾기위한 인증코드 발송";
	       msg.setSubject(subject);
	               
	       // 보내는 사람의 메일주소
	       String sender = "solee7966@gmail.com";
	       Address fromAddr = new InternetAddress(sender);
	       msg.setFrom(fromAddr);
	               
	       // 받는 사람의 메일주소
	       Address toAddr = new InternetAddress(recipient);
	       msg.addRecipient(Message.RecipientType.TO, toAddr);
	               
	       // 메시지 본문의 내용과 형식, 캐릭터 셋 설정
//	       msg.setContent("발송된 인증코드 : <span style='font-size:14pt; color:red;'>"+certification_code+"</span>", "text/html;charset=UTF-8");
	       msg.setContent(
	    		    "<div style='max-width:480px; margin:0 auto; padding:30px; "
	    		  + "font-family:Arial, sans-serif; background-color:#f9f9f9; border-radius:10px;'>"
	    		  
	    		  + "<h2 style='color:#333; text-align:center;'>🔐 이메일 인증 안내</h2>"
	    		  
	    		  + "<p style='font-size:15px; color:#555; line-height:1.6;'>"
	    		  + "안녕하세요 😊<br><br>"
	    		  + "요청하신 이메일 인증을 진행하기 위해 아래 인증코드를 입력해 주세요."
	    		  + "</p>"
	    		  
	    		  + "<div style='margin:30px 0; text-align:center;'>"
	    		  + "  <span style='display:inline-block; padding:15px 25px; "
	    		  + "  font-size:22px; font-weight:bold; color:#ffffff; "
	    		  + "  background-color:#ff6b6b; border-radius:8px; letter-spacing:3px;'>"
	    		  + certification_code
	    		  + "  </span>"
	    		  + "</div>"
	    		  
	    		  + "<p style='font-size:14px; color:#777;'>"
	    		  + "※ 인증코드는 <strong>5분 이내</strong>에만 유효합니다.<br>"
	    		  + "본 메일을 요청하지 않으셨다면 안전하게 무시해 주세요."
	    		  + "</p>"
	    		  
	    		  + "<hr style='border:none; border-top:1px solid #ddd; margin:25px 0;'>"
	    		  
	    		  + "<p style='font-size:12px; color:#aaa; text-align:center;'>"
	    		  + "© 2025 Your Service Name. All rights reserved."
	    		  + "</p>"
	    		  
	    		  + "</div>",
	    		  "text/html;charset=UTF-8"
	    		);
	               
	       // 메일 발송하기
	       Transport.send(msg);
	       
	   }// end of public void send_certification_code(String recipient, String certification_code) throws Exception--------
}
