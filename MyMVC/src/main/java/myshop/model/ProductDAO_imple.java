package myshop.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

import myshop.domain.CartDTO;
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


	//제품번호를 가지고서 해당 제품의 정보를 조회해오기
	@Override
	public ProductDTO selectOneProductByPnum(String pnum) throws SQLException {
		ProductDTO proDto = null;
		try {
			conn = ds.getConnection();
			String sql = " SELECT sname, pnum, pname, pcompany, price, saleprice, point, pqty, pcontent,"
						+"		  pimage1, pimage2, prdmanual_systemFileName, NVL(prdmanual_orginFileName, '없음') AS prdmanual_orginFileName "
		                +" FROM "
		                +" ( "
		                +"  select fk_snum, pnum, pname, pcompany, price, saleprice, point, pqty, pcontent, "
		                +"         pimage1, pimage2, prdmanual_systemFileName, prdmanual_orginFileName "
		                +"  from tbl_product "
		                +"  where pnum = to_number(?) "
		                +" ) P "
		                +" JOIN tbl_spec S "
		                +" ON P.fk_snum = S.snum ";
			
			pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, pnum);
	        rs = pstmt.executeQuery();
	        
	        if(rs.next()) {
	        	proDto = new ProductDTO();
	           
	            proDto.setPnum(rs.getInt("PNUM"));            // 제품번호
	            proDto.setPname(rs.getString("PNAME"));       // 제품명
	            proDto.setPcompany(rs.getString("PCOMPANY")); // 제조회사명
	            proDto.setPimage1(rs.getString("PIMAGE1"));   // 제품이미지1   이미지파일명
	            proDto.setPimage2(rs.getString("PIMAGE2"));   // 제품이미지2   이미지파일명
	            proDto.setPqty(rs.getInt("PQTY"));            // 제품 재고량
	            proDto.setPrice(rs.getInt("PRICE"));          // 제품 정가
	            proDto.setSaleprice(rs.getInt("SALEPRICE"));  // 제품 판매가(할인해서 팔 것이므로)
	            
	            SpecDTO spDTO = new SpecDTO();
	            spDTO.setSname(rs.getString("SNAME")); // 스펙명
	            
	            proDto.setSpdto(spDTO);
	            
	            proDto.setPcontent(rs.getString("PCONTENT"));      // 제품설명 
	            proDto.setPoint(rs.getInt("POINT"));              // 포인트 점수        
	            
	            proDto.setPrdmanual_systemFileName(rs.getString("PRDMANUAL_SYSTEMFILENAME")); // 파일서버에 업로드되어지는 실제 제품설명서 파일명
	            proDto.setPrdmanual_orginFileName(rs.getString("PRDMANUAL_ORGINFILENAME"));   // 웹클라이언트의 웹브라우저에서 파일을 업로드 할때 올리는 제품설명서 파일명
	        }// end of if(rs.next())-------------------------
	         
	      } finally {close();}
		return proDto;
	}//end of public ProductDTO selectOneProductByPnum(String pnum) throws SQLException-----


	
	//제품번호를 이용해 해당 제품의 추가된 이미지 정보를 조회해오기
	@Override
	public List<String> getImagesByPnum(String pnum) throws SQLException {
		List<String> imgList = new ArrayList<String>();
		try {
	         conn = ds.getConnection();
	         
	         String sql = " SELECT imgfilename "+
	                      " FROM tbl_product_imagefile "+
	                      " WHERE fk_pnum = TO_NUMBER(?) "+
	                      " ORDER BY imgfileno DESC ";
	         
	         pstmt = conn.prepareStatement(sql);
	         pstmt.setString(1, pnum);
	         
	         rs = pstmt.executeQuery();
	         
	         while(rs.next()) {
	            String imgfilename = rs.getString(1); // 이미지파일명 
	            imgList.add(imgfilename); 
	         }
			
		} finally {close();}
		
		return imgList;
	}//end of public List<String> getImagesByPnum(String pnum) throws SQLException-----


	
	//시스템에 업로드 되어진 파일설명서 첨부파일명 및 오리지널파일명 알아오기
	@Override
	public Map<String, String> getPrdmanualFileName(String pnum) throws SQLException {
		Map<String, String> map = new HashMap<String, String>();
		try {
			conn = ds.getConnection();
			String sql = " select PRDMANUAL_SYSTEMFILENAME, PRDMANUAL_ORGINFILENAME "
	                  + " from tbl_product "
	                  + " where pnum = to_number(?) ";
			pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, pnum);
	        rs = pstmt.executeQuery();
	        
	        if(rs.next()) {
	        	// 파일서버에 업로드되어진 실제 제품설명서 파일명
	            map.put("PRDMANUAL_SYSTEMFILENAME", rs.getString("PRDMANUAL_SYSTEMFILENAME"));
	            
	            // 웹클라이언트의 웹브라우저에서 파일을 업로드 할때 올리는 제품설명서 파일명 
	            map.put("PRDMANUAL_ORGINFILENAME", rs.getString("PRDMANUAL_ORGINFILENAME"));
	        }
			
		} finally {close();}
		return map;
	}//end of public Map<String, String> getPrdmanualFileName(String pnum) throws SQLException-----


	
	//장바구니 담기 
    //장바구니 테이블(tbl_cart)에 해당 제품을 담아야 한다.
    //장바구니 테이블에 해당 제품이 존재하지 않는 경우에는 tbl_cart 테이블에 insert 를 해야하고, 
    //장바구니 테이블에 해당 제품이 존재하는 경우에는 또 그 제품을 추가해서 장바구니 담기를 한다라면 tbl_cart 테이블에 update 를 해야한다.
	@Override
	public int addCart(Map<String, String> paraMap) throws SQLException {
		int n = 0;
		try {
			conn = ds.getConnection();
			/*
	           먼저 장바구니 테이블(tbl_cart)에 어떤 회원이 새로운 제품을 넣는 것인지,
	           아니면 또 다시 제품을 추가로 더 구매하는 것인지를 알아야 한다.
	           이것을 알기 위해서 어떤 회원이 어떤 제품을 장바구니 테이블(tbl_cart) 넣을때
	           그 제품이 이미 존재하는지 select 를 통해서 알아와야 한다.
	           
	         -------------------------------------------
	          cartno   fk_userid     fk_pnum   oqty  
	         -------------------------------------------
	            1      seoyh          7        12     
	            2      seoyh          6         3     
	            3      leess          7         5     
	        */
			String sql = " SELECT cartno "
						+" FROM tbl_cart"
						+" WHERE fk_userid = ? AND fk_pnum = ? ";
			pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, paraMap.get("userid"));
	        pstmt.setString(2, paraMap.get("pnum"));
	        rs = pstmt.executeQuery();
	        
	        if(rs.next()) {
	        	// 어떤 제품을 추가로 장바구니에 넣고자 하는 경우
	        	sql = " UPDATE tbl_cart SET oqty = oqty + ? "
	        		 +" WHERE cartno = ? ";
	        	pstmt = conn.prepareStatement(sql);
	        	pstmt.setInt(1, Integer.parseInt(paraMap.get("oqty")));
	        	pstmt.setInt(2, rs.getInt("cartno"));
	        	n = pstmt.executeUpdate();
	        	
	        } else {
	        	// 장바구니에 존재하지 않는 새로운 제품을 넣고자 하는 경우
	        	sql = " insert into tbl_cart(cartno, fk_userid, fk_pnum, oqty, registerday) "
	                 +" values(seq_tbl_cart_cartno.nextval, ?, ?, ?, default) ";
	        	pstmt = conn.prepareStatement(sql);
	            pstmt.setString(1, paraMap.get("userid"));
	            pstmt.setInt(2, Integer.parseInt(paraMap.get("pnum")));
	            pstmt.setInt(3, Integer.parseInt(paraMap.get("oqty")));
	            n = pstmt.executeUpdate();
	        }
		} finally {close();}
		
		return n;
	}//end of public int addCart(Map<String, String> paraMap) throws SQLException-----


	//로그인 한 사용자의 장바구니 목록을 조회하기
	@Override
	public List<CartDTO> selectProductCart(String userid) throws SQLException {
		List<CartDTO> cartList = null;
		
		try {
		   conn = ds.getConnection();
		   
		   String sql =  " SELECT C.cartno, C.fk_userid, C.fk_pnum, C.oqty, P.pname, P.pimage1, P.saleprice, P.point, P.pqty "
		            + " FROM "
		            + " (select cartno, fk_userid, fk_pnum, oqty, registerday "
		            + "  from tbl_cart "
		            + "  where fk_userid = ?) C "
		            + " JOIN tbl_product P "
		            + " ON C.fk_pnum = P.pnum "
		            + " ORDER BY C.cartno DESC ";
		   pstmt = conn.prepareStatement(sql);
		   pstmt.setString(1, userid);
		   
		   rs = pstmt.executeQuery();
		   
		   int cnt = 0;
		   while(rs.next()) {
			   cnt++;
			   if(cnt == 1) {
				   cartList = new ArrayList<CartDTO>();
			   }
			   
			   int cartno = rs.getInt("CARTNO");
	           String fk_userid = rs.getString("FK_USERID");
	           int fk_pnum = rs.getInt("FK_PNUM");
	           int oqty = rs.getInt("OQTY"); // 주문량
	           
	           String pname = rs.getString("PNAME");
	           String pimage1 = rs.getString("PIMAGE1");
	           int saleprice = rs.getInt("SALEPRICE");
	           int point = rs.getInt("POINT"); 
	           int pqty = rs.getInt("PQTY"); // 잔고량
	           
	           ProductDTO proDto = new ProductDTO();
	           proDto.setPnum(fk_pnum);
	           proDto.setPname(pname);
	           proDto.setPimage1(pimage1);
	           proDto.setSaleprice(saleprice);
	           proDto.setPoint(point);
	           proDto.setPqty(pqty);
	           
	           // ***** 중요!!!! ***** //
	           //주문량만 넣으면 DTO 단에 만들어놓은 메서드로 알아서 수량과 가격을 곱하여 계산함
	           proDto.setTotalPriceTotalPoint(oqty); 
	           
	           CartDTO cartDto = new CartDTO();
	           cartDto.setCartno(cartno);
	           cartDto.setFk_userid(fk_userid);
	           cartDto.setFk_pnum(fk_pnum);
	           cartDto.setOqty(oqty);
	           cartDto.setpDto(proDto);
	           
	           cartList.add(cartDto);
	           
		   }//end of while()-----
		   
		} finally {close();}
		return cartList;
	}//end of public List<CartDTO> selectProductCart(String userid) throws SQLException-----


	
	//로그인한 사용자의 장바구니에 담긴 주문총액합계 및 총포인트합계 알아오기
	@Override
	public Map<String, Integer> selectCartSumPricePoint(String userid) throws SQLException {
		Map<String, Integer> sumMap = new HashMap<String, Integer>();
		try {
	         conn = ds.getConnection();
	         
	         String sql = " SELECT NVL(SUM(C.oqty * P.saleprice), 0) AS SUMTOTALPRICE "
	                  + "      , NVL(SUM(C.oqty * P.point), 0) AS SUMTOTALPOINT "
	                  + " FROM "
	                  + " ( select fk_pnum, oqty "
	                  + "   from tbl_cart "
	                  + "   where fk_userid = ? ) C "
	                  + " JOIN tbl_product P "
	                  + " ON C.fk_pnum = P.pnum ";
	         
	         pstmt = conn.prepareStatement(sql);
	         pstmt.setString(1, userid);
	         rs = pstmt.executeQuery();
	         rs.next();
	         
	         sumMap.put("SUMTOTALPRICE", rs.getInt("SUMTOTALPRICE"));
	         sumMap.put("SUMTOTALPOINT", rs.getInt("SUMTOTALPOINT"));
	         
		} finally {close();}
		
		return sumMap;
	}//end of public Map<String, Integer> selectCartSumPricePoint(String userid) throws SQLException-----
	
	
	
}//end of public class ProductDAO_imple implements ProductDAO-----
