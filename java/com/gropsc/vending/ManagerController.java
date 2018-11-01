package com.gropsc.vending;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.SystemPropertyUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.google.gson.Gson;
import com.gropsc.vending.dao.ManagerDAO;
import com.gropsc.vending.dao.VendingDAO;
import com.gropsc.vending.vo.Company;
import com.gropsc.vending.vo.Goods;
import com.gropsc.vending.vo.User;
import com.gropsc.vending.vo.VendingMachine;
import com.gropsc.vending.vo.register;
import com.gropsc.vending.vo.VendingData;

@Controller
public class ManagerController {
	
	@Autowired
	private SqlSession sqlSession;
	
	String path = "resources/img/";
	
	//TOP画面で認証画面に移動する
		@RequestMapping(value="managerOpen", method = RequestMethod.GET)
		public String check() {
			return "managerCheck";
		}
	
	//管理者コードを認証して商品選択画面に移動
	@RequestMapping(value="managerCheck", method=RequestMethod.POST)
	public String userCheck(String code, Model model) {
		//DBから管理者のコード検索して認証処理すべき
		System.out.println("コードは　： "+code+"  です。");
		ManagerDAO dao = sqlSession.getMapper(ManagerDAO.class);
		User user = dao.manager_login(code);
		//失敗した場合エラーメッセージ出力、エラーメッセージ画面に連結
		String message = "";
		if(user ==null){
			message = "管理者コードをご確認してください。";
			model.addAttribute("message",message);
			model.addAttribute("locationStatus","managerOpen");
			return "message";
		}
		return "managerMenu";
	}
	
	//管理者メニューの画面移動せいぎょ
	@RequestMapping(value="location")
	public String managerGoods(String location, Model model, HttpSession session,
			@RequestParam(value="sel_com", defaultValue="")String sel_com,
			@RequestParam(value="category", defaultValue="01")int category,
			@RequestParam(value="vc", defaultValue="11")int vc
			) {
		VendingDAO vdao = sqlSession.getMapper(VendingDAO.class);
		ManagerDAO mdao = sqlSession.getMapper(ManagerDAO.class);
		//int vendingCode = 12;
		session.setAttribute("vending", vc);
		switch(location) {
		case "goods" : 
			System.out.println("goods page"+sel_com);
			List<VendingMachine> vmList = mdao.getVendingMachine(); //select bar
			//この自販機の会社情報を持ってくる
			List<Company> comlist = vdao.getLogoOfven(vc);
			List<Company> company_list = new ArrayList<>();
			for(Company c : comlist) {
				Company cc = vdao.selectCompany(c.getCompany_code());
				company_list.add(cc);
			}
			//この自販機の
			List<Goods> glist = vdao.getGoodsOfven(vc);
			List<Goods> goods_list = new ArrayList<>();
			for(Goods g : glist) {
				Goods gg = vdao.getGoodsSelect(g.getGoods_code());
				goods_list.add(gg);
			}
			String mglist = new Gson().toJson(goods_list);
			String clist = new Gson().toJson(company_list);
			model.addAttribute("mglist",mglist);
			model.addAttribute("clist",clist);
			model.addAttribute("company_list",company_list);
			model.addAttribute("sel_com",sel_com);
			model.addAttribute("vmlist",vmList);
			model.addAttribute("vc",vc);
			System.out.println("mglist:"+mglist);
			System.out.println("clist:"+clist);
			System.out.println("company_list:"+company_list);
			return "managerGoods";
		case "report" : 
			//会社、商品のリストを投げる
			List<Company> allComList = vdao.getAllCompany();
			List<Goods> allGoodsList = vdao.getAllGoods();
			model.addAttribute("clist",allComList);
			model.addAttribute("glist",allGoodsList);
			return "managerReport";
		case "vending" : 
			System.out.println("vc : "+vc+"vending Start");
			//自販機の残高、名
			List<VendingMachine> vmlist = mdao.getVendingMachine(); //select bar
			VendingMachine vm = mdao.getSelectVendingMachine(vc);
			//自販機の商品リスト、在庫、入り替え
			List<VendingData> vdlist = mdao.getVendingData(vc);
			System.out.println(vdlist);
			//VendingDataにcompany_name,goods_name,goods_imageを入れる
			for(int i=0;i<vdlist.size();i++) {
				//商品情報
				Goods g = vdao.getGoodsSelect(vdlist.get(i).getGoods_code());
				if(g != null) {
					vdlist.get(i).setGoods_name(g.getGoods_name());
					vdlist.get(i).setCompany_code(g.getCompany_code());
					vdlist.get(i).setGoods_image(g.getGoods_image());
					//会社情報
					Company c = vdao.selectCompany(vdlist.get(i).getCompany_code());
					vdlist.get(i).setCompany_name(c.getCompany_name());
				}
			}
			model.addAttribute("vendingMachineList",vmlist); //select bar
			model.addAttribute("vm",vm);
			System.out.println(vm);
			model.addAttribute("vendingDataList",vdlist); //table
			model.addAttribute("vc",vc);
			return "managerVending";
		case "user" : 
			List<VendingMachine> vml = mdao.getVendingMachine(); //select bar
			Map<String,Integer> map = new HashMap<>();
			map.put("vending_code", vc);
			System.out.println("user vc : "+vc);
			map.put("category", category);
			System.out.println("syainn:"+map);
			List<User> user_list = mdao.getUser(map);
			String ulist = new Gson().toJson(user_list);
			model.addAttribute("ulist",ulist);
			model.addAttribute("vmlist",vml);
			model.addAttribute("vc",vc);
			System.out.println("user list"+ulist);
			return "managerUser";
		}
		return null;
	}
	//会社登録, 会社修正 ページをopen
	@RequestMapping(value="managerCompanyPopup")
	public String managerCompanyPopup(
			@RequestParam(value="name", defaultValue="name") String name,
			@RequestParam(value="code", defaultValue="0") int code,
			@RequestParam(value="img", defaultValue="img") String img,
		    String flag, Model model,HttpSession session) {
		//flagは会社の登録か修正かを分かるように送ってくれたこと ("com_s","com_u")
		int vc = (int)session.getAttribute("vending");
		model.addAttribute("vc",vc);
		model.addAttribute("flag",flag);
		//(company)name,code
		model.addAttribute("name", name);
		model.addAttribute("code",code);
		model.addAttribute("img",img);
		System.out.println("pop: "+flag+name+code+img);
		return "managerCompanyPopup";
	}
	@RequestMapping(value="managerGoodsPopup")
	public String managerGoodsPopup(
			@RequestParam(value="name", defaultValue="name")String name, 
			@RequestParam(value="code", defaultValue="1")int code, 
			@RequestParam(value="info", defaultValue="info")String info, 
			@RequestParam(value="price", defaultValue="price")String price, 
			@RequestParam(value="img", defaultValue="resources/img/gropsc.png")String img, 
			String company_name,String company_code, String flag, Model model,HttpSession session) {
		//flagは会社または商品の登録か修正かを分かるように送ってくれたこと ("com_s","com_u","goods_s","goods_u")
		int vc = (int)session.getAttribute("vending");
		model.addAttribute("flag",flag);
		model.addAttribute("company_name",company_name);
		model.addAttribute("vc",vc);
		if(flag.equals("goods_s")) {
		model.addAttribute("img",img);
		model.addAttribute("company_code",company_code);
			return "managerGoodsPopup";
		}
		model.addAttribute("company_code",company_code);
		Goods g = new Goods();
		g.setGoods_info(info);
		g.setGoods_price(Integer.parseInt(price));
		g.setGoods_image(img);
		g.setGoods_code(code);
		g.setGoods_name(name);
		model.addAttribute("goods",g);
		return "managerGoodsPopup";
	}
	
