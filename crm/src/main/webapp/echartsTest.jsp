<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%
        String baseHref = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";
    %>
    <base href="<%=baseHref%>">
    <title>Title</title>
    <%--    引入jquery--%>
    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <%--    引入echarts--%>
    <script type="text/javascript" src="jquery/echarts/echarts.min.js"></script>
    <script type="text/javascript">
        $(function (){

            // 基于准备好的dom，初始化echarts实例
            var myChart = echarts.init(document.getElementById('main'));
            // 绘制图表
            myChart.setOption({
                title: { //标题
                    text: 'ECharts 入门示例'
                },
                tooltip: { //提示框
                    textStyle:{
                        color:"yellow",
                        fontStyle:"italic"
                    }
                },
                xAxis: {
                    data: ['衬衫', '羊毛衫', '雪纺衫', '裤子', '高跟鞋', '袜子']
                },
                yAxis: {},
                series: [
                    {
                        name: '销量',
                        type: 'bar',
                        data: [5, 20, 36, 10, 10, 20]
                    }
                ]
            });
            // 使用刚指定的配置项和数据显示图表。
            myChart.setOption(option);

        })
    </script>
</head>
<body>
<div id="main" style="width: 600px;height:400px;"></div>

</body>
</html>
