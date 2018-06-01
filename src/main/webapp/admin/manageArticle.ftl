<#macro head>
<script type="text/javascript" src="${base}/ckEditor/ckeditor.js"></script>
</#macro>
<#macro body>
<div style="padding: 10px">
    <div id="toolbar" class="btn-group">
        <div style="float:left;margin-right: 10px">
            <button type="button" class="btn btn-info" data-backdrop="static" data-toggle="modal"
                    onclick="getPublishArticlePage()">
                发表文章
            </button>
        </div>
        <div style="float:left">
            <button type="button" class="btn btn-info" onclick="openDeleteArticleDlg()">删除</button>
        </div>
    </div>
    <div>
        <span style="font-size: medium;color: #2aabd2">文章状态:</span>
        <select class="combobox" id="articleStatus" onchange="getArticleTableData()" style="margin-top: 5px;">
            <option value="publish">已发表</option>
            <option value="draft">草稿</option>
        </select>
    </div>
    <!--bootstrap table-->
    <table id="articleTable">
        <thead>
        <tr>
            <th data-field="state" data-checkbox="true"></th>
            <th class="col-xs-4" data-field="a_id" data-align="center">文章号</th>
            <th class="col-xs-1" data-field="a_title" data-align="center">文章标题</th>
            <th class="col-xs-1" data-field="a_publisher" data-align="center">发布者</th>
            <th class="col-xs-6" data-field="a_publish_time" data-align="center">发表时间</th>
            <th class="col-xs-6" data-field="a_type" data-align="center">文章类型</th>
            <th class="col-xs-6" data-field="a_recommend" data-align="center">是否推荐</th>
            <th class="col-xs-6" data-field="gmt_modified" data-align="center">修改时间</th>
            <th class="col-xs-6" data-field="a_attach_label" data-align="center">关联的标签</th>
            <th data-field="operation" data-formatter="actionFormatter" data-events="actionEvents" data-align="center">
                操作
            </th>
        </tr>
        </thead>
    </table>
    <!--修改文章对话框-->
    <div id="alterArticledlg" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel"
         aria-hidden="true">
        <div class="modal-header">
            <h3 id="myModalLabel">修改文章</h3>
        </div>
        <div class="modal-body">
            <form id="articleFm">
                <table>
                    <tr>
                        <td>
                            <label class="control-label" for="l_name">文章标题：</label>
                        </td>
                        <td>
                            <input id="a_title" type="text">
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <label class="control-label" for="trueName">发表人:</label>
                        </td>
                        <td>
                            <input id="a_publisher" type="text">
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <label class="control-label" for="trueName">发表时间:</label>
                        </td>
                        <td>
                            <input type="text" id="a_publish_time">
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <label class="control-label" for="trueName">文章类型:</label>
                        </td>
                        <td>
                            <select class="combobox" id="a_type">
                                <option value="原创">原创</option>
                                <option value="转载">转载</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <label class="control-label" for="trueName">关联标签:</label>
                        </td>
                        <td>
                            <span style="color: red" id="nowSelectLabel">暂无选择的标签</span>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <label class="control-label" for="trueName">选择新标签:</label>
                        </td>
                        <td>
                            <select class="combobox" id="a_attach_label">
                                <#list allArticleLabel as item>
                                    <option value="${item.l_id}">${item.l_name}</option>
                                </#list>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <label class="control-label" for="trueName">标签操作:</label>
                        </td>
                        <td>
                            <button type="button" class="btn btn-info" onclick="getArticleLabel()">选择下拉框中的标签</button>
                            <button type="button" class="btn btn-info" onclick="clearLabel()">清空已选所有标签</button>
                        </td>
                    </tr>
                </table>
            </form>
        </div>
        <div class="modal-footer">
            <button class="btn" data-dismiss="modal" aria-hidden="true">关闭
            </button>
            <button class="btn btn-primary" onclick="saveModifiedArticleExceptContent()">保存</button>
        </div>
    </div>
    <!-- 修改文章内容对话框 -->
    <div id="alterArticleContentdlg" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel"
         aria-hidden="true" style="width:70%;left:35%;z-index=0">
        <div class="modal-header">
            <h3 id="myModalLabel">修改文章内容</h3>
        </div>
        <div class="modal-body">
            <!-- CKeditor区域 -->
            <div style="margin-bottom: 10px; margin-top: 5px" id="ckEditor">
                <textarea name="CkEditor" id="CkEditor"></textarea>
            </div>
        </div>
        <div class="modal-footer">
            <button class="btn" data-dismiss="modal" aria-hidden="true">关闭
            </button>
            <button class="btn btn-primary" onclick="saveModifiedArticleContent()">保存</button>
        </div>
    </div>
    <!--确认删除文章对话框-->
    <div id="confirmDlg" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel"
         aria-hidden="true">
        <div class="modal-header">
            <h3 id="myModalLabel">删除文章</h3>
        </div>
        <div class="modal-body">
            <div style="margin:10px;">
                确定删除以下文章吗?该文章相关联的标签也会被删除!
            </div>
            <div id="deleteContent">

            </div>
        </div>
        <div class="modal-footer">
            <button class="btn" data-dismiss="modal" aria-hidden="true">取消
            </button>
            <button class="btn btn-primary" onclick="deleteArticle()">确定</button>
        </div>
    </div>
