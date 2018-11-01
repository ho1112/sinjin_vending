<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>  
<html>
<head>
	<title>グロップエスシー　自動販売機</title>
</head>
<style>
	.cl {
		width:150px;
		cursor:pointer;
	}
	.goodsImg {
		width:60px;
		height:60px;
	}
</style>

<script src="resources/js/jquery-3.2.1.min.js"></script>
<script>
$(function(){
	$(".gt").on("click",company)
	$(".gt").on("mouseover",img)
})

function img(){
	var code = $(this).attr("data-code");
	$.ajax({
		url : "goodsImg",
		method:"get",
		dataType:"json",
		success : function(resp){
			goodsImg(resp,code)
		},
		error : function(){
			alert("イメージを読みません。");
		}
	});
}
function goodsImg(resp,code){
	var data = "";
	$.each(resp, function(index,list){
		if(list.company_code == code){
			data += "<img class='goodsImg' alt='商品一覧' src='"+list.goods_image+"'>";
		}
	}); //end $.each
	$("#goodsList").html(data);
}

function company(){
	var com = $(this).attr("data-code");
	$.ajax({
		url:"company_logo",
		method:"get",
		data:"code="+com,
		success:function(){
			alert("会社コードを保存しました。");
		},
		error:function(){
			alert("会社コード保存にエラー発生");
		}
	});//end ajax
}//end company()

function manager(){
	location.href = "${pageContext.request.contextPath}/managerOpen";
}

</script>

<body>
	<h1>グロップエスシー　自動販売機</h1>

<div id="wrapper">
	<form id="topForm" method="get">
		<table>
			<tr>
		<c:forEach var="company" varStatus="index" items="${company}">
			<td class="gt" data-code="${company.company_code}">
			<img class="cl" src="${company.company_image}"></td>
			<c:if test="${index.index ==2}">
				<tr>	  
			</c:if>
		</c:forEach>
			</tr>
			</tr>
		</table>
		<br>
		<span id="goodsList">
			<img class="goodsImg" alt="商品一覧" src="resources/img/jihanki.jpg">
		</span>
		<br>
		<a href="check">
		<input id="next_btn" type="button" name="next_btn" value="次へ   ">
		</a>
	</form>
	<input id="manager_btn" type="button" name="manager_btn" value="管理者モード" onclick="manager()">
</div>
 
</body>
</html>
