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
	#vending_table{
		border : 1px solid;
	}
</style>
<script src="resources/js/jquery-3.2.1.min.js"></script>
<script>
	function vending_sign(){
		var vb = $("#vending_balance").val();
		var vn = $("#vending_name").val();
		$.ajax({
			url:"vending_sign",
			data:"balance="+vb+"&name="+vn,
			success:function(){
				alert('登録しました。');
				window.opener.location.reload();    //親画面 reload
				window.close();
			},error:function(){
				alert('失敗しました。');
			}
		});
	}//end vending_sign
</script>
<body>
	<div>
		<table id="vending_table">
			<tbody>
				<tr>
					<td>自販機名 : </td>
					<td><input type="text" id="vending_name"></td>
				</tr>
				<tr>
					<td>初期残高 : </td>
					<td><input type="text" id="vending_balance"></td>
				</tr>
				<tr>
					<td colspan="2"><input type="button" id="vending_sign" onclick="vending_sign()" value="自販機登録"></td>
				</tr>
			</tbody>		
		</table>
	</div>
</body>
</html>