package com.gropsc.vending.vo;

public class Goods {
	
	private int goods_code;
	private String goods_name;
	private int company_code;
	private String goods_info;
	private String goods_image;
	private int goods_stock;
	private int goods_price;
	private int goods_delete;
	
	public Goods() {}

	public Goods(int goods_code, String goods_name, int company_code, String goods_info, String goods_image,
			int goods_stock, int goods_price, int goods_delete) {
		super();
		this.goods_code = goods_code;
		this.goods_name = goods_name;
		this.company_code = company_code;
		this.goods_info = goods_info;
		this.goods_image = goods_image;
		this.goods_stock = goods_stock;
		this.goods_price = goods_price;
		this.goods_delete = goods_delete;
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

	public int getCompany_code() {
		return company_code;
	}

	public void setCompany_code(int company_code) {
		this.company_code = company_code;
	}

	public String getGoods_info() {
		return goods_info;
	}

	public void setGoods_info(String goods_info) {
		this.goods_info = goods_info;
	}

	public String getGoods_image() {
		return goods_image;
	}

	public void setGoods_image(String goods_image) {
		this.goods_image = goods_image;
	}

	public int getGoods_stock() {
		return goods_stock;
	}

	public void setGoods_stock(int goods_stock) {
		this.goods_stock = goods_stock;
	}

	public int getGoods_price() {
		return goods_price;
	}

	public void setGoods_price(int goods_price) {
		this.goods_price = goods_price;
	}

	public int getGoods_delete() {
		return goods_delete;
	}

	public void setGoods_delete(int goods_delete) {
		this.goods_delete = goods_delete;
	}

	@Override
	public String toString() {
		return "Goods [goods_code=" + goods_code + ", goods_name=" + goods_name + ", company_code=" + company_code
				+ ", goods_info=" + goods_info + ", goods_image=" + goods_image + ", goods_stock=" + goods_stock
				+ ", goods_price=" + goods_price + ", goods_delete=" + goods_delete + "]";
	};
	
}
