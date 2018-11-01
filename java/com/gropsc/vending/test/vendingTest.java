package com.gropsc.vending.test;

import static org.junit.Assert.*;

import java.util.Collection;
import java.util.Map;

import org.junit.Test;
import org.springframework.ui.Model;

import com.gropsc.vending.ManagerController;

public class vendingTest {

	@Test
	public void test() {
		ManagerController mc = new ManagerController();
		String ok = "managerUserPopup";
		Model m = new Model() {
			
			@Override
			public Model mergeAttributes(Map<String, ?> attributes) {
				// TODO Auto-generated method stub
				return null;
			}
			
			@Override
			public boolean containsAttribute(String attributeName) {
				// TODO Auto-generated method stub
				return false;
			}
			
			@Override
			public Map<String, Object> asMap() {
				// TODO Auto-generated method stub
				return null;
			}
			
			@Override
			public Model addAttribute(String attributeName, Object attributeValue) {
				// TODO Auto-generated method stub
				return null;
			}
			
			@Override
			public Model addAttribute(Object attributeValue) {
				// TODO Auto-generated method stub
				return null;
			}
			
			@Override
			public Model addAllAttributes(Map<String, ?> attributes) {
				// TODO Auto-generated method stub
				return null;
			}
			
			@Override
			public Model addAllAttributes(Collection<?> attributeValues) {
				// TODO Auto-generated method stub
				return null;
			}
		};
		assertEquals(ok,
				mc.user_update("uc","un","user_s","category",m,11));
		
		
	}

}
