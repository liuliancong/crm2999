<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
  Created by IntelliJ IDEA.
  User: callray_liu
  Date: 2023-02-08
  Time: 20:02
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
        $(function (){
            $(window).keydown(function (e){
                if(e.keyCode==13){
                    $("#loginBtn").click();
                }
            })


            //绑定单击事件
            $("#loginBtn").click(function (){
                var loginAct = $("#loginAct").val();
                var loginPwd = $("#loginPwd").val();
                var isRemPwd = $("#isRemPwd").prop("checked")

                if(loginAct==""){
                   alert("用户名不能为空")
                    return;
                }
                if(loginPwd==""){
                    alert("密码不能为空")
                    return;
                }

                $.ajax({
                    url:"settings/qx/user/login.do",
                    data:{
                        loginAct:loginAct,
                        loginPwd:loginPwd,
                        isRemPwd:isRemPwd
                    },
                    method:"POST",
                    dataType:"json",
                    success:function (returnObject) {
                        if(returnObject.code==2){
                            $("#msg").html(returnObject.message);
                        }
                        if(returnObject.code==1){
                            //打开此链接，通过servlet访问/workbench/index.jsp页面
                            window.location.href="workbench/index.do";
                        }
                    },
                    beforeSend:function (){
                        $("#msg").text("正在安全登录中...")
                        return true;
                    }
                })
            })

        })
    </script>
</head>
<body>
<div style="position: absolute; top: 0px; left: 0px; width: 60%;">
    <img src="image/IMG_7114.JPG" style="width: 100%; height: 90%; position: relative; top: 50px;">
</div>
<div id="top" style="height: 50px; background-color: #3C3C3C; width: 100%;">
    <div style="position: absolute; top: 5px; left: 0px; font-size: 30px; font-weight: 400; color: white; font-family: 'times new roman'">CRM &nbsp;<span style="font-size: 12px;">&copy;2023&nbsp;深圳市友邻通讯设备有限公司</span></div>
</div>

<div style="position: absolute; top: 120px; right: 100px;width:450px;height:400px;border:1px solid #D5D5D5">
    <div style="position: absolute; top: 0px; right: 60px;">
        <div class="page-header">
            <h1>登录</h1>
        </div>
        <form action="workbench/index.html" class="form-horizontal" role="form">
            <div class="form-group form-group-lg">
                <div style="width: 350px;">
                    <input class="form-control" type="text" id="loginAct" value="${cookie.loginAct.value}" placeholder="用户名">
                </div>
                <div style="width: 350px; position: relative;top: 20px;">
                    <input class="form-control" type="password" id="loginPwd" value="${cookie.loginPwd.value}" placeholder="密码">
                </div>
                <div class="checkbox"  style="position: relative;top: 30px; left: 10px;">
                    <label>
                        <c:if test="${not empty cookie.loginAct and not empty cookie.loginPwd}">
                            <input type="checkbox" id="isRemPwd" checked>
                        </c:if>
                        <c:if test="${empty cookie.loginAct or empty cookie.loginPwd}">
                            <input type="checkbox" id="isRemPwd">
                        </c:if>
                         十天内免登录
                    </label>
                    &nbsp;&nbsp;
                    <span id="msg" style="..."></span>
                </div>
                <button type="button" id="loginBtn" class="btn btn-primary btn-lg btn-block"  style="width: 350px; position: relative;top: 45px;">登录</button>
            </div>
        </form>
    </div>
</div>
</body>
</html>