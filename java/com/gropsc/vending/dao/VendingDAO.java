package com.gropsc.vending.dao;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.gropsc.vending.vo.Company;
import com.gropsc.vending.vo.Goods;
import com.gropsc.vending.vo.User;
import com.gropsc.vending.vo.register;

public interface VendingDAO {
	/**
	 * 社員認証
	 * @param user
	 * @return user
	 */
	
	//ある自販機に入っている会社のコードを獲得 - top
	public ArrayList<Company> getLogoOfven(int vending_code);
	//ある自販機の入っている商品のコードを獲得 - top
	public ArrayList<Goods> getGoodsOfven(int vending_code);
	//商品コードで商品の情報を獲得 - top
	public Goods getGoodsSelect(int goods_code);
	
	public ArrayList<Company> selectAllCompany();
	
	
	public User login(String code);
	//商品説明
	public String goodsInfo(String goods_name);
	//子画面に情報を出力するためのデータ呼び出し
	public Goods popupInfo(String goods_name);
	//会社コードで会社の情報呼び出し
	public Company selectCompany(int company_code);
	
	public Goods selectGoods(String goods_name);
	
	//sales_codeを獲得する
	public Integer getSalesCode();
	
	//購入情報をDBに入れるため
	public int sales(register regi);
	public int updateStock(Map<String,Integer> map);
	
	public List<Company> getAllCompany();
	public List<Goods> getAllGoods();
	//残高
	public int updateBalance(Map<String,Integer> map);
	
	
}
