package com.gropsc.vending.vo;

public class User {
	
	private String user_code;
	private String user_name;
	private String user_category;
	private int user_delete;
	private int vending_code;
	
	public User() {}

	public User(String user_code, String user_name, String user_category, int user_delete, int vending_code) {
		super();
		this.user_code = user_code;
		this.user_name = user_name;
		this.user_category = user_category;
		this.user_delete = user_delete;
		this.vending_code = vending_code;
	}

	public String getUser_code() {
		return user_code;
	}

	public void setUser_code(String user_code) {
		this.user_code = user_code;
	}

	public String getUser_name() {
		return user_name;
	}

	public void setUser_name(String user_name) {
		this.user_name = user_name;
	}

	public String getUser_category() {
		return user_category;
	}

	public void setUser_category(String user_category) {
		this.user_category = user_category;
	}

	public int getUser_delete() {
		return user_delete;
	}

	public void setUser_delete(int user_delete) {
		this.user_delete = user_delete;
	}

	public int getVending_code() {
		return vending_code;
	}

	public void setVending_code(int vending_code) {
		this.vending_code = vending_code;
	}

	@Override
	public String toString() {
		return "User [user_code=" + user_code + ", user_name=" + user_name + ", user_category=" + user_category
				+ ", user_delete=" + user_delete + ", vending_code=" + vending_code + "]";
	}

}
