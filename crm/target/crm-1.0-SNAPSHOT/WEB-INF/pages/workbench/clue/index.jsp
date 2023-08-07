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

            $("#createClueBtn").click(function (){
                $("#createClueForm").get(0).reset();
                $("#createClueModal").modal("show");
            });

            $("#closeSaveCreateClueBtn").click(function (){
                $("createClueModal").modal("hide");
            })

            //点击创建线索的保存按钮
            $("#saveCreateClueBtn").click(function (){
                //收集数据
                //所有者
                var owner = $("#create-clueOwner").val();
                //公司
                var company = $.trim($("#create-company").val());
                //称呼
                var appellation = $("#create-call").val();
                //姓名
                var fullname = $.trim($("#create-surname").val());
                var job = $.trim($("#create-job").val());
                //邮箱
                var email = $.trim($("#create-email").val())
                //公司座机
                var phone = $.trim($("#create-phone").val());
                //公司网站
                var website = $.trim($("#create-website").val());

                var mphone = $.trim($("#create-mphone").val());
                var state = $("#create-state").val();
                var source = $("#create-source").val();
                var description = $.trim($("#create-description").val());
                var contactSummary = $.trim($("#create-contactSummary").val());
                var nextContactTime = $.trim($("#create-nextContactTime").val());
                var address = $.trim($("#create-address").val());


                if(owner==""){
                    alert("所有者不能为空")
                    return;
                }
                if(company==""){
                    alert("公司名称不能为空")
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
                if(phone!=""){
                    var regExt = /^\d{3,}-\d{8,}|\d{4,}-\d{7,8}$/;
                    if(!regExt.test(phone)){
                        alert("公司座机输入有误!")
                        return;
                    }
                }
                if(website!=""){
                    var regExt=/([hH][tT]{2}[pP]:\/\/|[hH][tT]{2}[pP][sS]:\/\/|[wW]{3}.|[wW][aA][pP].|[fF][tT][pP].|[fF][iI][lL][eE].)[-A-Za-z0-9+&@#\/%?=~_|!:,.;]+[-A-Za-z0-9+&@#\/%=~_|]/;
                    if(!regExt.test(website)){
                        alert("网站不合法！")
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
                    url:"workbench/clue/saveCreateClue.do",
                    data:{
                        fullname:fullname,
                        appellation:appellation,
                        owner:owner,
                        company:company,
                        job:job,
                        email:email,
                        phone:phone,
                        website:website,
                        mphone:mphone,
                        state:state,
                        source:source,
                        description:description,
                        contactSummary:contactSummary,
                        nextContactTime:nextContactTime,
                        address:address
                    },
                    dataType:"json",
                    type:"post",
                    success:function (data){
                        if(data.code==1){
                            //将模态窗口关闭
                            $("#createClueModal").modal("hide");
                            //执行分页查询
                            queryClueByConditionForPage(1,$("#divPage").bs_pagination("getOption","rowsPerPage"));
                        }else{
                            alert(data.message)
                            //模态窗口不关闭
                            $("#createClueModal").modal("show");
                        }
                    }
                })
            });


        //当页面加载时，查询第一页，每页10条记录
        queryClueByConditionForPage(1,10);

        //点击查询按钮
       $("#queryClueByConditionForPageBtn").click(function (){
           queryClueByConditionForPage(1,$("#divPage").bs_pagination("getOption","rowsPerPage"));
       });

       //全选按钮
       $("#checkedAll").click(function (){
         $("#clueTbody input[type='checkbox']").prop("checked",this.checked);
       });

       //给tbody的按钮添加事件
       $("#clueTbody").on("click","input[type='checkbox']",function (){
           if($("#clueTbody input[type='checkbox']").size() == $("#clueTbody input[type='checkbox']:checked").size()){
               $("#checkedAll").prop("checked",true)
           }else{
               $("#checkedAll").prop("checked",false)
           }
       })

       //点击修改按钮
       $("#saveEditClueBtn").click(function (){
           var checkedIds = $("#clueTbody input[type='checkbox']:checked");
           // alert(checkedIds)
           if(checkedIds.size() != 1){
               alert("请选中一条记录进行修改！")
               return;
           }else if(checkedIds.size()==1){
               //收集参数
               var id = checkedIds.get(0).value;
               // alert(checkedIds.get(0).value)
               $.ajax({
                   url:"workbench/clue/queryClueById.do",
                   data:{
                       id:id
                   },
                   dataType:"json",
                   type:"post",
                   success:function (data){
                       //将结果赋值到修改的模态窗口中
                       $("#edit-id").val(data.id);
                       $("#edit-fullname").val(data.fullname);
                       $("#edit-appellation").val(data.appellation);
                       $("#edit-owner").val(data.owner);
                       $("#edit-company").val(data.company);
                       $("#edit-job").val(data.job);
                       $("#edit-email").val(data.email);
                       $("#edit-phone").val(data.phone);
                       $("#edit-website").val(data.website);
                       $("#edit-mphone").val(data.mphone);
                       $("#edit-state").val(data.state);
                       $("#edit-source").val(data.source);
                       $("#edit-description").val(data.description);
                       $("#edit-contactSummary").val(data.contactSummary);
                       $("#edit-nextContactTime").val(data.nextContactTime);
                       $("#edit-address").val(data.address);

                       $("#editClueModal").modal("show");
                   }
               })
           }
       });

       $("#closeSaveEditBtn").click(function (){
           $("#editClueModal").modal("hide");
       });

       $("#saveEditBtn").click(function (){
           var id =$("#edit-id").val();
           var fullname =$.trim($("#edit-fullname").val());
           var appellation =$("#edit-appellation").val();
           var owner =$("#edit-owner").val();
           var company =$.trim($("#edit-company").val());
           var job =$.trim($("#edit-job").val());
           var email =$.trim($("#edit-email").val());
           var phone =$.trim($("#edit-phone").val());
           var website =$.trim($("#edit-website").val());
           var mphone =$.trim($("#edit-mphone").val());
           var state =$("#edit-state").val();
           var source =$("#edit-source").val();
           var description =$.trim($("#edit-description").val());
           var contactSummary =$.trim($("#edit-contactSummary").val());
           var nextContactTime =$.trim($("#edit-nextContactTime").val());
           var address =$.trim($("#edit-address").val());

           if(owner==""){
               alert("所有者不能为空")
               return;
           }
           if(company==""){
               alert("公司名称不能为空")
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
           if(phone!=""){
               var regExt = /^\d{3,}-\d{8,}|\d{4,}-\d{7,8}$/;
               if(!regExt.test(phone)){
                   alert("公司座机输入有误!")
                   return;
               }
           }
           if(website!=""){
               var regExt=/([hH][tT]{2}[pP]:\/\/|[hH][tT]{2}[pP][sS]:\/\/|[wW]{3}.|[wW][aA][pP].|[fF][tT][pP].|[fF][iI][lL][eE].)[-A-Za-z0-9+&@#\/%?=~_|!:,.;]+[-A-Za-z0-9+&@#\/%=~_|]/;
               if(!regExt.test(website)){
                   alert("网站不合法！")
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
               url:"workbench/clue/saveEditClueById.do",
               data:{
                   id:id,
                   fullname:fullname,
                   appellation:appellation,
                   owner:owner,
                   company:company,
                   job:job,
                   email:email,
                   phone:phone,
                   website:website,
                   mphone:mphone,
                   state:state,
                   source:source,
                   description:description,
                   contactSummary:contactSummary,
                   nextContactTime:nextContactTime,
                   address:address,
               },
               dataType:"json",
               type:"post",
               success:function (data){
                   if(data.code==1){
                       //模态窗口关闭
                       $("#editClueModal").modal("hide");
                       //保持当前页不变
                       queryClueByConditionForPage($("#divPage").bs_pagination("getOption","currentPage"),$("#divPage").bs_pagination("getOption","rowsPerPage"));
                   }else{
                       alert(data.message);
                       $("#editClueModal").modal("show");
                   }
               }
           })
       });

       $("#deleteCLueByIdsBtn").click(function (){
           var checkedIds = $("#clueTbody input[type='checkbox']:checked");
           if(checkedIds.size()==0){
               alert("请选择一条或多条记录删除！")
               return;
           }
           if(window.confirm("请确认删除！")){
               var ids = "";
               $.each(checkedIds,function (){
                   ids+="id="+this.value+"&";
               })
               //截掉最后一位 &
               ids.substring(0,ids.length-1);
               $.ajax({
                   url:"workbench/clue/deleteClueByIds.do",
                   data:ids,
                   dataType:"json",
                   type:"post",
                   success:function (data){
                       if(data.code==1){
                           //如果checkedAll有选择，设置为false
                           $("#checkedAll").prop("checked",false);
                           //保持当前页不变
                           queryClueByConditionForPage($("#divPage").bs_pagination("getOption","currentPage"),$("#divPage").bs_pagination("getOption","rowsPerPage"));
                       }else{
                           alert(data.message)
                       }
                   }
               })
           }
       })








        });


        //分页查询
        function queryClueByConditionForPage(pageNo,pageSize){
            var fullname = $.trim($("#query-fullname").val());
            var company = $.trim($("#query-company").val());
            var phone = $("#query-phone").val();
            var source = $("#query-source").val();
            var owner = $.trim($("#query-owner").val());
            var mphone = $.trim($("#query-mphone").val());
            var state = $.trim($("#query-state").val());
            // alert("执行一次")
            $.ajax({
                url:"workbench/clue/queryClueByConditionForPage.do",
                data:{
                    fullname:fullname,
                    company:company,
                    phone:phone,
                    source:source,
                    owner:owner,
                    mphone:mphone,
                    state:state,
                    pageNo:pageNo,
                    pageSize:pageSize
                },
                dataType: "json",
                type:"post",
                success:function (data){
                    var htmlStr = "";

                    $.each(data.clueList,function (index,obj){
                       htmlStr+="<tr>";
                       htmlStr+="    <td><input type=\"checkbox\" value='"+obj.id+"'/></td>";
                       if(obj.appellation==null){
                           obj.appellation="";
                       }
                       htmlStr+="    <td><a style=\"text-decoration: none; cursor: pointer;\" onclick=\"window.location.href='workbench/clue/detailClue.do?id="+obj.id+"';\">"+obj.fullname+obj.appellation+"</a></td>";
                       htmlStr+="    <td>"+obj.company+"</td>";
                       htmlStr+="    <td>"+obj.phone+"</td>";
                       htmlStr+="    <td>"+obj.mphone+"</td>";
                       if(obj.source==null){
                           obj.source="";
                       }
                       htmlStr+="    <td>"+obj.source+"</td>";
                       htmlStr+="    <td>"+obj.owner+"</td>";
                       if(obj.state==null){
                           obj.state="";
                       }
                       htmlStr+="    <td>"+obj.state+"</td>";
                       htmlStr+="</tr>";
                    });
                    $("#clueTbody").html(htmlStr);

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
                            queryClueByConditionForPage(pageObj.currentPage,pageObj.rowsPerPage);
                        }
                    });

                }
            })

        }



    </script>
