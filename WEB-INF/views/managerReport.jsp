<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>  
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<style>
	#report_table {
		width : 70%;
		border: 1px solid;
		border-collapse: collapse;
	}
	th,td {
		border: 1px solid black;
		text-align:center;
	}
	.reportT {
		background: rgb(204,204,255);
	}
	.reportD {
		background: rgb(255,255,153);
	}
</style>
<%@ include file="managerMenu.jsp" %>
<script src="resources/js/jquery-3.2.1.min.js"></script>
<script>
	$(function(){
		btnSetting();
	})
	
	//マウスによってテーブルのカラー変更
	function tro(data){
		$(data).css("background","#b7a3cc");
	}
	function trl(data){
		$(data).css("background","white");
	}
	
	function btnSetting(){
		$('#report_menu').css('background-color','red');
	}
	function search(){
		var date1 = $("#date1").val();
		var date2 = $("#date2").val();
		if(date1==""||date2==""){
			alert("日付を選択してください。");
			return false;
		}
		var startArray = date1.split('-');
		var endArray = date2.split('-');
		var start = new Date(startArray[0],startArray[1],startArray[2])
		var end = new Date(endArray[0],endArray[1],endArray[2]);
		if(start.getTime()>end.getTime()){
			alert("終了日は開始日より後になります。");
			return false;
		}
		
		var ck = $("input:radio[name=ck]:checked").val();
		if(ck == undefined){
			alert("照会するオプションを選択してください。");
			return false;
		}
		var code = "";
		if(ck=="company_name"){ //会社帳票
			code = $("#company_list option:selected").val();
			$.ajax({
				url:"reportManager" ,
				data:"flag="+ck+"&date1="+date1+"&date2="+date2+"&code="+code,
				dataType:"json",
				success:function(resp){
					setting(ck,resp,date1,date2,code);
				},
				error:function(){
					alert("データがありません。");
				}
			})
		} else { //商品帳票
			code = $("#goods_list option:selected").val();
			$.ajax({
				url:"reportManager",
				data:"flag="+ck+"&date1="+date1+"&date2="+date2+"&code="+code,
				dataType:"json",
				success:function(resp){
					setting(ck,resp,date1,date2,code);
				},
				error:function(){
					alert("データがありません。");
				}
			})
		}//end else 商品帳票
	}//end search
	
	function setting(flag,re,date1,date2,code){
		var table = "";
		var report = "";
		if(flag=="company_name"){
			table += "<tr class='reportT'><th>会社コード</th><th>会社名</th><th colspan='2'>販売期間</th><th>販売数量</th><th>売り上げ(￥)</th></tr>";
			table += "<tr><td>"+re.company_code+"</td>";
			table += "<td>"+re.company_name+"</td>";
			table += "<td colspan='2'>"+date1+" ~ "+date2+"</td>"
			table += "<td>"+re.sales_count+"</td>";
			table += "<td>"+re.total_price+"</td></tr>";
			$.ajax({
				url:"reportList",
				data:"flag="+flag+"&date1="+date1+"&date2="+date2+"&code="+code,
				dataType:"json",
				success:function(resp){
					report += "<tr class='reportD'><th>No</th><th>販売コード</th><th>日付</th><th>商品名</th><th>販売数量</th><th>合計</th></tr>";
					for(var i=0;i<resp.length;i++){
						report += "<tr class='reportTR' onmouseover='tro(this)' onmouseleave='trl(this)'><td>"+(i+1)+"</td>";
						report += "<td>"+resp[i].sales_code+"</td>";
						report += "<td>"+resp[i].sales_time+"</td>";
						report += "<td>"+resp[i].goods_name+"</td>";
						report += "<td>"+resp[i].sales_count+"</td>";
						report += "<td>"+resp[i].total_price+"</td></tr>";
					}
					finalSetting(table, report);
				},
				error:function(){
					alert("データがありません。");
				}
			})
		} else {
			table += "<tr class='reportT'><th>会社名</th><th>商品コード</th><th>商品名</th><th>単価</th><th>販売数量</th><th>売り上げ(￥)</th></tr>";
			table += "<tr class='reportTR'><td>"+re.company_name+"</td>";
			table += "<td>"+re.goods_code+"</td>";
			table += "<td>"+re.goods_name+"</td>";
			table += "<td>"+re.goods_price+"</td>";
			table += "<td>"+re.sales_count+"</td>";
			table += "<td>"+re.total_price+"</td></tr>";
			$.ajax({
				url:"reportList",
				data:"flag="+flag+"&date1="+date1+"&date2="+date2+"&code="+code,
				dataType:"json",
				success:function(resp){
					report += "<tr class='reportD'><th>No</th><th>販売コード</th><th colspan='2'>日付</th><th>販売数量</th><th>合計</th></tr>";
					for(var i=0;i<resp.length;i++){
						report += "<tr class='reportTR' onmouseover='tro(this)' onmouseleave='trl(this)'><td>"+(i+1)+"</td>";
						report += "<td>"+resp[i].sales_code+"</td>";
						report += "<td colspan='2'>"+resp[i].sales_time+"</td>";
						report += "<td>"+resp[i].sales_count+"</td>";
						report += "<td>"+resp[i].total_price+"</td></tr>";
					}
					finalSetting(table, report);
				},
				error:function(){
					alert("データがありません。");
				}
			})
		}
		//帳票リスト生成
	}//end setting
	
	function finalSetting(table, report){
		$("#report_body").html(table+report+table);
	}
	
	//印刷
	function print(){
		$("#reportTR").off();
		var popupOption= "width=1000, height=600, left=300, top=50";
		var popup = window.open("","帳票",popupOption);
		self.focus();
		popup.document.open();
		popup.document.write("<html><head><title>Report</title><style>");
		var style = $('style').html();
		popup.document.write(style+"</style></head>");
		var table = document.getElementById('report_body').outerHTML;
		popup.document.write("<body><table id='report_table' style='width:100%'>");
		popup.document.write("<tr><th colspan='6'>グロップエスシー　帳票</th></tr>");
		popup.document.write("<tr><td colspan='6' style='border-bottom-color:white; text-align:right'>株式会社 グロップエスシー 東京オフィス</td></tr>");
		popup.document.write("<tr><td colspan='6' style='border-bottom-color:white; text-align:right'>〒162-0832 東京都新宿区岩戸町</td></tr>");
		popup.document.write("<tr><td colspan='6' style='border-bottom-color:white; text-align:right'>日交神楽坂ビル</td></tr>");
		popup.document.write("<tr><td colspan='6' style='text-align:right'>TEL (03)-xxxx-xxxx</td></tr>");
		
		popup.document.write(table);
		popup.document.write("</table></body></html>");
		popup.document.close();
		popup.print();
		popup.close();
		//$(".reportTR").on("mouseover",tro(this));
		//$(".reportTR").on("mouseleave",trl(this));
	}
	
</script>
<body>
<h1>帳票管理</h1>
<input type="date" id="date1">
<input type="date" id="date2">
<input type="button" onclick="search()" value="照会">

<input type="radio" name="ck" class="ck" value="company_name">
<span>会社</span>
<select id="company_list">
	<c:forEach var="cl" items="${clist}">
		<option value="${cl.company_code}">${cl.company_name}</option>
	</c:forEach>
</select>
<input type="radio" name="ck" class="ck" value="goods_name">
<span>商品</span>
<select id="goods_list">
	<c:forEach var="gl" items="${glist}">
		<option value="${gl.goods_code}">${gl.goods_name}</option>
	</c:forEach>
</select>
<input type="button" id="print" value="印刷" onclick="print()">
<table id="report_table">
	<tbody id="report_body">
	</tbody>
</table>
</body>
</html>