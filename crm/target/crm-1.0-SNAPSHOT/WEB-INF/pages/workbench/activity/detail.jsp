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
    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>

    <script type="text/javascript">

        //默认情况下取消和保存按钮是隐藏的
        var cancelAndSaveBtnDefault = true;

        $(function(){
            $("#remark").focus(function(){
                if(cancelAndSaveBtnDefault){
                    //设置remarkDiv的高度为130px
                    $("#remarkDiv").css("height","130px");
                    //显示
                    $("#cancelAndSaveBtn").show("2000");
                    cancelAndSaveBtnDefault = false;
                }
            });

            $("#cancelBtn").click(function(){
                //显示
                $("#cancelAndSaveBtn").hide();
                //设置remarkDiv的高度为130px
                $("#remarkDiv").css("height","90px");
                cancelAndSaveBtnDefault = true;
            });

            /*
            $(".remarkDiv").mouseover(function(){
                $(this).children("div").children("div").show();
            });
            */
            $("#remarkDivList").on("mouseover",".remarkDiv",function (){
                $(this).children("div").children("div").show();
            });
/*

            $(".remarkDiv").mouseout(function(){
                $(this).children("div").children("div").hide();
            });
*/
            $("#remarkDivList").on("mouseout",".remarkDiv",function (){
                $(this).children("div").children("div").hide();
            });
/*

            $(".myHref").mouseover(function(){
                $(this).children("span").css("color","red");
            });
*/
            $("#remarkDivList").on("mouseover",".myHref",function (){
                $(this).children("span").css("color","red");
            });

/*
            $(".myHref").mouseout(function(){
                $(this).children("span").css("color","#E6E6E6");
            });
*/
            $("#remarkDivList").on("mouseout",".myHref",function (){
                $(this).children("span").css("color","#E6E6E6");
            });

           $("#saveCreateActivityRemarkBtn").click(function (){
               //收集参数
               var noteContent = $.trim($("#remark").val());
               if(noteContent==""){
                   alert("备注不能为空！")
                   return;
               }
               /*
                  jsp的运行原理
                  xxx.jsp: 1、tomcat中运行：
                             把xxx.jsp翻译成一个servlet，
                             运行servlet，运行的结果是一个html网页
                             把HTML网页输出到浏览器
                           2、html网页在浏览器上运行：
                             先从上到下加载html网页到浏览器，在加载过程中，运行前端代码，
                             当页面都加载完成，再执行入口函数。

                   把页面片段显示在动态页面中：
                    选择器.append(htmlStr):追加显示在指定标签的内部的后边
                    <div id="myDiv">
                       aaaaaa
                       bbbbbb
                    </div>
                    var htmlStr = "<p>ccccccc</p>";
                    $("#myDiv").append(htmlStr)

                    <div id="myDiv">
                       aaaaaa
                       bbbbbb
                       <p>ccccccc</p>
                    </div>
                    选择器.html(htmlStr):覆盖显示在标签的内部
                    选择器.text(htmlStr):覆盖显示在标签的内部
                    选择器.after(htmlStr):覆盖显示在指定标签的外部的后边
                    <div id="myDiv">
                       aaaaaa
                       bbbbbb
                    </div>
                    var htmlStr = "<p>ccccccc</p>";
                    $("#myDiv").after(htmlStr)

                    <div id="myDiv">
                       aaaaaa
                       bbbbbb
                    </div>
                    <p>ccccccc</p>
                    选择器.before(htmlStr):覆盖显示在指定标签的外部的前边
                    <div id="myDiv">
                       aaaaaa
                       bbbbbb
                    </div>
                    var htmlStr = "<p>ccccccc</p>";
                    $("#myDiv").after(htmlStr)

                    p>ccccccc</p>
                    <div id="myDiv">
                       aaaaaa
                       bbbbbb
                    </div>

                */
               var activityId = '${activity.id}';
               // alert(activityId)
               $.ajax({
                   url:"workbench/activity/saveCreateActivityRemark.do",
                   type:"post",
                   dataType:"json",
                   data:{
                       noteContent:noteContent,
                       activityId:activityId
                   },
                   success:function (data){
                      if(data.code==1){
                          //清空textarea
                          $("#remark").val("");
                          var htmlStr = ""
                          htmlStr+="<div class=\"remarkDiv\" id=\"div_"+data.returnData.id+"\" style=\"height: 60px;\">";
                          htmlStr+="    <img title='${sessionScope.sessionUser.name}' src='image/user-thumbnail.png' style='width: 30px; height:30px;'>";
                          htmlStr+="<div style=\"position: relative; top: -40px; left: 40px;\" >";
                          htmlStr+="    <h5>"+data.returnData.noteContent+"</h5>";
                          htmlStr+="<font color='gray'>市场活动</font> <font color='gray'>-</font> <b>${activity.name}</b> <small style='color: gray;'> "+data.returnData.createTime+" 由${sessionScope.sessionUser.name}创建</small>";
                          htmlStr+="<div style=\"position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;\">";
                          htmlStr+="    <a class=\"myHref\" name=\"editA\" remarkId=\""+data.returnData.id+"\" href=\"javascript:void(0);\"><span class=\"glyphicon glyphicon-edit\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a>";
                          htmlStr+="    &nbsp;&nbsp;&nbsp;&nbsp;";
                          htmlStr+="    <a class=\"myHref\" name=\"deleteA\" remarkId=\""+data.returnData.id+"\" href=\"javascript:void(0);\"><span class=\"glyphicon glyphicon-remove\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a>";
                          htmlStr+="</div>";
                          htmlStr+="</div>";
                          htmlStr+="</div>";
                          $("#remarkDiv").before(htmlStr);
                      }else{
                          //提示信息
                          alert(data.message)
                      }
                   }
               })
           });

           $("#remarkDivList").on("click","a[name='deleteA']",function (){
               var id = $(this).attr("remarkId");
               // alert(id)
               $.ajax({
                   url:"workbench/activity/deleteActivityRemarkById.do",
                   data:{
                       id:id
                   },
                   dataType: "json",
                   type:"post",
                   success:function (data){
                       if(data.code==1){
                           $("#div_"+id).remove();
                       }else{
                           alert(data.message)
                       }
                   }
               })
           });

            $("#remarkDivList").on("click","a[name=editA]",function (){
                //收集参数
                var id = $(this).attr("remarkId");
                var noteContent = $("#div_"+id+" h5").text();
                // alert(noteContent)
                //将参数设置到模态窗口
                $("#edit-remarkId").val(id);
                $("#edit-noteContent").val(noteContent);
                //将模态窗口显示出来
                $("#editRemarkModal").modal("show");
            });

            $("#updateRemarkBtn").click(function (){
                var id = $("#edit-remarkId").val();
                var noteContent = $("#edit-noteContent").val();
                if(noteContent==""){
                    alert("请输入修改的备注!")
                    return;
                }
                $.ajax({
                    url:"workbench/activity/saveEditActivityRemarkById.do",
                    data:{
                        id:id,
                        noteContent:noteContent
                    },
                    dataType:"json",
                    type:"post",
                    success:function (data){
                        if(data.code==1){
                            //将模态窗口隐藏
                            $("#editRemarkModal").modal("hide");
                            //界面局部刷新
                            $("#div_"+data.returnData.id+" h5").text(data.returnData.noteContent);
                            $("#div_"+data.returnData.id+" small").text(" "+data.returnData.editTime+" 由${sessionScope.sessionUser.name}修改");
                        }else{
                            alert(data.message)
                            //将模态窗口显示出来
                            $("#editRemarkModal").modal("show");
                        }
                    }
                })
            });




        });

    </script>

