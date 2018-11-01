<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>  
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>商品選択</title>
<style>
	.gt {
		cursor:pointer;
		width:160px;
		height:160px;
	}
	.cart th, td {
		border:1px
		solid black;
	}
	.goods{
		width:150px;
		height:160px;
	}
	.price{
		text-align:center;
		margin-bottom:0px;
		border:1px groove;
	}
	#goodsSelectLabel{
		whith:400px;
		font-size: 25px;
		font-weight: bold;
	}
	#gropsc{
		margin : 0 auto;
		whith : 50px;
		height : 50px;
		cursor: pointer;
	}
</style>
</head>
<script src="resources/js/jquery-3.2.1.min.js"></script>
<script>
	var clist; var mglist; var vglist; var start = 0; var btn=0; var flag=0;
	var page = new Array(); var pageC=0;
	
	//プルダウンで会社を選択した場合、実行するfunction
	$(function(){
		$("#company_name").change(function(){
			var selected_CN = $("#company_name option:selected").attr("value");
			company_change(selected_CN);
			setting(clist,mglist,vglist,btn);
		});
		init0();
		page = [0];
		$("#next").click(function(){
			btn = 0;
			setting(clist,mglist,vglist,btn);
		});
		$("#pre").click(function(){
			btn = 1;
			setting(clist,mglist,vglist,btn);
		});
	}) 
	
	function company_change(selected_CN){
		start = 0; flag = 0; btn=0;
		page = new Array(); pageC=0;
		$("#next").attr('disabled',false);
		$.ajax({
			url:"company_change",
			method:"get",
			data:"company_name="+selected_CN,
			datatype:"text",
			success:function(newcom){
				//alert(newcom);
				//sessionに保存された。
			},
			error:function(){
				alert("会社情報を読みませんでした。");
			}
		});//end ajax
	}//end company_change
	
	function init0(company){
		$.ajax({
			url:"init0",
			dataType:"json",
			success:function(resp){
				clist=resp;
				init1();
			},
			error:function(){
				alert("データを読みませんでした。");
			}
		});//end ajax
	}
	function init1(company){
		$.ajax({
			url:"init1",
			dataType:"json",
			success:function(resp){
				mglist=resp;
				init2();
			},
			error:function(){
				alert("データを読みませんでした。");
			}
		});//end ajax
	}
	function init2(company){
		$.ajax({
			url:"init2",
			dataType:"json",
			success:function(resp){
				vglist=resp;
				setting(clist,mglist,vglist);
			},
			error:function(){
				alert("データを読みませんでした。");
			}
		});//end ajax
	}
	function setting(clist,mg,vg,btn){
		if(btn==0){ //nextボタン
			$("#pre").attr('disabled',false);
			pageC++;
			page[pageC] = flag;
			flag = start;
		} else if(btn==1) {	//preボタン
			$("#next").attr('disabled',false);
			flag = page[pageC];
			pageC--;
		}
		var sel_cn = $("#company_name option:selected").attr('data-code');
		var c=0; //当てはまる商品の数をcount
		var vstock=0;
		var	table ="<tr>";
		for(var i=flag;i<mg.length;i++){	
			if(sel_cn == mg[i].company_code){
				for(var j=0;j<vg.length;j++) {
					if(mg[i].goods_code == vg[j].goods_code) {
						vstock = vg[j].goods_stock;
						break;
					}
				}
				c++; 
				if(c==11) {
					start = i; //データがもっとある場合、次のページがスタートするnumberを保存する
					break;
				}
				if(c==6) table += "</tr><tr>"; //1行は五つ
				table +="<td class='gt'><img class='goods' data-name='"+mg[i].goods_name+"' src='"+mg[i].goods_image+"'><p class='price' data-stock='"+vstock+"' data-image='"+mg[i].goods_image+"' data-name='"+mg[i].goods_name+"'>"+"￥ "+mg[i].goods_price+"</p></td>";
			}//end 会社マッチングif
		}//end for
		table +="</tr>";
		if(c<11) $("#next").attr('disabled',true); //もう以上この会社の商品がない場合
		if(flag==0) $("#pre").attr('disabled',true); //最初のページである場合
		
		//if(btn==1) pstart = flag; //preボタンだった場合、現在のページがスタートするnumberを保存する
		$("#goods_body").html(table);
		$(function(){ //作ったテーブルにイベントを生成
			$(".goods").on("click",goodsInfo)
			$(".price").on("click",popupOpen)
		});
	}//end setting
	
	//商品説明
	function goodsInfo(){
		var td = $(this).attr("data-name");
		$.ajax({
			url:"goodsInfo",
			data:"goods_name="+td,
			success:function(info){
				//boardDetailを参照してhtml+をすればいいと思う
				$("#goodsInfo").html(info);
			},
			error:function(){
				alert("説明を読みませんでした。");
			}
		})//end ajax
	}//end 商品説明
	
	//子画面パート
	$(function(){
		$(".price").on("click",popupOpen)
	})
	function popupOpen(){
		var cart_body = $("#cart_body");
		var goods_name = $(this).attr("data-name");
		var count = 1;
		var flag = 0; //既にあるデータかを判断するため
		if(cart_body.find('tr').length > 9){
			alert("かごは最大10種類までです。");
			return false;
		}
		//重複処理
		if(cart_body.find('tr').length >0){
			for(var i=0;i<cart_body.find('tr').length;i++) {
				var n = cart_body.find('tr').eq(i).find('td:eq(1)').text();
				if(goods_name == n){
					goods_name = n;
					count = cart_body.find('tr').eq(i).find('td:eq(3)').html();
					flag = 1;
				}
			}//end for
		}//end if 
		
		var goods_image = $(this).attr("data-image");//商品のイメージ
		var goods_stock = $(this).attr("data-stock");//商品の在庫
		var url= "goodsSelectPopup?goods_name="+goods_name+"&goods_image="+goods_image+"&goods_stock="+goods_stock+"&count="+count+"&flag="+flag; //?aaa=dddでパラメータ追加しなさい
	    var popupOption= "width=700, height=600, left=300, top=50";
		window.open(url,"",popupOption); //url,name,option
	}
	//子画面からもらった情報を商品カートに入力するfunction
	function receive(data){
		var cart_body = $("#cart_body");
		var num = cart_body.find('tr').length +1;
		var price = 0; var count = 0;
		var stock = data[3];
		var cart = "<tr num='"+num+"'><td>"+num+"</td>";
		if(parseInt(data[4]) == 1){ //flag==1 重複あり
			for(var i=0;i<cart_body.find('tr').length;i++) {
				var n = cart_body.find('tr').eq(i).find('td:eq(1)').text();//商品名
				if(n == data[0]){//重複される商品を見つけったら
					var n = cart_body.find('tr').eq(i).find('td:eq(3)').text(data[2]);
				}
			}
		} else { //新しい商品なら
			$.each(data,function(index,resp){
				switch(index){
				case 0 : cart +="<td>"+resp+"</td>";
					break;
				case 1 : price=resp;
				cart +="<td>"+resp+"</td>";
					break;
				case 2 : count=resp;
				cart +="<td>"+resp+"</td>";
					break;
				case 3 : break;
				}//end switch
			});
	 		//1行の合計
			cart += "<td class='row_total'>"+price*count+"</td>"
			cart += "<td><input type='button' data-stock='"+stock+"' class='count_btn' value='▲' onclick='count(this)'>";
			cart += "<input type='button' data-stock='"+stock+"' class='count_btn' value='▼' onclick='count(this)'>";
			cart += "<input type='button' class='cart_cancel' value='X' onclick='cancel(this)'></td></tr>"
			$("#cart_body").append(cart);
		}// end else
		total();
	} //end receive
	
	function count(cbtn){
		var val = $(cbtn).val();
		var stock = $(cbtn).attr("data-stock");
		var gct = $(cbtn).parent().parent().find('td:eq(3)').text();
		var price = $(cbtn).parent().parent().find('td:eq(2)').html();
		
		switch(val){
		case "▲" :
			if(gct == stock){
				alert("申し訳ございませんが、商品の在庫が足りないです。");
				return false;
			}
			if(gct>9){
				alert("最大数量は10個です。");
				return false;
			}
			gct++;
			break;
		case "▼" :
			if(gct<2){
				alert("最小数量は1個です。");
				return false;
			}
			gct--;
			break;
		}
		$(cbtn).parent().parent().find('td:eq(3)').text(gct);
		$(cbtn).parent().parent().find('td:eq(4)').text(gct*price);
		total();
	}

	function total(){
		var cart_body = $("#cart_body");
		var count = 0; var total = 0;
		var length = cart_body.find('tr').length;
		var num = length - length +1;
		for(var i=0;i<cart_body.find('tr').length;i++) {
			cart_body.find('tr').eq(i).find('td:eq(0)').text(num++);
			count += parseInt(cart_body.find('tr').eq(i).find('td:eq(3)').html());
			total += parseInt(cart_body.find('tr').eq(i).find('td:eq(4)').html());
		}
		$("#cart_total").html(count+"個 / "+"￥ "+total);
	}//end 子画面
	
	//cartのキャンセルボタン
	function cancel(c){
		//$(c).parent().parent().remove();
		var yn = confirm('この商品を削除しますか。');
		if(yn) {$(c).closest('tr').remove(); total();}
		else return false;
	}
	
	//購入画面に移動
	function register(){
		//選択した商品がなかったら移動はできません。
		var cart_body = $("#cart_body");
		if(cart_body.find('tr').length ==0){
			alert("商品を選択してください。");
			return false;
		}
		//カートのデータをListに入れる
		var rowData = new Array();
        for(var i =0;i<cart_body.find('tr').length;i++){
        	var tdArr = new Array();
	        var no = cart_body.find('tr').eq(i).find('td').eq(0).html();
	        var goods = cart_body.find('tr').eq(i).find('td').eq(1).html();
	        var price = cart_body.find('tr').eq(i).find('td').eq(2).html();
	        var count = cart_body.find('tr').eq(i).find('td').eq(3).html();
	        var total = cart_body.find('tr').eq(i).find('td').eq(4).html();
       		tdArr.push(no); tdArr.push(goods);
       		tdArr.push(price);tdArr.push(count);tdArr.push(total);
        	rowData.push(tdArr);
        }
		$.ajax({
			url:"registerOpen",
			method:"post",
			datatype:"json",
			contentType : "application/json; charset=UTF-8",
			data:JSON.stringify(rowData),
			success:function(){
				location.href = "${pageContext.request.contextPath}/register";
			},
			error:function(){
				alert("商品情報伝送に失敗しました。");
			}
		});//end ajax
	}//end register
	function gohome(){
		location.href = "${pageContext.request.contextPath}/";
	}
