package myshop.model;

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

import myshop.domain.CategoryDTO;
import myshop.domain.ImageDTO;
import myshop.domain.ProductDTO;
import myshop.domain.SpecDTO;

public class ProductDAO_imple implements ProductDAO {
	// DataSource ds ==> 아파치톰캣이 제공하는 DBCP(DB Connection Pool)이다.
	private DataSource ds;
	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;

	// 기본 생성자
	public ProductDAO_imple() {
		try {
			Context initContext = new InitialContext();
			Context envContext  = (Context)initContext.lookup("java:/comp/env");
			ds = (DataSource)envContext.lookup("jdbc/myoracle");
		} catch (NamingException e) {e.printStackTrace();}
	}//end of public ProductDAO_imple()-----
	
	
	// 사용한 자원을 반납하는 close() 메소드 생성하기
	private void close() {
		try {
			if(rs    != null) {rs.close();     rs=null;}
		    if(pstmt != null) {pstmt.close(); pstmt=null;}
		    if(conn  != null) {conn.close();  conn=null;} // DBCP는 자원반납을 해주어야지만 다른 사용자가 사용할 수 있음
		} catch(SQLException e) {e.printStackTrace();}
	}// end of private void close()---------------
	
	
	
	
	// 메인페이지에 보여지는 상품이미지파일명을 모두 조회(select)하는 메소드
	@Override
	public List<ImageDTO> imageSelectAll() throws SQLException {
		List<ImageDTO> imgList = new ArrayList<>();
		try {
			conn = ds.getConnection();
			String sql = " select imgno, imgname, imgfilename "
						+" from tbl_main_page "
						+" order by imgno asc ";
			pstmt = conn.prepareStatement(sql);
			
			rs = pstmt.executeQuery();
			while(rs.next()) {
				ImageDTO imgDto = new ImageDTO();
				imgDto.setImgno(rs.getInt("imgno"));
				imgDto.setImgname(rs.getString("imgname"));
				imgDto.setImgfilename(rs.getString("imgfilename"));
				
				imgList.add(imgDto);
			}
		} finally {close();}
		return imgList;
	}//end of public List<ImageDTO> imageSelectAll() throws SQLException-----


	
	//제품의 스펙별(HIT, NEW, BEST) 상품의 전체개수를 알아오기
	@Override
	public int totalPspecCount(int snum) throws SQLException {
		int totalCount = 0;
		try {
			conn = ds.getConnection();
			String sql = " select count(*) "
						+" from tbl_product "
						+" where fk_snum = ? ";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, snum);
			rs = pstmt.executeQuery();
			rs.next();
			totalCount = rs.getInt(1);
			
		} finally {close();}
		return totalCount;
	}//end of public int totalPspecCount(int snum) throws SQLException-----


	
	//더보기 방식(페이징처리)으로 상품정보를 8개씩 잘라서(start ~ end) 조회해오기
	@Override
	public List<ProductDTO> selectBySpecName(Map<String, String> paraMap) throws SQLException {
		List<ProductDTO> productList = new ArrayList<ProductDTO>();
		try {
			conn = ds.getConnection();
			String sql = " SELECT pnum, pname, C.cname, pcompany, pimage1, pimage2, pqty, price, saleprice, S.sname, pcontent, point "
						+"     , to_char(pinputdate, 'yyyy-mm-dd') AS pinputdate "
						+" FROM tbl_product P JOIN tbl_category C "
						+" ON P.fk_cnum = C.cnum "
						+" JOIN tbl_spec S "
						+" ON P.fk_snum = S.snum "
						+" WHERE S.sname = ? "
						+" ORDER BY pnum DESC "
						+" OFFSET (?-1) * ? ROW "
						+" FETCH NEXT ? ROW ONLY ";
		/*
	            >> !! ORACLE 12C 이후 부터 지원되어지는 OFFSET - FETCH 을 사용하여 페이징 처리 !! <<
	           
	            ORDER BY pnum DESC 
	            OFFSET (@PAGE_NO-1)*@PAGE_SIZE ROW   -- @PAGE_NO ==> 페이지 번호 , @PAGE_SIZE ==> 한 페이지에 보여줄 row 수
	            FETCH NEXT @PAGE_SIZE ROW ONLY
	
	            order by 로 정렬 기준 정하고
	            offset을 통해 페이징 할 때마다 건너뛸 행의 수 설정
	            fetch next에서 몇 개의 행을 가져올지 결정
	            
	            @PAGE_NO = end/(end - start + 1)
	               @PAGE_SIZE = end - start + 1
         */
			pstmt = conn.prepareStatement(sql);
			
			int start = Integer.parseInt(paraMap.get("start")); 
			int end = Integer.parseInt(paraMap.get("end"));
			
			int PAGE_NO = end/(end - start + 1);
			int PAGE_SIZE = end - start + 1;
			
			pstmt.setString(1, paraMap.get("sname"));
			pstmt.setInt(2, PAGE_NO);
			pstmt.setInt(3, PAGE_SIZE);
			pstmt.setInt(4, PAGE_SIZE);
			
			rs = pstmt.executeQuery();
			while(rs.next()) {
				ProductDTO proDto = new ProductDTO();
				proDto.setPnum(rs.getInt("pnum"));
				proDto.setPname(rs.getString("pname")); // 제품명
				
				//카테고리DTO를 이용해 proDTO에 넣어주기
				CategoryDTO categDto = new CategoryDTO();
				categDto.setCname(rs.getString("cname")); // 카테고리명
				proDto.setCategdto(categDto);
				
				proDto.setPcompany(rs.getString("pcompany")); // 제조회사명
				proDto.setPimage1(rs.getString("pimage1"));   // 제품이미지1   이미지파일명
				proDto.setPimage2(rs.getString("pimage2"));   // 제품이미지2   이미지파일명
				proDto.setPqty(rs.getInt("pqty"));            // 제품 재고량
				proDto.setPrice(rs.getInt("price"));          // 제품 정가
				proDto.setSaleprice(rs.getInt("saleprice"));  // 제품 판매가(할인해서 팔 것이므로) 
				
				//스펙DTO를 이용해 proDTO에 넣어주기
				SpecDTO speDto = new SpecDTO();
				speDto.setSname(rs.getString("sname"));	//스펙명
				proDto.setSpdto(speDto);
				
				proDto.setPcontent(rs.getString("pcontent")); // 제품설명
				proDto.setPoint(rs.getInt("point"));          // 포인트 점수
				proDto.setPinputdate(rs.getString("pinputdate")); // 제품입고일자 

				productList.add(proDto);
			}//end of while()-----
			
		} finally {close();}
		return productList;
	}//end of public List<ProuctDTO> selectBySpecName(Map<String, String> paraMap) throws SQLException-----


	
	//tbl_category 테이블에서 카테고리 대분류 번호(cnum), 카테고리코드(code), 카테고리명(cname)을 조회해오기 
	@Override
	public List<CategoryDTO> getCategoryList() throws SQLException {
		List<CategoryDTO> categoryList = new ArrayList<>(); 
	      
	      try {
	          conn = ds.getConnection();
	          String sql = " select cnum, code, cname "  
	                    + " from tbl_category "
	                    + " order by cnum asc ";
	                    
	         pstmt = conn.prepareStatement(sql);
	         rs = pstmt.executeQuery();
	                  
	         while(rs.next()) {
	            CategoryDTO cDto = new CategoryDTO();
	            cDto.setCnum(rs.getInt(1));
	            cDto.setCode(rs.getString(2));
	            cDto.setCname(rs.getString(3));
	            
	            categoryList.add(cDto);
	         }// end of while(rs.next())----------------------------------
	         
	      } finally {
	         close();
	      }   
	      
	      return categoryList;
	}//end of public List<CategoryDTO> getCategoryList() throws SQLException-----


	
	//제품스펙 목록 조회하기
	@Override
	public List<SpecDTO> getSpecList() throws SQLException {
		List<SpecDTO> specList = new ArrayList<SpecDTO>();
		try {
			conn = ds.getConnection();
			String sql = " SELECT snum, sname "
						+" FROM tbl_spec ";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				SpecDTO sDto = new SpecDTO();
				sDto.setSnum(rs.getInt("snum"));
				sDto.setSname(rs.getString("sname"));
				specList.add(sDto);
			}
			
		} finally {close();}
		return specList;
	}//end of public List<SpecDTO> getSpecList() throws SQLException-----


	//제품번호 채번 해오기
	@Override
	public int getPnumOfProduct() throws SQLException {
		int pnum = 0;
	      
		try {
			conn = ds.getConnection();
         
			String sql = " select seq_tbl_product_pnum.nextval AS PNUM "
						+" from dual ";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
         
            rs.next();
            pnum = rs.getInt(1);
         
		} finally {close();}
		return pnum;
	}//end of public int getPnumOfProduct() throws SQLException-----


	//tbl_product 테이블에 제품정보 insert 하기
	@Override
	public int productInsert(ProductDTO proDto) throws SQLException {
		int result = 0;
		try {
			conn = ds.getConnection();
			
			String sql = " insert into tbl_product(pnum, pname, fk_cnum, pcompany, pimage1, pimage2, prdmanual_systemFileName, prdmanual_orginFileName, pqty, price, saleprice, fk_snum, pcontent, point) "
			         + " values(?,?,?,?,?,?,?,?,?,?,?,?,?,?) ";
	         
			pstmt = conn.prepareStatement(sql);
			
			pstmt.setInt(1, proDto.getPnum());
			pstmt.setString(2, proDto.getPname());
			pstmt.setInt(3, proDto.getFk_cnum());    
			pstmt.setString(4, proDto.getPcompany()); 
			pstmt.setString(5, proDto.getPimage1());    
			pstmt.setString(6, proDto.getPimage2()); 
			pstmt.setString(7, proDto.getPrdmanual_systemFileName());
			pstmt.setString(8, proDto.getPrdmanual_orginFileName());
			pstmt.setInt(9, proDto.getPqty()); 
			pstmt.setInt(10, proDto.getPrice());
			pstmt.setInt(11, proDto.getSaleprice());
			pstmt.setInt(12, proDto.getFk_snum());
			pstmt.setString(13, proDto.getPcontent());
			pstmt.setInt(14, proDto.getPoint());
			
			result = pstmt.executeUpdate();
	         
	      } finally {close();}
	      
			return result;
	}//end of public int productInsert(ProductDTO proDto) throws SQLException-----


	//tbl_product_imagefile 테이블에 제품의 추가이미지 파일명 insert 하기
	@Override
	public int product_imagefile_insert(Map<String, String> paraMap) throws SQLException {
		int result = 0;
	      
	      try {
	         conn = ds.getConnection();
	         
	         String sql = " insert into tbl_product_imagefile(imgfileno, fk_pnum, imgfilename) "
	                  + " values(seqImgfileno.nextval, ?, ?) ";
	         
	         pstmt = conn.prepareStatement(sql);
	         
	         pstmt.setInt(1, Integer.parseInt(paraMap.get("pnum")) );
	         pstmt.setString(2, paraMap.get("attachFileName"));
	         
	         result = pstmt.executeUpdate();
	         
	      } finally {
	         close();
	      }
	      
	      return result;   
	}//end of public int product_imagefile_insert(Map<String, String> paraMap) throws SQLException-----
	
	
	
}//end of public class ProductDAO_imple implements ProductDAO-----
