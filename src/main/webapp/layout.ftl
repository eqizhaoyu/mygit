<#import "${body_file_path}" as content>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <meta name="keywords" content="刘文银(LWY)个人博客,文章,作品,心情" />
    <meta name="description" content="刘文银(LWY)个人博客,技术分享,记录生活点滴" />
    <link href="${base}/css/base.css" rel="stylesheet">
    <link href="${base}/css/index.css" rel="stylesheet">
    <script type="text/javascript" src="${base}/js/jquery.min.js"></script>
    <script type="text/javascript" src="${base}/js/sliders.js"></script>
    <!--[if lt IE 9]>
    <script src="${base}/js/modernizr.js"></script>
    <![endif]-->
    <#if content.head??>
        <@content.head ></@content.head>
    </#if>
    <!--加入百度统计代码 -->
    <script>
        var _hmt = _hmt || [];
        (function() {
            var hm = document.createElement("script");
            hm.src = "https://hm.baidu.com/hm.js?70aa03e328e38bb27dc9bcbba1da27b6";
            var s = document.getElementsByTagName("script")[0];
            s.parentNode.insertBefore(hm, s);
        })();
    </script>
</head>

<header>
    <div class="logo f_l"> <a href="/"><img src="images/logo.png"></a> </div>
    <nav id="topnav" class="f_r">
        <ul>
            <a href="index" >首页</a> <a href="getAboutMe" >关于我</a> <a href="getMyArticle?labelId=0&pageNumber=1&pageSize=10" >文章</a> <a href="getMyMood" >心情</a> <a href="getMyProduction" >作品</a> <a href="getMessageBoard">留言</a><a href="userLogin" target="_blank">登录</a>
        </ul>
        <script src="js/nav.js"></script>
    </nav>
</header>

    <!--这里加入中间的内容-->
<body style="font-size: 14px;font-family: Microsoft YaHei">
    <div id="divMain">
        <#if content.body??>
        <@content.body></@content.body>
    </div>
</#if>
</body>

<footer>
    <p class="ft-copyright">LWY博客 Design by LWY 蜀ICP备16036750号</p>
    <div id="tbox"> <a id="togbook" href="getMessageBoard"></a> <a id="gotop" href="#"></a> </div>
</footer>
</div>
</body>
</html>