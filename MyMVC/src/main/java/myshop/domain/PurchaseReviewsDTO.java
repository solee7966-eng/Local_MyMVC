package myshop.domain;

import member.domain.MemberDTO;

public class PurchaseReviewsDTO {

	private int review_seq; 
	private String fk_userid;
	private int fk_pnum; 
	private String contents; 
	private String writeDate;
	
	private MemberDTO mDto;
	private ProductDTO proDto;
	
	public PurchaseReviewsDTO() { }

	public PurchaseReviewsDTO(int review_seq, String fk_userid, int fk_pnum, String contents, String writeDate,
			MemberDTO mDto, ProductDTO proDto) {
		this.review_seq = review_seq;
		this.fk_userid = fk_userid;
		this.fk_pnum = fk_pnum;
		this.contents = contents;
		this.writeDate = writeDate;
		this.mDto = mDto;
		this.proDto = proDto;
	}

	public int getReview_seq() {
		return review_seq;
	}

	public void setReview_seq(int review_seq) {
		this.review_seq = review_seq;
	}

	public String getFk_userid() {
		return fk_userid;
	}

	public void setFk_userid(String fk_userid) {
		this.fk_userid = fk_userid;
	}

	public int getFk_pnum() {
		return fk_pnum;
	}

	public void setFk_pnum(int fk_pnum) {
		this.fk_pnum = fk_pnum;
	}

	public String getContents() {
		return contents;
	}

	public void setContents(String contents) {
		this.contents = contents;
	}

	public String getWriteDate() {
		return writeDate;
	}

	public void setWriteDate(String writeDate) {
		this.writeDate = writeDate;
	}

	public MemberDTO getmDto() {
		return mDto;
	}

	public void setmDto(MemberDTO mDto) {
		this.mDto = mDto;
	}

	public ProductDTO getProDto() {
		return proDto;
	}

	public void setProDto(ProductDTO proDto) {
		this.proDto = proDto;
	}

	
		
}