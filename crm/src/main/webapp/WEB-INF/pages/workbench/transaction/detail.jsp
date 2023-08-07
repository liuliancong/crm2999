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

    <style type="text/css">
        .mystage{
            font-size: 20px;
            vertical-align: middle;
            cursor: pointer;
        }
        .closingDate{
            font-size : 15px;
            cursor: pointer;
            vertical-align: middle;
        }
    </style>

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
            $("#tranRemarkFatherDiv").on("mouseover",".remarkDiv",function (){
                $(this).children("div").children("div").show();
            })

/*

            $(".remarkDiv").mouseout(function(){
                $(this).children("div").children("div").hide();
            });
*/
            $("#tranRemarkFatherDiv").on("mouseout",".remarkDiv",function (){
                $(this).children("div").children("div").hide();
            })
/*

            $(".myHref").mouseover(function(){
                $(this).children("span").css("color","red");
            });
*/
            $("#tranRemarkFatherDiv").on("mouseover",".myHref",function (){
                $(this).children("span").css("color","red");
            })
/*

            $(".myHref").mouseout(function(){
                $(this).children("span").css("color","#E6E6E6");
            });
*/
            $("#tranRemarkFatherDiv").on("mouseout",".myHref",function (){
                $(this).children("span").css("color","#E6E6E6");
            })


            //阶段提示框
            $(".mystage").popover({
                trigger:'manual',
                placement : 'bottom',
                html: 'true',
                animation: false
            }).on("mouseenter", function () {
                var _this = this;
                $(this).popover("show");
                $(this).siblings(".popover").on("mouseleave", function () {
                    $(_this).popover('hide');
                });
            }).on("mouseleave", function () {
                var _this = this;
                setTimeout(function () {
                    if (!$(".popover:hover").length) {
                        $(_this).popover("hide")
                    }
                }, 100);
            });

            $("#saveTranRemarkBtn").click(function (){
                var noteContent = $.trim($("#remark").val());
                var tranId = '${tran.id}'
                if(noteContent==""){
                    alert("内容不能为空！");
                    return;
                }
                // console.log(noteContent+" , "+tranId)
                $.ajax({
                    url:"workbench/transaction/saveCreateTranRemark.do",
                    data:{
                        noteContent:noteContent,
                        tranId:tranId
                    },
                    dataType:"json",
                    type:"post",
                    success:function (data){
                        if(data.code==1){
                            var htmlStr = "";
                            htmlStr+="<div class=\"remarkDiv\" style=\"height: 60px;\" id=\"div_"+data.returnData.id+"\">";
                            htmlStr+="    <img title=\"${sessionScope.sessionUser.name}\" src=\"image/user-thumbnail.png\" style=\"width: 30px; height:30px;\">";
                            htmlStr+="    <div style=\"position: relative; top: -40px; left: 40px;\" >";
                            htmlStr+="        <h5>"+noteContent+"</h5>";
                            htmlStr+="        <font color=\"gray\">交易</font> <font color=\"gray\">-</font> <b>${tran.name}</b> <small style=\"color: gray;\"> "+data.returnData.createTime+" 由${sessionScope.sessionUser.name}创建</small>";
                            htmlStr+="        <div style=\"position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;\">";
                            htmlStr+="            <a class=\"myHref\" name=\"editA\" remarkId=\""+data.returnData.id+"\" href=\"javascript:void(0);\"><span class=\"glyphicon glyphicon-edit\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a>";
                            htmlStr+="            &nbsp;&nbsp;&nbsp;&nbsp;";
                            htmlStr+="            <a class=\"myHref\" name=\"deleteA\" remarkId=\""+data.returnData.id+"\" href=\"javascript:void(0);\"><span class=\"glyphicon glyphicon-remove\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a>";
                            htmlStr+="        </div>";
                            htmlStr+="    </div>";
                            htmlStr+="</div>";
                            $("#remarkDiv").before(htmlStr)
                            $("#remark").val("")
                        }else{
                            alert(data.code)
                        }
                    }
                })
            });

            $("#tranRemarkFatherDiv").on("click","a[name='editA']",function (){
                //取值
                var id = $(this).attr("remarkId");
                var noteContent = $("#div_"+id+" h5").text();
                //赋值
                // console.log(id+" , "+noteContent);
                $("#editRemarkModal").modal("show");
                $("#edit-remarkId").val(id);
                $("#edit-noteContent").val(noteContent);
            });

            $("#updateRemarkBtn").click(function (){
                //取值
                var id = $("#edit-remarkId").val();
                var noteContent = $.trim($("#edit-noteContent").val());
                if(noteContent==""){
                    alert("内容不能为空！");
                    return;
                }
                //发送请求
                $.ajax({
                    url:"workbench/transaction/saveEditTranRemark.do",
                    data:{
                        id:id,
                        noteContent:noteContent
                    },
                    dataType:"json",
                    type:"post",
                    success:function (data){
                        if(data.code==1){
                            $("#div_"+id+" h5").text(noteContent);
                            $("#div_"+id+" small").text(data.returnData.editTime+" 由${sessionScope.sessionUser.name}修改");
                            //关闭模态窗口
                            $("#editRemarkModal").modal("hide");
                            //初始化
                            $("#edit-remarkId").val("");
                            $("#edit-noteContent").val("");
                        }else{
                            alert(data.message);
                            $("#editRemarkModal").modal("show");
                        }
                    }
                })
            });

            $("#tranRemarkFatherDiv").on("click","a[name='deleteA']",function (){
                if(window.confirm("请确认删除！")){
                    var tranRemarkId = $(this).attr("remarkId");
                    $.ajax({
                        url:"workbench/transaction/deleteTranRemarkByTranRemarkId.do",
                        data:{
                            tranRemarkId:tranRemarkId
                        },
                        dataType:"json",
                        type:"post",
                        success:function (data){
                            if(data.code==1){
                                $("#div_"+tranRemarkId).remove();
                            }else{
                                alert(data.message)
                            }
                        }
                    })
                }
            });






        });



    </script>

