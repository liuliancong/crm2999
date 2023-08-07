<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
  Created by IntelliJ IDEA.
  User: callray_liu
  Date: 2023-05-12
  Time: 17:10
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
        $(function(){
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

            //当容器加载完毕向后台发送查询的请求
            var tranId = '${tranId}';
            $.ajax({
                url:"workbench/transaction/queryTranByTranId",
                data:{
                    tranId:tranId,
                },
                dataType:"json",
                type:"post",
                success:function (data){
                    $("#edit-owner").val(data.tran.owner);
                    $("#edit-money").val(data.tran.money);
                    $("#edit-name").val(data.tran.name);
                    $("#edit-expectedDate").val(data.tran.expectedDate);
                    $("#edit-customerName").val(data.tranCustomerNameActivityNameContactsNameStage.customerId);
                    $("#edit-stage").val(data.tran.stage);
                    $("#edit-type").val(data.tran.type);
                    $("#edit-source").val(data.tran.source);
                    $("#edit-activityId").val(data.tran.activityId);
                    $("#edit-activityName").val(data.tranCustomerNameActivityNameContactsNameStage.activityId);
                    $("#edit-contactsId").val(data.tran.contactsId);
                    $("#edit-contactsName").val(data.tranCustomerNameActivityNameContactsNameStage.contactsId);
                    $("#edit-possibility").val(data.tranCustomerNameActivityNameContactsNameStage.possibility);
                    $("#edit-description").val(data.tran.description);
                    $("#edit-contactSummary").val(data.tran.contactSummary);
                    $("#edit-nextContactTime").val(data.tran.nextContactTime);
                }
            });

            $("#searchActivityA").click(function (){
                $("#findMarketActivity").modal("show");
                $("#searchActivityInput").val("")
                $("#activityTbody").html("");
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
                            htmlStr+="    <td><input type=\"radio\" name=\"activity\" value=\""+obj.id+"\" activityName=\""+obj.name+"\"></td>";
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
                $("#edit-activityName").val(activityName)
                $("#edit-activityId").val(activityId)
                //关闭模态窗口
                $("#findMarketActivity").modal("hide");
                $("#searchActivityInput").val("")
                $("#activityTbody").html("");
            })

            //点击搜索联系人
            $("#searchContactsA").click(function (){
                $("#findContacts").modal("show");
                $("#searchContactsInput").val("")
                $("#contactsTbody").html()
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
                $("#edit-contactsName").val(contactsName);
                $("#edit-contactsId").val(contactsId);
                $("#findContacts").modal("hide");
                $("#searchContactsInput").val("")
                $("#contactsTbody").html()
            });

            //用户选择阶段
            $("#edit-stage").change(function (){
                var stage = $("#edit-stage option:selected").text();
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
                        $("#edit-possibility").val(data);
                    }
                })
            });

            $("#edit-customerName").typeahead({
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

            $("#saveEditTranBtn").click(function (){
                var id = '${tranId}';
                var owner = $("#edit-owner").val();
                var money = $.trim($("#edit-money").val());
                var name = $.trim($("#edit-name").val());
                var expectedDate = $("#edit-expectedDate").val();
                var customerName = $.trim($("#edit-customerName").val());
                var stage = $("#edit-stage").val();
                var type = $("#edit-type").val();
                var source = $("#edit-source").val();
                var activityId = $("#edit-activityId").val();
                var contactsId = $("#edit-contactsId").val();
                var description = $.trim($("#edit-description").val());
                var contactSummary = $.trim($("#edit-contactSummary").val());
                var nextContactTime = $.trim($("#edit-nextContactTime").val());
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
                    url:"workbench/transaction/saveEditTran.do",
                    data:{
                        id:id,
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
        })

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
                            <input type="text" class="form-control" style="width: 300px;" placeholder="请输入市场活动名称，支持模糊查询" id="searchActivityInput">
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
                            <input type="text" class="form-control" style="width: 300px;" placeholder="请输入联系人名称，支持模糊查询" id="searchContactsInput">
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
    <h3>修改交易</h3>
    <div style="position: relative; top: -40px; left: 70%;">
        <button type="button" class="btn btn-primary" id="saveEditTranBtn">保存</button>
        <button type="button" class="btn btn-default" onclick="window.history.back()">取消</button>
    </div>
    <hr style="position: relative; top: -40px;">
</div>
<form class="form-horizontal" role="form" style="position: relative; top: -30px;">
    <div class="form-group">
        <label for="edit-owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">
            <select class="form-control" id="edit-owner">
                <c:forEach items="${userList}" var="user">
                    <option value="${user.id}">${user.name}</option>
                </c:forEach>
            </select>
        </div>
        <label for="edit-money" class="col-sm-2 control-label">金额</label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="edit-money">
        </div>
    </div>

    <div class="form-group">
        <label for="edit-name" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="edit-name">
        </div>
        <label for="edit-expectedDate" class="col-sm-2 control-label">预计成交日期<span style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control mydate" id="edit-expectedDate" readonly>
        </div>
    </div>

    <div class="form-group">
        <label for="edit-customerName" class="col-sm-2 control-label">客户名称<span style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="edit-customerName" placeholder="支持自动补全，输入客户不存在则新建">
        </div>
        <label for="edit-stage" class="col-sm-2 control-label">阶段<span style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">
            <select class="form-control" id="edit-stage">
                <option></option>
                <c:forEach items="${dicValueStageList}" var="dicValueStage">
                    <option value="${dicValueStage.id}">${dicValueStage.value}</option>
                </c:forEach>
            </select>
        </div>
    </div>

    <div class="form-group">
        <label for="edit-type" class="col-sm-2 control-label">类型</label>
        <div class="col-sm-10" style="width: 300px;">
            <select class="form-control" id="edit-type">
                <option></option>
                <c:forEach items="${dicValueTransactionTypeList}" var="dicValueTransactionType">
                    <option value="${dicValueTransactionType.id}">${dicValueTransactionType.value}</option>
                </c:forEach>
            </select>
        </div>
        <label for="edit-possibility" class="col-sm-2 control-label">可能性</label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="edit-possibility" readonly>
        </div>
    </div>

    <div class="form-group">
        <label for="edit-source" class="col-sm-2 control-label">来源</label>
        <div class="col-sm-10" style="width: 300px;">
            <select class="form-control" id="edit-source">
                <option></option>
                <c:forEach items="${dicValueSourceList}" var="dicValueSource">
                    <option value="${dicValueSource.id}">${dicValueSource.value}</option>
                </c:forEach>
            </select>
        </div>
        <label for="edit-activityName" class="col-sm-2 control-label">市场活动源&nbsp;&nbsp;<a href="javascript:void(0);" id="searchActivityA"><span class="glyphicon glyphicon-search"></span></a></label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="hidden" id="edit-activityId">
            <input type="text" class="form-control" id="edit-activityName" readonly>
        </div>
    </div>

    <div class="form-group">
        <label for="edit-contactsName" class="col-sm-2 control-label">联系人名称&nbsp;&nbsp;<a href="javascript:void(0);" id="searchContactsA"><span class="glyphicon glyphicon-search"></span></a></label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="hidden" id="edit-contactsId">
            <input type="text" class="form-control" id="edit-contactsName" readonly>
        </div>
    </div>

    <div class="form-group">
        <label for="edit-description" class="col-sm-2 control-label">描述</label>
        <div class="col-sm-10" style="width: 70%;">
            <textarea class="form-control" rows="3" id="edit-description"></textarea>
        </div>
    </div>

    <div class="form-group">
        <label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
        <div class="col-sm-10" style="width: 70%;">
            <textarea class="form-control" rows="3" id="edit-contactSummary"></textarea>
        </div>
    </div>

    <div class="form-group">
        <label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control mydate" id="edit-nextContactTime" readonly>
        </div>
    </div>

</form>
</body>
</html>