	//商品登録、修正 
	@RequestMapping(value="goodsManager", method=RequestMethod.POST)
	public String updateManager (String flag, Goods goods,String company_name, @RequestPart MultipartFile upload, HttpSession session) {
		ManagerDAO dao = sqlSession.getMapper(ManagerDAO.class);
		String img = upload.getOriginalFilename();
		System.out.println(goods);
		switch(flag) {
		case "goods_s" :
			//goods_codeの順番を確認
			int nextCode = dao.getNextGoods_code()+1;
			goods.setGoods_code(nextCode);
			System.out.println("登録:"+goods);
			if(img=="") { //イメージを登録しなかｘた場合、基本イメージで設定されている
				System.out.println("no upload");
			} else {
				FileService fs = new FileService();
				String newFileName = fs.newSaveFile(upload,company_name, nextCode);
				System.out.println(newFileName);
				goods.setGoods_image(newFileName);
			}
			dao.goods_sign(goods);
			//自販機に追加
			int vending_code = (int)session.getAttribute("vending");
			Map<String,Integer> map = new HashMap<>();
			map.put("vending_code", vending_code);
			map.put("company_code", goods.getCompany_code());
			map.put("goods_code", goods.getGoods_code());
			map.put("goods_price", goods.getGoods_price());
			dao.goods_signOfven(map);
			break;
		case "goods_u" :
			System.out.println("goods_u/");
				if(img == "") { //アップロードしたイメージがない場合
					//DBにイメージを除いたname,price,info,image(既存)を送る
					int i = dao.goods_update(goods);
					System.out.println("i : "+i);
				} else { //新しいイメージをアップロードした場合(同じイメージである場合は想定しない)
					FileService fs = new FileService();
					String originalPath = goods.getGoods_image();
					if(fs.deleteFile(originalPath)) {
						System.out.println("削除");
					}
					//新しい imgfileを既存経路にアップロードさせる
					String save = fs.saveFile(upload,originalPath);
					goods.setGoods_image(save);
					System.out.println("修正 : "+goods);
					int i2 = dao.goods_update(goods);
					System.out.println("i2 : "+i2);
				}
			break;
 		}
		return "redirect:location?location=goods";
	}
	
