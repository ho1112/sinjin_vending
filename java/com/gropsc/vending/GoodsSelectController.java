package com.gropsc.vending;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.gropsc.vending.dao.VendingDAO;
import com.gropsc.vending.vo.Company;
import com.gropsc.vending.vo.Goods;
import com.gropsc.vending.vo.register;


@Controller
public class GoodsSelectController {
	
	@Autowired
	private SqlSession sqlSession; 
	
	@ResponseBody
	@RequestMapping(value="init0")
	public List<Company> init0(HttpSession session) {
		List<Company> clist = (List<Company>)session.getAttribute("company_list");
		return clist;
	}
	@ResponseBody
	@RequestMapping(value="init1")
	public List<Goods> init1(HttpSession session) {
		List<Goods> mglist = (List<Goods>)session.getAttribute("goods_list");
		return mglist;
	}
	@ResponseBody
	@RequestMapping(value="init2")
	public List<Goods> init2(HttpSession session) {
		VendingDAO dao = sqlSession.getMapper(VendingDAO.class);
		int vendingCode = (int)session.getAttribute("vending");
		List<Goods> vglist = dao.getGoodsOfven(vendingCode);
		return vglist;
	}
	
	
	@ResponseBody
	@RequestMapping(value="company_change",produces="application/text; charset=utf8")
	public String company_change(String company_name, HttpSession session) {
		session.setAttribute("company_name", company_name);
		return company_name;
	}
	
	//商品の説明を読んでくる
	@ResponseBody
	@RequestMapping(value="goodsInfo",produces="application/text; charset=utf8")
	public String goodsInfo(String goods_name) {
		//DBから商品の説明を読んであげる
		VendingDAO dao = sqlSession.getMapper(VendingDAO.class);
		String gn = dao.goodsInfo(goods_name);
		return gn;
	}
	
	//子画面を開く
	@RequestMapping(value="goodsSelectPopup", method=RequestMethod.GET)
	public String goodsSelectPopup(String goods_name, String goods_image, 
			String goods_stock, int count, int flag, Model model) {
		//クリックした商品の情報をDBまたはViewで持ってきて子画面に送る
		VendingDAO dao = sqlSession.getMapper(VendingDAO.class);
		Goods goods = dao.popupInfo(goods_name);
		Company company = dao.selectCompany(goods.getCompany_code());
		model.addAttribute("goods",goods);
		model.addAttribute("company_name",company.getCompany_name());
		model.addAttribute("goods_image",goods_image);
		model.addAttribute("goods_stock",goods_stock);
		model.addAttribute("count",count);
		model.addAttribute("flag",flag);
		System.out.println(count);
		System.out.println("popuInfo : "+goods);
		return "goodsPopup";
	}
	
	//商品カート情報を持ってくる
	@ResponseBody
	@RequestMapping(value="registerOpen", method=RequestMethod.POST)
	public String openRegister(@RequestBody List<List<String>> param, HttpSession session) {
		List<register> list = new ArrayList<>();
		for(List<String> l : param) {
			register regi = new register();
			regi.setNum(Integer.parseInt(l.get(0)));
			regi.setGoods_name(l.get(1));
			regi.setGoods_price(Integer.parseInt(l.get(2)));
			regi.setSales_count(Integer.parseInt(l.get(3)));
			regi.setTotal_price(Integer.parseInt(l.get(4)));
			
			list.add(regi);
		}
		session.setAttribute("regi", list);
		return "ok";
	}
	
	//レジ画面に移動
	@RequestMapping(value="register")
	public String register() {
		System.out.println("register start");
		return "register";
	}
	
	//購入ボタンを押すとDBに保存／クライアント側の最終処理
	@RequestMapping(value="sales", method = RequestMethod.GET)
	public String sales(HttpSession session, int money) {
		List<register> list = (List<register>)session.getAttribute("regi");
		VendingDAO dao = sqlSession.getMapper(VendingDAO.class);
		int vending_code = (int)session.getAttribute("vending");
		System.out.println(money+"円を稼ぎました。やったー！");
		//sales_codeも先に持ってきて一緒に登録
		Integer salesCode = dao.getSalesCode();
		if(salesCode == null) {
			salesCode = 100000;
		} else {
			salesCode++;
		}
		//現在時間
		SimpleDateFormat formatter = new SimpleDateFormat ( "yyyy.MM.dd HH:mm:ss", Locale.JAPAN );
		Date currentTime = new Date ( );
		String dTime = formatter.format ( currentTime );
		Map<String,Integer> stock_map = new HashMap<>();
		stock_map.put("vending_code", vending_code);
		//DBに販売情報を伝送
		for(register r : list) {
			//情報を集まる
			r.setSales_code(salesCode);
			r.setSales_time(dTime);
			Goods goods = dao.selectGoods(r.getGoods_name());
			r.setGoods_code(goods.getGoods_code());
			r.setCompany_code(goods.getCompany_code());
			Company c = dao.selectCompany(goods.getCompany_code());
			r.setCompany_name(c.getCompany_name());
			dao.sales(r);
			//在庫処理 vending_code, goods_code, count
			stock_map.put("goods_code", r.getGoods_code());
			stock_map.put("sales_count", r.getSales_count());
			dao.updateStock(stock_map);
		}
		//自販機の残高に稼ぐお金を追加
		Map<String,Integer> map = new HashMap<>();
		map.put("vending_code", vending_code);
		map.put("balance", money);
		dao.updateBalance(map);
		return "redirect:/";
	}
	
	//領収書ボタンをクリックした時
	@RequestMapping(value="registerPopup")
	public String registerPopup(String t, String o, Model model) {
		model.addAttribute("tounyuu",t);
		model.addAttribute("otsuri",o);
		System.out.println(t+"/"+o);
		return "registerPopup";
	}
	
}
