package com.gropsc.vending.vo;

public class registerData {
	
	private int num;
	private String goods_name;
	private int goods_price;
	private int goods_count;
	private int goods_total;
	
	public registerData() {}

	public registerData(int num, String goods_name, int goods_price, int goods_count, int goods_total) {
		super();
		this.num = num;
		this.goods_name = goods_name;
		this.goods_price = goods_price;
		this.goods_count = goods_count;
		this.goods_total = goods_total;
	}

	public int getNum() {
		return num;
	}

	public void setNum(int num) {
		this.num = num;
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

	public int getGoods_count() {
		return goods_count;
	}

	public void setGoods_count(int goods_count) {
		this.goods_count = goods_count;
	}

	public int getGoods_total() {
		return goods_total;
	}

	public void setGoods_total(int goods_total) {
		this.goods_total = goods_total;
	}

	@Override
	public String toString() {
		return "registerData [num=" + num + ", goods_name=" + goods_name + ", goods_price=" + goods_price
				+ ", goods_count=" + goods_count + ", goods_total=" + goods_total + "]";
	}

}