</div>

<script type="text/javascript">
    var nowSelectArticleRowIndex;
    if (CKEDITOR.instances['CkEditor']) {
        CKEDITOR.remove(CKEDITOR.instances['CkEditor']);
    }
    //初始化CKeditor
    CKEDITOR.replace('CkEditor', {
        //保存文章图片路径
        filebrowserImageUploadUrl: 'uploadArticleAttachFile',
        language: 'zh-cn',
        height: '500px',
        width: '100%'
    });

    /*初始化table数据*/
    $(function () {
        $("#articleTable").bootstrapTable({
            url: 'getArticleExceptContent?articleStatus=publish',
            method: 'get',
            search:true,
            showRefresh:true,
            showToggle:true,
            showColumns:true,
            toolbar:"#toolbar",
            pagination:true,
            pageNumber:1,
            pageSize:10,
            pageList: [20, 40, 60, 80,100],
        });
    });    //向服务器发送保存标签的请求

    //格式化操作按钮
    function actionFormatter(value, row, index) {
        if (row['a_publish_time'] == null) {
            return '<button type="button" class="btn btn-info" data-backdrop="static" data-toggle="modal"  onclick="openAlterArticledlg(' + index + ')">修改 </button>&nbsp;&nbsp;<button type="button" class="btn btn-info" data-backdrop="static" data-toggle="modal"  onclick="openAlterArticleContentdlg(' + index + ')">修改草稿内容 </button>&nbsp;&nbsp;<button type="button" class="btn btn-info" data-backdrop="static" data-toggle="modal"  onclick="realPublishArticle(' + row['a_id'] + ')">正式发表 </button>';
        } else {
            if (row['a_recommend'] == "不推荐") {
                return '<button type="button" class="btn btn-info" data-backdrop="static" data-toggle="modal"  onclick="openAlterArticledlg(' + index + ')">修改 </button>&nbsp;&nbsp;<button type="button" class="btn btn-info" data-backdrop="static" data-toggle="modal"  onclick="openAlterArticleContentdlg(' + index + ')">修改文章内容 </button>&nbsp;&nbsp;<button type="button" class="btn btn-info" data-backdrop="static" data-toggle="modal"  onclick="setRecommendArticle(' + row['a_id']+','+true + ')">推荐该文章 </button>';
            } else {
                return '<button type="button" class="btn btn-info" data-backdrop="static" data-toggle="modal"  onclick="openAlterArticledlg(' + index + ')">修改 </button>&nbsp;&nbsp;<button type="button" class="btn btn-info" data-backdrop="static" data-toggle="modal"  onclick="openAlterArticleContentdlg(' + index + ')">修改文章内容 </button>&nbsp;&nbsp;<button type="button" class="btn btn-info" data-backdrop="static" data-toggle="modal"  onclick="setRecommendArticle(' + row['a_id'] +','+false +  ')">取消推荐 </button>';
            }
        }
    }

    //当下拉框内容发生改变时获取新的数据
    function getArticleTableData() {
        var articleStatus = $('#articleStatus').val();
        $.ajax({
            url: 'getArticleExceptContent?articleStatus=' + articleStatus,
            type: 'get',
            timeout: 20000,
            success: function (data) {
                $("#articleTable").bootstrapTable('load', data);
            },
            error: function (XMLHttpRequest, textStatus, errorThrown) {
                alert("访问后台发生错误:" + XMLHttpRequest.status)
            }
        });
    }

    //获取发表文章页面
    function getPublishArticlePage() {
        location.href = "getPublishArticlePage";
    }

    //打开修改文章面板
    function openAlterArticledlg(index) {
        nowSelectArticleRowIndex = index;
        //获取当前行数据
        var row = $("#articleTable").bootstrapTable('getData')[index];
        //加载数据
        $('#a_title').val(row['a_title']);
        $('#a_publish_time').val(row['a_publish_time']);
        $('#a_publisher').val(row['a_publisher']);
        $('#a_type').val(row['a_type']);
        $('#nowSelectLabel').text(row['a_attach_label']);
        $('#alterArticledlg').modal('show');
        //当发表时间没有内容说明是草稿,将时间框设置为不可用
        if ($('#a_publish_time').val() == "") {
            $('#a_publish_time').attr("disabled", "disabled");
        } else {
            $('#a_publish_time').removeAttr("disabled");
        }
    }

    //打开修改文章内容面板
    function openAlterArticleContentdlg(index) {
        nowSelectArticleRowIndex = index;
        //获取当前行数据
        var row = $("#articleTable").bootstrapTable('getData')[index];
        //发送获取文章内容的请求
        $.ajax({
            url: 'getArticleContent?articleId=' + row['a_id'],
            type: 'get',
            timeout: 20000,
            success: function (data) {
                //加载数据
                CKEDITOR.instances.CkEditor.setData(data);
            },
            error: function (XMLHttpRequest, textStatus, errorThrown) {
                alert("访问后台发生错误:" + XMLHttpRequest.status)
            }
        });
        $('#alterArticleContentdlg').modal('show');
    }

    //获取下拉框里面的内容
    function getArticleLabel() {
        //追加内容
        if ($('#nowSelectLabel').text() == '暂无选择的标签') {
            $('#nowSelectLabel').text('');
            $('#nowSelectLabel').append($("#a_attach_label").find("option:selected").text());
        } else {     //判断是否已经加入了该标签
            var arr = $("#nowSelectLabel").text().split(',');
            var now = $("#a_attach_label").find("option:selected").text();
            for (var i = 0; i < arr.length; i++) {
                if (now == arr[i]) {
                    alert('该标签已被选择!');
                    return;
                }
            }
            $('#nowSelectLabel').append("," + $("#a_attach_label").find("option:selected").text());
        }
    }

    //清空标签
    function clearLabel() {
        $('#nowSelectLabel').text('暂无选择的标签');
    }

    //更新文章内容
    function saveModifiedArticleContent() {
        var articleContent = CKEDITOR.instances.CkEditor.getData();
        if (articleContent == '') {
            alert("文章内容不能为空");
            return;
        }
        var articleId = $("#articleTable").bootstrapTable('getData')[nowSelectArticleRowIndex]['a_id'];
        $.ajax({
            url: 'saveModifiedArticleContent',
            type: 'post',
            data: {
                articleId: articleId,
                articleContent: articleContent
            },
            timeout: 20000,
            success: function (data) {
                if (data == "ok") {
                    alert("文章内容更新成功!")
                    //关闭对话框
                    $('#alterArticleContentdlg').modal('hide');
                    //重新加载数据
                    var articleStatus = $('#articleStatus').val();
                    $("#articleTable").bootstrapTable('refresh', {url: 'getArticleExceptContent?articleStatus=' + articleStatus});
                } else {
                    alert("操作失败");
                }
            },
            error: function (XMLHttpRequest, textStatus, errorThrown) {
                alert("访问后台发生错误:" + XMLHttpRequest.status)
            }
        });
    }

    //更新文章非主体内容
    function saveModifiedArticleExceptContent() {
        var articleId = $("#articleTable").bootstrapTable('getData')[nowSelectArticleRowIndex]['a_id'];
        var a_title = $('#a_title').val();
        var a_publish_time = $('#a_publish_time').val();
        var a_publisher = $('#a_publisher').val();
        var a_type = $('#a_type').val();
        //直接获取标签名
        var a_attach_label = $("#nowSelectLabel").text();
        if (a_title == '') {
            alert("文章标题不能为空!");
        } else if (a_publish_time == '' && $('#articleStatus').val() == "publish") {
            alert("文章发表时间不能为空!");
        }
        else if (a_publisher == '') {
            alert("文章发表者不能为空!");
        }
        else if (a_type == '') {
            alert("文章类型不能为空!");
        }
        else if (a_attach_label == '暂无选择的标签') {
            alert("文章关联的标签不能为空!");
        } else {
            $.ajax({
                url: 'saveModifiedArticleExceptContent',
                type: 'post',
                data: {
                    a_id: articleId,
                    a_title: a_title,
                    a_publish_time: a_publish_time,
                    a_publisher: a_publisher,
                    a_type: a_type,
                    a_attach_label: a_attach_label
                },
                timeout: 20000,
                success: function (data) {
                    if (data == "ok") {
                        alert("文章更新成功!");
                        //关闭对话框
                        $('#alterArticledlg').modal('hide');
                        var articleStatus = $('#articleStatus').val();
                        //重载新数据
                        $("#articleTable").bootstrapTable('refresh', {url: 'getArticleExceptContent?articleStatus=' + articleStatus});
                    } else {
                        alert("操作失败");
                    }
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {
                    alert("访问后台发生错误:" + XMLHttpRequest.status)
                }
            });
        }
    }

    //打开删除文章提示对话框
    function openDeleteArticleDlg() {
        //清空信息
        $('#deleteContent').html('');
        var rows = $("#articleTable").bootstrapTable('getSelections');
        if (rows.length > 0) {
            for (var i = 0; i < rows.length; i++) {
                $('#deleteContent').append('<div style="padding:10px">' + rows[i]['a_title'] + '</div>');
            }
            //打开删除对框架
            $('#confirmDlg').modal('show');
        } else {
            alert("请先选择要删除的行!");
        }
    }

    //删除文章(批量的)
    function deleteArticle() {
        var rows = $("#articleTable").bootstrapTable('getSelections');
        var allArticleId = '';
        for (var i = 0; i < rows.length; i++) {
            allArticleId += rows[i]['a_id'] + ",";
        }
        allArticleId = allArticleId.substring(0, allArticleId.length - 1);
        $.ajax({
            url: 'deleteArticle',
            type: 'post',
            data: {
                allArticleId: allArticleId
            },
            timeout: 20000,
            success: function (data) {
                if (data == "ok") {
                    alert("成功删除" + rows.length + "条记录!");
                    //关闭对话框
                    $('#confirmDlg').modal('hide');
                    //重新加载数据
                    var articleStatus = $('#articleStatus').val();
                    $("#articleTable").bootstrapTable('refresh', {url: 'getArticleExceptContent?articleStatus=' + articleStatus});
                } else {
                    alert("操作失败");
                }
            },
            error: function (XMLHttpRequest, textStatus, errorThrown) {
                alert("访问后台发生错误:" + XMLHttpRequest.status)
            }
        });
    }

    //正式发表文章
    function realPublishArticle(a_id) {
        if (confirm("确定发表文章吗?")) {
            $.ajax({
                url: 'realPublishArticle',
                type: 'post',
                data: {
                    a_id: a_id
                },
                timeout: 20000,
                success: function (data) {
                    if (data == "ok") {
                        alert("成功发表!");
                        //重新加载数据
                        var articleStatus = $('#articleStatus').val();
                        $("#articleTable").bootstrapTable('refresh', {url: 'getArticleExceptContent?articleStatus=' + articleStatus});
                    } else {
                        alert("操作失败");
                    }
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {
                    alert("访问后台发生错误:" + XMLHttpRequest.status)
                }
            });
        }
    }

    //设置文章推荐
    function setRecommendArticle(a_id,a_recommend){
        $.ajax({
            url: 'setArticleRecommend',
            type: 'post',
            data: {
                a_id: a_id,
                a_recommend: a_recommend
            },
            timeout: 20000,
            success: function (data) {
                if (data == "ok") {
                    alert("更新成功!")
                    //重新加载数据
                    var articleStatus = $('#articleStatus').val();
                    $("#articleTable").bootstrapTable('refresh', {url: 'getArticleExceptContent?articleStatus=' + articleStatus});
                } else {
                    alert("操作失败");
                }
            },
            error: function (XMLHttpRequest, textStatus, errorThrown) {
                alert("访问后台发生错误:" + XMLHttpRequest.status)
            }
        });
    }
</script>

</#macro>