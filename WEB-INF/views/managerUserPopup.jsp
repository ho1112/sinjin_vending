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

</style>
<script src="resources/js/jquery-3.2.1.min.js"></script>
<script>
	
function save(){
	var name = $("#user_name").val();
	var category = $("#user_category option:selected").attr("value");
	var flag = '${flag}';	
	var page = '${category}';
	if(name==""){
		alert("社員名を入力してください。")
		return false;
	}
	if('${flag}' == 'user_s'){
		var yn = confirm("以上でよろしいでしょうか。");
		if(yn) {
			$.ajax({
				url:"user_manager",
				data:"flag="+flag+"&category="+category+"&page="+page+"&user_name="+name,
				success:function(message){
					alert(message);
					//window.opener.location.reload();    //親画面 reload
					window.opener.location.href = "${pageContext.request.contextPath}/location?location=user&vc="+${vc};
					window.close();
				},error:function(){
					alert('失敗しました。');
				}
			});
		} else return false;
	} else {
		var code = '${user_code}';
		var yn = confirm("社員情報を修正しますか。");
		if(yn) {
			$.ajax({
				url:"user_manager",
				data:"flag="+flag+"&category="+category+"&page="+page+"&user_name="+name+"&user_code="+code,
				success:function(message){
					alert(message);
					//window.opener.location.reload();    //親画面 reload
					window.opener.location.href = "${pageContext.request.contextPath}/location?location=user&vc="+${vc};
					window.close();
				},error:function(){
					alert('失敗しました。');
				}
			});
		} else return false;
	}
}//end save
	function cancel(){
		window.close();
	}
</script>
<body>
	<h1>社員情報管理</h1>
	<div>
	<table>
		<tr>
			<td>社員名</td>
			<c:choose>
			<c:when test="${flag=='user_s'}">
			<td><input type="text" id="user_name" name="user_name" data-name="user_s"></td>
			</c:when>
			<c:otherwise>
			<td><input type="text" id="user_name" name="user_name" value="${user_name}"></td>
			</c:otherwise>
			</c:choose>
		</tr>
		<tr>
			<td>社員分類</td>
			<td>
			<c:choose>
				<c:when test="${flag =='user_s'}">
				<select name="user_category" id="user_category" data-name='user_s'>
				</c:when>
				<c:otherwise>
				<select name="user_category" id="user_category" disabled="disabled">
				</c:otherwise>
			</c:choose>
			<option value="01" ${category=='01' ? 'selected' : '' }>社長</option>
			<option value="02" ${category=='02' ? 'selected' : '' }>役員</option>
			<option value="03" ${category=='03' ? 'selected' : '' }>一般社員</option>
			<option value="04" ${category=='04' ? 'selected' : '' }>パート・アルバイト等</option>
			</select>
			</td>
		</tr>
		<tr>
			<c:choose>
				<c:when test="${flag =='user_s'}">
				<td><input type="button" value="社員登録" id="save" onclick="save()"></td>
				</c:when>
				<c:otherwise>
				<td><input type="button" value="社員修正" id="save" onclick="save()" ></td>
				</c:otherwise>
			</c:choose>
			<td><input type="button" value="キャンセル" onclick="cancel()"></td>
		</tr>
	</table>
	</div>
	
</body>
</html>