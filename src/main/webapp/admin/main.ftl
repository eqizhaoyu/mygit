<#import "${body_file_path}" as content>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>LWY-BLOG后台管理系统</title>
    <link rel="stylesheet" href="${base}/admin/css/bootstrap.min.css" />
    <link rel="stylesheet" href="${base}/admin/css/bootstrap-responsive.min.css" />
    <link rel="stylesheet" href="${base}/admin/css/uniform.css" />
    <link rel="stylesheet" href="${base}/admin/css/unicorn.main.css" />
    <link rel="stylesheet" href="${base}/admin/css/unicorn.grey.css" class="skin-color" />
    <link rel="stylesheet" href="${base}/admin/bootstrapTable/bootstrap-table.min.css"/>
    <script type="text/javascript" src="${base}/admin/bootstrapTable/jquery.min.js"></script>
    <script type="text/javascript" src="${base}/admin/bootstrapTable/bootstrap.min.js"></script>
    <script type="text/javascript" src="${base}/admin/bootstrapTable/bootstrap-table.min.js"></script>
    <script type="text/javascript" src="${base}/admin/bootstrapTable/bootstrap-table-zh-CN.min.js"></script>
	<#if content.head??>
		<@content.head ></@content.head>
	</#if>
<script type="text/javascript">
$(function(){

	var sectionPage="section.jsp";var topicPage="topic.jsp";var userPage="user.jsp";var zonePage="zone.jsp";
	//在freemarker中获取null的话是会报错的,而在JSP中则不会出现这样的错误
	var curPage='${body_file_path}';
	if(sectionPage.indexOf(curPage)>=0&&curPage!=""){
		$("#sectionLi").addClass("active");
	} else if(topicPage.indexOf(curPage)>=0&&curPage!=""){
		$("#topicLi").addClass("active");
	} else if(userPage.indexOf(curPage)>=0&&curPage!=""){
		$("#userLi").addClass("active");
	} else if(zonePage.indexOf(curPage)>=0&&curPage!=""){
		$("#zoneLi").addClass("active");
	}
})
</script>
</head>
<body>
	<div style="color:antiquewhite;margin: 25px 0px -10px 25px;">
		<h3>LWY-BLOG</h3>
	</div>
	<div id="sidebar">
		<ul>
            <li id="zoneLi"><a href="/article/getArticleLabelAdminPage"><i class="icon icon-home"></i> <span>文章标签管理</span></a></li>
			<li id="zoneLi"><a href="/article/getArticleAdminPage"><i class="icon icon-home"></i> <span>文章管理</span></a></li>
			<li id="sectionLi"><a href="/production/getProductionAdminPage"><i class="icon icon-home"></i> <span>作品管理</span></a></li>
			<li id="topicLi"><a href="/mood/getMoodAdminPage"><i class="icon icon-home"></i> <span>心情管理</span></a></li>
            <li id="sectionLi"><a href="https://changyan.kuaizhan.com/"><i class="icon icon-home"></i> <span>评论及留言管理</span></a></li>
            <li id="sectionLi"><a href="/friendLink/getFriendLinkAdminPage"><i class="icon icon-home"></i> <span>友情链接管理</span></a></li>
			<li class="submenu"><a href="#"><i class="icon icon-th-list"></i>
					<span>系统管理</span> <span class="label">3</span></a>
				<ul>
					<li><a href="/system/getAlterPasswordAdminPage">修改密码</a></li>
                    <li><a href="#" onclick="clearSystemCache()">清空系统缓存</a></li>
					<li><a href="#" onclick="loginOut()">安全退出</a></li>
				</ul></li>
		</ul>

	</div>
	<div id="content">
		<div id="content-header">
			<div style="float:left;font-size: 28px;margin-left:20px">
				后台管理
			</div>
			<div style="float:right;margin-right:20px">欢迎你:亲爱的LWY</div>
		</div>
		<div id="breadcrumb">
			<a href="#" title="首页" class="tip-bottom">
			<i class="icon-home"></i>首页
			</a>
			<a href="#" class="current">${currentModule }</a>
		</div>

		<!--这里加入中间的内容-->
	<#if content.body??>
		<@content.body></@content.body>
	</#if>

		<div class="row-fluid">
			<div id="footer" class="span12">
				LWY博客 Design by LWY 蜀ICP备16036750号
			</div>
		</div>
	</div>
    <script src="/admin/js/jquery.ui.custom.js"></script>
    <!-- <script src="js/select2.min.js"></script> -->
    <script src="/admin/js/unicorn.js"></script>
	<script type="text/javascript">
		function loginOut(){
            if (confirm('确定退出吗?')==true){
                $.ajax({
                    url: '/login/loginOut',
                    type: 'post',
                    timeout: 20000,
                    success: function (data) {
                        if (data == 'ok') {
                            window.location.href="/userLogin";
                        } else {
                            alert("操作失败!!");
                        }
                    },
                    error: function (XMLHttpRequest, textStatus, errorThrown) {
                        alert("访问后台发生错误:" + XMLHttpRequest.status)
                    }
                });
			}
		}
		//清空系统缓存
		function clearSystemCache(){
            if (confirm('确定清空系统缓存吗?所有的缓存记录都将被清空!')==true){
                $.ajax({
                    url: '/system/clearSystemCache',
                    type: 'post',
                    timeout: 20000,
                    success: function (data) {
                        if (data == 'ok') {
                            alert("已清空系统缓存!!");
                        } else {
                            alert("操作失败!!");
                        }
                    },
                    error: function (XMLHttpRequest, textStatus, errorThrown) {
                        alert("访问后台发生错误:" + XMLHttpRequest.status)
                    }
                });
            }
		}
	</script>
</body>
</html>