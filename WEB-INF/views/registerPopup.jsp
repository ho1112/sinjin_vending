<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> 
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<title>Insert title here</title>
</head>
<style>
	 table {
		border:1px
		solid black;
	}
	.info{
		text-align: center;
	}
</style>
<script src="resources/js/jquery-3.2.1.min.js"></script>
<script>
$(function(){
	total();
});
function total(){
	var cart_body = $("#register_body");
	var count = 0; var total = 0;
	for(var i=0;i<cart_body.find('tr').length;i++) {
		count += parseInt(cart_body.find('tr').eq(i).find('td:eq(3)').html());
		total += parseInt(cart_body.find('tr').eq(i).find('td:eq(4)').html());
	}
	$("#register_total").html(count+"個 / "+"￥ "+total);
}//total
function registerPrint(){
	window.print();
	window.close();
}
</script>
<body>
<div id ="registerPopup">
	<form id="registerPopupForm" name="registerPopupForm">
		<table class='registerPopup'>
			<tr>
				<th colspan='5'>領	収	書</th>
			</tr>
			<tr>
				<td colspan='5'><br></td>
			</tr>
			<tr>
				<td>No.</td>
				<td>商品名</td>
				<td>値段</td>
				<td>数量</td>
				<td>合計</td>
			</tr>
			<tbody id="register_body">
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
					<td colspan='5'>------------------------------------------------</td>
				</tr>
				<tr>
					<td colspan="3">Total : </td>
					<td colspan="2" id="register_total"></td>
				</tr>
				<tr>
					<td colspan='5'><br></td>
				</tr>
				<tr>
					<td colspan="3">お預り</td>
					<td colspan="2">${tounyuu}円</td>
				</tr>
				<tr>
					<td colspan="3">お釣り</td>
					<td colspan="2">${otsuri}</td>
				</tr>
				<tr>
					<td colspan='5'>------------------------------------------------</td>
				</tr>
				<tr>
					<td class="info" colspan="5">(株)グロップエスシー</td>
				</tr>
				<tr>
					<td class="info" colspan="5">03-xxxx-xxxx</td>
				</tr>
			</tfoot>
		</table>
		<input type="button" id="print" value="発行" onclick="registerPrint()">	
		</form>
	</div>
</body>
</html>