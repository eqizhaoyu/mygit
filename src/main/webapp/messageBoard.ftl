<#macro head>
<title>留言板-刘文银(LWY)个人博客</title>
<link href="css/article.css" rel="stylesheet">
</#macro>
<#macro body>
<article>
    <!--PC和WAP自适应版-->
    <!--配置留言板的唯一ID-->

    <h2 class="title_tj">
        <p>留言<span>列表</span></p>
    </h2>
    <div class="bloglist left" style="min-height: 485px;">
        <div id="SOHUCS" sid="cn.lwy.website.messageBoard" style="width: 95%;"></div>
    </div>
    <aside class="right">
        <div class="news">
            <h3>
                <p style="font-size: 18px;width:80px;"><b>主人<span>寄语</span></b></p>
            </h3>
        </div>
        <div style="margin-top: 10px;font-size: 16px;line-height: 160%">
            &nbsp;&nbsp;站内的评论及留言我都是使用的第三方评论平台：畅言，所以第三方登录是安全的。既然来了就留个脚印吧。
        </div>
        <div style="width: 250px;border-radius: 50px;overflow: hidden;margin: 10px 0px 40px">
            <img src="images/foot.jpg">
        </div>
</article>
<!--end: thinking-->
<script type="text/javascript">

    (function(){
        var appid = 'cyt2cWe8d';
        var conf = 'prod_cee8547cb97f5bdf147c2219d2be19cd';
        var width = window.innerWidth || document.documentElement.clientWidth;
        //当屏幕尺寸小于960(移动设置)使用手机版的畅言
        if (width < 960) {
            window.document.write('<script id="changyan_mobile_js" charset="utf-8" type="text/javascript" src="http://changyan.sohu.com/upload/mobile/wap-js/changyan_mobile.js?client_id=' + appid + '&conf=' + conf + '"><\/script>'); } else { var loadJs=function(d,a){var c=document.getElementsByTagName("head")[0]||document.head||document.documentElement;var b=document.createElement("script");b.setAttribute("type","text/javascript");b.setAttribute("charset","UTF-8");b.setAttribute("src",d);if(typeof a==="function"){if(window.attachEvent){b.onreadystatechange=function(){var e=b.readyState;if(e==="loaded"||e==="complete"){b.onreadystatechange=null;a()}}}else{b.onload=a}}c.appendChild(b)};loadJs("http://changyan.sohu.com/upload/changyan.js",function(){window.changyan.api.config({appid:appid,conf:conf})}); } })(); </script>
            <script type="text/javascript" charset="utf-8" src="https://changyan.itc.cn/js/lib/jquery.js"></script>
            <script type="text/javascript" charset="utf-8" src="https://changyan.sohu.com/js/changyan.labs.https.js?appid=cyt2cWe8d"></script>
            <script type="text/javascript">
    window.onload=function(){
        $('.type-list.active').text('留言');
        var count=$('.comment-number .cy-number')[1].innerHTML;
        $('.cmt-list-number .comment-number').html('<span class="cy-number">'+count+'</span>条留言');
        $('.title-name-gw.title-name-bg').html('<div class="title-name-gw-tag"></div>最新留言');
        //自动打开登录面板
        var autoOpenLogin;
        <#if autoOpenLogin??>
            autoOpenLogin='${autoOpenLogin}';
        </#if>
        if(autoOpenLogin=='true'){
            $(".header-login").click();
        }
    }
</script>
</#macro>