<%--
  Created by IntelliJ IDEA.
  User: callray_liu
  Date: 2023-03-24
  Time: 9:26
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%
        String baseHref = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";
    %>
    <base href="<%=baseHref%>">
    <title>演示文件上传</title>

</head>
<%--
   文件上传的表单三个条件
      1.表单组件标签只能用：<input type="file">
              <input type="text|password|radio|checkbox|hidden|button|submit|reset|file">
                         <select>,<texztarea>等
      2.请求方式只能用post
           get：请求参数通过请求头提交到后台，参数放在url后边，只能想后台提交文本数据，对参数长度有限制：数据不安全
           post：请求参数请求体提交到后台，既能提交文本数据，又能提交二进制数据：理论上对数据没有限制
      3.表单的编码格式只能用：multipart/form-data
          根据HTTP协议的规定，浏览器每次向后台提交参数，都会对参数进行统一编码，默认采用的编码格式是urlencoded,
          这种编码格式只能对文本数据进行编码，浏览器每次向后台提交参数，都会首先把所有的参数转换成字符串，
          然后对这些数据进行urlencoded编码；文件上传的编码格式只能用multipart/form-data
--%>
<body>
     <form action="workbench/activity/fileUpload.do" method="post" enctype="multipart/form-data">
         <input type="file" name="myFile"><br>
         <input type="text" name="userName">
         <input type="submit" value="提交"><br>
     </form>

</body>
</html>
