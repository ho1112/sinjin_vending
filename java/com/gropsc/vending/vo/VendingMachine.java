package com.gropsc.vending.vo;

public class VendingMachine {
	
	private String vending_name;
	private int vending_balance;
	private int vending_code;
	
	public VendingMachine() {}

	public VendingMachine(String vending_name, int vending_balance, int vending_code) {
		super();
		this.vending_name = vending_name;
		this.vending_balance = vending_balance;
		this.vending_code = vending_code;
	}

	public String getVending_name() {
		return vending_name;
	}

	public void setVending_name(String vending_name) {
		this.vending_name = vending_name;
	}

	public int getVending_balance() {
		return vending_balance;
	}

	public void setVending_balance(int vending_balance) {
		this.vending_balance = vending_balance;
	}

	public int getVending_code() {
		return vending_code;
	}

	public void setVending_code(int vending_code) {
		this.vending_code = vending_code;
	}

	@Override
	public String toString() {
		return "VendingMachine [vending_name=" + vending_name + ", vending_balance=" + vending_balance
				+ ", vending_code=" + vending_code + "]";
	}

}
