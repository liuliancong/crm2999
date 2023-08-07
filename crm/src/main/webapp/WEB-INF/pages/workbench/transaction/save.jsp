<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
  Created by IntelliJ IDEA.
  User: callray_liu
  Date: 2023-05-12
  Time: 17:11
  To change this template use File | Settings | File Templates.
--%>
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

    <%--  TYPEAHEAD    --%>
    <script type="text/javascript" src="jquery/bs_typeahead/bootstrap3-typeahead.min.js"></script>

    <script type="text/javascript">
        $(function (){

            //当容器加载完毕，对容器调用工具函数
            $(".mydate").datetimepicker({
                language:'zh-CN',  //语言
                format:'yyyy-mm-dd', //日期的格式
                minView:'month',    //可以选择的最小视图 month day year hour week
                initialDate:new Date(), //初始化显示的日期
                autoclose:true, //设置选择完日期或者时间后，是否自动关闭日历
                todayBtn:true, //设置是否显示‘今天’按钮，默认false
                clearBtn:true, //设置是否显示清空按钮

            })

            $("#searchActivityA").click(function (){
                $("#findMarketActivity").modal("show");
            });

            $("#searchActivityInput").keyup(function (){
                var activityName = $("#searchActivityInput").val();
                $.ajax({
                    url:"workbench/transaction/queryActivityByActivityName.do",
                    data:{
                        activityName:activityName
                    },
                    dataType:"json",
                    type:"post",
                    success:function (data){
                        var htmlStr = "";
                        $.each(data,function (index,obj){
                            htmlStr+="<tr>";
                            htmlStr+="    <td><input type=\"radio\" name=\"activity\"/ value=\""+obj.id+"\" activityName=\""+obj.name+"\"></td>";
                            htmlStr+="    <td>"+obj.name+"</td>";
                            htmlStr+="    <td>"+obj.startDate+"</td>";
                            htmlStr+="    <td>"+obj.endDate+"</td>";
                            htmlStr+="    <td>"+obj.owner+"</td>";
                            htmlStr+="</tr>";
                        })
                        $("#activityTbody").html(htmlStr);
                    }
                })
            });

            //选中一个市场活动，关闭模态窗口
            $("#activityTbody").on("click","input[type='radio']",function (){
                var activityName = $(this).attr("activityName");
                var activityId = this.value;
                // console.log(activityName+","+activityId)
                $("#create-activityName").val(activityName)
                $("#create-activityId").val(activityId)
                //关闭模态窗口
                $("#findMarketActivity").modal("hide");
                $("#searchActivityInput").val("")
                $("#activityTbody").html("");
            })

            //点击搜索联系人
            $("#searchContactsA").click(function (){
                $("#findContacts").modal("show");
            });

            //输入联系人名字，模糊查询
            $("#searchContactsInput").keyup(function(){
                var contactsName = $("#searchContactsInput").val();
                $.ajax({
                    url:"workbench/transaction/queryContactsListByContactsName.do",
                    data:{
                        contactsName:contactsName
                    },
                    dataType:"json",
                    type:"post",
                    success:function (data){
                        var htmlStr = "";
                        $.each(data,function (index,obj){
                            htmlStr+="<tr>";
                            htmlStr+="    <td><input type=\"radio\" name=\"activity\" value=\""+obj.id+"\" contactsName=\""+obj.fullname+"\"/></td>";
                            htmlStr+="    <td>"+obj.fullname+"</td>";
                            htmlStr+="    <td>"+obj.email+"</td>";
                            htmlStr+="    <td>"+obj.mphone+"</td>";
                             htmlStr+="</tr>";
                        })
                        $("#contactsTbody").html(htmlStr)
                    }
                })
            });

            //选中一个联系人，关闭模态窗口
            $("#contactsTbody").on("click","input[type='radio']",function (){
                var contactsName = $(this).attr("contactsName");
                var contactsId = this.value;
                $("#create-contactsName").val(contactsName);
                $("#create-contactsId").val(contactsId);
                $("#findContacts").modal("hide");
                $("#searchContactsInput").val("")
                $("#contactsTbody").html()
            });

            //用户选择阶段
            $("#create-stage").change(function (){
               var stage = $("#create-stage option:selected").text();
               // var stage2 = $(this).find("option:selected").text();
               // alert(stage+" , "+stage2)
                if(stage==""){
                    alert("阶段不能为空");
                    return;
                }
                $.ajax({
                    url:"workbench/transaction/getPossibilityForPage",
                    data:{
                        stage:stage
                    },
                    dataType:"json",
                    type:"post",
                    success:function (data){
                        $("#create-possibility").val(data);
                    }
                })
            });

            $("#create-customerName").typeahead({
                source:function (jquery,process){
                    $.ajax({
                        url:"workbench/transaction/queryCustomerNameByCustomerName.do",
                        data:{
                            customerName:jquery
                        },
                        dataType:"json",
                        type:"post",
                        success:function (data){
                            process(data)
                        }
                    })
                }
            });

            $("#saveCreateTranBtn").click(function (){
                var owner = $("#create-owner").val();
                var money = $.trim($("#create-money").val());
                var name = $.trim($("#create-name").val());
                var expectedDate = $("#create-expectedDate").val();
                var customerName = $.trim($("#create-customerName").val());
                var stage = $("#create-stage").val();
                var type = $("#create-type").val();
                var source = $("#create-source").val();
                var activityId = $("#create-activityId").val();
                var contactsId = $("#create-contactsId").val();
                var description = $.trim($("#create-description").val());
                var contactSummary = $.trim($("#create-contactSummary").val());
                var nextContactTime = $.trim($("#create-nextContactTime").val());
                if(owner==""){
                    alert("所有者不能为空！")
                    return;
                }
                if(name==""){
                    alert("名称不能为空！")
                    return;
                }
                if(expectedDate==""){
                    alert("预计成交日期不能为空！")
                    return;
                }
                if(customerName==""){
                    alert("客户名称不能为空！")
                    return;
                }
                if(stage==""){
                    alert("阶段不能为空！")
                    return;
                }
                if(money != null){
                    var regExt = /^[1-9]\d*$/;
                    if(!regExt.test(money)){
                        alert("成本只能为非负正整数！")
                        return;
                    }
                }
                $.ajax({
                    url:"workbench/transaction/saveCreateTran.do",
                    data:{
                        owner:owner,
                        money:money,
                        name:name,
                        expectedDate:expectedDate,
                        customerName:customerName,
                        stage:stage,
                        type:type,
                        source:source,
                        activityId:activityId,
                        contactsId:contactsId,
                        description:description,
                        contactSummary:contactSummary,
                        nextContactTime:nextContactTime
                    },
                    dataType:"json",
                    type:"post",
                    success:function (data){
                        if(data.code==1){
                            window.location.href="workbench/transaction/index.do";
                        }else{
                            alert(data.message);
                        }
                    }
                })

            });

        });
    </script>

