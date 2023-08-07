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

            $("#createActivityBtn").click(function (){
                //初始化工作
                $("#createActivityForm").get(0).reset();
                //使这个模态窗口显示
                $("#createActivityModal").modal("show");
            })

            $("#saveActivityBtn").click(function (){
                //获取表单中的数据
                var owner = $("#create-marketActivityOwner").val();
                var name = $.trim($("#create-marketActivityName").val());
                var startDate = $("#create-startDate").val();
                var endDate = $("#create-endDate").val();
                var cost = $("#create-cost").val();
                var description = $.trim($("#create-description").val());
                if(owner==""){
                    alert("所有者不能为空！")
                    return;
                }
                if(name==""){
                    alert("活动名称不能为空！")
                    return;
                }
                //判断数据是否合法
                if(startDate=="" && !endDate==""){
                    alert("只有结束日期，没有开始日期！")
                    return;
                }
                if(!startDate==""&&!endDate==""){
                    if(startDate>endDate){
                        alert("活动结束日期不能小于创建日期")
                        return;
                    }
                }

                if(cost !=""){
                    var regExt = /^[1-9]\d*$/;
                    if(!regExt.test(cost)){
                        alert("成本只能为非负正整数！")
                        return;
                    }
                }

                //发送ajax请求
                $.ajax({
                    url:"workbench/activity/saveCreateActivity.do",
                    data:{
                        owner:owner,
                        name:name,
                        startDate:startDate,
                        endDate:endDate,
                        cost:cost,
                        description:description
                    },
                    dataType:"json",
                    type:"POST",
                    success:function (data){
                        if(data.code=="1"){
                            $("#createActivityModal").modal("hide");
                            queryActivityAndTotalRows(1,$("#demo_pag1").bs_pagination("getOption","rowsPerPage"));
                        }else{
                            alert(data.message)
                            return;
                        }
                    }
                })
            });

            //页面加载完毕时，执行分页查询
            queryActivityAndTotalRows(1,10);
            //点击查询时，执行
            $("#queryActivityAndTotalRowsBtn").click(function (){
                queryActivityAndTotalRows(1,$("#demo_pag1").bs_pagination("getOption","rowsPerPage"));
            })

            //给“全选”按钮添加单击事件
            $("#checkAll").click(function (){
                //如果全选按钮是选中状态，则列表中所有的checkbox都选中
/*                if(this.checked==true){
                     $("#activityTbody input[type='checkbox']").prop('checked',true);
                }else{
                    $("#activityTbody input[type='checkbox']").prop('checked',false);
                }*/
                $("#activityTbody input[type='checkbox']").prop('checked',this.checked);
            });

            //给tbody的每一个checkbox添加事件
