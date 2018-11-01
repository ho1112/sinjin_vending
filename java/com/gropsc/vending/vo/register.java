package com.gropsc.vending.vo;

public class register {
	
	private int num;
	private int sales_code;
	private int company_code;
	private String company_name;
	private int goods_code;
	private String goods_name;
	private int goods_price;
	private int sales_count;
	private String sales_time;
	private int total_price;
	
	public register() {}

	public register(int num, int sales_code, int company_code, String company_name, int goods_code, String goods_name,
			int goods_price, int sales_count, String sales_time, int total_price) {
		super();
		this.num = num;
		this.sales_code = sales_code;
		this.company_code = company_code;
		this.company_name = company_name;
		this.goods_code = goods_code;
		this.goods_name = goods_name;
		this.goods_price = goods_price;
		this.sales_count = sales_count;
		this.sales_time = sales_time;
		this.total_price = total_price;
	}

	public int getNum() {
		return num;
	}

	public void setNum(int num) {
		this.num = num;
	}

	public int getSales_code() {
		return sales_code;
	}

	public void setSales_code(int sales_code) {
		this.sales_code = sales_code;
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

	public int getGoods_code() {
		return goods_code;
	}

	public void setGoods_code(int goods_code) {
		this.goods_code = goods_code;
	}

	public String getGoods_name() {
		return goods_name;
	}

	public void setGoods_name(String goods_name) {
		this.goods_name = goods_name;
	}

	public int getGoods_price() {
		return goods_price;
	}

	public void setGoods_price(int goods_price) {
		this.goods_price = goods_price;
	}

	public int getSales_count() {
		return sales_count;
	}

	public void setSales_count(int sales_count) {
		this.sales_count = sales_count;
	}

	public String getSales_time() {
		return sales_time;
	}

	public void setSales_time(String sales_time) {
		this.sales_time = sales_time;
	}

	public int getTotal_price() {
		return total_price;
	}

	public void setTotal_price(int total_price) {
		this.total_price = total_price;
	}

	@Override
	public String toString() {
		return "register [num=" + num + ", sales_code=" + sales_code + ", company_code=" + company_code
				+ ", company_name=" + company_name + ", goods_code=" + goods_code + ", goods_name=" + goods_name
				+ ", goods_price=" + goods_price + ", sales_count=" + sales_count + ", sales_time=" + sales_time
				+ ", total_price=" + total_price + "]";
	}

}
