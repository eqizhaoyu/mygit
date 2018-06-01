<#macro head>
<title>心情-刘文银(LWY)个人博客</title>
<script src="${base}/layer/galleria.js" type="text/javascript"></script>
<link href="${base}/css/mood.css" rel="stylesheet">
<link href="${base}/css/articleDetailInfo.css" rel="stylesheet">
<style type="text/css" rel="stylesheet">
    /* for 980px or less */
    @media screen and (max-width: 980px) {
        .sy{
            font-size: 22px;
        }
        .arrow_box p {
            padding: 0 20px 20px;
            line-height: 52px;
        }

    }
</style>
</#macro>
<#macro body>
<div id="galleria" style="display: none"></div>
<div class="moodlist">
    <h1 class="t_nav"><span>删删写写，回回忆忆，虽无法行云流水，却也可碎言碎语。</span><a href="/" class="n1">我的心情</a></h1>
    <div class="bloglist">
        <#list moodList as m>
            <ul class="arrow_box">
                <div class="sy">
                    <#if m.m_share_to_other ==true>
                    ${m.m_content}
                    <#elseif session.alreadyLogin?exists>
                        <div style="float:left;margin-left:20px">
                            <img src="${base}/images/lock.png">
                            <div style="float: right;color: brown;margin-top: 5px;">(仅自己可见)</div>
                        </div>
                        <div style="float:left;margin-top:5px">${m.m_content}</div>
                    <#else>
                        <div style="color: darkgoldenrod;margin-bottom: 20px;">
                            <div style="float:left;margin-left:20px"><img src="${base}/images/lock.png"></div>
                            <div style="float:left;margin-top:5px">主人的私密心情,只有主人才能查看</div>
                            <div style="clear: both"></div>
                        </div>
                    </#if>
                </div>
                <!--配图的地方-->
            <#if m.m_share_to_other ==true>
                <#if m.m_attach_image!="">
                    <div class="attachImg">
                        <#list m.m_attach_image as img>
                            <div class="perAttachImg">
                                <figure>
                                    <img src="${base}${img}" style="width:100%">
                                </figure>
                            </div>
                        </#list>
                        <div style="clear:both;"></div>
                    </div>
                </#if>
            </#if>
                <span class="dateview">
                <img src="images/userHead/my.png" style="width:100%;height:100%;margin:0px">
            </span>
                <div style="float:right;margin-right: 20px;color: brown;">${m.m_publish_time}</div>
                <!--是否显示地点-->
                <#if m.m_share_publish_location==true>
                <div style="float:right;margin-right: 30px">
                    <div  style="float:right">
                    ${m.m_publish_location}
                    </div>
                    <div style="float:left">
                        <img src="images/location.png" style="margin-top: -2px;width:25px;height:25px">
                    </div>
                </div>
                </#if>
                <div style="clear:both"></div>
            </ul>
        </#list>
    </div>
</div>
<script type="text/javascript">
    //在页面加载的时候需要用到
    var attachImage='';
    var page=2;
    var finished=0;
    var sover=0;
    //相册加载
    //这里要注意window.onload和jQuery提供的$(document).ready的区别,前者是等待所引用的js和css加载完毕之后才会执行,而后者是在dom加载完毕之后就会执行
    //$(function()
    window.onload=function(){
        // Load theme
        Galleria.loadTheme('layer/themes/lightbox/galleria.lightbox.js');
        galleriaInit();
    }

    //图片框初始化
    function galleriaInit(){
        $('#galleria').galleria({
            data_source: '.bloglist ul .attachImg',
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

    //如果屏幕未到整屏自动加载下一页补满
    var setdefult=setInterval(function (){
        if(sover==1)
            clearInterval(setdefult);
        else if($(".bloglist").height()<$(window).height())
            loadmore($(window));
        else
            clearInterval(setdefult);
    },500);

    //加载完
    function loadover(){
        if(sover==1)
        {
            var overtext="Duang～没有更多的数据了";
            $(".loadmore").remove();
            if($(".loadover").length>0)
            {
                $(".loadover span").eq(0).html(overtext);
            }
            else
            {
                var txt='<div class="loadover"><span>'+overtext+'</span></div>'
                $(".bloglist").append(txt);
            }
        }
    }

    //加载更多
    var vid=0;
    function loadmore(obj) {
        if (finished == 0 && sover == 0) {
            var scrollTop = $(obj).scrollTop();
            var scrollHeight = $(document).height();
            var windowHeight = $(obj).height();

            if ($(".loadmore").length == 0) {
                var txt = '<div class="loadmore"><span class="loading"></span>加载中..</div>'
                $(".bloglist").append(txt);
            }

            if (scrollHeight - scrollTop - windowHeight <= 50) {
                //此处是滚动条到底部时候触发的事件，在这里写要加载的数据，或者是拉动滚动条的操作
                //防止未加载完再次执行
                finished = 1;
                $.ajax({
                    type: 'GET',
                    url: 'getMoodData?pageNumber=' + page + '&pageSize=10',
                    success: function (data) {
                        if (data == "") {
                            sover = 1;
                            loadover();
                            if (page == 1) {
                                $("#no_msg").removeClass("hidden");
                                $(".loadover").remove();
                            }
                        }
                        else {
                            // 为了测试，延迟1秒加载
                            setTimeout(function () {
                                $(".loadmore").remove();
                                //记载数据
                                $('.bloglist').append(data);
                                page += 1;
                                finished = 0;
                                //重新初始化
                                galleriaInit();
                            }, 1000);
                        }
                    },
                    error: function (xhr, type) {
                        alert('数据加载失败!');
                    }
                });
            }
        }
    }
    //页面滚动执行事件
    $(window).scroll(function (){
        loadmore($(this));
    });
</script>
</#macro>