/*            $("#activityTbody input[type='checkbox']").click(function (){
                //如果列表中所有的checkbox都选中，则‘全选’按钮也选中
                if($("#activityTbody input[type='checkbox']").size()==("#activityTbody input[type='checkbox']:checked").size()){
                    $("#checkAll").prop('checked',true)
                }else{//如果列表汇总至少有一个没选中，则全选按钮取消
                    $("#checkAll").prop('checked',false)
                }
            })*/
            $("#activityTbody").on("click","input[type='checkbox']",function (){
                if($("#activityTbody input[type='checkbox']").size()==$("#activityTbody input[type='checkbox']:checked").size()){
                    $("#checkAll").prop("checked",true);
                }else{
                    $("#checkAll").prop("checked",false)
                }
            });

            //给删除按钮添加单击事件
            $("#deleteActivityBtn").click(function (){
                //收集参数
                //获取列表中被选中的checkbox
                var checkedIds =$("#activityTbody input[type='checkbox']:checked");
                if(checkedIds.size()==0){
                    alert("请选择需要删除的市场活动!")
                    return;
                }
                if(window.confirm("确认删除吗？")){
                    var ids = "";
                    $.each(checkedIds,function (){
                        ids+="id="+this.value+"&"
                    });
                    ids.substring(0,ids.length-1)
                    //发送请求
                    $.ajax({
                        url:"workbench/activity/deleteActivityByIds.do",
                        data:ids,
                        dataType:"json",
                        type:"post",
                        success:function (data){
                            if(data.code=="1"){
                                queryActivityAndTotalRows(1,$("#demo_pag1").bs_pagination("getOption","rowsPerPage"));
                            }else if(data.code=="2"){
                                alert("删除失败")
                            }
                        }
                    })
                }
            });

            //用户点击修改活动，判断是否有选中一条记录，发送ajax请求
            $("#editActivityBtn").click(function (){
                var checkedIds = $("#activityTbody input[type='checkbox']:checked");
                if(checkedIds.size()==0){
                    alert("请选中其中一条记录进行修改！")
                    return;
                }else if(checkedIds.size()>1){
                    alert("只能修改一条记录，无法对多条记录进行修改！")
                    return;
                }else if(checkedIds.size()==1){
                    //可以使用 var id = checkedIds.val() 或者 var id = checkedIds[0].value
                    var id = checkedIds.get(0).value;
                    //选中一条记录，发送ajax请求
                    $.ajax({
                        url:"workbench/activity/queryActivityById.do",
                        data:{
                            id:id
                        },
                        dataType:"json",
                        type:"post",
                        success:function (data){
                            //把市场活动的信息显示在模态窗口
                            $("#edit-id").val(data.id);
                            $("#edit-marketActivityOwner").val(data.owner);
                            $("#edit-marketActivityName").val(data.name);
                            $("#edit-startTime").val(data.startDate)
                            $("#edit-endTime").val(data.endDate)
                            $("#edit-cost").val(data.cost)
                            $("#edit-describe").val(data.description)
                            //使这个模态窗口显示
                            $("#editActivityModal").modal("show");
                        }
                    })
                }
            });

            $("#saveEditActivityBtn").click(function (){
                //收集参数
                var id = $("#edit-id").val();
                var owner = $("#edit-marketActivityOwner").val();
                var name = $.trim($("#edit-marketActivityName").val());
                var startDate = $("#edit-startTime").val();
                var endDate = $("#edit-endTime").val();
                var cost = $("#edit-cost").val();
                var description =$.trim($("#edit-describe").val());
                if(owner==""){
                    alert("所有者不能为空！")
                    return;
                }
                if(name==""){
                    alert("活动名称不能为空！")
                    return;
                }
                //判断数据是否合法
                if(startDate=="" && !endDate==""){
                    alert("只有结束日期，没有开始日期！")
                    return;
                }
                if(!startDate==""&&!endDate==""){
                    if(startDate>endDate){
                        alert("活动结束日期不能小于创建日期")
                        return;
                    }
                }

                if(cost !=""){
                    var regExt = /^[1-9]\d*$/;
                    if(!regExt.test(cost)){
                        alert("成本只能为非负正整数！")
                        return;
                    }
                }
                //发送ajax请求
                $.ajax({
                    url:"workbench/activity/saveEditActivityById.do",
                    data:{
                        id:id,
                        owner:owner,
                        name:name,
                        startDate:startDate,
                        endDate:endDate,
                        cost:cost,
                        description:description
                    },
                    dataType:"json",
                    type:"post",
                    success:function (data){
                        if(data.code==1){
                            $("#editActivityModal").modal("hide")
                            //刷新市场活动列表，保持当前页号和页面显示条数不变
                            queryActivityAndTotalRows($("#demo_pag1").bs_pagination("getOption","currentPage"),$("#demo_pag1").bs_pagination("getOption","rowsPerPage"));
                        }else{
                            alert(data.message)
                            $("#editActivityModal").modal("show")
                        }
                    }
                });
            });

            $("#exportActivityAllBtn").click(function (){
               window.location.href="workbench/activity/exportAllActivity.do";
            });

            $("#exportActivityXzBtn").click(function (){
                //收集参数
                //获取列表中被选中的checkbox
                var checkedIds =$("#activityTbody input[type='checkbox']:checked");
                if(checkedIds.size()==0){
                    alert("请选择需要下载的市场活动!")
                    return;
                }
                var ids = "";
                $.each(checkedIds,function (){
                    ids+="id="+this.value+"&"
                });
                ids.substring(0,ids.length-1)
                window.location.href="workbench/activity/exportActiviryByIds.do?"+ids
            })

            //给导入按钮添加单击事件
            $("#importActivityBtn").click(function (){
                //收集参数
                var activityFileName = $("#activityFile").val(); //只能获取文件名
                // alert(activityFile) //C:\fakepath\activityList1679556454947.xls
                /*
                   js截取字符串
                      str.substr(starIndex,length)
                      str.substr(starIndex) //从下标文starIndex开始截取，截取到最后
                      str.substring(startIndex,endIndex)
                 */
                var suffix = activityFileName.substr(activityFileName.lastIndexOf(".")+1);
                if(suffix.toLowerCase() != "xls"){
                    alert("只支持xls文件")
                    return;
                }
                var activityFile = $("#activityFile")[0].files[0];
                // alert(activityFile.size)
                if(activityFile.size>5*1024*1024){
                    alert("文件大小不能超过5MB");
                    return;
                }

                //FormData是ajax提供的接口,可以模拟键值对，向后台提交参数
                //FormData最大的优势是不但能提交文本数据，还能提交二进制数据
                var formData = new FormData();
                formData.append("activityFile",activityFile);
                formData.append("userName","张三")

                //发送请求
                $.ajax({
                    url:"workbench/activity/importActivity.do",
                    data:formData,
                    processData:false,//设置ajax向后台提交参数前，是否把参数同意转换成字符串：true/false,默认为true
                    contentType:false,//设置ajax向后台提交参数之前，是否把所有的参数统一按urlencoded编码：true/false，默认为true
                    type:"post",
                    dataType:"json",
                    success:function (data){
                        if(data.code==1){
                            //提示成功导入记录条数
                            alert("成功导入"+data.returnData+"条记录");
                            //关闭模态窗口
                            $("#importActivityModal").modal("hide");
                            //文件上传之后，将表单值为空
                            $("#activityFile").val("")
                            //刷新市场活动列表，显示第一条数据，保持每页显示条数不变
                            queryActivityAndTotalRows(1,$("#demo_pag1").bs_pagination("getOption","rowsPerPage"));
                        }else{
                            //提示信息
                            alert(data.message)
                            //模态窗口不关闭
                            $("#importActivityModal").modal("show");
                        }
                    }
                })
            })





        });

        function queryActivityAndTotalRows(pageNo,pageSize){
            //获取参数
            var name = $("#query-name").val();
            var owner = $("#query-owner").val();
            var startDate = $("#query-startDate").val();
            var endDate = $("#query-endDate").val();
            // var pageNo = 1;
            // var pageSize = 10;
            $.ajax({
                url:"workbench/activity/queryActivityByConditionForPage.do",
                data:{
                    name:name,
                    owner:owner,
                    startDate:startDate,
                    endDate:endDate,
                    pageNo:pageNo,
                    pageSize:pageSize
                },
                type:"post",
                dataType: "json",
                success:function(data){
                    //根据条件查询的总记录条数
                    // $("#totalRowsB").text(data.totalRows);
                    //根据条件查询的记录
                    var htmlStr = "";
                    $.each(data.activityList,function (index,obj){
                        htmlStr+="<tr class=\"active\">";
                        htmlStr+="    <td><input type=\"checkbox\" value=\""+obj.id+"\"/></td>";
                        htmlStr+="    <td><a style=\"text-decoration: none; cursor: pointer;\" onclick=\"window.location.href='workbench/activity/detailActivity.do?id="+obj.id+"';\">"+obj.name+"</a></td>";
                        htmlStr+="     <td>"+obj.owner+"</td>";
                        htmlStr+="    <td>"+obj.startDate+"</td>";
                        htmlStr+="     <td>"+obj.endDate+"</td>";
                        htmlStr+="</tr>";
                    });
                    $("#activityTbody").html(htmlStr);

                    //取消全选按钮
                    $("#checkAll").prop("checked",false)

                    //计算总页数
                    var totalForPages = 1;
                    if(data.totalRows % pageSize == 0){
                        totalForPages = data.totalRows / pageSize ;
                    }else{
                        totalForPages = parseInt(data.totalRows / pageSize) + 1;
                    }

                    $("#demo_pag1").bs_pagination({
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
                            queryActivityAndTotalRows(pageObj.currentPage,pageObj.rowsPerPage);
                        }
                    });

                }
            });

        };

    </script>