</head>
<body>

<!-- 修改市场活动备注的模态窗口 -->
<div class="modal fade" id="editRemarkModal" role="dialog">
    <%-- 备注的id --%>
    <input type="hidden" id="edit-remarkId">
    <div class="modal-dialog" role="document" style="width: 40%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">修改备注</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form">
                    <div class="form-group">
                        <label for="edit-noteContent" class="col-sm-2 control-label">内容</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="edit-noteContent"></textarea>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="updateRemarkBtn">更新</button>
            </div>
        </div>
    </div>
</div>



<!-- 返回按钮 -->
<div style="position: relative; top: 35px; left: 10px;">
    <a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span></a>
</div>

<!-- 大标题 -->
<div style="position: relative; left: 40px; top: -30px;">
    <div class="page-header">
        <h3>市场活动-${activity.name} <small>${activity.startDate} ~ ${activity.endDate}</small></h3>
    </div>

</div>

<br/>
<br/>
<br/>

<!-- 详细信息 -->
<div style="position: relative; top: -70px;">
    <div style="position: relative; left: 40px; height: 30px;">
        <div style="width: 300px; color: gray;">所有者</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${activity.owner}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">名称</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${activity.owner}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>

    <div style="position: relative; left: 40px; height: 30px; top: 10px;">
        <div style="width: 300px; color: gray;">开始日期</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${activity.startDate}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">结束日期</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${activity.endDate}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 20px;">
        <div style="width: 300px; color: gray;">成本</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${activity.cost}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 30px;">
        <div style="width: 300px; color: gray;">创建者</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${activity.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${activity.createTime}</small></div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 40px;">
        <div style="width: 300px; color: gray;">修改者</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${activity.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${activity.editTime}</small></div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 50px;">
        <div style="width: 300px; color: gray;">描述</div>
        <div style="width: 630px;position: relative; left: 200px; top: -20px;">
            <b>
                ${activity.description}
            </b>
        </div>
        <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
</div>

<!-- 备注 -->
<div style="position: relative; top: 30px; left: 40px;" id="remarkDivList">
    <div class="page-header">
        <h4>备注</h4>
    </div>
<%--    遍历remarkList，显示所有的备注--%>
    <c:forEach items="${remarkList}" var="remark">
        <div class="remarkDiv" id="div_${remark.id}" style="height: 60px;">
            <img title="${remark.createBy}" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
            <div style="position: relative; top: -40px; left: 40px;" >
                <h5>${remark.noteContent}</h5>
                <font color="gray">市场活动</font> <font color="gray">-</font> <b>${activity.name}</b> <small style="color: gray;">${remark.editFlag=='1'?remark.editTime:remark.createTime} 由${remark.editFlag=='1'?remark.editBy:remark.createBy}${remark.editFlag=='1'?"修改":"创建"}</small>
                <div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
                    <%--
                        使用标签保存数据，以便在需要的时候能够获取到这些数据

                         给标签添加属性：
                              如果是表单组件标签，优先使用value属性，只有value不方便使用时，使用自定义属性；
                              如果不是表单组件标签，不推荐使用value属性，推荐使用自定义属性值
                         获取属性值时：
                              如果获取表单组件标签的value属性值，dom对象.value
                                                            jquery对象.val()
                              如果自定义的属性，不管是什么标签只能用：jquery对象.attr("属性值")；
                    --%>
                    <a class="myHref" name="editA" remarkId="${remark.id}" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
                    &nbsp;&nbsp;&nbsp;&nbsp;
                    <a class="myHref" name="deleteA" remarkId="${remark.id}" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
                </div>
            </div>
        </div>
    </c:forEach>

    <!-- 备注1 -->
<%--
    <div class="remarkDiv" style="height: 60px;">
        <img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
        <div style="position: relative; top: -40px; left: 40px;" >
            <h5>哎呦！</h5>
            <font color="gray">市场活动</font> <font color="gray">-</font> <b>发传单</b> <small style="color: gray;"> 2017-01-22 10:10:10 由zhangsan</small>
            <div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
                <a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
                &nbsp;&nbsp;&nbsp;&nbsp;
                <a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
            </div>
        </div>
    </div>
--%>

    <!-- 备注2 -->
<%--
    <div class="remarkDiv" style="height: 60px;">
        <img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
        <div style="position: relative; top: -40px; left: 40px;" >
            <h5>呵呵！</h5>
            <font color="gray">市场活动</font> <font color="gray">-</font> <b>发传单</b> <small style="color: gray;"> 2017-01-22 10:20:10 由zhangsan</small>
            <div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
                <a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
                &nbsp;&nbsp;&nbsp;&nbsp;
                <a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
            </div>
        </div>
    </div>
--%>

    <div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
        <form role="form" style="position: relative;top: 10px; left: 10px;">
            <textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"  placeholder="添加备注..."></textarea>
            <p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
                <button id="cancelBtn" type="button" class="btn btn-default">取消</button>
                <button type="button" class="btn btn-primary" id="saveCreateActivityRemarkBtn">保存</button>
            </p>
        </form>
    </div>
</div>
<div style="height: 200px;"></div>
</body>
</html>
