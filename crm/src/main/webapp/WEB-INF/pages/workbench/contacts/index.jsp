<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
  Created by IntelliJ IDEA.
  User: callray_liu
  Date: 2023-05-08
  Time: 14:44
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

            //页面加载完毕时，执行查询
            queryContactsByConditionForPage(1,10);

            //点击查询
            $("#searchContactsBtn").click(function (){
                queryContactsByConditionForPage(1,$("#divPage").bs_pagination("getOption","rowsPerPage"));
            });

            //点击创建
            $("#createContactsBtn").click(function (){
                $("#createContactsModal").modal("show");
            });

            //用户点击保存按钮
            $("#saveCreateContactsBtn").click(function (){
                //收集参数
                var owner = $("#create-owner").val();
                var source = $("#create-source").val();
                var fullname = $.trim($("#create-fullname").val());
                var appellation = $("#create-appellation").val();
                var job = $.trim($("#create-job").val());
                var mphone = $.trim($("#create-mphone").val());
                var email = $.trim($("#create-email").val());
                var customerId = $("#create-customerId").val();
                var description = $.trim($("#create-description").val());
                var contactSummary = $.trim($("#create-contactSummary").val());
                var nextContactTime = $.trim($("#create-nextContactTime").val());
                var address = $.trim($("#create-address").val());
                //判断条件是否符合
                if(owner==""){
                    alert("所有者不能为空！")
                    return;
                }
                if(fullname==""){
                    alert("姓名不能为空！");
                    return;
                }
                //先判断邮箱是否为空
                if(email!=""){
                    var regExt = /^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/;
                    if(!regExt.test(email)){
                        alert("邮箱格式不符，请重新输入！")
                        return;
                    }
                }
                if(mphone!=""){
                    var regExt = /^[1][3,4,5,6,7,8,9][0-9]{9}$/;
                    if(!regExt.test(mphone)){
                        alert("手机号码输入有误！")
                        return;
                    }
                }
                $.ajax({
                    url:"workbench/contacts/saveCreateContacts.do",
                    data:{
                        owner:owner,
                        source:source,
                        fullname:fullname,
                        appellation:appellation,
                        job:job,
                        mphone:mphone,
                        email:email,
                        customerId:customerId,
                        description:description,
                        contactSummary:contactSummary,
                        nextContactTime:nextContactTime,
                        address:address
                    },
                    dataType:"json",
                    type:"post",
                    success:function (data){
                        if(data.code==1){
                            //关闭模态窗口
                            $("#createContactsModal").modal("hide");
                        }else{
                            alert(data.message)
                            //开启模态窗口
                            $("#createContactsModal").modal("show");
                        }
                    }
                })
            });

            //用户输入客户名称
            $("#create-customerName").keyup(function (e){
                // console.log(e.keyCode) enter为13
                var customerName = $.trim($("#create-customerName").val());
                if(e.keyCode==13){
                    if(customerName==""){
                        alert("请输入客户名称！");
                        return;
                    }else{
                        //输入内容不为空的时候，进行查询


                    }
                }
            });





        });

        //分页查询
        function queryContactsByConditionForPage(pageNo,pageSize){
            //收集参数
            var owner = $.trim($("#query-owner").val());
            var fullname = $.trim($("#query-fullname").val());
            var customerName = $.trim($("#query-customerName").val());
            var source = $.trim($("#query-source").val());
            // alert("执行一次")
            $.ajax({
                url:"workbench/contacts/queryContactsListByConditionForPage.do",
                data:{
                    owner:owner,
                    fullname:fullname,
                    customerName:customerName,
                    source:source,
                    pageNo:pageNo,
                    pageSize:pageSize
                },
                dataType: "json",
                type:"post",
                success:function (data){
                    var htmlStr = "";

                    $.each(data.contactsList,function (index,obj){
                        htmlStr +="<tr>";
                        htmlStr +="    <td><input type=\"checkbox\" /></td>";
                        htmlStr +="    <td><a style=\"text-decoration: none; cursor: pointer;\" onclick=\"window.location.href='/workbench/contacts/detailContacts.do?contactsId="+obj.id+"';\">"+obj.fullname+"</a></td>";
                        htmlStr +="    <td>"+obj.customerId+"</td>";
                        htmlStr +="    <td>"+obj.owner+"</td>";
                        htmlStr +="    <td>"+obj.source+"</td>";
                        htmlStr +="</tr>";
                    });
                    $("#contactsTbody").html(htmlStr);

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
                            queryContactsByConditionForPage(pageObj.currentPage,pageObj.rowsPerPage);
                        }
                    });

                }
            })

        }

    </script>
</head>
<body>


