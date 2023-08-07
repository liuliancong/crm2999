<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
  Created by IntelliJ IDEA.
  User: callray_liu
  Date: 2023-05-08
  Time: 14:40
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
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

    <%-- PAGENATION插件 --%>
    <link rel="stylesheet" type="text/css" href="jquery/bs_pagination-master/css/jquery.bs_pagination.min.css">
    <script type="text/javascript" src="jquery/bs_pagination-master/js/jquery.bs_pagination.min.js"></script>
    <script type="text/javascript" src="jquery/bs_pagination-master/localization/en.js"></script>

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

            //定制字段
            $("#definedColumns > li").click(function(e) {
                //防止下拉菜单消失
                e.stopPropagation();
            });

            //当页面加载时
            queryCustomerByConditionForPage(1,10);

            //点击查询按钮
            $("#queryCustomerListByConditionForPage").click(function (){
               queryCustomerByConditionForPage(1,$("#divPage").bs_pagination("getOption","rowsPerPage"));
            });

            //点击创建按钮，弹出模态窗口
            $("#saveCreateCustomerBtn").click(function (){
                //将模态窗口初始化
               $("#createCustomerForm").get(0).reset();
               $("#createCustomerModal").modal("show");
            });

            //点击保存按钮
            $("#saveCreateBtn").click(function(){
                //id, owner, name, website, phone, create_by, create_time,contact_summary,next_contact_time, description, address
                //收集参数
                var owner = $.trim($("#create-owner").val());
                var name = $.trim($("#create-name").val());
                var website = $.trim($("#create-website").val());
                var phone = $.trim($("#create-phone").val());
                var description = $.trim($("#create-description").val());
                var contactSummary = $.trim($("#create-contactSummary").val());
                var nextContactTime = $("#create-nextContactTime").val();
                var address = $.trim($("#create-address").val());
                //判断是否合法
                if(owner==""){
                    alert("所有者不能为空")
                    return;
                }
                if(name==""){
                    alert("所有者不能为空")
                    return;
                }
                if(website!=""){
                    var regExt=/([hH][tT]{2}[pP]:\/\/|[hH][tT]{2}[pP][sS]:\/\/|[wW]{3}.|[wW][aA][pP].|[fF][tT][pP].|[fF][iI][lL][eE].)[-A-Za-z0-9+&@#\/%?=~_|!:,.;]+[-A-Za-z0-9+&@#\/%=~_|]/;
                    if(!regExt.test(website)){
                        alert("网站不合法！")
                        return;
                    }
                }
                if(phone!=""){
                    var regExt = /^\d{3,}-\d{8,}|\d{4,}-\d{7,8}$/;
                    if(!regExt.test(phone)){
                        alert("公司座机输入有误!")
                        return;
                    }
                }
                //发送ajax请求
                $.ajax({
                    url:"workbench/customer/saveCreateCustomer.do",
                    data:{
                        owner:owner,
                        name:name,
                        website:website,
                        phone:phone,
                        description:description,
                        contactSummary:contactSummary,
                        nextContactTime:nextContactTime,
                        address:address
                    },
                    dataType:"json",
                    type:"post",
                    success:function(data){
                        if(data.code==1){
                            //创建成功，先将模态窗口关闭，然后执行分页查询
                            $("#createCustomerModal").modal("hide");
                            queryCustomerByConditionForPage(1,$("#divPage").bs_pagination("getOption","rowsPerPage"));
                        }else{
                            alert(data.message)
                            $("#createCustomerModal").modal("show");
                        }
                    }
                })
            })

            //点击关闭按钮
            $("#closeCreateBtn").click(function(){
                $("#createCustomerModal").modal("hide");
            });

            //点击修改按钮
            $("#saveEditCustomerBtn").click(function (){
                //判断是否只选中了一个复选框
                var checkedCustomers = $("#customerTbody input[type='checkbox']:checked");
                if(checkedCustomers.size() != 1){
                    alert("请选中一行数据进行修改！")
                    return;
                }
                var customerId = checkedCustomers.get(0).value;
                //发送查询的异步请求
                $.ajax({
                    url:"workbench/customer/queryCustomerByCustomerId.do",
                    data:{
                        customerId:customerId
                    },
                    dataType:"json",
                    type:"post",
                    success:function(data){
                        $("#edit-id").val(data.id);
                        $("#edit-owner").val(data.owner);
                        $("#edit-name").val(data.name);
                        $("#edit-website").val(data.website);
                        $("#edit-phone").val(data.phone);
                        $("#edit-description").val(data.description);
                        $("#edit-contactSummary").val(data.contactSummary);
                        $("#edit-nextContactTime").val(data.nextContactTime);
                        $("#edit-address").val(data.address);
                        //模态窗口开启
                        $("#editCustomerModal").modal("show")
                    }
                })
            });

            //点击保存按钮
            $("#saveEditCustomerByIdBtn").click(function (){
                //获取参数
                var id = $("#edit-id").val();
                var owner = $.trim($("#edit-owner").val());
                var name = $.trim($("#edit-name").val());
                var website = $.trim($("#edit-website").val());
                var phone = $.trim($("#edit-phone").val());
                var description = $.trim($("#edit-description").val());
                var contactSummary = $.trim($("#edit-contactSummary").val());
                var nextContactTime = $("#edit-nextContactTime").val();
                var address = $.trim($("#edit-address").val());
                //判断是否合法
                if(owner==""){
                    alert("所有者不能为空")
                    return;
                }
                if(name==""){
                    alert("所有者不能为空")
                    return;
                }
                if(website!=""){
                    var regExt=/([hH][tT]{2}[pP]:\/\/|[hH][tT]{2}[pP][sS]:\/\/|[wW]{3}.|[wW][aA][pP].|[fF][tT][pP].|[fF][iI][lL][eE].)[-A-Za-z0-9+&@#\/%?=~_|!:,.;]+[-A-Za-z0-9+&@#\/%=~_|]/;
                    if(!regExt.test(website)){
                        alert("网站不合法！")
                        return;
                    }
                }
                if(phone!=""){
                    var regExt = /^\d{3,}-\d{8,}|\d{4,}-\d{7,8}$/;
                    if(!regExt.test(phone)){
                        alert("公司座机输入有误!")
                        return;
                    }
                }
                $.ajax({
                    url:"workbench/customer/saveEditCustomerByCustomerId.do",
                    data:{
                        id:id,
                        owner:owner,
                        name:name,
                        website:website,
                        phone:phone,
                        description:description,
                        contactSummary:contactSummary,
                        nextContactTime:nextContactTime,
                        address:address
                    },
                    dataType:"json",
                    type:"post",
                    success:function(data){
                        if(data.code==1){
                            //关闭模态窗口
                            $("#editCustomerModal").modal("hide")
                            //到当前修改的页面
                            queryCustomerByConditionForPage($("#divPage").bs_pagination("getOption","currentPage"),$("#divPage").bs_pagination("getOption","rowsPerPage"));
                        }else{
                            alert(data.message)
                            $("#editCustomerModal").modal("show")
                        }
                    }
                })


            });

            //全选和全不选
            $("#checkedAll").click(function(){
                $("#customerTbody input[type='checkbox']").prop("checked",this.checked)
            });
            $("#customerTbody").on("click","input[type='checkbox']",function (){
                if($("#customerTbody input[type='checkbox']").size()==$("#customerTbody input[type='checkbox']:checked").size()){
                    $("#checkedAll").prop("checked",true);
                }else{
                    $("#checkedAll").prop("checked",false);
                }
            });



            //点击关闭按钮
            $("#closeSaveCustomerBtn").click(function (){
                $("#editCustomerModal").modal("hide")
            })

            //用户点击删除按钮
            $("#deleteCustomerIdsBtn").click(function (){
                var deleteCheckedCustomerIds = $("#customerTbody input[type='checkbox']:checked");
                if(deleteCheckedCustomerIds.size() == 0){
                    alert("请选中一条记录进行删除！");
                    return;
                }
                if(window.confirm("请确认删除！")){
                    var id = "";
                    $.each(deleteCheckedCustomerIds,function (index,obj){
                        id += "id="+this.value+"&";
                    });
                    id = id.substring(0,id.length-1);
                    // console.log(id)
                    $.ajax({
                        url:"workbench/customer/deleteCustomerByCustomerIds.do",
                        data:id,
                        dataType:"json",
                        type:"post",
                        success:function (data){
                            if(data.code==1){
                                //到当前删除的页面
                                // alert(data.message)
                                queryCustomerByConditionForPage($("#divPage").bs_pagination("getOption","currentPage"),$("#divPage").bs_pagination("getOption","rowsPerPage"));
                            }else{
                                alert(data.message)
                            }
                        }
                    })
                }
            });








        });

        //分页查询
        function queryCustomerByConditionForPage(pageNo,pageSize){
            var name = $.trim($("#query-name").val());
            var owner = $.trim($("#query-owner").val());
            var phone = $.trim($("#query-phone").val());
            var website = $.trim($("#query-website").val());
            // console.log(name+" , "+owner+" , "+phone+" , "+website)
            // alert("执行一次")
            $.ajax({
                url:"workbench/customer/queryCustomerByConditionForPage.do",
                data:{
                    name:name,
                    owner:owner,
                    phone:phone,
                    website:website,
                    pageNo:pageNo,
                    pageSize:pageSize
                },
                dataType: "json",
                type:"post",
                success:function (data){
                    var htmlStr = "";

                    $.each(data.customerList,function (index,obj){
                        htmlStr +="<tr>";
                        htmlStr +="    <td><input type=\"checkbox\" value=\""+obj.id+"\"/></td>";
                        htmlStr +="    <td><a style=\"text-decoration: none; cursor: pointer;\" onclick=\"window.location.href='workbench/customer/detailCustomer.do?customerId="+obj.id+"';\">"+obj.name+"</a></td>";
                        htmlStr +="    <td>"+obj.owner+"</td>";
                        htmlStr +="    <td>"+obj.phone+"</td>";
                        htmlStr +="    <td>"+obj.website+"</td>";
                        htmlStr +="</tr>";
                    });
                    $("#customerTbody").html(htmlStr);

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
                            queryCustomerByConditionForPage(pageObj.currentPage,pageObj.rowsPerPage);
                        }
                    });

                }
            })

        }


    </script>
