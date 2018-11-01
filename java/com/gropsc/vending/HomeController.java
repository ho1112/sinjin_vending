package com.gropsc.vending;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.gropsc.vending.dao.VendingDAO;
import com.gropsc.vending.vo.Company;
import com.gropsc.vending.vo.Goods;

/**
 * Handles requests for the application home page.
 */
@Controller
public class HomeController {
	
	@Autowired
	private SqlSession sqlSession; 
	
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String home(Model model, HttpSession session) {
		System.out.println("初期画面");
		//接続する自販機の初期画面を設定
		//自販機コードは臨時で設定
		int vendingCode = 11;
		VendingDAO dao = sqlSession.getMapper(VendingDAO.class);
		//この自販機の会社logoを持ってくる
		List<Company> clist = dao.getLogoOfven(vendingCode);
		List<Company> company_list = new ArrayList<>();
		for(Company c : clist) {
			Company cc = dao.selectCompany(c.getCompany_code());
			company_list.add(cc);
		}
		List<Goods> glist = dao.getGoodsOfven(vendingCode);
		List<Goods> goods_list = new ArrayList<>();
		for(Goods g : glist) {
			Goods gg = dao.getGoodsSelect(g.getGoods_code());
			goods_list.add(gg);
		}
		model.addAttribute("company",company_list);
		session.setAttribute("company_list", company_list);
		session.setAttribute("goods_list", goods_list);
		session.setAttribute("vending", vendingCode);
		return "top";
	}
	
	@ResponseBody
	@RequestMapping("goodsImg")
	public List<Goods> goodsImg(HttpSession session) {
		int v = (int)session.getAttribute("vending");
		VendingDAO dao = sqlSession.getMapper(VendingDAO.class);
		List<Goods> glist = dao.getGoodsOfven(v);
		List<Goods> goods_list = new ArrayList<>();
		for(Goods g : glist) {
			Goods gg = dao.getGoodsSelect(g.getGoods_code());
			goods_list.add(gg);
		}
		return goods_list;
	}
	//会社のロゴをクリックした時
	@ResponseBody
	@RequestMapping("company_logo")
	public void company_logo(HttpSession session, int code) {
		VendingDAO dao = sqlSession.getMapper(VendingDAO.class);
		Company c = dao.selectCompany(code);
		session.setAttribute("company_name", c.getCompany_name());
	}
	
}