</head>
<body>

<%--备注模态窗口--%>
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
        <h3>${tran.name} <small>￥${tran.money}</small></h3>
    </div>

</div>

<br/>
<br/>
<br/>

<!-- 阶段状态 -->
<div style="position: relative; left: 40px; top: -50px;">
    阶段&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    <c:forEach items="${stageList}" var="stage">
        <c:if test="${tran.stage == stage.value}">
            <span class="glyphicon glyphicon-map-marker mystage" data-toggle="popover" data-placement="bottom" data-content="${stage.value}" style="color: #90F790;"></span>
            -----------
        </c:if>
        <c:if test="${tran.orderNo > stage.orderNo}">
            <span class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom" data-content="${stage.value}" style="color: #90F790;"></span>
            -----------
        </c:if>
        <c:if test="${tran.orderNo < stage.orderNo}">
            <span class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom" data-content="${stage.value}"></span>
            -----------
        </c:if>
    </c:forEach>
<%--    <span class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom" data-content="资质审查" style="color: #90F790;"></span>
    -----------
    <span class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom" data-content="需求分析" style="color: #90F790;"></span>
    -----------
    <span class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom" data-content="价值建议" style="color: #90F790;"></span>
    -----------
    <span class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom" data-content="确定决策者" style="color: #90F790;"></span>
    -----------
    <span class="glyphicon glyphicon-map-marker mystage" data-toggle="popover" data-placement="bottom" data-content="提案/报价" style="color: #90F790;"></span>
    -----------
    <span class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom" data-content="谈判/复审"></span>
    -----------
    <span class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom" data-content="成交"></span>
    -----------
    <span class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom" data-content="丢失的线索"></span>
    -----------
    <span class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom" data-content="因竞争丢失关闭"></span>
    -------------%>
    <span class="closingDate">${tran.expectedDate}</span>
</div>

