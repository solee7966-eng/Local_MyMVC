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
	   
	   
	   
	   
	   
	   
}
