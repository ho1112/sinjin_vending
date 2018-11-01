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
var flag = ""; var name=""; var code= ""; var img="";
$(function(){
	flag = '${flag}';
	name = '${name}';
	code = '${code}';
	img = '${img}';
	setting(flag);
	$("#upload").on("change", preview);
})

function setting(flag){
	var table = "<form id='signForm' action='companyManager' method='POST' enctype='multipart/form-data'>";
	table += "<input type='hidden' name='flag' value='"+flag+"'>";
	table += "<input type='hidden' name='company_code' value='"+code+"'>";
	table += "<input type='hidden' name='company_image' value='"+img+"'>";
	switch(flag){
	case "com_s" :
		table += "<table><tr><td><img src='resources/img/gropsc.png' id='preview'></td>";
		table += "<td>会社名</td><td><input type='text' id='company_name' name='company_name'></td></tr>";
		table += "<tr><td><input type='file' id='upload' name='upload'  accept='image/*'></td>";
		table += "<td colspan='2'><input type='button' id='save' value='会社登録'></td></tr>";
		table += "<tr><td colspan='3'><input type='button' value='キャンセル' onclick='cancel()'></td></tr>";
		table += "</table></form>";
		break;
	case "com_u" :
		table += "<table><tr><td><img src='"+img+"' id='preview'></td>";
		table += "<td>会社名</td><td><input type='text' value='"+name+"' id='company_name' name='company_name' value='aaaaaaaaaaaa'></td></tr>";
		table += "<tr><td><input type='file' id='upload' name='upload'  accept='image/*'></td>";
		table += "<td colspan='2'><input type='button' id='save' value='会社修正'></td></tr>";
		table += "<tr><td colspan='3'><input type='button' value='キャンセル' onclick='cancel()'></td></tr>";
		table += "</table></form>";
		break;
	}//end switch
	$("#managerPage").html(table);
	$("#save").on("click",save);
}
function save(){
	var form;
	var name = $("#company_name").val();
	if(name==""){
		alert("会社名を入力してください。")
		return false;
	}
	if('${flag}' == 'com_s'){
		var yn = confirm("以上でよろしいでしょうか。");
		if(yn) {
			form = new FormData($("#signForm")[0]);
			$.ajax({
				url:"companyManager",
				type:"post",
				data:form,
				async:false,
				cache:false,
				contentType: false,
				processData: false,
				success:function(){
					alert('登録しました。');
					window.opener.location.reload();    //親画面 reload
					window.close();
				},error:function(){
					alert('失敗しました。');
				}
			});
		} else return false;
	} else {
		var yn = confirm("会社情報の修正は以上でよろしいでしょうか。");
		if(yn) {
			form = new FormData($("#signForm")[0]);
			$.ajax({
				url:"companyManager",
				type:"post",
				data:form,
				async:false,
				cache:false,
				contentType: false,
				processData: false,
				success:function(){
					alert('修正しました。');
					window.opener.location.reload();    //親画面 reload
					window.close();
				},error:function(){
					alert('失敗しました。');
				}
			});
		} else return false;
	}
}//end save

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

function cancel(){
	window.close();
}
</script>
<body>
<div id="managerPage">
</div>
</body>
</html>