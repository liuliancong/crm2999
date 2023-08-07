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
            $.ajax({
                url:"workbench/chart/transaction/queryTranStageVoGroupByStage.do",
                dataType:"json",
                type:"post",
                success:function (data){
                    // 基于准备好的dom，初始化echarts实例
                    var myChart = echarts.init(document.getElementById('main'));
                    // 绘制图表
                    var option = {
                        title: {
                            text: '交易统计图表',
                            subtext: '交易表中各个交易阶段的数量'
                        },
                        tooltip: {
                            trigger: 'item',
                            formatter: "{a} <br/>{b} : {c}"
                        },
                        toolbox: {
                            feature: {
                                dataView: {readOnly: false},
                                restore: {},
                                saveAsImage: {}
                            }
                        },
                        series: [
                            {
                                name: '数据量',
                                type: 'funnel',
                                left: '10%',
                                width: '80%',
                                label: {
                                    formatter: '{b}'
                                },
                                labelLine: {
                                    show: true
                                },
                                itemStyle: {
                                    opacity: 0.7
                                },
                                emphasis: {
                                    label: {
                                        position: 'inside',
                                        formatter: '{b}: {c}'
                                    }
                                },
                                data: data
                            },

                        ]
                    };
                    // 使用刚指定的配置项和数据显示图表。
                    myChart.setOption(option);
                }
            })

        })
    </script>
</head>
<body>
<div id="main" style="width: 600px;height:400px;"></div>

</body>
</html>
