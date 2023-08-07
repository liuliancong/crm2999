<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
  Created by IntelliJ IDEA.
  User: callray_liu
  Date: 2023-04-10
  Time: 10:46
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

            $("#saveCreateClueRemarkBtn").click(function (){
                var noteContent = $.trim($("#remark").val());
                if(noteContent==""){
                    alert("请输入备注！")
                    return;
                }
                var clueId = '${clue.id}';
                $.ajax({
                    url:"workbench/clue/saveCreateClueRemark.do",
                    data:{
                        noteContent:noteContent,
                        clueId:clueId
                    },
                    dataType:"json",
                    type:"post",
                    success:function (data){
                        if(data.code==1){
                            //将备注值，置为空
                            $("#remark").val("")

                            var htmlStr = "";
                            htmlStr+="<div class=\"remarkDiv\" style=\"height: 60px;\" id=\"div_"+data.returnData.id+"\">";
                            htmlStr+="   <img title=\"${sessionScope.sessionUser.name}\" src=\"image/user-thumbnail.png\" style=\"width: 30px; height:30px;\">";
                            htmlStr+="   <div style=\"position: relative; top: -40px; left: 40px;\" >";
                            htmlStr+="       <h5>"+data.returnData.noteContent+"</h5>";
                            htmlStr+="       <font color=\"gray\">线索</font> <font color=\"gray\">-</font> <b>${clue.fullname}${clue.appellation}-${clue.company}</b> <small style=\"color: gray;\"> "+data.returnData.createTime+" 由${sessionScope.sessionUser.name}创建</small>";
                            htmlStr+="       <div style=\"position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;\">";
                            htmlStr+="           <a class=\"myHref\" name=\"editA\" remarkId=\""+data.returnData.id+"\" href=\"javascript:void(0);\"><span class=\"glyphicon glyphicon-edit\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a>";
                            htmlStr+="           &nbsp;&nbsp;&nbsp;&nbsp;";
                            htmlStr+="           <a class=\"myHref\" name=\"deleteA\" remarkId=\""+data.returnData.id+"\" href=\"javascript:void(0);\"><span class=\"glyphicon glyphicon-remove\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a>";
                            htmlStr+="       </div>";
                            htmlStr+="   </div>";
                            htmlStr+="</div>";

                            $("#remarkDiv").before(htmlStr)

                        }else{
                            alert(data.message)
                        }
                    }
                })
            });

            $("#remarkDivList").on("click","a[name='editA']",function (){
                var id = $(this).attr("remarkId");
                var noteContent = $("#div_"+id+" h5").text();
                // alert(id+", "+noteContent)
                $("#edit-remarkId").val(id);
                $("#edit-noteContent").val(noteContent);
                $("#editRemarkModal").modal("show");
            });

            $("#updateRemarkBtn").click(function (){
                var id = $("#edit-remarkId").val();
                var noteContent = $("#edit-noteContent").val();
                if(noteContent==""){
                    alert("请输入备注！")
                    return;
                }
                $.ajax({
                    url:"workbench/clue/saveEditClueRemarkById.do",
                    data:{
                        id:id,
                        noteContent:noteContent
                    },
                    dataType:"json",
                    type:"post",
                    success:function (data){
                        if(data.code==1){
                            $("#editRemarkModal").modal("hide");
                            //页面局部刷新
                            $("#div_"+id+" h5").text(data.returnData.noteContent)
                            $("#div_"+id+" small").text(" "+data.returnData.editTime+" 由${sessionScope.sessionUser.name}修改")
                        }else{
                            alert(data.message)
                            $("#editRemarkModal").modal("show");
                        }
                    }
                })
            });

            $("#remarkDivList").on("click","a[name='deleteA']",function (){
                var id = $(this).attr("remarkId");
                $.ajax({
                    url:"workbench/clue/deleteClueRemarkById.do",
                    data:{
                        id:id
                    },
                    dataType:"json",
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

            $("#relationActivityBtn").click(function (){
                //初始化工作
                $("#searchActivityNameClueId").val("")
                $("#boundActivityTbody").html("");
                $("#checkedAllRelation").prop("checked",false);
                //模态窗口开启
                $("#bundModal").modal("show");
            });

            $("#searchActivityNameClueId").keyup(function (){
               //收集参数
               var activityName = $.trim($("#searchActivityNameClueId").val());
               var clueId = '${clue.id}';
               $.ajax({
                   url:"workbench/clue/queryActivityByActivityNameClueId.do",
                   data:{
                       activityName:activityName,
                       clueId:clueId
                   },
                   dataType:"json",
                   type:"post",
                   success:function (data){
                       var htmlStr = "";
                       $.each(data,function (index,obj){
                           htmlStr+="<tr>";
                           htmlStr+="    <td><input type=\"checkbox\" value='"+obj.id+"'/></td>";
                           htmlStr+="    <td>"+obj.name+"</td>";
                           htmlStr+="    <td>"+obj.startDate+"</td>";
                           htmlStr+="    <td>"+obj.endDate+"</td>";
                           htmlStr+="    <td>"+obj.owner+"</td>";
                           htmlStr+="</tr>";
                       });
                       $("#boundActivityTbody").html(htmlStr)
                   }
               });
            });

            //全选和全不选
            $("#checkedAllRelation").click(function (){
                $("#boundActivityTbody input[type='checkbox']").prop("checked",this.checked);
            });
            $("#boundActivityTbody").on("click","input[type='checkbox']",function(){
                if($("#boundActivityTbody input[type='checkbox']").size()==$("#boundActivityTbody input[type='checkbox']:checked").size()){
                    $("#checkedAllRelation").prop("checked",true);
                }else{
                    $("#checkedAllRelation").prop("checked",false);
                }
            })

            $("#relationActivityClueBtn").click(function (){
                var checkedIds = $("#boundActivityTbody input[type='checkbox']:checked");
                var clueId = '${clue.id}';
                if(checkedIds.size==0){
                    alert("请选择一个活动进行关联！")
                    return;
                }
                console.log(clueId)
                var ids = "";
                $.each(checkedIds,function (){
                    ids+="activityId="+this.value+"&";
                });
                ids += "clueId="+clueId;
                //发送ajax请求
                $.ajax({
                    url:"workbench/clue/saveCreateClueActivityRelationByList.do",
                    data:ids,
                    dataType:"json",
                    type:"post",
                    success:function(data){
                        if(data.code==1){
                            //模态窗口关闭
                            $("#bundModal").modal("hide");
                            var htmlStr="";
                            $.each(data.returnData,function (index,obj){
                            htmlStr+="<tr id='tr_"+obj.id+"'>";
                            htmlStr+="    <td>"+obj.name+"</td>";
                            htmlStr+="    <td>"+obj.startDate+"</td>";
                            htmlStr+="    <td>"+obj.endDate+"</td>";
                            htmlStr+="   <td>"+obj.owner+"</td>";
                            htmlStr+="    <td><a href=\"javascript:void(0);\" remarkId=\""+obj.id+"\" style=\"text-decoration: none;\"><span class=\"glyphicon glyphicon-remove\"></span>解除关联</a></td>";
                            htmlStr+="</tr>";
                            });
                            $("#activityTbody").append(htmlStr)
                        }else{
                            alert(data.message)
                            $("#bundModal").modal("show");
                        }
                    }
                })
            });

            $("#activityTbody").on("click","a",function(){
               if(window.confirm("请确认删除！")){
                   var clueId = '${clue.id}';
                   var activityId = $(this).attr("remarkId");
                   $.ajax({
                       url:"workbench/clue/deleteClueActivityRelationByClueIdActivityId.do",
                       data:{
                           activityId:activityId,
                           clueId:clueId
                       },
                       dataType:"json",
                       type:"post",
                       success:function (data){
                           if(data.code==1){
                               $("#tr_"+activityId).remove();
                           }else{
                               alert(data.message)
                           }
                       }
                   })
                }
            });

            $("#toConvertBtn").click(function (){
               window.location.href="workbench/clue/toConvert.do?clueId=${clue.id}";
            });







        });


    </script>

</head>
<body>
<!-- 修改市</div>场活动备注的模态窗口 -->
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

<!-- 关联市场活动的模态窗口 -->
<div class="modal fade" id="bundModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 80%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">关联市场活动</h4>
            </div>
            <div class="modal-body">
                <div class="btn-group" style="position: relative; top: 18%; left: 8px;">
                    <form class="form-inline" role="form">
                        <div class="form-group has-feedback">
                            <input type="text" id="searchActivityNameClueId" class="form-control" style="width: 300px;" placeholder="请输入市场活动名称，支持模糊查询">
                            <span class="glyphicon glyphicon-search form-control-feedback"></span>
                        </div>
                    </form>
                </div>
                <table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
                    <thead>
                    <tr style="color: #B3B3B3;">
                        <td><input type="checkbox" id="checkedAllRelation"/></td>
                        <td>名称</td>
                        <td>开始日期</td>
                        <td>结束日期</td>
                        <td>所有者</td>
                        <td></td>
                    </tr>
                    </thead>
                    <tbody id="boundActivityTbody">
<%--                    <tr>
                        <td><input type="checkbox"/></td>
                        <td>发传单</td>
                        <td>2020-10-10</td>
                        <td>2020-10-20</td>
                        <td>zhangsan</td>
                    </tr>
                    <tr>
                        <td><input type="checkbox"/></td>
                        <td>发传单</td>
                        <td>2020-10-10</td>
                        <td>2020-10-20</td>
                        <td>zhangsan</td>
                    </tr>--%>
                    </tbody>
                </table>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                <button type="button" class="btn btn-primary" id="relationActivityClueBtn">关联</button>
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
        <h3>${clue.fullname}${clue.appellation} <small>${clue.company}</small></h3>
    </div>
    <div style="position: relative; height: 50px; width: 500px;  top: -72px; left: 700px;">
        <button type="button" class="btn btn-default" id="toConvertBtn"><span class="glyphicon glyphicon-retweet"></span> 转换</button>

    </div>
</div>

<br/>
<br/>
<br/>

<!-- 详细信息 -->
<div style="position: relative; top: -70px;">
    <div style="position: relative; left: 40px; height: 30px;">
        <div style="width: 300px; color: gray;">名称</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.fullname}${clue.appellation}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">所有者</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.owner}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 10px;">
        <div style="width: 300px; color: gray;">公司</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.company}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">职位</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.job}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 20px;">
        <div style="width: 300px; color: gray;">邮箱</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.email}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">公司座机</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.phone}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 30px;">
        <div style="width: 300px; color: gray;">公司网站</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.website}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">手机</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.mphone}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 40px;">
        <div style="width: 300px; color: gray;">线索状态</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.state}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">线索来源</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.source}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 50px;">
        <div style="width: 300px; color: gray;">创建者</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${clue.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${clue.createTime}</small></div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 60px;">
        <div style="width: 300px; color: gray;">修改者</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${clue.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${clue.editTime}</small></div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 70px;">
        <div style="width: 300px; color: gray;">描述</div>
        <div style="width: 630px;position: relative; left: 200px; top: -20px;">
            <b>
                ${clue.description}
            </b>
        </div>
        <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 80px;">
        <div style="width: 300px; color: gray;">联系纪要</div>
        <div style="width: 630px;position: relative; left: 200px; top: -20px;">
            <b>
                ${clue.contactSummary}
            </b>
        </div>
        <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 90px;">
        <div style="width: 300px; color: gray;">下次联系时间</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.nextContactTime}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px; "></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 100px;">
        <div style="width: 300px; color: gray;">详细地址</div>
        <div style="width: 630px;position: relative; left: 200px; top: -20px;">
            <b>
                ${clue.address}
            </b>
        </div>
        <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
</div>

<!-- 备注 -->
<div style="position: relative; top: 40px; left: 40px;" id="remarkDivList">
    <div class="page-header">
        <h4>备注</h4>
    </div>

    <!-- 备注1 -->
    <c:forEach items="${clueRemarkList}" var="clueRemark">
        <div class="remarkDiv" style="height: 60px;" id="div_${clueRemark.id}">
            <img title="${clueRemark.createBy}" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
            <div style="position: relative; top: -40px; left: 40px;" >
                <h5>${clueRemark.noteContent}</h5>
                <font color="gray">线索</font> <font color="gray">-</font> <b>${clue.fullname}${clue.appellation}-${clue.company}</b> <small style="color: gray;"> ${clueRemark.editFlag=='0' ? clueRemark.createTime:clueRemark.editTime} 由${clueRemark.editFlag=='0' ? clueRemark.createBy:clueRemark.editBy}${clueRemark.editFlag=='0' ? "创建":"修改"}</small>
                <div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
                    <a class="myHref" name="editA" remarkId="${clueRemark.id}" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
                    &nbsp;&nbsp;&nbsp;&nbsp;
                    <a class="myHref" name="deleteA" remarkId="${clueRemark.id}" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
                </div>
            </div>
        </div>
    </c:forEach>

<%--
    <!-- 备注2 -->
    <div class="remarkDiv" style="height: 60px;">
        <img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
        <div style="position: relative; top: -40px; left: 40px;" >
            <h5>呵呵！</h5>
            <font color="gray">线索</font> <font color="gray">-</font> <b>李四先生-动力节点</b> <small style="color: gray;"> 2017-01-22 10:20:10 由zhangsan</small>
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
                <button type="button" class="btn btn-primary" id="saveCreateClueRemarkBtn">保存</button>
            </p>
        </form>
    </div>
</div>

<!-- 市场活动 -->
<div>
    <div style="position: relative; top: 60px; left: 40px;">
        <div class="page-header">
            <h4>市场活动</h4>
        </div>
        <div style="position: relative;top: 0px;">
            <table class="table table-hover" style="width: 900px;">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td>名称</td>
                    <td>开始日期</td>
                    <td>结束日期</td>
                    <td>所有者</td>
                    <td></td>
                </tr>
                </thead>
                <tbody id="activityTbody">
                <c:forEach items="${activityList}" var="activity">
                    <tr id="tr_${activity.id}">
                        <td>${activity.name}</td>
                        <td>${activity.startDate}</td>
                        <td>${activity.endDate}</td>
                        <td>${activity.owner}</td>
                        <td><a href="javascript:void(0);" remarkId="${activity.id}" style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>

        <div>
            <a href="javascript:void(0);" id="relationActivityBtn" data-target="#bundModal" style="text-decoration: none;"><span class="glyphicon glyphicon-plus"></span>关联市场活动</a>
        </div>
    </div>
</div>


<div style="height: 200px;"></div>
</body>
</html>