	@RequestMapping(value="companyManager")
	public String signManager(String flag, Company company, @RequestPart MultipartFile upload, HttpSession session) {
		ManagerDAO dao = sqlSession.getMapper(ManagerDAO.class);
		String img = upload.getOriginalFilename();
		switch(flag) {
		case "com_s" :
			System.out.println("com_s/");
			int nextCode = dao.getNextCompany_code()+100;
			company.setCompany_code(nextCode);
			if(img == "") {
				company.setCompany_image("resources/img/gropsc.png");
			} else {
				System.out.println("img upload :"+company);
				FileService fs = new FileService();
				String newFileName = fs.newSaveFile(upload,company.getCompany_name(), nextCode);
				System.out.println(newFileName);
				company.setCompany_image(newFileName);
			} 
			System.out.println(company);
			dao.company_sign(company);
			//自販機に追加
			int vending_code = (int)session.getAttribute("vending");
			Map<String,Integer> map = new HashMap<>();
			map.put("vending_code", vending_code);
			map.put("company_code", company.getCompany_code());
			dao.company_signOfven(map);
			break;
		case "com_u" :
			System.out.println("com_u/");
			if(img == "") { //アップロードしたイメージがない場合
				dao.company_update(company);
			} else { //新しいイメージをアップロードした場合(同じイメージである場合は想定しない)
				System.out.println("1");
				FileService fs = new FileService();
				String originalPath = company.getCompany_image();
				/*
				if(fs.deleteFile(originalPath)) {
					System.out.println("삭제성공");
				}*/
				//新しい imgfileを既存経路にアップロードさせる
				System.out.println("original: "+originalPath);
				String save = fs.saveFile(upload,originalPath);
				System.out.println("2");
				company.setCompany_image(save);
				System.out.println("修正 : "+company);
				dao.company_update(company);
			
			break;
			}
		}//end switch
		return "redirect:location?location=goods";
	}
	
	//会社削除
	@RequestMapping(value="company_delete")
	public String company_delete(String cn, int cc) {
		ManagerDAO dao = sqlSession.getMapper(ManagerDAO.class);
		int del = dao.company_deleteOfven(cc);
		return "redirect:location?location=goods";
	}
	//商品削除
	@RequestMapping(value="goods_delete")
	public String goods_delete(String gn, int gc, HttpSession session) {
		int vending_code = (int)session.getAttribute("vending");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("goods_code", gc); map.put("vending_code", vending_code);
		ManagerDAO dao = sqlSession.getMapper(ManagerDAO.class);
		int del = dao.goods_deleteOfven(map);
		return "redirect:location?location=goods";
	}
	
	//社員画面
	@ResponseBody
	@RequestMapping(value="userManager")
	public List<User> userManager(int category, HttpSession session) {
		System.out.println("ajax user : "+category);
		int vending_code = (int)session.getAttribute("vending");
		Map<String,Integer> map = new HashMap<>();
		map.put("vending_code", vending_code);
		map.put("category", category);
		ManagerDAO mdao = sqlSession.getMapper(ManagerDAO.class);
		List<User> ulist = mdao.getUser(map);
		System.out.println(ulist);
		return ulist;
	}
	
	@RequestMapping(value="user_delete")
	public String user_delete(
			@RequestParam(value="user_code", defaultValue="00")String uc,
			@RequestParam(value="category", defaultValue="03")String category,
			HttpSession session,int vc) {
		if(uc.equals("00")) {
			return null;
		}
		int vending_code = (int)session.getAttribute("vending");
		Map<String,String> map = new HashMap<>();
		map.put("vending_code", vending_code+"");
		map.put("user_code", uc);
		ManagerDAO mdao = sqlSession.getMapper(ManagerDAO.class);
		mdao.user_delete(map);
		return "redirect:location?location=user&category="+category+"&vc="+vc;
	}
	
	@RequestMapping(value="managerUserPopup")
	public String user_update(
			@RequestParam(value="user_code", defaultValue="aaa")String user_code,
			@RequestParam(value="user_name", defaultValue="aaa")String user_name,
			String flag, String category, Model model,int vc) {
		model.addAttribute("category",category);
		model.addAttribute("flag",flag);
		model.addAttribute("vc",vc);
		switch(flag) {
		case "user_s" :
			System.out.println("user_s");
			break;
		case "user_u" :
			System.out.println("user_u");
			model.addAttribute("user_name",user_name);
			model.addAttribute("user_code",user_code);
			break;
		}
		return "managerUserPopup";
	}
	
