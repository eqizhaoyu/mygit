<#macro head>
<script type="text/javascript" src="${base}/ckEditor/ckeditor.js"></script>
<link href="/admin/bootstrap-fileinput/css/fileinput.css" media="all" rel="stylesheet" type="text/css"/>
<script src="/admin/bootstrap-fileinput/js/fileinput.js" type="text/javascript"></script>
<script src="/admin/bootstrap-fileinput/js/locales/zh.js" type="text/javascript"></script>
</#macro>
<#macro body>
<div style="padding: 10px">
    <div id="toolbar" class="btn-group">
        <div style="float:left;margin-right: 10px">
            <button type="button" class="btn btn-info" data-backdrop="static" data-toggle="modal"
                    onclick="openPublishMooddlg()">
                发表心情
            </button>
        </div>
        <div style="float:left">
            <button type="button" class="btn btn-info" onclick="openDeleteProductionDlg()">删除心情</button>
        </div>
    </div>
    <!--bootstrap table-->
    <!--说说本来就是用来记录心情的,所以不需要提供编辑功能,不然就失去了说说的意义了-->
    <table id="moodTable">
        <thead>
        <tr>
            <th data-field="state" data-checkbox="true"></th>
            <th class="col-xs-4" data-field="m_id" data-align="center">心情号</th>
            <th class="col-xs-4" data-field="m_content" data-align="center">内容</th>
            <th class="col-xs-1" data-field="m_publish_time" data-align="center">发表时间</th>
            <th class="col-xs-1" data-field="m_publish_location" data-align="center">发表地点</th>
            <th class="col-xs-6" data-field="m_share_publish_location" data-align="center">是否公开地点</th>
            <th class="col-xs-6" data-field="m_share_to_other" data-align="center">是否公开心情</th>
            <th data-field="operation" data-formatter="actionFormatter" data-events="actionEvents" data-align="center">
                操作
            </th>
        </tr>
        </thead>
    </table>
    <!--发表心情对话框-->
    <div id="publishMooddlg" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel"
         aria-hidden="true" style="width:60%;left:550px">
        <div class="modal-header">
            <h3 id="myModalLabel">修改心情内容</h3>
        </div>
        <div class="modal-body">
            当前位置:<input id="nowLocation" type="text" width="300px">
            &nbsp;<a href="javascript:(0)" onclick="getNowPosition()">获取当前位置</a>&nbsp;&nbsp;
            是否公开位置:<input type="checkbox" id="m_share_publish_location" checked>
            &nbsp;&nbsp;
            是否公开心情:<input type="checkbox" id="m_share_to_other" checked>
            <!--因为浏览器定位误差较大,所以最好使用手写的方式来填写位置-->

            <!-- CKeditor区域 -->
            <div style="margin-bottom: 10px; margin-top: 20px" id="ckEditor">
                <textarea name="CkEditor" id="CkEditor"></textarea>
            </div>
            <input id="moodAttachImage" name="moodAttachImage" class="file" type="file" multiple
                   data-min-file-count="1">
        </div>
        <div class="modal-footer">
            <button class="btn" data-dismiss="modal" aria-hidden="true">关闭
            </button>
            <button class="btn btn-primary" onclick="publishMood()">发表心情</button>
        </div>
    </div>

    <!--确认删除心情对话框-->
    <div id="confirmDlg" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel"
         aria-hidden="true">
        <div class="modal-header">
            <h3>删除心情</h3>
        </div>
        <div class="modal-body">
            <div style="margin:10px;">
                确定删除以下心情吗?
            </div>
            <div id="deleteContent">

            </div>
        </div>
        <div class="modal-footer">
            <button class="btn" data-dismiss="modal" aria-hidden="true">取消
            </button>
            <button class="btn btn-primary" onclick="deleteMood()">确定</button>
        </div>
    </div>

    <!--查看心情配图对话框-->
    <div id="moodAttachImageDlg" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel"
         aria-hidden="true">
        <div class="modal-header">
            <h3>心情配图</h3>
        </div>
        <div class="modal-body">
            <div style="max-width:660px;" id="attchImgArea">

            </div>
        </div>
        <div class="modal-footer">
            <button class="btn" data-dismiss="modal" aria-hidden="true">关闭
            </button>
        </div>
    </div>
