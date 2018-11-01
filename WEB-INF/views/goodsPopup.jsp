<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>  
<html>
<head>
	<title>グロップエスシー　自動販売機</title>
</head>
<style>
	#goods_image{
		width:150px;
		height:160px;
	}
	.brand{
		border:1px
		solid black;
	}
	p {
		color: red;
	}

</style>
<script src="resources/js/jquery-3.2.1.min.js"></script>
<script>
	$(function(){
		$("#select").on("click",select)
		$("#cancel").on("click",cancel)
		$(".count_btn").on("click",count)
	})
	
	function select(){
		//親画面 reload..でも画面reloadしたらだめ..reloadしても
		//以前の会社名プルダウンとページと説明は維持すべき
		//popup>>>goodsSelect画面にデータ伝送が必要だ
		var price = ${goods.goods_price};
		var goods_count = $("#goods_count").html();
		var stock = ${goods_stock};
		var flag = ${flag};
		var data = ["${goods.goods_name}", ${goods.goods_price}, goods_count, stock, flag];
		//親画面にデータを投げる
		window.opener.receive(data);
		window.close();    
	}
	function cancel(){
		window.close();
	}
	function count(){
		var cbtn = $(this).val();
		var stock = $("#stock").attr("data-stock");
		var gct = parseInt($("#goods_count").html());
		var need = $("#need_money").html();
		if(cbtn=="▲"){
			if(gct == stock){
				alert("申し訳ございませんが、商品の在庫が足りないです。");
				return false;
			}
			if(gct>9){
				alert("最大数量は10個です。");
				return false;
			}else{
				gct++;
			}
		} else {
			if(gct<2){
				alert("最小数量は1個です。");
				return false;
			}else{
				gct--;
			}
		}
		$("#goods_count").html(gct);
		$("#need_money").html("￥　" + ${goods.goods_price}* gct);
	}	
	
</script>

<body>
	<h1>グロップエスシー　自動販売機</h1>
<div id="wrapper">
	<form id="popupForm" method="post">
	<input id="stock" type="hidden" data-stock="${goods_stock}">
		<table>
			<tr>
				<td colspan="3" class="brand">${company_name}</td>
			</tr>
			<tr>
				<td colspan="3" class="brand">${goods.goods_name}</td>
			</tr>
			<tr>
				<td rowspan="2"><img id="goods_image" src="${goods_image}"></td>
				<c:choose>
					<c:when test="${goods_stock ==0}">
						<td><p>申し訳ございませんが、<br>現在この商品の在庫がありません。<br>他の商品を選んでください。</p></td>					
					</c:when>
					<c:otherwise>
						<td><label id="goods_count">${count}</label></td>
					</c:otherwise>				
				</c:choose>
				<c:if test="${goods_stock>0}">
				<td><input type="button" class="count_btn" value="▲">
				<input type="button" class="count_btn" value="▼"></td>
				</c:if>
			</tr>
			<tr>
				<td><label>必要金額</label></td>
				<td><label id="need_money">￥ ${goods.goods_price * count}</label></td>
			</tr>
			<tr>
				<td>￥ ${goods.goods_price}</td>
			</tr>
		</table>
		<input type="button" value="選択" id="select">
		<input type="button" value="キャンセル" id="cancel">
	</form>
</div> 


</body>
</html>