</head>
<body>

<!-- 创建客户的模态窗口 -->
<div class="modal fade" id="createCustomerModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel1">创建客户</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form" id="createCustomerForm">

                    <div class="form-group">
                        <label for="create-owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-owner">
                                <c:forEach items="${userList}" var="user">
                                    <option value="${user.id}">${user.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <label for="create-name" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-name">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-website" class="col-sm-2 control-label">公司网站</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-website">
                        </div>
                        <label for="create-phone" class="col-sm-2 control-label">公司座机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-phone">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="create-description" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="create-description"></textarea>
                        </div>
                    </div>
                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

                    <div style="position: relative;top: 15px;">
                        <div class="form-group">
                            <label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control mydate" id="create-nextContactTime">
                            </div>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                    <div style="position: relative;top: 20px;">
                        <div class="form-group">
                            <label for="create-address" class="col-sm-2 control-label">详细地址</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="1" id="create-address"></textarea>
                            </div>
                        </div>
                    </div>
                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" id="closeCreateBtn">关闭</button>
                <button type="button" class="btn btn-primary" id="saveCreateBtn">保存</button>
            </div>
        </div>
    </div>
</div>

<!-- 修改客户的模态窗口 -->
<div class="modal fade" id="editCustomerModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">修改客户</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form">

                    <div class="form-group">
                        <input type="hidden" id="edit-id">
                        <label for="edit-owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-owner">
                                <c:forEach items="${userList}" var="user">
                                    <option value="${user.id}">${user.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <label for="edit-name" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-name" value="动力节点">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-website" class="col-sm-2 control-label">公司网站</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-website" value="http://www.bjpowernode.com">
                        </div>
                        <label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-phone" value="010-84846003">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-description" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="edit-description"></textarea>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

                    <div style="position: relative;top: 15px;">
                        <div class="form-group">
                            <label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3" id="edit-contactSummary"></textarea>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control mydate" id="edit-nextContactTime">
                            </div>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                    <div style="position: relative;top: 20px;">
                        <div class="form-group">
                            <label for="edit-address" class="col-sm-2 control-label">详细地址</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="1" id="edit-address">北京大兴大族企业湾</textarea>
                            </div>
                        </div>
                    </div>
                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" id="closeSaveCustomerBtn">关闭</button>
                <button type="button" class="btn btn-primary" id="saveEditCustomerByIdBtn">更新</button>
            </div>
        </div>
    </div>
</div>




<div>
    <div style="position: relative; left: 10px; top: -10px;">
        <div class="page-header">
            <h3>客户列表</h3>
        </div>
    </div>
</div>

<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">

    <div style="width: 100%; position: absolute;top: 5px; left: 10px;">

        <div class="btn-toolbar" role="toolbar" style="height: 80px;">
            <form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">名称</div>
                        <input class="form-control" id="query-name" type="text">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">所有者</div>
                        <input class="form-control" id="query-owner" type="text">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">公司座机</div>
                        <input class="form-control" id="query-phone" type="text">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">公司网站</div>
                        <input class="form-control" id="query-website" type="text">
                    </div>
                </div>

                <button type="button" class="btn btn-default" id="queryCustomerListByConditionForPage">查询</button>

            </form>
        </div>
        <div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
            <div class="btn-group" style="position: relative; top: 18%;">
                <button type="button" class="btn btn-primary" id="saveCreateCustomerBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
                <button type="button" class="btn btn-default" id="saveEditCustomerBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
                <button type="button" class="btn btn-danger" id="deleteCustomerIdsBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
            </div>

        </div>
        <div style="position: relative;top: 10px;">
            <table class="table table-hover">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td><input type="checkbox" id="checkedAll"/></td>
                    <td>名称</td>
                    <td>所有者</td>
                    <td>公司座机</td>
                    <td>公司网站</td>
                </tr>
                </thead>
                <tbody id="customerTbody">
<%--                <tr>
                    <td><input type="checkbox" /></td>
                    <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">动力节点</a></td>
                    <td>zhangsan</td>
                    <td>010-84846003</td>
                    <td>http://www.bjpowernode.com</td>
                </tr>
                <tr class="active">
                    <td><input type="checkbox" /></td>
                    <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">动力节点</a></td>
                    <td>zhangsan</td>
                    <td>010-84846003</td>
                    <td>http://www.bjpowernode.com</td>
                </tr>--%>
                </tbody>
            </table>
        </div>

        <div id="divPage"></div>

    </div>

</div>
</body>
</html>