</div>
<script type="text/javascript">
    var nowSelectProductionId;
    var productonCoverImageUrl = ''; //保存文件上传的路径值,需要保存到数据库,默认值为空
    if (CKEDITOR.instances['CkEditor']) {
        CKEDITOR.remove(CKEDITOR.instances['CkEditor']);
    }
    //初始化CKeditor
    CKEDITOR.replace('CkEditor', {
        //保存文章图片路径
        filebrowserImageUploadUrl: 'saveProductionContactFile',
        language: 'zh-cn',
        height: '120px',
        width: '100%'
    });
    //初始化bootstrap-input
    $("#moodAttachImage").fileinput({
        uploadUrl: 'saveMoodAttachImage', // 后台使用js方法
        uploadAsync: false,
        minFileCount: 1,
        maxFileCount: 9,
        language: 'zh',
        msgFilesTooMany: '9',
        allowedFileExtensions: ['jpg', 'png', 'jpeg'],
        initialPreviewAsData: true // identify if you are sending preview data only and not the markup
    }).on('filebatchpreupload', function (event, data) {
        if ($('.imgClass').length >= 1) {
            var img = $(".kv-preview-thumb");
            img[9].remove();
            $(".kv-upload-progress").addClass("hide");
            return {
                message: "最多只能上传9张!"
            };
        }
    });

    $('#moodAttachImage').on('filebatchuploadsuccess', function (event, data, previewId, index) {
        var response = data.response;
        //获取所有图片的ID集合
        productonCoverImageUrl = response['allImageId'];
        //提示文件上传成功
        $('.file-caption-name').append('&nbsp;&nbsp;图片上传成功>');
        //将将心情内容进行保存
        $.ajax({
            url: 'saveMood',
            type: 'post',
            data: {
                m_publish_location: $('#nowLocation').val(),
                m_share_publish_location: document.getElementById("m_share_publish_location").checked,
                m_share_to_other: document.getElementById("m_share_to_other").checked,
                m_content: CKEDITOR.instances.CkEditor.getData(),
                m_attach_image: productonCoverImageUrl
            },
            timeout: 20000,
            success: function (data) {
                if (data == "ok") {
                    alert("心情发表成功!");
                }
                //将当前信息清空
                clearMoodContent();
                //重新加载数据
                //$("#productionTable").bootstrapTable('refresh', {url: 'getAllProduction'});
            },
            error: function (XMLHttpRequest, textStatus, errorThrown) {
                alert("访问后台发生错误:" + XMLHttpRequest.status)
            }
        });
    });
    $(".fileinput-remove-button").on("click", function () {  //删除按钮
        $('.imgClass').remove();
    });

    //发表心情
    function publishMood() {
        var m_content = CKEDITOR.instances.CkEditor.getData();
        //客户端验证
        if (m_content == '') {
            alert('心情内容不能为空!');
        } else {
            //判断是否有文件需要上传
            if ($('#moodAttachImage').fileinput("getFilesCount") > 0) {          //获取文件个数
                //手动提交图片,图片上传成功之后再进行心情保存
                $('.btn.btn-default.fileinput-upload.fileinput-upload-button').click();
            } else {  //直接进行保存
                $.ajax({
                    url: 'saveMood',
                    type: 'post',
                    data: {
                        m_publish_location: $('#nowLocation').val(),
                        m_share_publish_location: document.getElementById("m_share_publish_location").checked,
                        m_share_to_other: document.getElementById("m_share_to_other").checked,
                        m_content: CKEDITOR.instances.CkEditor.getData(),
                        m_attach_image: ''
                    },
                    timeout: 20000,
                    success: function (data) {
                        if (data == "ok") {
                            alert("心情发表成功!");
                        }
                        //将当前信息清空
                        clearMoodContent();
                        //重新加载数据
                        //$("#productionTable").bootstrapTable('refresh', {url: 'getAllProduction'});
                    },
                    error: function (XMLHttpRequest, textStatus, errorThrown) {
                        alert("访问后台发生错误:" + XMLHttpRequest.status)
                    }
                });
            }
        }
    }

    //将文本框里面的内容清空
    function clearMoodContent() {
        $('#nowLocation').val('');
        CKEDITOR.instances.CkEditor.setData('');
        $('.close.fileinput-remove').click();
    }

    /*初始化table数据*/
    $(function () {
        $("#moodTable").bootstrapTable({
            url: 'getMoodData',
            search:true,
            showRefresh:true,
            showToggle:true,
            showColumns:true,
            toolbar:"#toolbar",
            pagination:true,
            pageNumber:1,
            pageSize:10,
            pageList: [20, 40, 60, 80,100]
        });
    });    //向服务器发送保存标签的请求

    //格式化操作按钮
    function actionFormatter(value, row, index) {
        return '<button type="button" class="btn btn-info" data-backdrop="static" data-toggle="modal"  onclick="getMoodAttachImage(' + index + ')">查看心情配图 </button>';
    }

    //打开发表心情面板
    function openPublishMooddlg() {
        $('#publishMooddlg').modal('show');
    }

    //打开删除文章提示对话框
    function openDeleteProductionDlg() {
        //清空信息
        $('#deleteContent').html('');
        var rows = $("#moodTable").bootstrapTable('getSelections');
        if (rows.length > 0) {
            for (var i = 0; i < rows.length; i++) {
                var m_content = rows[i]['m_content'];
                if (m_content.length > 50) {
                    m_content = m_content.substring(0, 25);
                }
                $('#deleteContent').append('<div style="padding:10px">' + m_content + '</div>');
            }
            //打开删除对框架
            $('#confirmDlg').modal('show');
        } else {
            alert("请先选择要删除的行!");
        }
    }

    //删除心情(批量的)
    function deleteMood() {
        var rows = $("#moodTable").bootstrapTable('getSelections');
        var allMoodId = '';
        for (var i = 0; i < rows.length; i++) {
            allMoodId += rows[i]['m_id'] + ",";
        }
        allMoodId = allMoodId.substring(0, allMoodId.length - 1);
        $.ajax({
            url: 'deleteMood',
            type: 'post',
            data: {
                allMoodId: allMoodId
            },
            timeout: 20000,
            success: function (data) {
                if (data == "ok") {
                    alert("成功删除" + rows.length + "条记录!");
                    //关闭对话框
                    $('#confirmDlg').modal('hide');
                    //重新加载数据
                    $("#moodTable").bootstrapTable('refresh', {url: 'getMoodData'});
                } else {
                    alert("操作失败");
                }
            },
            error: function (XMLHttpRequest, textStatus, errorThrown) {
                alert("访问后台发生错误:" + XMLHttpRequest.status);
            }
        });
    }

    //查看心情配图
    function getMoodAttachImage(index) {
        //获取心情ID
        var m_id = $("#moodTable").bootstrapTable('getData')[index]['m_id'];
        $.ajax({
            url: 'getMoodAttachImage',
            type: 'post',
            data: {
                m_id: m_id
            },
            timeout: 20000,
            success: function (data) {
                if (data == "no data") {
                    $('#attchImgArea').html('<div style="padding:10px;text-align:center;color:red">无配图!</div>');
                } else {
                    $('#attchImgArea').html('');
                    //将获取到的图片显示到对话框中
                    for (var i = 0; i < data.length; i++) {
                        $('#attchImgArea').append('<div style="padding:10px;float:left"><img style="width:200px" src="' + data[i] + '"></div>');
                    }
                }
                $('#moodAttachImageDlg').modal('show');
            },
            error: function (XMLHttpRequest, textStatus, errorThrown) {
                alert("访问后台发生错误:" + XMLHttpRequest.status);
            }
        });
    }

    //获取当前位置
    function getNowPosition(){
        if (navigator.geolocation){
            navigator.geolocation.getCurrentPosition(showPosition,showError);
        }else{
            alert("浏览器不支持地理定位。");
        }
    }

    function showPosition(position){
        var latlon = position.coords.latitude+','+position.coords.longitude;

        //调用百度地图,5秒过时
        var url = "http://api.map.baidu.com/geocoder/v2/?ak=C93b5178d7a8ebdb830b9b557abce78b&callback=renderReverse&location="+latlon+"&output=json&pois=0";
        $.ajax({
            type: "GET",
            dataType: "jsonp",
            url: url,
            timeout:5000,
            success: function (json) {
                //成功获取位置
                if(json.status==0){
                    //将位置加载到地址控件中
                    $('#nowLocation').val(json.result.formatted_address);
                }
            },
            error: function (XMLHttpRequest, textStatus, errorThrown) {
                alert(latlon+"地址位置获取失败");
            }
        });
    }

    //定位失败提示信息
    function showError(error){
        switch(error.code) {
            case error.PERMISSION_DENIED:
                alert("定位失败,用户拒绝请求地理定位");
                break;
            case error.POSITION_UNAVAILABLE:
                alert("定位失败,位置信息是不可用");
                break;
            case error.TIMEOUT:
                alert("定位失败,请求获取用户位置超时");
                break;
            case error.UNKNOWN_ERROR:
                alert("定位失败,定位系统失效");
                break;
        }
    }
</script>

</#macro>