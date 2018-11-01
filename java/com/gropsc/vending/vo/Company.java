package com.gropsc.vending.vo;

public class Company {
	
	private int company_code;
	private String company_name;
	private String company_image;
	private int company_delete;
	
	public Company() {};
	
	public Company(int company_code, String company_name, String company_image, int company_delete) {
		super();
		this.company_code = company_code;
		this.company_name = company_name;
		this.company_image = company_image;
		this.company_delete = company_delete;
	}

	public int getCompany_code() {
		return company_code;
	}

	public void setCompany_code(int company_code) {
		this.company_code = company_code;
	}

	public String getCompany_name() {
		return company_name;
	}

	public void setCompany_name(String company_name) {
		this.company_name = company_name;
	}

	public String getCompany_image() {
		return company_image;
	}

	public void setCompany_image(String company_image) {
		this.company_image = company_image;
	}

	public int getCompany_delete() {
		return company_delete;
	}

	public void setCompany_delete(int company_delete) {
		this.company_delete = company_delete;
	}

	@Override
	public String toString() {
		return "company [company_code=" + company_code + ", company_name=" + company_name + ", company_image="
				+ company_image + ", company_delete=" + company_delete + "]";
	}
	
}
