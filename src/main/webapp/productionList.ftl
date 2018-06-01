<#macro head>
<title>我的作品-刘文银(LWY)个人博客</title>
<link href="${base}/css/production.css" type="text/css" rel="stylesheet">
</#macro>
<#macro body>
<article >
    <h1 class="t_nav"><span>不积跬步无以至千里,不积小流无以成江海。 </span><a href="/" class="n1">我的作品</a></h1>
    <div class="newblog left">
        <#list productList as p>
            <h3><b><a title="${p.p_name}" href="getProductionContent?productionId=${p.p_id}" target="_blank">${p.p_name}</a></b></h3>
            <p class="dateview">
                <span>修改时间：${p.gmt_modified}</span>
                <span>作者：${p.p_developer}</span>
                <span>分类：<a href="/getMyProduction?type=${p.p_type}">[<a href="/">${p.p_type}</a>]</span>
                <span>点击：(<a href="javascript:void(0)" style="margin: 0px 3px;">${p.p_hits}</a>)</span>
                <span>评论：(<a href="javascript:void(0)"><span id = "sourceId::cn.lwy.website.production.${p.p_id}" class = "cy_cmt_count" style="margin: 0px 3px;"></span></a>)</span>
            </p>
            <figure><img src="${base}${p.p_cover_url}"></figure>
            <ul class="nlist">
                <p>${p.p_brief?substring(0,180)+"..."}</p>
                <a title="${p.p_name}" href="getProductionContent?productionId=${p.p_id}" target="_blank" class="readmore">详细信息</a>
            </ul>
            <div class="line"></div>
        </#list>
        <!--获取畅言评论-->
        <script id="cy_cmt_num" src="https://changyan.sohu.com/upload/plugins/plugins.list.count.js?clientId=cyt2cWe8d">
        </script>
        <div class="blank"></div>
    </div>
    <aside class="right"  id="rightSide">
        <div class="rnav">
            <h2>栏目导航</h2>
            <ul style="width:''">
                <li><a href="/getMyProduction?type=小游戏" target="_blank">小游戏</a></li>
                <li><a href="/getMyProduction?type=网站" target="_blank">网站</a></li>
                <li><a href="/getMyProduction?type=B/S系统" target="_blank">B/S系统</a></li>
                <li><a href="/getMyProduction?type=移动APP" target="_blank">移动APP</a></li>
            </ul>
        </div>
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
        <h3 class="links">
            <p>友情<span>链接</span></p>
        </h3>
        <ul class="website">
            <#list friendLink as fl>
                <li><a href="${fl.fl_link_url}" target="_blank">${fl.fl_link_text}</a></li>
            </#list>
        </ul>
        <!-- Baidu Button BEGIN -->
        <div id="bdshare" class="bdshare_t bds_tools_32 get-codes-bdshare"><a class="bds_tsina"></a><a class="bds_qzone"></a><a class="bds_tqq"></a><a class="bds_renren"></a><span class="bds_more"></span><a class="shareCount"></a></div>
        <script type="text/javascript" id="bdshare_js" data="type=tools&amp;uid=6574585" ></script>
        <script type="text/javascript" id="bdshell_js"></script>
        <script type="text/javascript">
            document.getElementById("bdshell_js").src = "http://bdimg.share.baidu.com/static/js/shell_v2.js?cdnversion=" + Math.ceil(new Date()/3600000)
        </script>
        <!-- Baidu Button END -->
    </aside>
</article>
</#macro>