<!-- 创建联系人的模态窗口 -->
<div class="modal fade" id="createContactsModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" onclick="$('#createContactsModal').modal('hide');">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabelx">创建联系人</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form">

                    <div class="form-group">
                        <label for="create-owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-owner">
                                <c:forEach items="${userList}" var="user">
                                    <option value="${user.id}">${user.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <label for="create-source" class="col-sm-2 control-label">来源</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-source">
                                <option></option>
                                <c:forEach items="${dicValueSourceList}" var="dicValueSource">
                                    <option value="${dicValueSource.id}">${dicValueSource.value}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-fullname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-fullname">
                        </div>
                        <label for="create-appellation" class="col-sm-2 control-label">称呼</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-appellation">
                                <option></option>
                                <c:forEach items="${dicValueAppellationList}" var="dicValueAppellation">
                                    <option value="${dicValueAppellation.id}">${dicValueAppellation.value}</option>
                                </c:forEach>
                            </select>
                        </div>

                    </div>

                    <div class="form-group">
                        <label for="create-job" class="col-sm-2 control-label">职位</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-job">
                        </div>
                        <label for="create-mphone" class="col-sm-2 control-label">手机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-mphone">
                        </div>
                    </div>

                    <div class="form-group" style="position: relative;">
                        <label for="create-email" class="col-sm-2 control-label">邮箱</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-email">
                        </div>
                    </div>

                    <div class="form-group" style="position: relative;">
                        <label for="create-customerName" class="col-sm-2 control-label">客户名称</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="hidden" id="create-customerId">
                            <input type="text" class="form-control" id="create-customerName" placeholder="支持自动补全，输入客户不存在则新建">
                        </div>
                    </div>

                    <div class="form-group" style="position: relative;">
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
                                <input type="text" class="form-control" id="create-nextContactTime">
                            </div>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                    <div style="position: relative;top: 20px;">
                        <div class="form-group">
                            <label for="create-address" class="col-sm-2 control-label">详细地址</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="1" id="create-address">北京大兴区大族企业湾</textarea>
                            </div>
                        </div>
                    </div>
                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="saveCreateContactsBtn">保存</button>
            </div>
        </div>
    </div>
</div>

<!-- 修改联系人的模态窗口 -->
<div class="modal fade" id="editContactsModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel1">修改联系人</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form">

                    <div class="form-group">
                        <label for="edit-owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-owner">
                                <c:forEach items="${userList}" var="user">
                                    <option value="${user.id}">${user.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <label for="edit-source" class="col-sm-2 control-label">来源</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-source">
                                <option></option>
                                <c:forEach items="${dicValueSourceList}" var="dicValueSource">
                                    <option value="${dicValueSource.id}">${dicValueSource.value}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-fullname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-fullname" value="李四">
                        </div>
                        <label for="edit-appellation" class="col-sm-2 control-label">称呼</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-appellation">
                                <option></option>
                                <c:forEach items="${dicValueAppellationList}" var="dicValueAppellation">
                                    <option value="${dicValueAppellation.id}">${dicValueAppellation.value}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-job" class="col-sm-2 control-label">职位</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-job" value="CTO">
                        </div>
                        <label for="edit-mphone" class="col-sm-2 control-label">手机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-mphone" value="12345678901">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-email" class="col-sm-2 control-label">邮箱</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-email" value="lisi@bjpowernode.com">
                        </div>
                    </div>


                    <div class="form-group">
                        <label for="edit-customerName" class="col-sm-2 control-label">客户名称</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="hidden" id="edit-customerId">
                            <input type="text" class="form-control" id="edit-customerName" placeholder="支持自动补全，输入客户不存在则新建" value="动力节点">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-description" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="edit-description">这是一条线索的描述信息</textarea>
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
                                <input type="text" class="form-control" id="edit-nextContactTime">
                            </div>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                    <div style="position: relative;top: 20px;">
                        <div class="form-group">
                            <label for="edit-address" class="col-sm-2 control-label">详细地址</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="1" id="edit-address">北京大兴区大族企业湾</textarea>
                            </div>
                        </div>
                    </div>
                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" data-dismiss="modal">更新</button>
            </div>
        </div>
    </div>
</div>





<div>
    <div style="position: relative; left: 10px; top: -10px;">
        <div class="page-header">
            <h3>联系人列表</h3>
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
                        <div class="input-group-addon">姓名</div>
                        <input class="form-control" type="text" id="query-fullname">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">客户名称</div>
                        <input class="form-control" type="text" id="query-customerName">
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


                <button type="button" class="btn btn-default" id="searchContactsBtn">查询</button>

            </form>
        </div>
        <div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 10px;">
            <div class="btn-group" style="position: relative; top: 18%;">
                <button type="button" class="btn btn-primary" id="createContactsBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
                <button type="button" class="btn btn-default" data-toggle="modal" data-target="#editContactsModal"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
                <button type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
            </div>


        </div>
        <div style="position: relative;top: 20px;">
            <table class="table table-hover">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td><input type="checkbox" id="checkedAll"/></td>
                    <td>姓名</td>
                    <td>客户名称</td>
                    <td>所有者</td>
                    <td>来源</td>
                </tr>
                </thead>
                <tbody id="contactsTbody">
<%--                <tr>
                    <td><input type="checkbox" /></td>
                    <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">李四</a></td>
                    <td>动力节点</td>
                    <td>zhangsan</td>
                    <td>广告</td>
                    <td>2000-10-10</td>
                </tr>
                <tr class="active">
                    <td><input type="checkbox" /></td>
                    <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">李四</a></td>
                    <td>动力节点</td>
                    <td>zhangsan</td>
                    <td>广告</td>
                    <td>2000-10-10</td>
                </tr>--%>
                </tbody>
            </table>
        </div>

        <div id="divPage"></div>

    </div>

</div>
</body>
</html>