</head>
<body>

<!-- 查找市场活动 -->
<div class="modal fade" id="findMarketActivity" role="dialog">
    <div class="modal-dialog" role="document" style="width: 80%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">查找市场活动</h4>
            </div>
            <div class="modal-body">
                <div class="btn-group" style="position: relative; top: 18%; left: 8px;">
                    <form class="form-inline" role="form">
                        <div class="form-group has-feedback">
                            <input type="text" class="form-control" id="searchActivityInput" style="width: 300px;" placeholder="请输入市场活动名称，支持模糊查询">
                            <span class="glyphicon glyphicon-search form-control-feedback"></span>
                        </div>
                    </form>
                </div>
                <table id="activityTable3" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
                    <thead>
                    <tr style="color: #B3B3B3;">
                        <td></td>
                        <td>名称</td>
                        <td>开始日期</td>
                        <td>结束日期</td>
                        <td>所有者</td>
                    </tr>
                    </thead>
                    <tbody id="activityTbody">
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<!-- 查找联系人 -->
<div class="modal fade" id="findContacts" role="dialog">
    <div class="modal-dialog" role="document" style="width: 80%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">查找联系人</h4>
            </div>
            <div class="modal-body">
                <div class="btn-group" style="position: relative; top: 18%; left: 8px;">
                    <form class="form-inline" role="form">
                        <div class="form-group has-feedback">
                            <input type="text" class="form-control" id="searchContactsInput" style="width: 300px;" placeholder="请输入联系人名称，支持模糊查询">
                            <span class="glyphicon glyphicon-search form-control-feedback"></span>
                        </div>
                    </form>
                </div>
                <table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
                    <thead>
                    <tr style="color: #B3B3B3;">
                        <td></td>
                        <td>名称</td>
                        <td>邮箱</td>
                        <td>手机</td>
                    </tr>
                    </thead>
                    <tbody id="contactsTbody">
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>


