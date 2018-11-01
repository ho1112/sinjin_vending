package com.gropsc.vending.vo;

public class VendingData {
	
	private int vending_code;
	private int company_code;
	private int goods_code;
	private int goods_stock;
	private String stock_time;
	//dbにはない
	private String company_name; 
	private String goods_name;
	private String goods_image;
	
	public VendingData() {}

	public VendingData(int vending_code, int company_code, int goods_code, int goods_stock, String stock_time,
			String company_name, String goods_name, String goods_image) {
		super();
		this.vending_code = vending_code;
		this.company_code = company_code;
		this.goods_code = goods_code;
		this.goods_stock = goods_stock;
		this.stock_time = stock_time;
		this.company_name = company_name;
		this.goods_name = goods_name;
		this.goods_image = goods_image;
	}

	public int getVending_code() {
		return vending_code;
	}

	public void setVending_code(int vending_code) {
		this.vending_code = vending_code;
	}

	public int getCompany_code() {
		return company_code;
	}

	public void setCompany_code(int company_code) {
		this.company_code = company_code;
	}

	public int getGoods_code() {
		return goods_code;
	}

	public void setGoods_code(int goods_code) {
		this.goods_code = goods_code;
	}

	public int getGoods_stock() {
		return goods_stock;
	}

	public void setGoods_stock(int goods_stock) {
		this.goods_stock = goods_stock;
	}

	public String getStock_time() {
		return stock_time;
	}

	public void setStock_time(String stock_time) {
		this.stock_time = stock_time;
	}

	public String getCompany_name() {
		return company_name;
	}

	public void setCompany_name(String company_name) {
		this.company_name = company_name;
	}

	public String getGoods_name() {
		return goods_name;
	}

	public void setGoods_name(String goods_name) {
		this.goods_name = goods_name;
	}

	public String getGoods_image() {
		return goods_image;
	}

	public void setGoods_image(String goods_image) {
		this.goods_image = goods_image;
	}

	@Override
	public String toString() {
		return "VendingMachine [vending_code=" + vending_code + ", company_code=" + company_code + ", goods_code="
				+ goods_code + ", goods_stock=" + goods_stock + ", stock_time=" + stock_time + ", company_name="
				+ company_name + ", goods_name=" + goods_name + ", goods_image=" + goods_image + "]";
	}
	
}