<!-- 详细信息 -->
<div style="position: relative; top: 0px;">
    <div style="position: relative; left: 40px; height: 30px;">
        <div style="width: 300px; color: gray;">所有者</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${tran.owner}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">金额</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${tran.money}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 10px;">
        <div style="width: 300px; color: gray;">名称</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${tran.name}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">预计成交日期</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${tran.expectedDate}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 20px;">
        <div style="width: 300px; color: gray;">客户名称</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${tran.customerId}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">阶段</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${tran.stage}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 30px;">
        <div style="width: 300px; color: gray;">类型</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${tran.type}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">可能性</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${tran.possibility}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 40px;">
        <div style="width: 300px; color: gray;">来源</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${tran.source}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">市场活动源</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${tran.activityId}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 50px;">
        <div style="width: 300px; color: gray;">联系人名称</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${tran.contactsId}</b></div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 60px;">
        <div style="width: 300px; color: gray;">创建者</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${tran.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${tran.createTime}</small></div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 70px;">
        <div style="width: 300px; color: gray;">修改者</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${tran.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${tran.editTime}</small></div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 80px;">
        <div style="width: 300px; color: gray;">描述</div>
        <div style="width: 630px;position: relative; left: 200px; top: -20px;">
            <b>
                ${tran.description}
            </b>
        </div>
        <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 90px;">
        <div style="width: 300px; color: gray;">联系纪要</div>
        <div style="width: 630px;position: relative; left: 200px; top: -20px;">
            <b>
                ${tran.contactSummary}
            </b>
        </div>
        <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 100px;">
        <div style="width: 300px; color: gray;">下次联系时间</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${tran.nextContactTime}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
</div>

<!-- 备注 -->
<div style="position: relative; top: 100px; left: 40px;" id="tranRemarkFatherDiv">
    <div class="page-header">
        <h4>备注</h4>
    </div>

    <c:forEach items="${tranRemarkList}" var="tranRemark">
        <div class="remarkDiv" style="height: 60px;" id="div_${tranRemark.id}">
            <img title="${tranRemark.createBy}" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
            <div style="position: relative; top: -40px; left: 40px;" >
                <h5>${tranRemark.noteContent}</h5>
                <font color="gray">交易</font> <font color="gray">-</font> <b>${tran.name}</b> <small style="color: gray;"> ${tranRemark.editFlag == 0 ? tranRemark.createTime:tranRemark.editTime} 由${tranRemark.editFlag == 0 ? tranRemark.createBy:tranRemark.editBy}${tranRemark.editFlag == 0 ? "创建":"修改"}</small>
                <div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
                    <a class="myHref" name="editA" remarkId="${tranRemark.id}" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
                    &nbsp;&nbsp;&nbsp;&nbsp;
                    <a class="myHref" name="deleteA" remarkId="${tranRemark.id}" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
                </div>
            </div>
        </div>
    </c:forEach>


    <div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
        <form role="form" style="position: relative;top: 10px; left: 10px;">
            <textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"  placeholder="添加备注..."></textarea>
            <p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
                <button id="cancelBtn" type="button" class="btn btn-default">取消</button>
                <button type="button" class="btn btn-primary" id="saveTranRemarkBtn">保存</button>
            </p>
        </form>
    </div>
</div>

<!-- 阶段历史 -->
<div>
    <div style="position: relative; top: 100px; left: 40px;">
        <div class="page-header">
            <h4>阶段历史</h4>
        </div>
        <div style="position: relative;top: 0px;">
            <table id="activityTable" class="table table-hover" style="width: 900px;">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td>阶段</td>
                    <td>金额</td>
                    <td>预计成交日期</td>
                    <td>创建人</td>
                    <td>创建时间</td>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${tranHistoryList}" var="tranHistory">
                    <tr>
                        <td>${tranHistory.stage}</td>
                        <td>${tranHistory.money}</td>
                        <td>${tranHistory.expectedDate}</td>
                        <td>${tranHistory.createBy}</td>
                        <td>${tranHistory.createTime}</td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>

    </div>
</div>

<div style="height: 200px;"></div>

</body>
</html>
