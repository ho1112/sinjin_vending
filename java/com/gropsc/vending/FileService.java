package com.gropsc.vending;

import java.io.File;
import java.io.IOException;

import org.springframework.web.multipart.MultipartFile;

public class FileService {
	
	final String PATH = "C:/Users/Ho/Documents/workspace-sts-3.9.4.RELEASE/.metadata/.plugins/org.eclipse.wst.server.core/tmp0/wtpwebapps/vending_machine/";
		
	public String saveFile(MultipartFile upload, String originalFile) {
		//ファイル名変更
		System.out.println("save1");
		char last = originalFile.charAt(originalFile.length()-5);
		String l = Character.toString(last);
		String newname = "";
		try {
			newname = (Integer.parseInt(l)+1)+"";
		}catch (Exception e) {
			newname = 1+"";
		}
		System.out.println("newname : "+newname);
		//拡張子
		int lastIndex = originalFile.lastIndexOf(".");
		String ext = originalFile.substring(lastIndex,originalFile.length());
		originalFile = originalFile.substring(0,lastIndex-1);
		System.out.println("拡張子: "+ext);
		System.out.println("原本cut:"+originalFile);
		
		File saveFile = null;
		saveFile = new File(PATH+originalFile+newname+ext);
		System.out.println("saveFile 全体のurl : "+saveFile);
		//DBに保存する名は前にPATHを外して
		String save = originalFile+newname+ext;
		System.out.println("return:"+save);
		try {
			upload.transferTo(saveFile);
		} catch (IllegalStateException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		return save;
	}
	
	//登録
	public String newSaveFile(MultipartFile upload, String company_name, int goods_code) {
		String goodsPath = "resources/img/goods/"+company_name+"/";
		String ori = upload.getOriginalFilename();
		//拡張子
		int lastIndex = ori.lastIndexOf(".");
		String ext = ori.substring(lastIndex,ori.length());
		ori = ori.substring(0,lastIndex);
		System.out.println("name: "+ori);
		File newDir = new File(PATH+goodsPath);
		if(!newDir.isDirectory()) {
			System.out.println("dir make");
			newDir.mkdirs();
		}
		
		File newImage = new File(PATH+goodsPath+goods_code+ext);
		System.out.println("새로운이미지파일명 : "+newImage.toString());
		String fileName = goodsPath+goods_code+ext;
		System.out.println("return : "+fileName);
		try {
			upload.transferTo(newImage);
		} catch (IllegalStateException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		return fileName;
	}
			
			
	//ファイル削除
	public boolean deleteFile(String path){
		boolean result = false;
		
		System.out.println("패스"+path);
		String fullPath = PATH+path;
		
		File delFile = new File(fullPath);
		if(delFile.isFile()){
			delFile.delete();
			result = true;
		}
		System.out.println("삭제if문 끝");
		return result;
	}
}
