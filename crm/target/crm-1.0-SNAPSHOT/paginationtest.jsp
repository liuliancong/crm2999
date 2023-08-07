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
    <link rel="stylesheet" type="text/css" href="jquery/bootstrap_3.3.0/css/bootstrap.min.css">
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <%-- PAGENATION插件 --%>
    <link rel="stylesheet" type="text/css" href="jquery/bs_pagination-master/css/jquery.bs_pagination.min.css">
    <script type="text/javascript" src="jquery/bs_pagination-master/js/jquery.bs_pagination.min.js"></script>
    <script type="text/javascript" src="jquery/bs_pagination-master/localization/en.js"></script>

    <script type="text/javascript">
        $(function() {

            $("#demo_pag1").bs_pagination({
                currentPage:2, //当前页数，相当于pageNo

                rowsPerPage:20, //每页显示条数，相当于pageSize
                totalRows:1000, //总条数
                totalPages: 50, //总页数，必填参数

                visiblePageLinks: 10, //最多可显示选择的页数

                showGoToPage: true, //控制是否显示“跳转到”部分，默认true --显示
                showRowsPerPage: true, //是否显示“每页显示条数部分。”默认true--显示
                showRowsInfo: true, //是否显示记录的信息，默认true--显示

                //用户每次切换页号，都会自动触发本函数
                onChangePage:function (event,pageObj){// returns page_num and rows_per_page after a link has clicked
                    //js代码
                    alert(pageObj.currentPage)
                    alert(pageObj.rowsPerPage)
                }

            });

        });
    </script>
   <title>演示页面</title>

</head>
<body>
<div id="demo_pag1"></div>
</body>
</html>
