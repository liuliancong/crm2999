<%--
  Created by IntelliJ IDEA.
  User: callray_liu
  Date: 2023-03-23
  Time: 9:24
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%
        String baseHref = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";
    %>
    <base href="<%=baseHref%>">
    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <title>演示下载文件</title>
    <script type="text/javascript">
        $(function (){
            $("#fileDownBtn").click(function (){
                window.location.href="workbench/filedownloadexcel.do";
            });
        })
    </script>
</head>
<body>
<input type="button" id="fileDownBtn" value="下载">
</body>
</html>
