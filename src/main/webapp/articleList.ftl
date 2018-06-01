<#macro head>
<title>文章-刘文银(LWY)个人博客</title>
<link href="${base}/css/article.css" rel="stylesheet">
<link href="${base}/bootstrap-paginator/bootstrap.css" rel="stylesheet">
<link href="${base}/bootstrap/css/bootstrap.css">
<script src="${base}/bootstrap-paginator/bootstrap-paginator.js"></script>
</#macro>
<#macro body>
<article>
    <h2 class="title_tj">
        <p>文章<span>列表</span></p>
    </h2>
    <div class="bloglist left">
        <#list articleList as article>
            <h3><b><a href="getArticleDetailInfo?articleId=${article.a_id}">${article.a_title}</a></b></h3>
            <figure><img src="${base}/images/${article.attachImg}.jpg"></figure>
            <ul>
                <p>${article.a_content?substring(0,180)+"..."}</p>
                <a href="getArticleDetailInfo?articleId=${article.a_id}" href="getArticleDetailInfo" target="_blank" class="readmore">阅读全文>></a>
            </ul>
            <p class="dateview">
                <span>${article.a_publish_time}</span>
                <span>文章类型：[<a href="javascript:void(0)">${article.a_type}</a>]</span>
                <span>点击：(<a href="javascript:void(0)" style="margin: 0px 3px;">${article.a_hits}</a>)</span>
                <span>评论：(<a href="javascript:void(0)"><span id = "sourceId::cn.lwy.website.${article.a_id}" class = "cy_cmt_count" style="margin: 0px 3px;"></span></a>)</span>
            </p>
        </#list>
        <script id="cy_cmt_num" src="https://changyan.sohu.com/upload/plugins/plugins.list.count.js?clientId=cyt2cWe8d">
        </script>
        <div id="articlePaging"></div>
        <div style="height:25px;clear: both;"></div>
    </div>
    <aside class="right">
        <div class="weather"><iframe width="250" scrolling="no" height="60" frameborder="0" allowtransparency="true" src="http://i.tianqi.com/index.php?c=code&id=12&icon=1&num=1"></iframe></div>
        <div class="news">
            <h3>
                <p>最新<span>文章</span></p>
            </h3>
            <ul class="rank">
                <#list newArticle as na>
                    <li><a href="getArticleDetailInfo?articleId=${na.a_id}" target="_blank">${na.a_title}</a></li>
                </#list>
            </ul>
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
            <h3 class="links">
                <p>友情<span>链接</span></p>
            </h3>
            <ul class="website">
                <#list friendLink as fl>
                    <li><a href="${fl.fl_link_url}" target="_blank">${fl.fl_link_text}</a></li>
                </#list>
            </ul>
        </div>
        <!-- Baidu Button BEGIN -->
        <div id="bdshare" class="bdshare_t bds_tools_32 get-codes-bdshare"><a class="bds_tsina"></a><a class="bds_qzone"></a><a class="bds_tqq"></a><a class="bds_renren"></a><span class="bds_more"></span><a class="shareCount"></a></div>
        <script type="text/javascript" id="bdshare_js" data="type=tools&amp;uid=6574585" ></script>
        <script type="text/javascript" id="bdshell_js"></script>
        <script type="text/javascript">
            var options = {
                itemTexts: function (type, page, current) {
                    switch (type) {
                        case "first":
                            return "首页";
                        case "prev":
                            return "上一页";
                        case "next":
                            return "下一页";
                        case "last":
                            return "末页";
                        case "page":
                            return page;
                    }
                },
                currentPage: ${currentPage},
                totalPages: ${totalPages},
                numberOfPages:5,
                onPageClicked: function (event, originalEvent, type, page){
                    window.location.href="/getMyArticle?labelId=${labelId}&pageNumber="+page+"&pageSize=10"
                }
            }
            $('#articlePaging').bootstrapPaginator(options);
            document.getElementById("bdshell_js").src = "http://bdimg.share.baidu.com/static/js/shell_v2.js?cdnversion=" + Math.ceil(new Date()/3600000)
        </script>
        <!-- Baidu Button END -->
</article>
</#macro>