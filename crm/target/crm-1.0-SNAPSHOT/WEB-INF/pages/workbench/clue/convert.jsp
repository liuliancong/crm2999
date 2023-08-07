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


    <link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

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

            $("#isCreateTransaction").click(function(){
                if(this.checked){
                    $("#create-transaction2").show(200);
                }else{
                    $("#create-transaction2").hide(200);
                }
            });

            $("#searchActivityModalA").click(function (){
                //初始化
                //将搜索框的值置为空
                $("#searchActivityInput").val("");
                //将搜索的信息置为空
                $("#activityTbody").html("");
                $("#searchActivityModal").modal("show");
            });

            $("#searchActivityInput").keyup(function (){
                //收集参数
                var activityName = $("#searchActivityInput").val();
                var clueId = '${clue.id}';
                //发送请求
                $.ajax({
                    url:"workbench/clue/queryActivityByActivityName.do",
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
                            htmlStr+="    <td><input type=\"radio\" name=\"activity\" value=\""+obj.id+"\" activityName=\""+obj.name+"\"/></td>";
                            htmlStr+="    <td>"+obj.name+"</td>";
                            htmlStr+="    <td>"+obj.startDate+"</td>";
                            htmlStr+="    <td>"+obj.endDate+"</td>";
                            htmlStr+="    <td>"+obj.owner+"</td>";
                            htmlStr+="</tr>";
                        });
                        $("#activityTbody").html(htmlStr);
                    }
                });
            });

            $("#activityTbody").on("click","input[type='radio']",function (){
                //收集参数
                //获取activityName
                var activityName = $(this).attr("activityName");
                //获取activityId
                var activityId = this.value;
                // console.log(activityName+" , "+activityId)
                //赋值
                $("#activityId").val(activityId);
                $("#activity").val(activityName);
                //关闭模态窗口
                $("#searchActivityModal").modal("hide");
            });

            $("#convertClueBtn").click(function (){
                //String clueId,String money,String name,String expectedDate,String stage,String activityId,String isCreateTran
                var clueId = '${clue.id}';
                var money = $.trim($("#amountOfMoney").val());
                var name = $.trim($("#tradeName").val());
                var expectedDate = $("#expectedClosingDate").val();
                var stage = $("#stage").val();
                var activityId = $("#activityId").val();
                var isCreateTran = $("#isCreateTransaction").prop("checked");
                //判断条件是否符合
                if(isCreateTran){
                    var regExt = /^[1-9]\d*$/;
                    if(!regExt.test(money)){
                        alert("成本只能为非负正整数！")
                        return;
                    }
                }
                //发送请求
                $.ajax({
                    url:"workbench/clue/saveConvertClue.do",
                    data:{
                        clueId:clueId,
                        money:money,
                        name:name,
                        expectedDate:expectedDate,
                        stage:stage,
                        activityId:activityId,
                        isCreateTran:isCreateTran
                    },
                    dataType:"json",
                    type:"post",
                    success:function (data){
                        if(data.code==1){
                            window.location.href = "workbench/clue/index.do";
                        }else{
                            alert(data.message)
                        }
                    }
                })

            });





        });
    </script>

</head>
<body>

<!-- 搜索市场活动的模态窗口 -->
<div class="modal fade" id="searchActivityModal" role="dialog" >
    <div class="modal-dialog" role="document" style="width: 90%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">搜索市场活动</h4>
            </div>
            <div class="modal-body">
                <div class="btn-group" style="position: relative; top: 18%; left: 8px;">
                    <form class="form-inline" role="form">
                        <div class="form-group has-feedback">
                            <input type="text" id="searchActivityInput" class="form-control" style="width: 300px;" placeholder="请输入市场活动名称，支持模糊查询">
                            <span class="glyphicon glyphicon-search form-control-feedback"></span>
                        </div>
                    </form>
                </div>
                <table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
                    <thead>
                    <tr style="color: #B3B3B3;">
                        <td></td>
                        <td>名称</td>
                        <td>开始日期</td>
                        <td>结束日期</td>
                        <td>所有者</td>
                        <td></td>
                    </tr>
                    </thead>
                    <tbody id="activityTbody">
<%--                    <tr>
                        <td><input type="radio" name="activity"/></td>
                        <td>发传单</td>
                        <td>2020-10-10</td>
                        <td>2020-10-20</td>
                        <td>zhangsan</td>
                    </tr>
                    <tr>
                        <td><input type="radio" name="activity"/></td>
                        <td>发传单</td>
                        <td>2020-10-10</td>
                        <td>2020-10-20</td>
                        <td>zhangsan</td>
                    </tr>--%>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<div id="title" class="page-header" style="position: relative; left: 20px;">
    <h4>转换线索 <small>${clue.fullname}${clue.appellation}-${clue.company}</small></h4>
</div>
<div id="create-customer" style="position: relative; left: 40px; height: 35px;">
    新建客户：${clue.company}
</div>
<div id="create-contact" style="position: relative; left: 40px; height: 35px;">
    新建联系人：${clue.fullname}${clue.appellation}
</div>
<div id="create-transaction1" style="position: relative; left: 40px; height: 35px; top: 25px;">
    <input type="checkbox" id="isCreateTransaction"/>
    为客户创建交易
</div>
<div id="create-transaction2" style="position: relative; left: 40px; top: 20px; width: 80%; background-color: #F7F7F7; display: none;" >

    <form>
        <div class="form-group" style="width: 400px; position: relative; left: 20px;">
            <label for="amountOfMoney">金额</label>
            <input type="text" class="form-control" id="amountOfMoney">
        </div>
        <div class="form-group" style="width: 400px;position: relative; left: 20px;">
            <label for="tradeName">交易名称</label>
            <input type="text" class="form-control" id="tradeName" value="${clue.company}-">
        </div>
        <div class="form-group" style="width: 400px;position: relative; left: 20px;">
            <label for="expectedClosingDate">预计成交日期</label>
            <input type="text" class="form-control mydate" readonly id="expectedClosingDate">
        </div>
        <div class="form-group" style="width: 400px;position: relative; left: 20px;">
            <label for="stage">阶段</label>
            <select id="stage"  class="form-control">
                <option></option>
                <c:forEach items="${dicValueList}" var="dicValue">
                    <option value="${dicValue.id}">${dicValue.value}</option>
                </c:forEach>
            </select>
        </div>
        <div class="form-group" style="width: 400px;position: relative; left: 20px;">
            <input type="hidden" id="activityId">
            <label for="activity">市场活动源&nbsp;&nbsp;<a href="javascript:void(0);"  id="searchActivityModalA" style="text-decoration: none;"><span class="glyphicon glyphicon-search"></span></a></label>
            <input type="text" class="form-control" id="activity" placeholder="点击上面搜索" readonly>
        </div>
    </form>

</div>

<div id="owner" style="position: relative; left: 40px; height: 35px; top: 50px;">
    记录的所有者：<br>
    <b>${clue.owner}</b>
</div>
<div id="operation" style="position: relative; left: 40px; height: 35px; top: 100px;">
    <input class="btn btn-primary" id="convertClueBtn" type="button" value="转换">
    &nbsp;&nbsp;&nbsp;&nbsp;
    <input class="btn btn-default" type="button" value="取消">
</div>
</body>
</html>
