package myshop.domain;

public class SpecDTO {
	private int snum;      // 스펙번호       
	private String sname;  // 스펙명
	
	public SpecDTO() {}
	
	public SpecDTO(int snum, String sname) {
		super();
		this.snum = snum;
		this.sname = sname;
	}
	
	public int getSnum() {
		return snum;
	}
	public void setSnum(int snum) {
		this.snum = snum;
	}
	public String getSname() {
		return sname;
	}
	public void setSname(String sname) {
		this.sname = sname;
	}
}
