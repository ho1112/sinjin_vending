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
	#company_list {
		width: 150px;
	}
	#goods_list {
		width : 75%;
		float: right;
		border: solid 1px;
	}
	.goods_img {
		width:150px;
		height:160px;
	}

</style>
<script src="resources/js/jquery-3.2.1.min.js"></script>
<script>
var win;
	$(function(){
		//menu color setting
		btnSetting();
		//goods table setting
		setting();
		//select box onchange
		$("#company_name").change(function(){
			var selected_CN = $("#company_name option:selected").attr("value");
			setting();
		});
		$("#vending_list").change(function(){
			var selected_vc = $("#vending_list option:selected").attr("value");
			vending_change(selected_vc);
		});
	})
	function vending_change(selected_vc){
		location.href = "${pageContext.request.contextPath}/location?location=goods&vc="+selected_vc;
	}
	
	function btnSetting(){
		$('#goods_menu').css('background-color','red');
	}
	function setting(){
		var selected_CN = $("#company_name option:selected").attr("value");
		var mg = ${mglist};
		var cl = ${clist};
		var cc = "";
		//selectボックスから会社名をもらってcompany_codeを獲得
		for(var i=0;i<cl.length;i++){
			if(cl[i].company_name == selected_CN){
				cc = cl[i].company_code;
				break;
			}
		}
		//company_codeでその会社の商品を抽出
		var table = "<tr>";
		for(var i=0;i<mg.length;i++){
			if(mg[i] == null){
				table += "</tr>";
			} 
			else if(mg[i].company_code == cc){
				table += "<td rowspan='4'><img class='goods_img' src='"+mg[i].goods_image+"'></td></tr>";
				table += "<tr><td>商品名</td><td>:"+mg[i].goods_name+"</td></tr>";
				table += "<tr><td>値段</td><td>:"+mg[i].goods_price+"</td></tr>";
				table += "<tr><td>商品コード</td><td>:"+mg[i].goods_code+"</td></tr>";
				table += "<tr><td><input type='button' value='商品削除' data-name='"+mg[i].goods_name+"' data-code='"+mg[i].goods_code+"' onclick='goods_delete(this)'><input type='button' data-name='"+mg[i].goods_name+"' data-code='"+mg[i].goods_code+"' price='"+mg[i].goods_price+"' info='"+mg[i].goods_info+"' img='"+mg[i].goods_image+"' flag='goods_u' onclick=goods_popup(this) value='商品修正'></td>";
				table += "<td>商品説明</td><td>:"+mg[i].goods_info+"</td></tr>";
			}			
		}//end table for
		$("#goods_body").html(table);	
	}//end setting
	
	function company_delete(){
		var selected_CN = $("#company_name option:selected").attr("value");
		var selected_CC = $("#company_name option:selected").attr("data-code");
		var yn = confirm(selected_CN+"を削除しますか。会社を削除するとこの会社の商品も削除されます。");
		if(yn) location.href = "${pageContext.request.contextPath}/company_delete?cn="+selected_CN+"&cc="+selected_CC;
		else return false;
	}
	function goods_delete(data){
		var code = $(data).attr('data-code');
		var name = $(data).attr('data-name');
		var yn = confirm(name+"を削除しますか。");
		if(yn) location.href = "${pageContext.request.contextPath}/goods_delete?gn="+name+"&gc="+code;
		else return false;
	}
	function company_popup(data){
		var flag = $(data).attr('flag');
		var selected_CN = $("#company_name option:selected").attr("value");
		var selected_CC = $("#company_name option:selected").attr("data-code");
		var selected_CI = $("#company_name option:selected").attr("data-img");
		//popup設定
		var url= "managerCompanyPopup?name="+selected_CN+"&code="+selected_CC+"&img="+selected_CI+"&flag="+flag;
		if(flag == "com_s"){
			url="managerCompanyPopup?flag="+flag;
		}
		var popupOption= "width=700, height=600, left=300, top=50";
		window.open(url,"",popupOption); //url,name,option
	}
	function goods_popup(data){
		var selected_CN = $("#company_name option:selected").attr("value");
		var selected_CC = $("#company_name option:selected").attr("data-code");
		var code = $(data).attr('data-code');
		var name = $(data).attr('data-name');
		var info = $(data).attr('info');
		var price = $(data).attr('price');
		var img = $(data).attr('img');
		var flag = $(data).attr('flag');
		//popup設定
		var url= "managerGoodsPopup?name="+name+"&code="+code+"&flag="+flag+"&info="+info+"&price="+price+"&img="+img+"&company_name="+selected_CN+"&company_code="+selected_CC;
		if(flag == "goods_s"){
			url ="managerGoodsPopup?flag="+flag+"&company_name="+selected_CN+"&company_code="+selected_CC;
		}
		var popupOption= "width=700, height=600, left=300, top=50";
		win = window.open(url,"",popupOption); //url,name,option
	}
	
</script>
<%@ include file="managerMenu.jsp" %>
<body>
<div>
	<div style="width: 50%; margin: 0%; position:absolute;">
		<input type="button" id="company_sign" flag="com_s" onclick="company_popup(this)" value="会社登録">
	</div>
	<div  style="width: 40%;  margin: 0%; position:absolute; right: 10px;"  align="right">
		<input type="button" id="goods_sign" flag='goods_s' onclick="goods_popup(this)" value="商品登録">
	</div>
</div>
<br><br>
	<select name="vending_list" id="vending_list">
		<c:forEach var="vm" items="${vmlist}" >
			<option value="${vm.vending_code}" 
			<c:if test="${vm.vending_code == vc}">selected="selected"</c:if>>
			${vm.vending_name}</option>
		</c:forEach>
	</select>
<div id="company_list">
<select name="company_name" id="company_name">
	<c:forEach var="cl" items="${company_list}" >
		<option value="${cl.company_name}" data-code="${cl.company_code}" data-img="${cl.company_image}"
		<c:if test="${sel_com == cl.company_code}">selected="selected"</c:if>>
		${cl.company_name}</option>
	</c:forEach>
</select>
<input type="button" id="company_delete" onclick="company_delete()" value="会社削除">
<input type="button" id="company_update" flag='com_u' onclick="company_popup(this)" value="会社修正">
</div>
<div id="goods_list">
	<table id="goods_table">
		<tbody id="goods_body">
		</tbody>
	</table>
	<p id="login_check"></p>
</div>
</body>
</html>