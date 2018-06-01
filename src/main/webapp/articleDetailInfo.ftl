<#macro head>
<title>${articleContent.a_title}-刘文银(LWY)个人博客</title>
<link href="${base}/css/articleDetailInfo.css" rel="stylesheet">
<link rel="stylesheet" href="${base}/highlight/styles/default.css">
<script src="${base}/highlight/highlight.pack.js"></script>
<script>hljs.initHighlightingOnLoad();</script>
<script src="${base}/layer/galleria.js" type="text/javascript"></script>
</#macro>
<#macro body>
<div id="galleria" style="display: none"></div>
<article id="content">
    <h1 class="t_nav"><span>您当前的位置：<a href="/">首页</a>&nbsp;&gt;&nbsp;<a href="getMyArticle?labelId=0&pageNumber=1&pageSize=10">文章</a>&nbsp;&gt;&nbsp;阅读文章</span><a href="/" class="n1">阅读文章</a></h1>
    <div class="index_about">
        <h2 class="c_titile">${articleContent.a_title}</h2>
        <p class="box_c"><span class="d_time">发表时间：${articleContent.a_publish_time}</span><span>作者：${articleContent.a_publisher}</span><span>点击量：${articleContent.a_hits}</span><span>类型：${articleContent.a_type}</span></p>
        <ul class="infos">
            ${articleContent.a_content}
        </ul>
        <div style="clear:both"></div>
        <!--评论区域,使用畅言-->
        <div >
            <!-- 打赏的区域  -->
            <div style="text-align:center">
                <div id="cyReward" role="cylabs" data-use="reward"></div>
            </div>
            <!-- 表情区域 -->
            <div id="cyEmoji" role="cylabs" data-use="emoji"></div>
            <div style="clear:both"></div>
            <!--PC和WAP自适应版-->
            <div id="SOHUCS" sid="cn.lwy.website.${articleId}" style="width: 95%;"></div>
        </div>
        <!-- 配置表情的 -->
        <script type="text/javascript" charset="utf-8" src="https://changyan.itc.cn/js/lib/jquery.js"></script>
        <script type="text/javascript" charset="utf-8" src="https://changyan.sohu.com/js/changyan.labs.https.js?appid=cyt2cWe8d"></script>
        <!--配置打赏的-->
        <script type="text/javascript" charset="utf-8" src="https://changyan.itc.cn/js/lib/jquery.js"></script>
        <script type="text/javascript" charset="utf-8" src="https://changyan.sohu.com/js/changyan.labs.https.js?appid=cyt2cWe8d"></script>
        <!--页脚区域-->
        <div class="ad"> </div>
        <div class="nextinfo">
            <p>上一篇：
                <#if lastArticle?exists>
                    <a href="/getProductionContent?productionId=${lastArticle.a_id}">${lastArticle.a_title}</a>
                <#else >
                    没有了
                </#if>
            </p>
            <p>下一篇：
                <#if nextArticle?exists>
                    <a href="/getProductionContent?productionId=${nextArticle.a_id}">${nextArticle.a_title}</a>
                <#else >
                    没有了
                </#if>
            </p>
        </div>
        <div class="otherlink">
            <h2>相关文章</h2>
            <ul>
                <li>暂无相关文章</li>
            </ul>
        </div>
    </div>
    <aside class="right">
        <!-- Baidu Button BEGIN -->
        <div id="bdshare" class="bdshare_t bds_tools_32 get-codes-bdshare"><a class="bds_tsina"></a><a class="bds_qzone"></a><a class="bds_tqq"></a><a class="bds_renren"></a><span class="bds_more"></span><a class="shareCount"></a></div>
        <script type="text/javascript" id="bdshare_js" data="type=tools&amp;uid=6574585" ></script>
        <script type="text/javascript" id="bdshell_js"></script>
        <script type="text/javascript">
            document.getElementById("bdshell_js").src = "http://bdimg.share.baidu.com/static/js/shell_v2.js?cdnversion=" + Math.ceil(new Date()/3600000)
        </script>
        <!-- Baidu Button END -->
        <div class="blank"></div>
        <div class="news">
            <h3>
                <p>栏目<span>最新</span></p>
            </h3>
            <ul class="rank">
                <#list newArticle as na>
                    <li><a href="getArticleDetailInfo?articleId=${na.a_id}" target="_blank">${na.a_title}</a></li>
                </#list>
            </ul>
            <div style="clear:both"></div>
            <h3 class="ph">
                <p>点击<span>排行</span></p>
            </h3>
            <ul class="paih">
                <#list clickRateArticle as ca>
                    <#if ca_index<5>
                        <li><a href="getArticleDetailInfo?articleId=${ca.a_id}" target="_blank">${ca.a_title}</a></li>
                    </#if>
                </#list>
            </ul>
        </div>
        <div style="clear:both"></div>
        <h3 class="links">
            <p>友情<span>链接</span></p>
        </h3>
        <ul class="website">
            <#list friendLink as fl>
                <li><a href="${fl.fl_link_url}"  target="_blank">${fl.fl_link_text}</a></li>
            </#list>
        </ul>
    </aside>
</article>
<script type="text/javascript">
    (function () {
        var appid = 'cyt2cWe8d';
        var conf = 'prod_cee8547cb97f5bdf147c2219d2be19cd';
        var width = window.innerWidth || document.documentElement.clientWidth;
        if (width < 960) {
            window.document.write('<script id="changyan_mobile_js" charset="utf-8" type="text/javascript" src="http://changyan.sohu.com/upload/mobile/wap-js/changyan_mobile.js?client_id=' + appid + '&conf=' + conf + '"><\/script>');
        } else {
            var loadJs = function (d, a) {
                var c = document.getElementsByTagName("head")[0] || document.head || document.documentElement;
                var b = document.createElement("script");
                b.setAttribute("type", "text/javascript");
                b.setAttribute("charset", "UTF-8");
                b.setAttribute("src", d);
                if (typeof a === "function") {
                    if (window.attachEvent) {
                        b.onreadystatechange = function () {
                            var e = b.readyState;
                            if (e === "loaded" || e === "complete") {
                                b.onreadystatechange = null;
                                a()
                            }
                        }
                    } else {
                        b.onload = a
                    }
                }
                c.appendChild(b)
            };
            loadJs("http://changyan.sohu.com/upload/changyan.js", function () {
                window.changyan.api.config({appid: appid, conf: conf})
            });
        }
    })();
    window.onload=function(){
        // Load theme
        Galleria.loadTheme('layer/themes/lightbox/galleria.lightbox.js');

        $('#galleria').galleria({
            data_source: '#content',
            extend: function() {
                this.bind(Galleria.LOADFINISH, function(e) {
                    $(e.imageTarget).click(this.proxy(function(e) {
                        e.preventDefault();
                        this.next();
                    }))
                })
            },
            keep_source: true,
            data_config: function(img) {
                return {
                    description: $(img).next('.caption').html()
                }
            }
        });
    }
</script>
</#macro>