<div style="position:  relative; left: 30px;">
    <h3>创建交易</h3>
    <div style="position: relative; top: -40px; left: 70%;">
        <button type="button" class="btn btn-primary" id="saveCreateTranBtn">保存</button>
        <button type="button" class="btn btn-default" onclick="window.history.back()">取消</button>
    </div>
    <hr style="position: relative; top: -40px;">
</div>
<form class="form-horizontal" role="form" style="position: relative; top: -30px;">
    <div class="form-group">
        <label for="create-owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">
            <select class="form-control" id="create-owner">
                <c:forEach items="${userList}" var="user">
                    <option value="${user.id}">${user.name}</option>
                </c:forEach>
            </select>
        </div>
        <label for="create-money" class="col-sm-2 control-label">金额</label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="create-money">
        </div>
    </div>

    <div class="form-group">
        <label for="create-name" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="create-name">
        </div>
        <label for="create-expectedDate" class="col-sm-2 control-label">预计成交日期<span style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control mydate" id="create-expectedDate" readonly>
        </div>
    </div>

    <div class="form-group">
        <label for="create-customerName" class="col-sm-2 control-label">客户名称<span style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="create-customerName" placeholder="支持自动补全，输入客户不存在则新建">
        </div>
        <label for="create-stage" class="col-sm-2 control-label">阶段<span style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">
            <select class="form-control" id="create-stage">
                <option></option>
                <c:forEach items="${dicValueStageList}" var="dicValueStage">
                    <option value="${dicValueStage.id}">${dicValueStage.value}</option>
                </c:forEach>
            </select>
        </div>
    </div>

    <div class="form-group">
        <label for="create-type" class="col-sm-2 control-label">类型</label>
        <div class="col-sm-10" style="width: 300px;">
            <select class="form-control" id="create-type">
                <option></option>
                <c:forEach items="${dicValueTransactionTypeList}" var="dicValueTransactionType">
                    <option value="${dicValueTransactionType.id}">${dicValueTransactionType.value}</option>
                </c:forEach>
            </select>
        </div>
        <label for="create-possibility" class="col-sm-2 control-label">可能性</label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="create-possibility" readonly>
        </div>
    </div>

    <div class="form-group">
        <label for="create-source" class="col-sm-2 control-label">来源</label>
        <div class="col-sm-10" style="width: 300px;">
            <select class="form-control" id="create-source">
                <option></option>
                <c:forEach items="${dicValueSourceList}" var="dicValueSource">
                    <option value="${dicValueSource.id}">${dicValueSource.value}</option>
                </c:forEach>
            </select>
        </div>
        <label for="create-activityName" class="col-sm-2 control-label">市场活动源&nbsp;&nbsp;<a href="javascript:void(0);" id="searchActivityA"><span class="glyphicon glyphicon-search"></span></a></label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="hidden" id="create-activityId">
            <input type="text" class="form-control" id="create-activityName" readonly>
        </div>
    </div>

    <div class="form-group">
        <label for="create-contactsName" class="col-sm-2 control-label">联系人名称&nbsp;&nbsp;<a href="javascript:void(0);" id="searchContactsA"><span class="glyphicon glyphicon-search"></span></a></label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="hidden" id="create-contactsId">
            <input type="text" class="form-control" id="create-contactsName" readonly>
        </div>
    </div>

    <div class="form-group">
        <label for="create-description" class="col-sm-2 control-label">描述</label>
        <div class="col-sm-10" style="width: 70%;">
            <textarea class="form-control" rows="3" id="create-description"></textarea>
        </div>
    </div>

    <div class="form-group">
        <label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
        <div class="col-sm-10" style="width: 70%;">
            <textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
        </div>
    </div>

    <div class="form-group">
        <label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control mydate" id="create-nextContactTime" readonly>
        </div>
    </div>

</form>
</body>
</html>