</head>
<body>

<!-- 创建线索的模态窗口 -->
<div class="modal fade" id="createClueModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 90%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">创建线索</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form" id="createClueForm">

                    <div class="form-group">
                        <label for="create-clueOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-clueOwner">
                                <c:forEach items="${userList}" var="user">
                                    <option value="${user.id}">${user.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <label for="create-company" class="col-sm-2 control-label">公司<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-company">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-call" class="col-sm-2 control-label">称呼</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-call">
                                <option></option>
                                <c:forEach items="${appellationList}" var="appellation">
                                    <option value="${appellation.id}">${appellation.value}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <label for="create-surname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-surname">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-job" class="col-sm-2 control-label">职位</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-job">
                        </div>
                        <label for="create-email" class="col-sm-2 control-label">邮箱</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-email">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-phone" class="col-sm-2 control-label">公司座机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-phone">
                        </div>
                        <label for="create-website" class="col-sm-2 control-label">公司网站</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-website">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-mphone" class="col-sm-2 control-label">手机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-mphone">
                        </div>
                        <label for="create-state" class="col-sm-2 control-label">线索状态</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-state">
                                <option></option>
                                <c:forEach items="${clueStateList}" var="clueState">
                                    <option value="${clueState.id}">${clueState.value}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-source" class="col-sm-2 control-label">线索来源</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-source">
                                <option></option>
                                <c:forEach items="${sourceList}" var="source">
                                    <option value="${source.id}">${source.value}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>


                    <div class="form-group">
                        <label for="create-description" class="col-sm-2 control-label">线索描述</label>
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
                <button type="button" class="btn btn-default" id="closeSaveCreateClueBtn">关闭</button>
                <button type="button" class="btn btn-primary" id="saveCreateClueBtn">保存</button>
            </div>
        </div>
    </div>
</div>

<!-- 修改线索的模态窗口 -->
<div class="modal fade" id="editClueModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 90%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">修改线索</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form">
                    <input type="hidden" id="edit-id">
                    <div class="form-group">
                        <label for="edit-owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-owner">
                                <c:forEach items="${userList}" var="user">
                                    <option value="${user.id}">${user.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <label for="edit-company" class="col-sm-2 control-label">公司<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-company" value="动力节点">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-appellation" class="col-sm-2 control-label">称呼</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-appellation">
                                <option></option>
                                <c:forEach items="${appellationList}" var="appellation">
                                    <option value="${appellation.id}">${appellation.value}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <label for="edit-fullname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-fullname" value="李四">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-job" class="col-sm-2 control-label">职位</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-job" value="CTO">
                        </div>
                        <label for="edit-email" class="col-sm-2 control-label">邮箱</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-email" value="lisi@bjpowernode.com">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-phone" value="010-84846003">
                        </div>
                        <label for="edit-website" class="col-sm-2 control-label">公司网站</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-website" value="http://www.bjpowernode.com">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-mphone" class="col-sm-2 control-label">手机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-mphone" value="12345678901">
                        </div>
                        <label for="edit-state" class="col-sm-2 control-label">线索状态</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-state">
                                <option></option>
                                <c:forEach items="${clueStateList}" var="clueState">
                                    <option value="${clueState.id}">${clueState.value}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-source" class="col-sm-2 control-label">线索来源</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-source">
                                <option></option>
                                <c:forEach items="${sourceList}" var="source">
                                    <option value="${source.id}">${source.value}</option>
                                </c:forEach>
                            </select>
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
                                <textarea class="form-control" rows="3" id="edit-contactSummary">这个线索即将被转换</textarea>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control mydate" id="edit-nextContactTime" value="2017-05-01">
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
                <button type="button" class="btn btn-default" id="closeSaveEditBtn">关闭</button>
                <button type="button" class="btn btn-primary" id="saveEditBtn">更新</button>
            </div>
        </div>
    </div>
</div>




<div>
    <div style="position: relative; left: 10px; top: -10px;">
        <div class="page-header">
            <h3>线索列表</h3>
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
                        <input class="form-control" type="text" id="query-fullname">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">公司</div>
                        <input class="form-control" type="text" id="query-company">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">公司座机</div>
                        <input class="form-control" type="text" id="query-phone">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">线索来源</div>
                        <select class="form-control" id="query-source">
                            <option></option>
                            <c:forEach items="${sourceList}" var="source">
                                <option value="${source.id}">${source.value}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <br>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">所有者</div>
                        <input class="form-control" type="text" id="query-owner">
                    </div>
                </div>



                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">手机</div>
                        <input class="form-control" type="text" id="query-mphone">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">线索状态</div>
                        <select class="form-control" id="query-state">
                            <option></option>
                            <c:forEach items="${clueStateList}" var="clueState">
                                <option value="${clueState.id}">${clueState.value}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <%-- 必须设置类型为button，不设置，默认为submit --%>
                <button type="button" class="btn btn-default" id="queryClueByConditionForPageBtn">查询</button>

            </form>
        </div>
        <div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 40px;">
            <div class="btn-group" style="position: relative; top: 18%;">
                <button type="button" class="btn btn-primary"  data-target="#createClueModal" id="createClueBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
                <button type="button" class="btn btn-default"  data-target="#editClueModal" id="saveEditClueBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
                <button type="button" class="btn btn-danger" id="deleteCLueByIdsBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
            </div>


        </div>
        <div style="position: relative;top: 50px;">
            <table class="table table-hover">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td><input type="checkbox" id="checkedAll"/></td>
                    <td>名称</td>
                    <td>公司</td>
                    <td>公司座机</td>
                    <td>手机</td>
                    <td>线索来源</td>
                    <td>所有者</td>
                    <td>线索状态</td>
                </tr>
                </thead>
                <tbody id="clueTbody">
                <%--
                <tr>
                    <td><input type="checkbox" /></td>
                    <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='';">李四先生</a></td>
                    <td>动力节点</td>
                    <td>010-84846003</td>
                    <td>12345678901</td>
                    <td>广告</td>
                    <td>zhangsan</td>
                    <td>已联系</td>
                </tr>
                <tr class="active">
                    <td><input type="checkbox" /></td>
                    <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='l';">李四先生</a></td>
                    <td>动力节点</td>
                    <td>010-84846003</td>
                    <td>12345678901</td>
                    <td>广告</td>
                    <td>zhangsan</td>
                    <td>已联系</td>
                </tr>
                --%>
                </tbody>
            </table>
        </div>

        <div style="height: 50px; position: relative;top: 60px;" id="divPage">
<%--            <div>
                <button type="button" class="btn btn-default" style="cursor: default;">共<b>50</b>条记录</button>
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
            </div>--%>
        </div>

    </div>

</div>
</body>
</html>