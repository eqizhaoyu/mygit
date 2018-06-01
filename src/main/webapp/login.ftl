
<!DOCTYPE html>
<!-- 声明文档结构类型 -->
<html lang="zh-cn">
<!-- 声明文档文字区域 -->
<head>
    <!-- 文档头部区域 -->
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <!-- 文档的头部区域中元数据区的字符集定义，这里是UTF-11，表示国际通用的字符集编码 -->
    <title>登录-刘文银(LWY)个人博客</title>
    <!-- 文档的头部区域的标题。这里要注意，这个tittle的内容对于SEO来说极其重要 -->
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1 ">
    <!--[if IE 9]>
    <meta name=ie content=9>
    <![endif]-->
    <!--[if IE 11]>
    <meta name=ie content=11>
    <![endif]-->
    <!--[if IE 7]>
    <meta name=ie content=7>
    <![endif]-->
    <!-- 文档头部区域的apple设备的图标的引用 -->
    <meta name="viewport" content="width=device-width,user-scalable=no">
    <!-- 文档头部区域对于不同接口设备的特殊声明。宽=设备宽，用户不能自行缩放 -->
    <!-- Loading Bootstrap -->
    <link rel="stylesheet" href="${base}/bootstrap/css/bootstrap.min.css">
    <link href="${base}/css/login/login.css" rel="stylesheet">
    <link href="${base}/css/login/blue.css" rel="stylesheet">

    <link href="${base}/css/login/u.css" rel="stylesheet">
    <link href="${base}/css/login/c.css" rel="stylesheet">
    <link href="${base}/css/login/login.css" rel="stylesheet">
    <script src="${base}/js/jquery.min.js" type="text/javascript"></script>
</head>
<body>
<section class="c-screen  c-group-middle" style="background-color:#EDEDED;">
    <div class="p-login-container u-clearfix c-group-middle_content">
        <div class="c-box-login-wrap">
            <div class="p-login-form-links u-bounceInRight">
                <img src="${base}/images/title.png"  />
            </div>
            <div class="c-box-login u-bounceInLeft">
                <div class="c-box-login_header">
                    <h3>登录</h3>
                </div>
                    <div class="c-box-login_content">
                        <div class="c-textbox_wrap">
                            <div class="input-group">
                                <span class="input-group-addon"><i class="glyphicon glyphicon-user"></i></span>
                                <input id="txtLoginName" type="textbox" class="form-control" placeholder="用户名" ></asp:TextBox>
                            </div>
                        </div>
                        <div class="c-textbox_wrap">
                            <div class="input-group">
                                <span class="input-group-addon"><i class="glyphicon glyphicon-lock"></i></span>
                                <input id="txtLoginPassword" type="password" class="form-control" placeholder="密码"></asp:TextBox>
                            </div>
                        </div>

                        <div class="c-box-login_footer">
                            <!--跳转到留言板页面-->
                            <a href="getMessageBoard?autoOpenLogin=true">第三方登录</a>
                            &nbsp;&nbsp;<input type="checkbox" id="rememberMe">记住我
                            <input type="button" value="登录" class="btn btn-success btn-lg u-f--r" OnClick="userLogin()" />
                        </div>
                    </div>
            </div>
            <div class="p-login-form-links u-bounceInRight"><a href="index">回到首页</a></div>
        </div>
    </div>
</section>
<script>
    $(function () {
        <#if username?? && password??>
            $('#txtLoginName').val("${username}");
            $('#txtLoginPassword').val("${password}");
        </#if>
    });

    //用户登录
    function userLogin(){
        $.ajax({
            url: '${base}/login',
            type: 'post',
            data: {
                userId:$('#txtLoginName').val(),
                userPassword:$('#txtLoginPassword').val(),
                rememberMe:$("input[type='checkbox']").is(':checked')
            },
            timeout: 20000,
            success: function (data) {
                if (data == 'ok') {
                    window.location.href="${base}/article/getArticleAdminPage";
                } else if(data=='error'){
                    alert("用户名或密码不正确!!");
                }else if(data=='forbidden'){
                    alert("你已输错三次密码,请于一小时后重试!")
                }else{
                    alert("登录失败!");
                }
            },
            error: function (XMLHttpRequest, textStatus, errorThrown) {
                alert("访问后台发生错误:" + XMLHttpRequest.status)
            }
        });
    }

</script>
</body>
</html>