	//登録、修正
	@ResponseBody
	@RequestMapping(value="user_manager",produces="application/text; charset=utf8")
	public String user_manager(String flag, String category, String user_code, String page, String user_name, HttpSession session) {
		System.out.println("userpopupから"+flag+category+page);
		int vending_code = (int)session.getAttribute("vending");
		ManagerDAO dao = sqlSession.getMapper(ManagerDAO.class);
		String message = "";
		User user = new User();
		user.setVending_code(vending_code);
		user.setUser_name(user_name);
		user.setUser_category(category);
		switch(flag) {
		case "user_s" :
			//新しいコード順番を取る
			int count = dao.getNextUser_code(category);
			String newCode = "";
			if(category.equals("01")) newCode = "ow01";
			else if(category.equals("02")) newCode = "ex02";
			else if(category.equals("03")) newCode = "sa03";
			else newCode = "pa04";
			
			if(count<9) newCode += "000"+(count+1);
			else if(count<99) newCode += "00"+(count+1);
			else if(count<999) newCode += "0"+(count+1);
			else if(count<9999) newCode += (count+1)+"";
			else {
				message = "もう社員登録が不可能です。システムの修正が必要です。";				
				return message;
			}
			user.setUser_code(newCode);
			System.out.println("ajax user_s"+user);
			dao.user_sign(user);
			message = "登録しました。";
			break;
		case "user_u" :
			user.setUser_code(user_code);
			System.out.println("ajax user_u : "+user);
			int i = dao.user_update(user);
			if(i==1)message = "修正しました。";
			break;
		}
		return message;
	}
	
	//在庫修正
	@ResponseBody
	@RequestMapping(value="updateStock")
	public String updateStock(int stock,int goods_code,int vending_code) {
		ManagerDAO mdao = sqlSession.getMapper(ManagerDAO.class);
		VendingData vd = new VendingData();
		vd.setGoods_code(goods_code);
		vd.setGoods_stock(stock);
		vd.setVending_code(vending_code);
		mdao.updateStock(vd);
		System.out.println(vd);
		return "ok";
	}
	//自販機修正
	@ResponseBody
	@RequestMapping(value="updateVending")
	public String updateVending(int vending_code,String vending_name,int vending_balance) {
		ManagerDAO mdao = sqlSession.getMapper(ManagerDAO.class);
		VendingMachine vm = new VendingMachine();
		vm.setVending_code(vending_code);
		vm.setVending_balance(vending_balance);
		vm.setVending_name(vending_name);
		mdao.updateVending(vm);
		System.out.println(vm);
		return "ok";
	}
	//自販機登録
	@RequestMapping(value="managerVendingPopup")
	public String managerVendingPopup() {
		return "managerVendingPopup";
	}
	
	@ResponseBody
	@RequestMapping(value="vending_sign")
	public String vending_sign(int balance, String name) {
		VendingMachine vm = new VendingMachine();
		vm.setVending_balance(balance);
		vm.setVending_name(name);
		//新しいcodeを取る
		ManagerDAO mdao = sqlSession.getMapper(ManagerDAO.class);
		int vc = mdao.getNextVending_code() + 1;
		vm.setVending_code(vc);
		System.out.println(vm);
		mdao.vending_sign(vm);
		return "ok";
	}
	
	@RequestMapping(value="vending_delete")
	public String vending_delete(int vc) {
		System.out.println(vc);
		ManagerDAO mdao = sqlSession.getMapper(ManagerDAO.class);
		mdao.vending_delete(vc);
		return "redirect:location?location=vending";
	}
	
	@ResponseBody
	@RequestMapping(value="reportManager")
	public register reportManager(String flag, String date1, String date2, int code) {
		ManagerDAO mdao = sqlSession.getMapper(ManagerDAO.class);
		Map<String,String> map = new HashMap<>();
		map.put("code", code+"");
		map.put("date1", date1); map.put("date2", date2);
		register re = new register();
		switch(flag) {
		case "company_name" :
			re= mdao.companyReport(map);
			break;
		case "goods_name" :
			re= mdao.goodsReport(map);
			break;
		}
		System.out.println("帳票 : "+re);
		return re;
	}
	
	@ResponseBody
	@RequestMapping(value="reportList")
	public List<register> reportList(String flag, String date1, String date2, int code) {
		System.out.println(flag+date1+date2+code);
		ManagerDAO mdao = sqlSession.getMapper(ManagerDAO.class);
		Map<String,String> map = new HashMap<>();
		map.put("code", code+""); map.put("flag", flag);
		map.put("date1", date1); map.put("date2", date2);
		List<register> rList = mdao.reportList(map);
		System.out.println(rList);
		return rList;
	}
	
}
