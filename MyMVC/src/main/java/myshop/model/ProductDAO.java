package myshop.model;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import myshop.domain.CartDTO;
import myshop.domain.CategoryDTO;
import myshop.domain.ImageDTO;
import myshop.domain.ProductDTO;
import myshop.domain.SpecDTO;

public interface ProductDAO {
	   //메인페이지에 보여지는 상품이미지파일명을 모두 조회(select)하는 추상메소드
	   List<ImageDTO> imageSelectAll() throws SQLException;

	   //제품의 스펙별(HIT, NEW, BEST) 상품의 전체개수를 알아오기 
	   int totalPspecCount(int snum) throws SQLException;

	   //더보기 방식(페이징처리)으로 상품정보를 8개씩 잘라서(start ~ end) 조회해오기
	   List<ProductDTO> selectBySpecName(Map<String, String> paraMap) throws SQLException;

	   //tbl_category 테이블에서 카테고리 대분류 번호(cnum), 카테고리코드(code), 카테고리명(cname)을 조회해오기 
	   List<CategoryDTO> getCategoryList() throws SQLException;

	   //tbl_spec 테이블에서 스펙번호(snum), 스펙명(sname) 조회해오기
	   List<SpecDTO> getSpecList() throws SQLException;

	   //제품번호 채번 해오기
	   int getPnumOfProduct() throws SQLException;

	   //tbl_product 테이블에 제품정보 insert 하기
	   int productInsert(ProductDTO proDto) throws SQLException;

	   //tbl_product_imagefile 테이블에 제품의 추가이미지 파일명 insert 하기
	   int product_imagefile_insert(Map<String, String> paraMap) throws SQLException;

	   //제품번호를 가지고서 해당 제품의 정보를 조회해오기
	   ProductDTO selectOneProductByPnum(String pnum) throws SQLException;

	   //제품번호를 이용해 해당 제품의 추가된 이미지 정보를 조회해오기
	   List<String> getImagesByPnum(String pnum) throws SQLException;

	   //시스템에 업로드 되어진 파일설명서 첨부파일명 및 오리지널파일명 알아오기
	   Map<String, String> getPrdmanualFileName(String pnum) throws SQLException;

	   //장바구니 테이블(tbl_cart)에 해당 제품을 담아야 한다.
	   //장바구니 테이블에 해당 제품이 존재하지 않는 경우에는 tbl_cart 테이블에 insert 를 해야하고, 
	   //장바구니 테이블에 해당 제품이 존재하는 경우에는 또 그 제품을 추가해서 장바구니 담기를 한다라면 tbl_cart 테이블에 update 를 해야한다. 
	   int addCart(Map<String, String> paraMap) throws SQLException;

	   //로그인 한 사용자의 장바구니 목록을 조회하기
	   List<CartDTO> selectProductCart(String userid) throws SQLException;

	   //로그인한 사용자의 장바구니에 담긴 주문총액합계 및 총포인트합계 알아오기
	   Map<String, Integer> selectCartSumPricePoint(String userid) throws SQLException;

	   //장바구니 테이블에서 특정제품의 주문량 변경시키기
	   int updateCart(Map<String, String> paraMap) throws SQLException;

	   //장바구니 테이블에서 특정제품을 삭제하기
	   int deleteCart(String cartno) throws SQLException;

	   //주문번호(시퀀스 seq_tbl_order 값)을 채번해오는 것.
	   int get_seq_tbl_order() throws SQLException;

	   // *** Transaction 처리를 해주는 메소드 호출하기 *** //
       // 1. 주문 테이블에 입력되어야할 주문전표를 채번(select)하기 => 이건 했음!!
       // 2. 주문 테이블에 채번해온 주문전표, 로그인한 사용자, 현재시각을 insert 하기(수동커밋처리) 
       // 3. 주문상세 테이블에 채번해온 주문전표, 제품번호, 주문량, 주문금액을 insert 하기(수동커밋처리) 
       // 4. 제품 테이블에서 제품번호에 해당하는 잔고량을 주문량 만큼 감하기 update 하기(수동커밋처리)
                
       // 5. 장바구니 테이블에서 str_cartno_join 값에 해당하는 행들을 삭제(delete)하기(수동커밋처리)
       // >> 장바구니에서 주문을 한 것이 아니라 특정제품을 바로주문하기를 한 경우에는 장바구니 테이블에서 행들을 삭제할 작업은 없다. <<
                
       // 6. 회원 테이블에서 로그인한 사용자의 coin 액을 sum_totalPrice 만큼 감하고, point 를 sum_totalPoint 만큼 더하기(update)(수동커밋처리) 
       // 7. **** 모든처리가 성공되었을시 commit 하기(commit) ****
       // 8. **** SQL 장애 발생시 rollback 하기(rollback) ****
	   int orderAdd(Map<String, Object> paraMap) throws SQLException;

	   //주문한 제품에 대해 email 보내기시 email 내용에 넣을 주문한 제품번호들에 대한 제품정보를 얻어오는 것.
	   List<ProductDTO> getJumunProductList(String pnums) throws SQLException;

	   //tbl_map(위,경도) 테이블에 있는 정보를 가져오기(select)
	   List<Map<String, String>> selectStoreMap() throws SQLException;
	   
	   
	   
}
