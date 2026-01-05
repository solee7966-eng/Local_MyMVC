package member.model;

import java.io.UnsupportedEncodingException;
import java.security.GeneralSecurityException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

import member.domain.MemberDTO;
import util.security.AES256;
import util.security.SecretMyKey;
import util.security.Sha256;

public class MemberDAO_imple implements MemberDAO {
	private DataSource ds; // DataSource ds 는 아파치톰캣이 제공하는 DBCP(DB Connection Pool)이다.
	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;
	
	private AES256 aes;
	
	// 기본 생성자
	public MemberDAO_imple() {
		try {
	    	Context initContext = new InitialContext();
	        Context envContext  = (Context)initContext.lookup("java:/comp/env");
	        ds = (DataSource)envContext.lookup("jdbc/myoracle");
	        
	        aes = new AES256(SecretMyKey.KEY);
	        // SecretMyKey.KEY 은 우리가 만든 암호화/복호화 키이다.
    	} 
		catch(NamingException e) {e.printStackTrace();}
		catch(UnsupportedEncodingException e) {e.printStackTrace();}
	}
	
	
	// 사용한 자원을 반납하는 close() 메소드 생성하기
 	private void close() {
 		try {
 			if(rs    != null) {rs.close();	  rs=null;}
 			if(pstmt != null) {pstmt.close(); pstmt=null;}
 			if(conn  != null) {conn.close();  conn=null;}
 		} catch(SQLException e) {
 			e.printStackTrace();
 		}
 	}// end of private void close()---------------
	 	
	 	
	
	// 회원가입을 해주는 메서드(tbl_member 테이블에 insert)
	@Override
	public int registerMember(MemberDTO member) throws SQLException {
		int result = 0;
		try {
			  conn = ds.getConnection();
			  String sql = " insert into tbl_member(userid, pwd, name, email, mobile, postcode, address, detailaddress, extraaddress, gender, birthday) "  
			  		     + " values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?) "; 
			  pstmt = conn.prepareStatement(sql); 
			  
			  pstmt.setString(1, member.getUserid());
			  pstmt.setString(2, Sha256.encrypt(member.getPwd()) ); // 암호를 SHA256 알고리즘으로 단방향 암호화 시킨다.
			  pstmt.setString(3, member.getName());
			  pstmt.setString(4, aes.encrypt(member.getEmail()) );  // 이메일을 AES256 알고리즘으로 양방향 암호화 시킨다.
			  pstmt.setString(5, aes.encrypt(member.getMobile()) ); // 휴대폰을 AES256 알고리즘으로 양방향 암호화 시킨다.
			  pstmt.setString(6, member.getPostcode());
			  pstmt.setString(7, member.getAddress());
			  pstmt.setString(8, member.getDetailaddress());
			  pstmt.setString(9, member.getExtraaddress());
			  pstmt.setString(10, member.getGender());
			  pstmt.setString(11, member.getBirthday());
			  
			  result = pstmt.executeUpdate();
			  
		} catch(GeneralSecurityException | UnsupportedEncodingException e) {
			  e.printStackTrace();
		} finally {
			close();
		}
		
		return result;
	}// end of public int registerMember(MemberDTO member) throws SQLException-------


	// ID 중복검사(tbl_member 테이블에서 userid 가 존재하면 true 를 리턴해주고, userid 가 존재하지 않으면 false 를 리턴한다)
	@Override
	public boolean idDuplicateCheck(String userid) throws SQLException {
		boolean isExists = false;
		try {
			conn = ds.getConnection();
			String sql = " select userid "
						+" from tbl_member "
						+" where userid = ? ";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, userid);
			rs = pstmt.executeQuery();
			
			isExists = rs.next(); // 행이 있다면(입력받은 id가 중복됨) true, 행이 없다면(입력받은 id가 고유함) false
		} finally {close();}
		
