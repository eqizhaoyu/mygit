<#macro head>
<title>${productionContent.p_name}-刘文银(LWY)个人博客</title>
<link href="${base}/css/articleDetailInfo.css" rel="stylesheet">
<script src="${base}/layer/galleria.js" type="text/javascript"></script>
</#macro>
<#macro body>
<div id="galleria" style="display: none"></div>
<article>
    <h1 class="t_nav"><span>您当前的位置：<a href="/">首页</a>&nbsp;&gt;&nbsp;<a href="getMyProduction">作品</a>&nbsp;&gt;&nbsp;作品详细信息</span><a href="javascript:(0)" class="n1">作品详细信息</a></h1>
    <div style="clear: both;"></div>
    <div class="index_about">
        <h2 class="c_titile">${productionContent.p_name}</h2>
        <p class="box_c"><span class="d_time">修改时间：${productionContent.gmt_modified}</span><span>作者：${productionContent.p_developer}</span><span>类型：${productionContent.p_type}</span><span>浏览：${productionContent.p_hits}</span></p>
        <ul class="infos" id="content">
            ${productionContent.p_brief}
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
            <div id="SOHUCS" sid="cn.lwy.website.production.${productionId}" style="width: 95%;"></div>
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
            <p>上一个：
                <#if lastProduction?exists>
                    <a href="/getProductionContent?productionId=${lastProduction.p_id}">${lastProduction.p_name}</a>
                <#else >
                    没有了
                </#if>
            </p>
            <p>下一个：
                <#if nextProduction?exists>
                    <a href="/getProductionContent?productionId=${nextProduction.p_id}">${nextProduction.p_name}</a>
                <#else >
                    没有了
                </#if>
            </p>
        </div>
        <div class="otherlink">
            <h2>相关作品</h2>
            <ul>
                <li>暂无相关作品</li>
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
                <p>最新<span>作品</span></p>
            </h3>
            <ul class="rank">
                <#list newProduction as np>
                    <li><a href="/getProductionContent?productionId=${np.p_id}" title="${np.p_name}" target="_blank">${np.p_name}</a></li>
                </#list>
            </ul>
            <div style="clear: both"></div>
            <h3 class="ph">
                <p>点击<span>排行</span></p>
            </h3>
            <ul class="paih">
                <#list clickRateProduction as cp>
                    <li><a href="/getProductionContent?productionId=${cp.p_id}" title="${cp.p_name}" target="_blank">${cp.p_name}</a></li>
                </#list>
            </ul>
            <div style="clear: both"></div>
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