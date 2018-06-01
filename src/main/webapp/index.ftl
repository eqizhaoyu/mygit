<#macro head>
<title>首页-刘文银(LWY)个人博客</title>
</#macro>
<#macro body>
<article>
    <div class="l_box f_l">
        <div class="banner">
            <div id="slide-holder">
                <div id="slide-runner">
                    <a href="javascript:void(0)">
                        <img id="slide-img-1" src="images/a1.jpg" alt=""/>
                    </a>
                    <a href="javascript:void(0)">
                        <img id="slide-img-2" src="images/a2.jpg" alt=""/>
                    </a>
                    <a href="javascript:void(0)">
                        <img id="slide-img-3" src="images/a3.jpg" alt=""/>
                    </a>
                    <a href="javascript:void(0)">
                        <img id="slide-img-4" src="images/a4.jpg" alt=""/>
                    </a>
                    <div id="slide-controls">
                        <p id="slide-client" class="text"><strong></strong><span></span></p>
                        <p id="slide-desc" class="text"></p>
                        <p id="slide-nav"></p>
                    </div>
                </div>
            </div>
        </div>
        <!-- banner代码 结束 -->
            <div class="topnews">
            <h2><span><a href="getAboutMe" target="_blank">lwy</a>个人博客</span><b>文章</b>推荐</h2>
            <#list recommendArticle as ra>
                <div class="blogs">
                    <figure><img src="images/${ra.attachImg}.jpg"></figure>
                    <ul>
                        <h3><a href="getArticleDetailInfo?articleId=${ra.a_id}" target="_blank">${ra.a_title}</a></h3>
                        <p>${ra.a_content?substring(0,120)+"..."}</p>
                        <p class="autor">
                            <span class="lm f_l"><a href="javascript:void(0)">个人博客</a></span>
                            <span class="dtime f_l">${ra.a_publish_time}</span>
                            <span class="viewnum f_r">浏览(<a href="javascript:void(0)">${ra.a_hits}</a>)</span>
                            <span class="pingl f_r">评论(<a href="javascript:void(0)"><span id = "sourceId::cn.lwy.website.${ra.a_id}" class = "cy_cmt_count" style="padding-left: 0px;margin-right: 0px;"></span></a>)</span>
                        </p>
                    </ul>
                </div>
            </#list>
        </div>
    </div>
    <div class="r_box f_r" id="rightSide">
        <div class="tit01">
            <h3>关注我</h3>
            <div class="gzwm">
                <ul>
                    <li><a class="weibo" href="http://weibo.com/u/3828477981" target="_blank">微博</a></li>
                    <li><a class="github" href="http://github.com/lwyyyyyy/mygit" target="_blank">GitHub</a></li>
                    <li><a class="weixin" href="javascript:void(0)" target="_blank" title="暂未开放">公众号</a></li>
                    <li><a class="email" href="mailto:1515439874@qq.com" title="1515439874@qq.com">邮箱</a></li>
                </ul>
            </div>
        </div>
        <!--tit01 end-->
        <div class="lizhi">
            <figure>
                <img src="images/lizhi-logo.jpg">
            </figure>
        </div>
        <div class="moreSelect" id="lp_right_select">
            <div class="ms-top">
                <ul class="hd" id="tab">
                    <li class="cur"><a href="javascript:void(0)">点击排行</a></li>
                    <li><a href="javascript:void(0)">最新文章</a></li>
                    <li><a href="javascript:void(0)">博主推荐</a></li>
                </ul>
            </div>
            <div class="ms-main" id="ms-main">
                <div style="display: block;" class="bd bd-news">
                    <ul>
                        <#list clickRateArticle as ca>
                            <li><a href="getArticleDetailInfo?articleId=${ca.a_id}" target="_blank">${ca.a_title}</a></li>
                        </#list>
                    </ul>
                </div>
                <div class="bd bd-news">
                    <ul>
                        <#list newArticle as na>
                            <li><a href="getArticleDetailInfo?articleId=${na.a_id}" target="_blank">${na.a_title}</a></li>
                        </#list>
                    </ul>
                </div>
                <div class="bd bd-news">
                    <ul>
                        <#list recommendArticle as ra>
                            <#if ra_index<6>
                                <li><a href="getArticleDetailInfo?articleId=${ra.a_id}" target="_blank">${ra.a_title}</a></li>
                            </#if>
                        </#list>
                    </ul>
                </div>
            </div>
            <!--ms-main end -->
        </div>
        <!--切换卡 moreSelect end -->

        <div class="cloud">
            <h3>标签云</h3>
            <ul>
                <#list allLabel as label>
                    <li><a href="/getMyArticle?labelId=${label.l_id}&pageNumber=1&pageSize=10" title="${label.l_description}">${label.l_name} (${label.relatedArticleCount})</a></li>
                </#list>
            </ul>
        </div>
        <div class="tuwen">
            <h3>作品推荐</h3>
            <ul>
                <#list recommendProduction as rp>
                    <li>
                        <a href="getProductionContent?productionId=${rp.p_id}" target="_blank">
                            <div style="height: 57px;float: left;">
                                <figure>
                                    <img src="${base}${rp.p_cover_url}">
                                </figure>
                            </div>
                            <b>${rp.p_name}</b>
                        </a>
                        <p>
                            <span class="tulanmu">
                                <a href="/getMyProduction?type=${rp.p_type}" target="_blank">${rp.p_type}</a>
                            </span>
                            <span class="tutime">${rp.gmt_modified}</span>
                        </p>
                    </li>
                </#list>
            </ul>
        </div>
        <div class="links">
            <h3><span>[<a href="javascript:void(0)" onclick="alert('请将申请发送到博主邮箱~')">申请友情链接</a>]</span>友情链接</h3>
            <ul class="website">
                <#list friendLink as fl>
                    <li><a href="${fl.fl_link_url}" target="_blank">${fl.fl_link_text}</a></li>
                </#list>
            </ul>
        </div>
    </div>
    <script id="cy_cmt_num" src="https://changyan.sohu.com/upload/plugins/plugins.list.count.js?clientId=cyt2cWe8d">
    </script>
    <!--r_box end -->
    <script type="text/javascript">
        window.onload = function () {
            var oLi = document.getElementById("tab").getElementsByTagName("li");
            var oUl = document.getElementById("ms-main").getElementsByTagName("div");

            for (var i = 0; i < oLi.length; i++) {
                oLi[i].index = i;
                oLi[i].onmouseover = function () {
                    for (var n = 0; n < oLi.length; n++) oLi[n].className = "";
                    this.className = "cur";
                    for (var n = 0; n < oUl.length; n++) oUl[n].style.display = "none";
                    oUl[this.index].style.display = "block"
                }
            }
        }
        if (!window.slider) {
            var slider = {};
        }
        slider.data = [
            {
                "id": "slide-img-1", // 与slide-runner中的img标签id对应
                "client": "日常",
                "desc": "每天都是敲啊敲代码~" //这里修改描述
            },
            {
                "id": "slide-img-2",
                "client": "回忆",
                "desc": "童年最爱de动漫,卡卡罗特marry with 琪琪~"
            },
            {
                "id": "slide-img-3",
                "client": "音乐",
                "desc": "每天都离不开音乐~"
            },
            {
                "id": "slide-img-4",
                "client": "回忆",
                "desc": "童年最爱de动漫,卡卡罗特都有baby了~"
            }
        ];
        //获取作品推荐的所有图片,修改图片的显示方式
        var allTu=$('.tuwen ul li img');
        for(var i=0;i<allTu.length;i++){
            //当图片高度小于了57说明没有将高度填满,则将图片修改成指定高度,宽度自适应,多余的部分隐藏
            if(allTu[i].height<57){
                allTu[i].height=57;
            }
        }
    </script>
</article>
</#macro>