		return isExists;
	}//end of public boolean idDuplicateCheck(String userid) throws SQLException-----


	// 이메일 중복검사
	@Override
	public boolean emailDuplicateCheck(String email) throws SQLException {
		boolean isExists = false;
		try {
			conn = ds.getConnection();
			String sql = " select email "
						+" from tbl_member "
						+" where email = ? ";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, aes.encrypt(email)); // email은 DB에 암호화되어 저장됐기 때문에
													//  똑같이 암호화하여 sql 문에 넣어주어야 비교가 가능!
			rs = pstmt.executeQuery();
			isExists = rs.next(); // 행이 있다면(입력받은 id가 중복됨) true, 행이 없다면(입력받은 id가 고유함) false
		}
		catch(GeneralSecurityException | UnsupportedEncodingException e) {e.printStackTrace();}
		finally {close();}
		
		return isExists;
	}//end of public boolean emailDuplicateCheck(String email) throws SQLException-----


	// 로그인 처리
	@Override
	public MemberDTO login(Map<String, String> paraMap) throws SQLException {
		MemberDTO member = null;
		
		try {
			conn = ds.getConnection();
			String sql = " WITH "
						+" M AS ( "
						+"  SELECT userid, name, coin, point, "
						+"      trunc( months_between(sysdate, lastpwdchangedate) ) AS pwdchangegap, "
						+"      to_char(registerday, 'yyyy-mm-dd hh24:mi:ss') as registerday, idle, email, mobile, postcode, address, detailaddress, extraaddress "
						+"  FROM tbl_member "
						+"  WHERE status = 1 AND userid = ? and pwd = ? "
						+" ) "
						+" , H AS ( "
						+"  select trunc( months_between(sysdate, MAX(LOGINDATE)) ) AS LAST_LOGINDATE_GAP "
						+"  FROM tbl_loginhistory "
						+"  where fk_userid = ? "
						+" ) "
						+" SELECT userid, name, coin, point, pwdchangegap, registerday, idle, email, mobile "
						+"       ,postcode, address, detailaddress, extraaddress, LAST_LOGINDATE_GAP "
						+" FROM M CROSS JOIN H ";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, paraMap.get("userid"));
			pstmt.setString(2, Sha256.encrypt(paraMap.get("pwd"))); // 암호화하여 넣어주어야 DB에서 비교가 가능! 
			pstmt.setString(3, paraMap.get("userid"));
			
			rs = pstmt.executeQuery();
			if(rs.next()) {
				member = new MemberDTO();
				member.setUserid(rs.getString("userid"));
				member.setName(rs.getString("name"));
				member.setCoin(rs.getInt("coin"));
				member.setPoint(rs.getInt("point"));

				// 마지막으로 암호를 변경한 날짜가 현재시각으로 부터 3개월이 지났으면 true
                // 마지막으로 암호를 변경한 날짜가 현재시각으로 부터 3개월이 지나지 않았으면 false
				if(rs.getInt("pwdchangegap") >= 3) {
					System.out.println("pwdchangegap: " + rs.getInt("pwdchangegap"));
					member.setRequirePwdChange(true); // 로그인 시 암호를 변경하라는 alert를 띄우기 위해 사용
				}
				
				member.setRegisterday(rs.getString("registerday"));
				member.setIdle(rs.getInt("idle"));
				
				member.setEmail(aes.decrypt(rs.getString("email"))); // 이메일은 암호화된 것으로 DB에 저장됐으므로 복호화하여 가져온다.
				member.setMobile(aes.decrypt(rs.getString("mobile"))); // 이메일 또한 복호화하여 DB에서 가져온다.
				
				member.setPostcode(rs.getString("postcode"));
				member.setAddress(rs.getString("address"));
				member.setDetailaddress(rs.getString("detailaddress"));
				member.setExtraaddress(rs.getString("extraaddress"));
				
				// === 휴면이 아니고, 마지막 로그인 일자가 1년 미만인 회원만 tbl_loginhistory(로그인기록) 테이블에 insert 하기 시작 === //
				if(member.getIdle() == 0 && rs.getInt("LAST_LOGINDATE_GAP") < 12) {
					sql = " insert into tbl_loginhistory(historyno, fk_userid, clientip)"
						 +"	values(seq_historyno.nextval, ?, ?) ";
					pstmt = conn.prepareStatement(sql);
					pstmt.setString(1, paraMap.get("userid"));
					pstmt.setString(2, paraMap.get("clientip"));
					
					pstmt.executeUpdate();
				} else {
					// 휴면이고, 마지막 로그인 일자가 1년 이상인 회원일 경우 휴면처리 해주기
					member.setIdle(1); //MemberDTO 값 바꿔준 것
					if(rs.getInt("idle") == 1) {
						// DB의 Idle 값도 1로 변경해주기
						sql = " update tbl_member set idle = 1 "
							 +"	where userid = ? ";
						
						pstmt = conn.prepareStatement(sql);
						pstmt.setString(1, paraMap.get("userid"));
						
						pstmt.executeUpdate();
					}
				}
				// === 휴면이 아닌 회원만 tbl_loginhistory(로그인기록) 테이블에 insert 하기 시작 === //
				
			}//end of if(rs.next())-----
			
		}
		catch(GeneralSecurityException | UnsupportedEncodingException e) {e.printStackTrace();}
		finally {close();}
		
		return member;
	}//end of public MemberDTO login(Map<String, String> paraMap) throws SQLException-----


	
	// 아이디 찾기(성명, 이메일을 입력받아서 해당 사용자의 아이디를 알려준다) 
	@Override
	public String findUserid(Map<String, String> paraMap) throws SQLException {
		String userid = null;
		
		try {
			conn = ds.getConnection();
			String sql = " select userid "
						+" from tbl_member "
						+" where status = 1 AND name = ? AND email = ? ";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, paraMap.get("name"));
			pstmt.setString(2, aes.encrypt(paraMap.get("email")));
			
			rs = pstmt.executeQuery();
			if(rs.next()) {
				userid = rs.getString("userid");
			}
			
		} 
		catch(GeneralSecurityException | UnsupportedEncodingException e) {e.printStackTrace();}
		finally {close();}
		
		return userid;
	}//end of public String findUserid(Map<String, String> paraMap) throws SQLException-----


	
	// 비밀번호 찾기(아이디, 이메일을 입력받아서 해당 사용자가 존재하는지 여부를 알려준다)
	@Override
	public boolean isUserExists(Map<String, String> paraMap) throws SQLException {
		boolean isUserExists = false;
		
		try {
			conn = ds.getConnection();
			String sql = " select userid "
						+" from tbl_member "
						+" where status = 1 AND userid = ? AND email = ? ";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, paraMap.get("userid"));
			pstmt.setString(2, aes.encrypt(paraMap.get("email")));
			
			rs = pstmt.executeQuery();
			isUserExists = rs.next(); // 조회해 온 행이 있다면 true / 없다면 false
		} 
		catch(GeneralSecurityException | UnsupportedEncodingException e) {e.printStackTrace();}
		finally {close();}
		
		return isUserExists;
	}//end of public boolean isUserExists(Map<String, String> paraMap) throws SQLException-----


	
	// 비밀번호 변경해주는 메서드
	@Override
	public int pwdUpdate(Map<String, String> paraMap) throws SQLException {
		int result = 0;
		
		try {
			conn = ds.getConnection();
			
			String sql = " update tbl_member set pwd = ?, lastpwdchangedate = sysdate " 
						+" where userid = ? ";
			
			pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, Sha256.encrypt(paraMap.get("new_pwd")) ); // 암호를 SHA256 알고리즘으로 단방향 암호화 시킨다.
	        pstmt.setString(2, paraMap.get("userid") );  

	        result = pstmt.executeUpdate();
		} finally {close();}
		
		return result;
	}//end of public int pwdUpdate(Map<String, String> paraMap) throws SQLException


	// 결제된 금액에 따른 코인 및 포인트 값 증가(수정)해주기
	@Override
	public int coinUpdateLoginUser(Map<String, String> paraMap) throws SQLException {
		int result = 0;
		
		try {
			conn = ds.getConnection();
			
			String sql = " update tbl_member set coin = to_number(?), point = point + to_number(?) " 
						+" where userid = ? ";
			
			pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, paraMap.get("coinmoney"));
	        pstmt.setString(2, String.valueOf( Integer.parseInt(paraMap.get("coinmoney"))*0.01));
	        pstmt.setString(3, paraMap.get("userid") );

	        result = pstmt.executeUpdate();
		} finally {close();}
		
		return result;
	}//end of public int coinUpdateLoginUser(Map<String, String> paraMap) throws SQLException-----


	// 다른 사용자가 사용중인 email 이라면 true, 다른 사용자가 사용하지 않는 email 이라면 false
	@Override
	public boolean emailDuplicateCheck2(Map<String, String> paraMap) throws SQLException {
		boolean isExists = false;
		try {
			conn = ds.getConnection();
			String sql = " select email "
						+" from tbl_member "
						+" where email = ? AND userid != ? ";
			// 정보를 수정할 때 이메일은 변경하려 할 때 본인이 등록했던 이메일은 새로 수정할 수 없음
			// 그렇기에 유저아이디가 본인이 아니면서, 입력받은 아이디가 존재한다면 true값을 반환
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, aes.encrypt(paraMap.get("email"))); // email은 DB에 암호화되어 저장됐기 때문에
																   // 똑같이 암호화하여 sql 문에 넣어주어야 비교가 가능!
			pstmt.setString(2, paraMap.get("userid"));
			
			rs = pstmt.executeQuery();
			isExists = rs.next(); // 행이 있다면(입력받은 id가 중복됨) true, 행이 없다면(입력받은 id가 고유함) false
		}
		catch(GeneralSecurityException | UnsupportedEncodingException e) {e.printStackTrace();}
		finally {close();}
		
		return isExists;
	}//end of public boolean emailDuplicateCheck2(Map<String, String> paraMap) throws SQLException00000


	// 비밀번호 변경시 현재 사용중인 비밀번호인지 아닌지 알아오기(현재 사용중인 비밀번호 이라면 true, 새로운 비밀번호이라면 false)
	@Override
	public boolean pwdduplicatePwdCheck(Map<String, String> paraMap) throws SQLException {
		boolean isExists = false;
	      
	      try {
	         conn = ds.getConnection();
	         
	         String sql = " select pwd "
	                  + " from tbl_member "
	                  + " where userid = ? and pwd = ? ";
	         
	         pstmt = conn.prepareStatement(sql); 
	         pstmt.setString(1, paraMap.get("userid"));
	         pstmt.setString(2, Sha256.encrypt(paraMap.get("new_pwd")));
	         
	         rs = pstmt.executeQuery();
	         
	         isExists = rs.next(); // 행이 있으면 true  (새암호가 현재 사용중인 암호와 같은 경우) 
	                                  // 행이 없으면 false (새암호가 현재 사용중인 암호와 다른 경우) 
	      } finally {close();}

	      return isExists;
	}//end of public boolean pwdduplicatePwdCheck(Map<String, String> paraMap) throws SQLException-----


	
	// 회원정보 수정하기 메서드
	@Override
	public int updateMember(MemberDTO mbDto) throws SQLException {
		int result = 0;
		
		try {
			conn = ds.getConnection();
			String sql = " update tbl_member set name = ? "
						+" 					 , pwd = ? "
						+" 					 , email = ? "
						+" 					 , mobile = ? "
						+" 					 , postcode = ? "
						+" 					 , address = ? "
						+" 					 , detailaddress = ? "
						+" 					 , extraaddress = ? "
						+" 					 , LASTPWDCHANGEDATE = sysdate "
						+" where userid = ? ";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, mbDto.getName());
			pstmt.setString(2, Sha256.encrypt(mbDto.getPwd()));
			pstmt.setString(3, aes.encrypt(mbDto.getEmail()));
			pstmt.setString(4, aes.encrypt(mbDto.getMobile()));
			pstmt.setString(5, mbDto.getPostcode());
			pstmt.setString(6, mbDto.getAddress());
			pstmt.setString(7, mbDto.getDetailaddress());
			pstmt.setString(8, mbDto.getExtraaddress());
			pstmt.setString(9, mbDto.getUserid());

	        result = pstmt.executeUpdate();
	        //System.out.println("여까지 들어옵니까?");
	        
		} catch (UnsupportedEncodingException | GeneralSecurityException e) {
			e.printStackTrace();
		} finally {close();}
		
		return result;
	}//end of public int updateMember(MemberDTO mbDto) throws SQLException-----


	
	// 페이징 처리를 안 한 회원 또는 검색한 회원목록 보여주기
	@Override
	public List<MemberDTO> selectMemberNopaing(Map<String, String> paraMap) throws SQLException {
		List<MemberDTO> memberList = new ArrayList<MemberDTO>();
		try {
			conn = ds.getConnection();
			String sql = " SELECT userid, name, email, gender "
						+" FROM tbl_member "
						+" WHERE userid != 'admin' ";
			
			//검색하는 컬럼(name, userid, email)
			String colName = paraMap.get("searchType");
			//검색한 단어
			String searchWord = paraMap.get("searchWord");
			
			if("email".equals(colName) && !"".equals(searchWord)) {
				//검색 대상이 이메일인 경우 암호화를 해야함
				//자바파일에서 null값이거나 name, userid, email일 경우 ""로 변경해주었음
				aes.encrypt(searchWord);
			}
			
			if(!"".equals(colName) && !"".equals(searchWord)) {
				if("email".equals(colName)) {
					//검색대상이 이메일이라면 아래의 sql 구문을 사용해야함
					sql += " AND email ? ";
				} else {
					//컬럼명에는 위치홀더(?)를 사용하면 안 된다! 무조건 데이터값에만 사용
					//위치홀더(?)로 들어오는 것은 컬럼명과 테이블명이 아닌 오로지 데이터값만 들어온다.!!!! 
					sql += " AND " +colName+ " LIKE '%'|| ? ||'%' ";
				}
			}
						
			sql += " ORDER BY registerday DESC ";
			pstmt = conn.prepareStatement(sql);
			
			if(!"".equals(colName) && !"".equals(searchWord)) {
				//검색대상 및 검색어가 있는 경우 위치홀더에 값을 넣어주면 됨
				pstmt.setString(1, searchWord);
			}
			
			rs = pstmt.executeQuery();
			while(rs.next()) {
				MemberDTO mbDto = new MemberDTO();
				mbDto.setUserid(rs.getString("userid"));
				mbDto.setName(rs.getString("name"));
				mbDto.setEmail(aes.decrypt(rs.getString("email"))); //복호화해주어 가져오기
				mbDto.setGender(rs.getString("gender"));
				memberList.add(mbDto);
			}//end of rs.next()-----
		} 
		catch (UnsupportedEncodingException | GeneralSecurityException e) {e.printStackTrace();}
		finally {close();}
		
		return memberList;
	}//end of public List<MemberDTO> selectMemberNopaing(Map<String, String> paraMap) throws SQLException-----


	
	// 페이징 처리를  한 회원 또는 검색한 회원목록 보여주기
	@Override
	public List<MemberDTO> selectMemberpaing(Map<String, String> paraMap) throws SQLException {
		List<MemberDTO> memberList = new ArrayList<MemberDTO>();
		
		try {
			conn = ds.getConnection();
			String sql = " SELECT userid, name, email, gender "
						+" FROM tbl_member "
						+" WHERE userid != 'admin' ";
			
			//검색하는 컬럼(name, userid, email)
			String colName = paraMap.get("searchType");
			//검색한 단어
			String searchWord = paraMap.get("searchWord");
			
			if("email".equals(colName) && !"".equals(searchWord)) {
				//검색 대상이 이메일인 경우 암호화를 해야함
				//자바파일에서 null값이거나 name, userid, email일 경우 ""로 변경해주었음
				aes.encrypt(searchWord);
			}
			
			if(!"".equals(colName) && !"".equals(searchWord)) {
				if("email".equals(colName)) {
					//검색대상이 이메일이라면 아래의 sql 구문을 사용해야함
					sql += " AND email ? ";
				} else {
					//컬럼명에는 위치홀더(?)를 사용하면 안 된다! 무조건 데이터값에만 사용
					//위치홀더(?)로 들어오는 것은 컬럼명과 테이블명이 아닌 오로지 데이터값만 들어온다.!!!! 
					sql += " AND " +colName+ " LIKE '%'|| ? ||'%' ";
				}
			}
			
			//몇 페이지인가
			int currentShowPageNo = Integer.parseInt(paraMap.get("currentShowPageNo"));
			//페이지 내에서 몇 명을 출력하여 보여줄 것인가
			int sizePerPage = Integer.parseInt(paraMap.get("sizePerPage"));
			
			//페이징처리를 위한 SQL 구문(아래 코드는 몇 페이지에서 몇 개씩 볼 것이다 라는 뜻) 
			//이제 register를 기준으로 정렬하지 않고, userseq를 기준으로 잡기!(가입일자가 똑같은 값이면 페이징처리가 되지 않기때문)
			//order by 이후의 컬럼은 고유해야 함!
			sql += " ORDER BY userseq DESC "
				 +" OFFSET (?-1)*? ROW "
				 +" FETCH NEXT ? ROW ONLY ";
			
			pstmt = conn.prepareStatement(sql);
			
			if(!"".equals(colName) && !"".equals(searchWord)) {
				//검색대상 및 검색어가 있는 경우 위치홀더에 값을 넣어주면 됨
				pstmt.setString(1, searchWord);
				pstmt.setInt(2, currentShowPageNo);
				pstmt.setInt(3, sizePerPage);
				pstmt.setInt(4, sizePerPage);
			} else {
				//검색대상 및 검색어아 없는 경우
				pstmt.setInt(1, currentShowPageNo);
				pstmt.setInt(2, sizePerPage);
				pstmt.setInt(3, sizePerPage);
			}
			
			rs = pstmt.executeQuery();
			while(rs.next()) {
				MemberDTO mbDto = new MemberDTO();
				mbDto.setUserid(rs.getString("userid"));
				mbDto.setName(rs.getString("name"));
				mbDto.setEmail(aes.decrypt(rs.getString("email"))); //복호화해주어 가져오기
				mbDto.setGender(rs.getString("gender"));
				memberList.add(mbDto);
			}//end of rs.next()-----
		} 
		catch (UnsupportedEncodingException | GeneralSecurityException e) {e.printStackTrace();}
		finally {close();}
		
		return memberList;
	}//end of public List<MemberDTO> selectMemberpaing(Map<String, String> paraMap) throws SQLException-----


	
	//페이징 처리를 위한 검색이 있는 또는 검색이 없는 회원에 대한 총 페이지수 알아오기
	@Override
	public int getTotalPage(Map<String, String> paraMap) throws SQLException {
		int totalPage = 0;

		try {
			conn = ds.getConnection();
			String sql = " SELECT ceil(count(*)/?) "
						+" FROM tbl_member "
						+" WHERE userid != 'admin' ";
			
			//검색하는 컬럼(name, userid, email)
			String colName = paraMap.get("searchType");
			//검색한 단어
			String searchWord = paraMap.get("searchWord");
			
			if("email".equals(colName) && !"".equals(searchWord)) {
				//검색 대상이 이메일인 경우 암호화를 해야함
				//자바파일에서 null값이거나 name, userid, email일 경우 ""로 변경해주었음
				aes.encrypt(searchWord);
			}
			
			if(!"".equals(colName) && !"".equals(searchWord)) {
				if("email".equals(colName)) {
					//검색대상이 이메일이라면 아래의 sql 구문을 사용해야함
					sql += " AND email ? ";
				} else {
					//컬럼명에는 위치홀더(?)를 사용하면 안 된다! 무조건 데이터값에만 사용
					//위치홀더(?)로 들어오는 것은 컬럼명과 테이블명이 아닌 오로지 데이터값만 들어온다.!!!! 
					sql += " AND " +colName+ " LIKE '%'|| ? ||'%' ";
				}
			}
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, Integer.parseInt(paraMap.get("sizePerPage")));
			
			if(!"".equals(colName) && !"".equals(searchWord)) {
				//검색대상 및 검색어가 있는 경우 위치홀더에 값을 넣어주면 됨
				pstmt.setString(2, searchWord);
			}
			
			rs = pstmt.executeQuery();
			rs.next();
			totalPage = rs.getInt(1);
			
		} 
		catch (UnsupportedEncodingException | GeneralSecurityException e) {e.printStackTrace();}
		finally {close();}
		
		return totalPage;
	}//end of public int getTotalPage(Map<String, String> paraMap) throws SQLException-----


	//뷰단(memberList.jsp)에서 "페이징 처리시 보여주는 순번 공식" 에서 사용하기 위해 검색이 있는 또는 검색이 없는 회원의 총개수 알아오기
	@Override
	public int getTotalMemberCount(Map<String, String> paraMap) throws SQLException {
		int totalMemberCount = 0;
		try {
			conn = ds.getConnection();
			String sql = " SELECT count(*) "
						+" FROM tbl_member "
						+" WHERE userid != 'admin' ";
			
			//검색하는 컬럼(name, userid, email)
			String colName = paraMap.get("searchType");
			//검색한 단어
			String searchWord = paraMap.get("searchWord");
			
			if("email".equals(colName) && !"".equals(searchWord)) {
				//검색 대상이 이메일인 경우 암호화를 해야함
				//자바파일에서 null값이거나 name, userid, email일 경우 ""로 변경해주었음
				aes.encrypt(searchWord);
			}
			
			if(!"".equals(colName) && !"".equals(searchWord)) {
				if("email".equals(colName)) {
					//검색대상이 이메일이라면 아래의 sql 구문을 사용해야함
					sql += " AND email ? ";
				} else {
					//컬럼명에는 위치홀더(?)를 사용하면 안 된다! 무조건 데이터값에만 사용
					//위치홀더(?)로 들어오는 것은 컬럼명과 테이블명이 아닌 오로지 데이터값만 들어온다.!!!! 
					sql += " AND " +colName+ " LIKE '%'|| ? ||'%' ";
				}
			}
			
			pstmt = conn.prepareStatement(sql);
			if(!"".equals(colName) && !"".equals(searchWord)) {
				//검색대상 및 검색어가 있는 경우 위치홀더에 값을 넣어주면 됨
				pstmt.setString(1, searchWord);
			}
			
			rs = pstmt.executeQuery();
			rs.next();
			totalMemberCount = rs.getInt(1);
		} 
		catch (UnsupportedEncodingException | GeneralSecurityException e) {e.printStackTrace();}
		finally {close();}
		
		return totalMemberCount;
	}//end of public int getTotalMemberCount(Map<String, String> paraMap) throws SQLException-----

	

	// 뷰단에서 받아온 userid를 이용해 해당 userid에 맞는 회원정보 가져오기
	@Override
	public MemberDTO selectOneMember(String userid) throws SQLException {
		MemberDTO mbDto = null;
		try {
			conn = ds.getConnection();
			
			String sql = " SELECT userid, name, coin, point, to_char(registerday, 'yyyy-mm-dd') as registerday,"
						+"		 idle, email, mobile, postcode, address, detailaddress, extraaddress, gender, birthday "
						+" FROM tbl_member "
						+" WHERE userid = ? AND status = 1 ";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, userid);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				mbDto = new MemberDTO();
				mbDto.setUserid(rs.getString("userid"));
				mbDto.setName(rs.getString("name"));
				mbDto.setCoin(rs.getInt("coin"));
				mbDto.setPoint(rs.getInt("point"));
				mbDto.setRegisterday(rs.getString("registerday"));
				mbDto.setIdle(rs.getInt("idle"));
				mbDto.setEmail(aes.decrypt(rs.getString("email")));
				mbDto.setMobile(aes.decrypt(rs.getString("mobile")));
				mbDto.setPostcode(rs.getString("postcode"));
				mbDto.setAddress(rs.getString("address"));
				mbDto.setDetailaddress(rs.getString("detailaddress"));
				mbDto.setExtraaddress(rs.getString("extraaddress"));
				mbDto.setGender(rs.getString("gender"));
				mbDto.setBirthday(rs.getString("birthday"));
			}
		} 
		catch (UnsupportedEncodingException | GeneralSecurityException e) {e.printStackTrace();}
		finally {close();}
		
		return mbDto;
	}

	
	
	
	
}// DAO_imple 클래스 종료----------