</head>
<body>

<!-- 创建市场活动的模态窗口 -->
<div class="modal fade" id="createActivityModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel1">创建市场活动</h4>
            </div>
            <div class="modal-body">

                <form class="form-horizontal" role="form" id="createActivityForm">

                    <div class="form-group">
                        <label for="create-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-marketActivityOwner">
                                <c:forEach items="${userList}" var="user" >
                                    <option value="${user.id}">${user.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <label for="create-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-marketActivityName">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-startDate" class="col-sm-2 control-label">开始日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control mydate" id="create-startDate" readonly>
                        </div>
                        <label for="create-endDate" class="col-sm-2 control-label">结束日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control mydate" id="create-endDate" readonly>
                        </div>
                    </div>
                    <div class="form-group">

                        <label for="create-cost" class="col-sm-2 control-label">成本</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-cost">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="create-description" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="create-description"></textarea>
                        </div>
                    </div>

                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="saveActivityBtn">保存</button>
            </div>
        </div>
    </div>
</div>

<!-- 修改市场活动的模态窗口 -->
<div class="modal fade" id="editActivityModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel2">修改市场活动</h4>
            </div>
            <div class="modal-body">

                <form class="form-horizontal" role="form">
                    <input type="hidden" id="edit-id">
                    <div class="form-group">
                        <label for="edit-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-marketActivityOwner">
                                <c:forEach items="${userList}" var="user" >
                                    <option value="${user.id}">${user.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <label for="edit-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-marketActivityName" value="发传单">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-startTime" class="col-sm-2 control-label">开始日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control mydate" id="edit-startTime" value="2020-10-10" readonly>
                        </div>
                        <label for="edit-endTime" class="col-sm-2 control-label">结束日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control mydate" id="edit-endTime" value="2020-10-20" readonly>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-cost" class="col-sm-2 control-label">成本</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-cost" value="5,000">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-describe" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="edit-describe">市场活动Marketing，是指品牌主办或参与的展览会议与公关市场活动，包括自行主办的各类研讨会、客户交流会、演示会、新产品发布会、体验会、答谢会、年会和出席参加并布展或演讲的展览会、研讨会、行业交流会、颁奖典礼等</textarea>
                        </div>
                    </div>

                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="saveEditActivityBtn">更新</button>
            </div>
        </div>
    </div>
</div>

<!-- 导入市场活动的模态窗口 -->
<div class="modal fade" id="importActivityModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">导入市场活动</h4>
            </div>
            <div class="modal-body" style="height: 350px;">
                <div style="position: relative;top: 20px; left: 50px;">
                    请选择要上传的文件：<small style="color: gray;">[仅支持.xls]</small>
                </div>
                <div style="position: relative;top: 40px; left: 50px;">
                    <input type="file" id="activityFile">
                </div>
                <div style="position: relative; width: 400px; height: 320px; left: 45% ; top: -40px;" >
                    <h3>重要提示</h3>
                    <ul>
                        <li>操作仅针对Excel，仅支持后缀名为XLS的文件。</li>
                        <li>给定文件的第一行将视为字段名。</li>
                        <li>请确认您的文件大小不超过5MB。</li>
                        <li>日期值以文本形式保存，必须符合yyyy-MM-dd格式。</li>
                        <li>日期时间以文本形式保存，必须符合yyyy-MM-dd HH:mm:ss的格式。</li>
                        <li>默认情况下，字符编码是UTF-8 (统一码)，请确保您导入的文件使用的是正确的字符编码方式。</li>
                        <li>建议您在导入真实数据之前用测试文件测试文件导入功能。</li>
                    </ul>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button id="importActivityBtn" type="button" class="btn btn-primary">导入</button>
            </div>
        </div>
    </div>
</div>


<div>
    <div style="position: relative; left: 10px; top: -10px;">
        <div class="page-header">
            <h3>市场活动列表</h3>
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
                        <input class="form-control" type="text" id="query-name">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">所有者</div>
                        <input class="form-control" type="text" id="query-owner">
                    </div>
                </div>


                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">开始日期</div>
                        <input class="form-control" type="text" id="query-startDate" />
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">结束日期</div>
                        <input class="form-control" type="text" id="query-endDate">
                    </div>
                </div>

                <button type="button" class="btn btn-default" id="queryActivityAndTotalRowsBtn">查询</button>

            </form>
        </div>
        <div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
            <div class="btn-group" style="position: relative; top: 18%;">
                <button type="button" class="btn btn-primary" data-target="#createActivityModal" id="createActivityBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
                <button type="button" class="btn btn-default" data-target="#editActivityModal" id="editActivityBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
                <button type="button" class="btn btn-danger" id="deleteActivityBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
            </div>
            <div class="btn-group" style="position: relative; top: 18%;">
                <button type="button" class="btn btn-default" data-toggle="modal" data-target="#importActivityModal" ><span class="glyphicon glyphicon-import"></span> 上传列表数据（导入）</button>
                <button id="exportActivityAllBtn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-export"></span> 下载列表数据（批量导出）</button>
                <button id="exportActivityXzBtn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-export"></span> 下载列表数据（选择导出）</button>
            </div>
        </div>
        <div style="position: relative;top: 10px;">
            <table class="table table-hover">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td><input type="checkbox" id="checkAll"/></td>
                    <td>名称</td>
                    <td>所有者</td>
                    <td>开始日期</td>
                    <td>结束日期</td>
                </tr>
                </thead>
                <tbody id="activityTbody">
<%--                <tr class="active">
                    <td><input type="checkbox" /></td>
                    <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">发传单</a></td>
                    <td>zhangsan</td>
                    <td>2020-10-10</td>
                    <td>2020-10-20</td>
                </tr>
                <tr class="active">
                    <td><input type="checkbox" /></td>
                    <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">发传单</a></td>
                    <td>zhangsan</td>
                    <td>2020-10-10</td>
                    <td>2020-10-20</td>
                </tr>--%>
                </tbody>
            </table>
        </div>

        <div id="demo_pag1"></div>
<%--

        <div style="height: 50px; position: relative;top: 30px;">
            <div>
                <button type="button" class="btn btn-default" style="cursor: default;">共<b id="totalRowsB">0</b>条记录</button>
            </div>
            <div class="btn-group" style="position: relative;top: -34px; left: 110px;">
                <button type="button" class="btn btn-default" style="cursor: default;">显示</button>
                <div class="btn-group">
                    <button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
                        10
                        <span class="caret"></span>
                    </button>
                    <ul class="dropdown-menu" role="menu">
                        <li><a href="#">20</a></li>
                        <li><a href="#">30</a></li>
                    </ul>
                </div>
                <button type="button" class="btn btn-default" style="cursor: default;">条/页</button>
            </div>
            <div style="position: relative;top: -88px; left: 285px;">
                <nav>
                    <ul class="pagination">
                        <li class="disabled"><a href="#">首页</a></li>
                        <li class="disabled"><a href="#">上一页</a></li>
                        <li class="active"><a href="#">1</a></li>
                        <li><a href="#">2</a></li>
                        <li><a href="#">3</a></li>
                        <li><a href="#">4</a></li>
                        <li><a href="#">5</a></li>
                        <li><a href="#">下一页</a></li>
                        <li class="disabled"><a href="#">末页</a></li>
                    </ul>
                </nav>
            </div>
        </div>
--%>

    </div>

</div>
</body>
</html>
