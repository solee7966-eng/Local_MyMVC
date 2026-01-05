package member.model;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import member.domain.MemberDTO;

public interface MemberDAO {

	// 회원가입을 해주는 추상메서드(tbl_member 테이블에 insert)
	int registerMember(MemberDTO member) throws SQLException;

	// ID 중복검사(tbl_member 테이블에서 userid 가 존재하면 true 를 리턴해주고, 존재하지 않으면 false 를 리턴한다)
	boolean idDuplicateCheck(String userid) throws SQLException;

	// Email 중복검사(tbl_member 테이블에서 Email이 존재하면 true 를 리턴해주고, 존재하지 않으면 false 를 리턴한다)
	boolean emailDuplicateCheck(String email) throws SQLException;

	// 로그인 처리
	MemberDTO login(Map<String, String> paraMap) throws SQLException;

	// 아이디 찾기(성명, 이메일을 입력받아서 해당 사용자의 아이디를 알려준다)
	String findUserid(Map<String, String> paraMap) throws SQLException;

	// 비밀번호 찾기(아이디, 이메일을 입력받아서 해당 사용자가 존재하는지 여부를 알려준다)
	boolean isUserExists(Map<String, String> paraMap) throws SQLException;

	// 비밀번호 변경해주기
	int pwdUpdate(Map<String, String> paraMap) throws SQLException;

	// 결제된 금액에 따른 코인 및 포인트 값 증가(수정)해주기
	int coinUpdateLoginUser(Map<String, String> paraMap) throws SQLException;

	// 다른 사용자가 사용중인 email 이라면 true, 다른 사용자가 사용하지 않는 email 이라면 false
	boolean emailDuplicateCheck2(Map<String, String> paraMap) throws SQLException;

	// 비밀번호 변경시 현재 사용중인 비밀번호인지 아닌지 알아오기(현재 사용중인 비밀번호 이라면 true, 새로운 비밀번호이라면 false)
	boolean pwdduplicatePwdCheck(Map<String, String> paraMap) throws SQLException;

	// 회원정보 수정하기 메서드
	int updateMember(MemberDTO mbDto) throws SQLException;

	// 페이징 처리를 안 한 회원 또는 검색한 회원목록 보여주기
	List<MemberDTO> selectMemberNopaing(Map<String, String> paraMap) throws SQLException;

	// 페이징 처리를 한 회원 또는 검색한 회원목록 보여주기
	List<MemberDTO> selectMemberpaing(Map<String, String> paraMap) throws SQLException;

	// 페이징 처리를 위한 검색이 있는 또는 검색이 없는 회원에 대한 총 페이지수 알아오기
	int getTotalPage(Map<String, String> paraMap) throws SQLException;

	// 뷰단(memberList.jsp)에서 "페이징 처리시 보여주는 순번 공식" 에서 사용하기 위해 검색이 있는 또는 검색이 없는 회원의 총개수 알아오기
	int getTotalMemberCount(Map<String, String> paraMap) throws SQLException;

	// 뷰단에서 받아온 userid를 이용해 해당 userid에 맞는 회원정보 가져오기
	MemberDTO selectOneMember(String userid) throws SQLException;
}