</script>

<body>
<div>
	<label id="goodsSelectLabel">商品を選択してください。</label>
	<img id="gropsc" src="resources/img/gohome.png" onclick="gohome()">
</div>
	<div id="wrapper">
		<select name="company_name" id="company_name">
		<c:forEach var="cl" items="${clist}" >
			<option value="${cl.company_name}" data-code="${cl.company_code}" 
			<c:if test="${cl.company_name == company_name}">selected="selected"</c:if>>
			${cl.company_name}</option>
		</c:forEach>
		</select>
		<form id="goodsSelectForm">
			<table>
				<tbody id="goods_body">
				
				</tbody>
			</table>
		</form>
		<div id="page">
			<input id="pre" data-name="pre" type="button" value="◀">	
			<input id="next" data-name="next" type="button" value="▶">		
		</div>
		<div id ="cart">
		<table class='cart'>
			<tr>
				<th colspan='6'>ショッピングカート</th>
			</tr>
			<tr>
				<td>No.</td>
				<td>商品名</td>
				<td>値段</td>
				<td>数量</td>
				<td>合計</td>
				<td>オプション</td>
			</tr>
			<tbody id="cart_body">
			</tbody>
			<tfoot>
				<tr>
					<td colspan="3">Total : </td>
					<td colspan="3" id="cart_total"></td>
				</tr>
				<tr>
					<td colspan="6">最大10種類までできます。</td>
				</tr>
			</tfoot>
		</table>
		</div>
		<!-- 商品説明 -->
		<h1 id="goodsInfo">商品の説明が入る所です。</h1>
		<input type="button" value="次へ" onclick="register()">
	</div>
</body>
</html>