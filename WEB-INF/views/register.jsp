<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>  
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<title>購入</title>
<style>
	.cart th, td {
		border:1px
		solid black;
	}
</style>
</head>
<script src="resources/js/jquery-3.2.1.min.js"></script>
<script>
$(function(){
	$("#tounyuu").on("KeyUp",otsuri);
	total();
});

function total(){
	var cart_body = $("#cart_body");
	var count = 0; var total = 0;
	for(var i=0;i<cart_body.find('tr').length;i++) {
		count += parseInt(cart_body.find('tr').eq(i).find('td:eq(3)').html());
		total += parseInt(cart_body.find('tr').eq(i).find('td:eq(4)').html());
	}
	$("#cart_total").html(count+"個 / "+"￥ "+total);
	$("#goukei").html(total);
}//total

function otsuri(){
	var keyValue = event.keyCode;
	//投入金額に文字を入れた場合、エラー
	if( ((keyValue >= 48) && (keyValue <= 57)||(keyValue==8)) ) { //8はback space
	}else {
		alert("お金を入れてください。");
		$("#tounyuu").val("");
		$("#otsuri").html("");
		return false;
	}
	//お釣りの計算とバックスペースを押したときの処理
	if($("#tounyuu").val() !=""){
		var total = parseInt($("#goukei").html());
		var tounyuu = parseInt($("#tounyuu").val());
		var otsuri = tounyuu - total;
		if(otsuri<0){
			$("#otsuri").html(Math.abs(otsuri)+"円をもっと入れてください。");	
		} else {
		$("#otsuri").html(otsuri+"円");
		}
	} else {
		$("#otsuri").html("");
	}
	//購入ボタン処理
	if(otsuri<0 || tounyuu==null){
		$("#kounyuu").attr('disabled',true);
	} else if(otsuri == 0){
		$("#kounyuu").attr('disabled',false);
		$("#kounyuu").attr('onclick',false);
		$("#kounyuu").on('click',home);
	} else{
		$("#kounyuu").attr('disabled',false);
	}
}//end otsuri

function buy(){
	alert("ご利用ありがとうございます。(株)グロップエスシー自販機");
	$("#tounyuu").attr('disabled',true);
	//購入ボタンを返却ボタンに変更
	$("#kounyuu").val("返却");
	$("#kounyuu").attr('onclick',false);
	$("#kounyuu").on('click',hen);
	$("#register").attr('disabled',false);
}
function hen(){
	var otsuri= $("#otsuri").html();
	alert(otsuri+"を返却しました。ありがとうございます。");
	end();
}
function home(){
	alert("ご利用ありがとうございます。初期画面に戻ります。");
	end();
}
function end(){
	var money = $("#goukei").text();
	location.href = "${pageContext.request.contextPath}/sales?money="+money;
}
//領収書ボタン
function registerPrint(){
	var t = $("#tounyuu").val();
	var o = $("#otsuri").html();
	var url= "registerPopup?t="+t+"&o="+o;
    var popupOption= "width=700, height=600, left=300, top=50";
	window.open(url,"",popupOption); //url,name,option
}
</script>
<body>
	<div id ="cart">
	<form id="registerForm" name="registerForm">
	<h1><label>ご利用ありがとうございました。</label></h1>
		<table class='cart'>
			<tr>
				<th colspan='5'>ショッピングカート</th>
			</tr>
			<tr>
				<td>No.</td>
				<td>商品名</td>
				<td>値段</td>
				<td>数量</td>
				<td>合計</td>
			</tr>
			<tbody id="cart_body">
				<c:forEach var="regi" items="${regi}">
					<tr>
						<td>${regi.num}</td>
						<td>${regi.goods_name}</td>
						<td>${regi.goods_price}</td>
						<td>${regi.sales_count}</td>
						<td>${regi.total_price}</td>
					</tr>
				</c:forEach>
			</tbody>
			<tfoot>
				<tr>
					<td colspan="3">Total : </td>
					<td colspan="2" id="cart_total"></td>
				</tr>
			</tfoot>
		</table>
		<table>
			<tr>
				<td>合計金額</td>
				<td id="goukei"></td>
			</tr>
			<tr>
				<td>投入金額</td>
				<td><input type="text" id="tounyuu" onKeyUp="otsuri()"></td>
			</tr>
			<tr>	
				<td>お釣り</td>
				<td id="otsuri"></td>
			</tr>
		</table>
		<input type="button" id="register" value="領収書" disabled="disabled" onclick="registerPrint()">
		<input type="button" id="kounyuu" value="購入" disabled="disabled" onclick="buy()">	
		</form>
	</div>
</body>
</html>