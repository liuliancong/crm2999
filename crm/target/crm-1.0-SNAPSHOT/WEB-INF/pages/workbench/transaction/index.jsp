<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
	<%
	String baseHref = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";
	%>
	<base href="<%=baseHref%>">
	<meta charset="UTF-8">

	<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
	<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />

	<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
	<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
	<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
	<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

	<%-- PAGENATION插件 --%>
	<link rel="stylesheet" type="text/css" href="jquery/bs_pagination-master/css/jquery.bs_pagination.min.css">
	<script type="text/javascript" src="jquery/bs_pagination-master/js/jquery.bs_pagination.min.js"></script>
	<script type="text/javascript" src="jquery/bs_pagination-master/localization/en.js"></script>

<script type="text/javascript">

	$(function(){

		queryTranByConditionForPage(1,10)

		$("#searchTranListBtn").click(function (){
			queryTranByConditionForPage(1,$("#divPage").bs_pagination("getOption","rowsPerPage"));
		});

		$("#createTranBtn").click(function (){
			window.location.href="workbench/transaction/toSaveCreateTran.do"
		});

		//全选和全不选
		$("#checkedAll").click(function (){
			$("#tranTbody input[type='checkbox']").prop("checked",this.checked);
		});
		$("#tranTbody").on("click","input[type=checkbox]",function (){
			if($("#tranTbody input[type='checkbox']").size()==$("#tranTbody input[type='checkbox']:checked").size()){
				$("#checkedAll").prop("checked",true);
			}else{
				$("#checkedAll").prop("checked",false);
			}
		})

		//前往修改界面
		$("#editTranBtn").click(function(){
			var checkedTranId = $("#tranTbody input[type='checkbox']:checked");
			if(checkedTranId.size() != 1){
				alert("请选择一条记录进行修改!")
				return;
			}
			var tranId = checkedTranId.get(0).value;
			// console.log(tranId)
			window.location.href="workbench/transaction/editTran.do?tranId="+tranId;
		});


		
		
	});

	//分页查询
	function queryTranByConditionForPage(pageNo,pageSize){
		var owner = $("#query-owner").val();
		var name = $.trim($("#query-name").val());
		var customerName = $.trim($("#query-customerName").val());
		var stage = $("#query-stage").val();
		var type = $("#query-type").val();
		var source = $("#query-source").val();
		var contactsName = $.trim($("#query-contactsName").val());
		// alert("执行一次")
		$.ajax({
			url:"workbench/transaction/queryTranListByConditionForPage.do",
			data:{
				owner:owner,
				name:name,
				customerName:customerName,
				stage:stage,
				type:type,
				source:source,
				contactsName:contactsName,
				pageNo:pageNo,
				pageSize:pageSize
			},
			dataType: "json",
			type:"post",
			success:function (data){
				var htmlStr = "";

				$.each(data.tranList,function (index,obj){
					htmlStr+="<tr>";
					htmlStr+="    <td><input type=\"checkbox\" value=\""+obj.id+"\"/></td>";
					htmlStr+="    <td><a style=\"text-decoration: none; cursor: pointer;\" onclick=\"window.location.href='workbench/transaction/detailTran.do?tranId="+obj.id+"';\">"+obj.name+"</a></td>";
					htmlStr+="    <td>"+obj.customerId+"</td>";
					htmlStr+="    <td>"+obj.stage+"</td>";
					if(obj.type==null){
						obj.type="";
					}
					htmlStr+="    <td>"+obj.type+"</td>";
					htmlStr+="    <td>"+obj.owner+"</td>";
					if(obj.source==null){
						obj.source="";
					}
					htmlStr+="    <td>"+obj.source+"</td>";
					htmlStr+="    <td>"+obj.contactsId+"</td>";
					htmlStr+="</tr>";
				});
				$("#tranTbody").html(htmlStr);

				$("#checkedAll").prop("checked",false);

				//计算总页数
				var totalForPages = 1;
				if(data.totalRows % pageSize == 0){
					totalForPages = data.totalRows / pageSize ;
				}else{
					totalForPages = parseInt(data.totalRows / pageSize) + 1;
				}

				$("#divPage").bs_pagination({
					currentPage:pageNo, //当前页数，相当于pageNo

					rowsPerPage:pageSize, //每页显示条数，相当于pageSize
					totalRows:data.totalRows, //总条数
					totalPages: totalForPages, //总页数，必填参数

					visiblePageLinks: 5, //最多可显示选择的页数

					showGoToPage: true, //控制是否显示“跳转到”部分，默认true --显示
					showRowsPerPage: true, //是否显示“每页显示条数部分。”默认true--显示
					showRowsInfo: true, //是否显示记录的信息，默认true--显示

					//用户每次切换页号，都会自动触发本函数
					onChangePage:function (event,pageObj){// returns page_num and rows_per_page after a link has clicked
						//js代码
						queryTranByConditionForPage(pageObj.currentPage,pageObj.rowsPerPage);
					}
				});

			}
		})

	}
	
</script>
</head>
<body>

	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>交易列表</h3>
			</div>
		</div>
	</div>
	
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
	
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" type="text" id="query-owner">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input class="form-control" type="text" id="query-name">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">客户名称</div>
				      <input class="form-control" type="text" id="query-customerName">
				    </div>
				  </div>
				  
				  <br>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">阶段</div>
					  <select class="form-control" id="query-stage">
					  	<option></option>
						  <c:forEach items="${dicValueStageList}" var="dicValueStage">
							  <option value="${dicValueStage.id}">${dicValueStage.value}</option>
						  </c:forEach>
					  </select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">类型</div>
					  <select class="form-control" id="query-type">
					  	<option></option>
						  <c:forEach items="${dicValueTransactionTypeList}" var="dicValueTransactionType">
							  <option value="${dicValueTransactionType.id}">${dicValueTransactionType.value}</option>
						  </c:forEach>
					  </select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">来源</div>
				      <select class="form-control" id="query-source">
						  <option></option>
						  <c:forEach items="${dicValueSourceList}" var="dicValueSource">
							  <option value="${dicValueSource.id}">${dicValueSource.value}</option>
						  </c:forEach>
						</select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">联系人名称</div>
				      <input class="form-control" type="text" id="query-contactsName">
				    </div>
				  </div>
				  
				  <button type="button" class="btn btn-default" id="searchTranListBtn">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 10px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" id="createTranBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="editTranBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
				
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="checkedAll" /></td>
							<td>名称</td>
							<td>客户名称</td>
							<td>阶段</td>
							<td>类型</td>
							<td>所有者</td>
							<td>来源</td>
							<td>联系人名称</td>
						</tr>
					</thead>
					<tbody id="tranTbody">
					</tbody>
				</table>
			</div>

			<div id="divPage"></div>
			
		</div>
		
	</div>
</body>
</html>