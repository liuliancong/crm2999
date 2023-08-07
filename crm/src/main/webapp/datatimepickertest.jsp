<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <%
        String baseHref = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+"/"+request.getContextPath()+"/";
    %>
    <base href="<%=baseHref%>">
    <meta charset="UTF-8">
    <%--引入jquery框架    --%>
    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <%--BOOTSTRAP框架    --%>
    <link rel="stylesheet" href="jquery/bootstrap_3.3.0/css/bootstrap.min.css">
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <%-- BOOTSTRAP_DATETIMEPICKER插件 --%>
    <link rel="stylesheet" href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css">
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
    <title>演示</title>
    <script type="text/javascript">
        $(function (){
            //当容器加载完毕，对容器调用工具函数
            $("#myDate").datetimepicker({
                language:'zh-CN',  //语言
                format:'yyyy-mm-dd hh:ii:ss', //日期的格式
                minView:'hour',    //可以选择的最小视图 month day year hour week
                initialDate:new Date(), //初始化显示的日期
                autoclose:true, //设置选择完日期或者时间后，是否自动关闭日历

            })
        })
    </script>
</head>
<body>
<input type="text" id="myDate">

</body>
</html>
