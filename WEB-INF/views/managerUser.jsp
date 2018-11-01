<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>  
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<style>
	.user_table {
		border : 1px solid;
	}
</style>
</head>
<%@ include file="managerMenu.jsp" %>
<script src="resources/js/jquery-3.2.1.min.js"></script>
<script>
var ul;
	$(function(){
		ul = ${ulist};
		btnSetting();
		setting();//基本設定
		$("#user_category").change(function(){
			var uc = $("#user_category option:selected").attr("value");
			changeSetting(uc);
		});
		$("#vending_list").change(function(){
			var selected_vc = $("#vending_list option:selected").attr("value");
			vending_change(selected_vc);
		});
	})
	function vending_change(vc){
		location.href = "${pageContext.request.contextPath}/location?location=user&vc="+vc;
	}
	
	function btnSetting(){
		$('#user_menu').css('background-color','red');
	}
	function changeSetting(uc){
		$.ajax({
			url : "userManager",
			data:"category="+uc,
			datatype:"json",
			success:function(resp){
				ul = resp;
				setting();
			},error:function(){
				alert('データがありません。');
			}
		})
	}//end changeSetting
	
	function setting(){
		var uc = $("#user_category option:selected").attr("value");
		var table = "";
		for(var i=0;i<ul.length;i++){
			if(ul[i] == null) {
				table += "<tr><td colspan='4'>該当する社員がいません。</td></tr>";
			} else {
				table += "<tr>";
				table += "<td>"+(i+1)+"</td>"
				table += "<td>"+ul[i].user_code+"</td>";
				table += "<td>"+ul[i].user_name+"</td>";
				table += "<td colspa='2'><input type='button' onclick='user_popup(this)' flag='user_u' value='修正' data-code='"+ul[i].user_code+"' data-name='"+ul[i].user_name+"'>";
				table += "<input type='button' onclick='user_delete(this)' value='削除' data-code='"+ul[i].user_code+"' data-name='"+ul[i].user_name+"'></td></tr>";
			}
		}//end for
		$("#user_body").html(table);
	}//end setting
	
	function user_popup(){
		alert('d');
	}
	function user_delete(data){
		var user_code = $(data).attr('data-code');
		var user_name = $(data).attr('data-name');
		var uc = $("#user_category option:selected").attr("value");
		var yn = confirm(user_name+"を削除しますか。");
		if(yn) {
			location.href = "${pageContext.request.contextPath}/user_delete?user_code="+user_code+"&category="+uc+"&vc="+${vc};
		}
		else return false;
	}
	function user_popup(data){
		var uc = $("#user_category option:selected").attr("value");
		var flag = $(data).attr('flag');
		var user_code = $(data).attr('data-code');
		var user_name = $(data).attr('data-name');
		//popup設定
		var	url= "managerUserPopup?category="+uc+"&flag=user_s"+"&vc="+${vc};
		if(flag == "user_u"){
			url= "managerUserPopup?category="+uc+"&user_code="+user_code+"&user_name="+user_name+"&flag="+flag+"&vc="+${vc};
		}
		var popupOption= "width=700, height=600, left=300, top=50";
		win = window.open(url,"",popupOption); //url,name,option
	}
	
	
	
</script>
<body>
<h1>社員管理</h1>
<div id="user_page">
<select name="vending_list" id="vending_list">
		<c:forEach var="vm" items="${vmlist}" >
			<option value="${vm.vending_code}" 
			<c:if test="${vm.vending_code == vc}">selected="selected"</c:if>>
			${vm.vending_name}</option>
		</c:forEach>
	</select>
<select name="user_category" id="user_category">
	<option value="01">社長</option>
	<option value="02">役員</option>
	<option value="03">一般社員</option>
	<option value="04">パート・アルバイト等</option>
</select>
<input type="button" id="user_sign" value="社員登録" onclick="user_popup()">
<table class="user_table">
	<thead id="head">
	<tr><td>No.</td><td>社員コード</td><td>社員名</td><td colspan='2'>オプション</td></tr>
	</thead>
	<tbody id="user_body">
	</tbody>
</table>
</div>

</body>
</html>