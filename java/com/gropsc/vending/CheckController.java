package com.gropsc.vending;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.gropsc.vending.dao.VendingDAO;
import com.gropsc.vending.vo.Company;
import com.gropsc.vending.vo.Goods;
import com.gropsc.vending.vo.User;

@Controller
public class CheckController {
	
	@Autowired
	private SqlSession sqlSession; 
	
	//TOP画面で認証画面に移動する
	@RequestMapping(value="check", method = RequestMethod.GET)
	public String check(HttpSession session, Model model) {
		String cn = (String)session.getAttribute("company_name");
		String message = "";
		if(cn == null) {
			message = "ブランドを選択してください。";
			model.addAttribute("message",message);
			return "message";
		}
		return "check";
	}
	
	//社員コードを認証して商品選択画面に移動
	@RequestMapping(value="userCheck", method=RequestMethod.POST)
	public String userCheck(String code, Model model, HttpSession session) {
		//DBからユーザーのコード検索して認証処理すべき
		System.out.println("社員コードは　： "+code+"  です。");
		VendingDAO dao = sqlSession.getMapper(VendingDAO.class);
		User user = dao.login(code);
		//失敗した場合エラーメッセージ出力、エラーメッセージ画面に連結
		String message = "";
		if(user ==null){
			message = "社員コードをご確認してください。";
			model.addAttribute("message",message);
			model.addAttribute("locationStatus","check");
			return "message";
		}
		//選択した会社名を送って会社名プルダウンを設定する
		int vendingCode = (int)session.getAttribute("vending");
		//この自販機の会社、商品情報が(master)必要
		List<Company> clist = (List<Company>)session.getAttribute("company_list");
		List<Goods> mglist = (List<Goods>)session.getAttribute("goods_list");
		//vending_dataテーブルからの商品情報
		List<Goods> vglist = dao.getGoodsOfven(vendingCode);
		
		model.addAttribute("clist",clist);
		model.addAttribute("mglist",mglist);
		model.addAttribute("vglist",vglist);
		return "goodsSelect";
	}
	
}
