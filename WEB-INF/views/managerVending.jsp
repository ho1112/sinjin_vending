<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>  
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<style>
	.vending_table {
		border : 1px solid;
	}
</style>
<%@ include file="managerMenu.jsp" %>
<script src="resources/js/jquery-3.2.1.min.js"></script>
<script>
	$(function(){
		btnSetting();
		$("#vending_list").change(function(){
			var selected_vn = $("#vending_list option:selected").attr("value");
			setting();
		});
	})
	
	function btnSetting(){
		$('#vending_menu').css('background-color','red');
	}
	function tro(data){
		$(data).css("background","#b7a3cc");
	}
	function trl(data){
		$(data).css("background","white");
	}
	
	function stock_update(data){
		var stock = $(data).parent().parent().find('td:eq(4)').find('input').val();
		var goods_code = $(data).attr('data-code');
		if(stock<0){
			alert("在庫は'０'以上でなければなりません。");
			return false;
		}
		$.ajax({
			url:"updateStock",
			data:"stock="+stock+"&vending_code="+${vc}+"&goods_code="+goods_code,
			success: function(){
				alert("修正しました。");
				location.href = "${pageContext.request.contextPath}/location?location=vending&vc="+${vc};
			},
			error:function(){
				alert("在庫修正に失敗しました。");
			}
		});
	}
	
	function vending_update(data){
		var vending_code = $(data).attr('data-code');
		var vending_name = $(data).parent().parent().find('td:eq(0)').find('input').val();
		var vending_balance = $(data).parent().parent().find('td:eq(2)').find('input').val();
		$.ajax({
			url:"updateVending",
			data:"vending_name="+vending_name+"&vending_code="+vending_code+"&vending_balance="+vending_balance,
			success:function(){
				alert("修正しました。");
				location.href = "${pageContext.request.contextPath}/location?location=vending&vc="+${vc};
			},
			error:function(){
				alert("自販機修正に失敗しました。");
			}
		});
	}//end vending_update
	
	function vending_signPopup(){
		//popup設定
		var	url= "managerVendingPopup";
		var popupOption= "width=700, height=600, left=300, top=50";
		win = window.open(url,"",popupOption); //url,name,option
	}
	
	function setting(){
		var vc = $("#vending_list option:selected").attr("value");
		location.href = "${pageContext.request.contextPath}/location?location=vending&vc="+vc;
	}
	
	function vending_delete(data){
		var vc = $(data).attr('data-code');
		var yn = confirm("自販機を削除すると自販機の情報及びこの自販機の商品情報も作上されます。よろしいでしょうか");
		if(yn) {
			location.href = "${pageContext.request.contextPath}/vending_delete?vc="+vc;
		}
		else return false;
	}
		
	
	
	
	
</script>
<body>
	<span>自販機管理</span><br>
	<select name="vending_list" id="vending_list">
		<c:forEach var="vm" items="${vendingMachineList}" >
			<option value="${vm.vending_code}" 
			<c:if test="${vm.vending_code == vc}">selected="selected"</c:if>>
			${vm.vending_name}</option>
		</c:forEach>
	</select>
<br>
	<input type="button" id="vending_signPopup" onclick="vending_signPopup()" value="自販機登録">
<div>
	<table class="vending_table">
		<tbody id="vending_body">
		<tr>
			<td colspan="2"><input type="text" id="vending_name" value="${vm.vending_name}"></td>
			<td>残高  :  ￥</td>
			<td><input type="text" id="vending_balance" value="${vm.vending_balance}"></td>
			<td><input type="button" data-code="${vm.vending_code}" onclick="vending_update(this)" value="自販機修正"></td>
			<td><input type="button" data-code="${vm.vending_code}" onclick="vending_delete(this)" value="自販機削除"></td>
		</tr>
		<c:forEach var="vd" items="${vendingDataList}">
		<tr onmouseover='tro(this)' onmouseleave='trl(this)'>
			<td>${vd.company_name}</td>
			<td>${vd.goods_code}</td>
			<td>${vd.goods_name}</td>
			<td>${vd.stock_time}</td>
			<td><input type="text" class="goods_stock" value="${vd.goods_stock}"></td>
			<td><input type="button" id="stock_update" data-stock="${vd.goods_stock}" data-code="${vd.goods_code}" onclick="stock_update(this)" value="在庫修正"></td>
		</tr>
		</c:forEach>
		</tbody>
	</table>
</div>

</body>
</html>