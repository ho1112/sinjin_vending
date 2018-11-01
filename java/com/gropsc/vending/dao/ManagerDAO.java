package com.gropsc.vending.dao;

import java.util.List;
import java.util.Map;

import com.gropsc.vending.vo.Company;
import com.gropsc.vending.vo.Goods;
import com.gropsc.vending.vo.User;
import com.gropsc.vending.vo.VendingMachine;
import com.gropsc.vending.vo.register;
import com.gropsc.vending.vo.VendingData;

public interface ManagerDAO {
	
	//管理者認証
	public User manager_login(String code);
	
	//会社削除 
	public int company_deleteOfven(int company_code);
	
	//商品削除
	public int goods_deleteOfven(Map<String, Object> map);
	
	//商品登録
	public int goods_sign(Goods goods);
	public int goods_signOfven(Map<String,Integer> map);
	//商品修正
	public int goods_update(Goods goods);
	//次のgoods_code確認
	public int getNextGoods_code();
	//会社修正
	public int company_update(Company company);
	//会社登録
	public int company_sign(Company company);
	public int getNextCompany_code();
	public int company_signOfven(Map<String,Integer> map);
	//社員
	public List<User> getUser(Map<String,Integer> map);
	public int user_delete(Map<String,String> map);
	public int user_sign(User user);
	public int user_update(User user);
	public int getNextUser_code(String category);
	//自販機
	public List<VendingMachine> getVendingMachine();
	public VendingMachine getSelectVendingMachine(int vending_code);
	public List<VendingData> getVendingData(int vending_code);
	//在庫修正
	public int updateStock(VendingData vd);
	//自販機
	public int updateVending(VendingMachine vm);
	public int getNextVending_code();
	public int vending_sign(VendingMachine vm);
	public int vending_delete(int vending_code);
	//帳票
	public register companyReport(Map<String,String> map);
	public register goodsReport(Map<String,String> map);
	public List<register> reportList(Map<String,String> map);
}
