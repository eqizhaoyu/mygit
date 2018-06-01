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