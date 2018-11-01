package com.gropsc.vending.vo;

import java.util.ArrayList;

public class GoodsList {

	private ArrayList<Goods> goodsList;

	@Override
	public String toString() {
		return "GoodsList [goodsList=" + goodsList + "]";
	}

	public GoodsList(ArrayList<Goods> goodsList) {
		super();
		this.goodsList = goodsList;
	}

	public ArrayList<Goods> getGoodsList() {
		return goodsList;
	}

	public void setGoodsList(ArrayList<Goods> goodsList) {
		this.goodsList = goodsList;
	}
	
	
	
}
