<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>  
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UFT-8">
<title>管理者メニュー</title>
</head>
<style>
	hr {
		border : none;
		border-bottom : 1px solid red;
		height: 10px;
	}
	#managerDiv {
		width:100%;
			}
	.menu{
		margin : 0 auto;
		height : 100px;
		width : 250px;
		background-color: rgb(0,153,255);
		color: white;
		font-size: 40px;
		cursor: pointer;
	}
	#gropsc{
		margin : 0 auto;
		position: absolute;
		height : 100px;
		cursor: pointer;
	}
</style>
<script src="resources/js/jquery-3.2.1.min.js"></script>
<script>
	$(function(){
		$('#goods_menu').on('click',goodsMenu);
		$('#report_menu').on('click',reportMenu);
		$('#vending_menu').on('click',vendingMenu);
		$('#user_menu').on('click',userMenu);
	})
	
	function goodsMenu(){
		location.href = "${pageContext.request.contextPath}/location?location=goods";
	}
	function reportMenu(){
		location.href = "${pageContext.request.contextPath}/location?location=report";
	}
	function vendingMenu(){
		location.href = "${pageContext.request.contextPath}/location?location=vending";
	}
	function userMenu(){
		location.href = "${pageContext.request.contextPath}/location?location=user";
	}
	
	function change1(btn) {
		//btn.css('background-color','red');
		btn.style.background = 'yellow';
	}
	function change2(btn) {
		btn.style.background = 'rgb(0,153,255)';
		btnSetting();
	}
	function gohome(){
		location.href = "${pageContext.request.contextPath}/";
	}
</script>
<body>
<div id="managerDiv">
	<form id="managerForm">
		<input class="menu" type="button" id="goods_menu" onmouseover="change1(this)" onmouseout="change2(this)" value="商品管理">
		<input class="menu" type="button" id="report_menu" onmouseover="change1(this)" onmouseout="change2(this)" value="帳票管理">
		<input class="menu" type="button" id="vending_menu" onmouseover="change1(this)" onmouseout="change2(this)" value="自販機管理">
		<input class="menu" type="button" id="user_menu" onmouseover="change1(this)" onmouseout="change2(this)" value="社員管理">
		<img id="gropsc" src="resources/img/gohome.png" onclick="gohome()">
		<br>
		<hr>
	</form>
</div>
</body>
</html>