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
	#preview{
		width:150px;
		height:160px;
	}

</style>
<script src="resources/js/jquery-3.2.1.min.js"></script>
<script>
var flag = ""; var name=""; var code= "";
$(function(){
	//flag = '${flag}';
	//name = '${name}';
	//code = '${code}';
	$("#upload").on("change", preview);
	$("#save").on("click",save);
	$("#cancel").on("click",cancel);
});


//uploadしたイメージのプレビュー
function preview(e) {
	var files = e.target.files;
	var filesArr = Array.prototype.slice.call(files);
	
	filesArr.forEach(function(f){
		if(!f.type.match("image.*")) {
			alert("イメージファイルだけアップロードができます。");
			return false;
		}
		var reader = new FileReader();
		reader.onload = function(e){
			$("#preview").attr("src",e.target.result);
		}
		reader.readAsDataURL(f);
	});
}//end priview

function check(){
	var keyValue = event.keyCode;
	//文字を入れた場合、エラー
	if( ((keyValue >= 48) && (keyValue <= 57)||(keyValue==8)) ) {
	}else {
		alert("数字だけを入力できます。");
		$("#goods_price").val("");
		$("#goods_price").focus();
		return false;
	}
}

function save(){
	var form;
	var name = $("#goods_name").val();
	var price = $("#goods_price").val();
	var info = $("#goods_info").val();
	
	if(name==""||price==""||info==""){
		alert("商品情報を入力してください。")
		return false;
	}
	if('${flag}' == 'goods_s'){
		var yn = confirm("以上でよろしいでしょうか。");
		if(yn) {
			form = new FormData($("#signForm")[0]);
			$.ajax({
				url:"goodsManager",
				type:"post",
				data:form,
				async:false,
				cache:false,
				contentType: false,
				processData: false,
				success:function(){
					alert('登録しました。');
					window.opener.location.href = "${pageContext.request.contextPath}/location?location=goods&sel_com="+${company_code}+"&vc="+${vc};
					window.close();
				},error:function(){
					alert('失敗しました。');
				}
			});
		} else return false;
	} else {
		var yn = confirm("商品情報を修正すると他の自販機の同一商品の情報も修正されます。よろしいでしょうか。");
		if(yn) {
			form = new FormData($("#signForm")[0]);
			$.ajax({
				url:"goodsManager",
				type:"post",
				data:form,
				async:false,
				cache:false,
				contentType: false,
				processData: false,
				success:function(){
					alert('修正しました。');
					//window.opener.location.reload();    //親画面 reload
					window.opener.location.href = "${pageContext.request.contextPath}/location?location=goods&sel_com="+${company_code}+"&vc="+${vc};
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
<div id="managerPage">
	<form id="signForm" action="goodsManager" method="POST" name="signForm" enctype="multipart/form-data">
	<input type="hidden" name="flag" value="${flag}">
	<input type="hidden" name="company_name" value="${company_name}">
	<c:if test="${goods != null}">
	<input type="hidden" name="goods_code" value="${goods.goods_code}">
	<input type="hidden" name="company_code" value="${goods.company_code}">
	</c:if>
	<input type="hidden" name="goods_image" value="${goods.goods_image}">
	<input type="hidden" name="company_code" value="${company_code}">
		<table>
			<tr>
				<c:choose>
					<c:when test="${goods != null}">
						<td rowspan="4"><img src="${goods.goods_image}" id="preview"></td>		
					</c:when>
					<c:otherwise>
						<td rowspan="4"><img src="${img}" id="preview"></td>	
					</c:otherwise>
				</c:choose>
				<td>会社名</td>
				<td>${company_name}</td>
			</tr>
			<tr>
				<td>商品名</td>
				<c:choose>
					<c:when test="${goods != null}">
						<td><input type="text" id="goods_name" name="goods_name" value="${goods.goods_name}"></td>
					</c:when>
					<c:otherwise>
						<td><input type="text" id="goods_name" name="goods_name"></td>
					</c:otherwise>
				</c:choose>
			</tr>
			<tr>
				<td>値段</td>
				<c:choose>
					<c:when test="${goods != null}">
						<td><input type="text" id="goods_price" name="goods_price" onKeyUp="check()" value="${goods.goods_price}"></td>
					</c:when>
					<c:otherwise>
						<td><input type="text" id="goods_price" name="goods_price" onKeyUp="check()"></td>
					</c:otherwise>
				</c:choose>
			</tr>
			<tr>
				<td>商品説明</td>
				<c:choose>
					<c:when test="${goods != null}">
						<td><input type="text" id="goods_info" name="goods_info" value="${goods.goods_info}"></td>
					</c:when>
					<c:otherwise>
						<td><input type="text" id="goods_info" name="goods_info"></td>
					</c:otherwise>
				</c:choose>
			</tr>
			<tr>
				<td><input type="file" id="upload" name="upload"  accept="image/*"></td>
				<c:choose>
					<c:when test="${goods != null}">
						<td colspan="2"><input type="button" id="save" value="商品修正"></td>
					</c:when>
				 	<c:otherwise>
				 		<td colspan="2"><input type="button" id="save" value="商品登録"></td>
				 	</c:otherwise>
				</c:choose>
			</tr>
			<tr>
				<td colspan="3"><input type="button" name="test" id="cancel" value="キャンセル" ></td>
			</tr>
		</table>
	</form>
</div>
</body>
</html>