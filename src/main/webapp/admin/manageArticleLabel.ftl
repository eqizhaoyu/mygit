<#macro body>
<div style="padding: 10px">
    <div id="toolbar" class="btn-group">
        <div style="float:left;margin-right: 10px">
            <button type="button" class="btn btn-primary" data-backdrop="static" data-toggle="modal"
                    onclick="openDlg('add',0)">
                新增
            </button>
        </div>
        <div style="float:left">
            <button type="button" class="btn btn-primary" onclick="openDeleteArticleLabelDlg()">删除</button>
        </div>
    </div>
    <h4>当前已有标签列表</h4>
    <!--bootstrap table-->
    <table id="articleLabelTable">
        <thead>
        <tr>
            <th data-field="state" data-checkbox="true"></th>
            <th class="col-xs-4" data-field="l_id" data-align="center">标签号</th>
            <th class="col-xs-1" data-field="l_name" data-align="center">标签名</th>
            <th class="col-xs-1" data-field="l_description" data-align="center">标签描述</th>
            <th class="col-xs-6" data-field="gmt_modified" data-align="center">修改时间</th>
            <th class="col-xs-6" data-field="relaterArticleCount" data-align="center">关联文章数</th>
            <th data-field="operation" data-formatter="actionFormatter" data-events="actionEvents" data-align="center">
                操作
            </th>
        </tr>
        </thead>
    </table>
    <!--保存标签对话框-->
    <div id="dlg" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-header">
            <h3 id="myModalLabel">添加标签</h3>
        </div>
        <div class="modal-body">
            <form id="articleFm">
                <table>
                    <tr>
                        <td>
                            <label class="control-label" for="l_name">标签名：</label>
                        </td>
                        <td>
                            <input id="l_name" type="text">
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <label class="control-label" for="trueName">标签描述:</label>
                        </td>
                        <td>
                            <input id="l_description" type="text">
                        </td>
                    </tr>
                </table>
            </form>
        </div>
        <div class="modal-footer">
            <button class="btn" data-dismiss="modal" aria-hidden="true">关闭
            </button>
            <button class="btn btn-primary" onclick="saveOrUpdateArticleLable()">保存</button>
        </div>
    </div>
    <!--确认删除标签对话框-->
    <div id="confirmDlg" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel"
         aria-hidden="true">
        <div class="modal-header">
            <h3 id="myModalLabel">删除标签</h3>
        </div>
        <div class="modal-body">
            <div style="margin:10px;">
                确定删除以下标签吗?若该标签有相关联的文章则不能进行删除!
            </div>
            <div id="deleteContent">

            </div>
        </div>
        <div class="modal-footer">
            <button class="btn" data-dismiss="modal" aria-hidden="true">取消
            </button>
            <button class="btn btn-primary" onclick="deleteArticleLabel()">确定</button>
        </div>
    </div>
    <!--标签对应文章列表-->
    <div id="labelContactrticleDlg" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel"
         aria-hidden="true" style="width: 65%;left: 35%">
        <div class="modal-header">
            <h3>标签:<span id="nowLabel"></span>所关联的文章如下:</h3>
        </div>
        <div class="modal-body">
            <table id="labelContactrticleTable">
                <thead>
                <tr>
                    <th class="col-xs-1" data-field="a_title" data-align="center">文章标题</th>
                    <th class="col-xs-1" data-field="a_publish_time" data-align="center">发布时间</th>
                    <th class="col-xs-6" data-field="a_publisher" data-align="center">发表者</th>
                    <th class="col-xs-6" data-field="a_type" data-align="center">文章类型</th>
                    <th class="col-xs-6" data-field="a_is_draft" data-align="center">文章状态</th>
                </tr>
                </thead>
            </table>
        </div>
        <div class="modal-footer">
            <button class="btn" data-dismiss="modal" aria-hidden="true">关闭
            </button>
        </div>
    </div>
</div>

<script type="text/javascript">
    //全局变量
    //当前选中的行标签的ID
    var nowSelectRowId;
    //当前被选中行的名字
    var nowSelectRowName;
    //当前操作是修改还是增加
    var addOrEdit;
    /*初始化table数据*/
    $(function () {
        $("#articleLabelTable").bootstrapTable({
            url: 'getArticleLabelJson',
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
        //不设置URL,在进行数据获取的时候才进行加载
        $("#labelContactrticleTable").bootstrapTable({
            search:true,
            showRefresh:true,
            showToggle:true,
            showColumns:true,
            pagination:true,
            pageNumber:1,
            pageSize:10,
            pageList: [20, 40, 60, 80,100]
        });
    });    //向服务器发送保存标签的请求

    function saveArticleLable() {
        var l_name = $('#l_name').val();
        var l_description = $('#l_description').val();
        if (l_name == '') {
            alert('标签名不能为空!');
        } else if (l_name.length > 25) {     //js中获取字符串的长度也是使用length
            alert('标签名不能超过25个字符!');
        } else if (l_description.length > 50) {
            alert('标签描述不能超过50个字符!');
        } else {
            $.ajax({
                url: 'saveArticleLabel',
                type: 'post',
                data: {
                    l_name: $('#l_name').val(),
                    l_description: $('#l_description').val()
                },
                timeout: 20000,
                success: function (data) {
                    if (data == 'ok') {
                        //关闭保存对话框
                        $('#dlg').modal('hide');
                        alert('添加成功');
                        $("#articleLabelTable").bootstrapTable('refresh', {url: 'getArticleLabelJson'});
                    } else if (data == 'alreadyExit') {
                        alert("该标签已存在,不能重复添加!");
                    } else {
                        alert("对不起,添加失败!");
                    }
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {
                    alert("访问后台发生错误:" + XMLHttpRequest.status)
                }
            });
        }
    }

    //格式化操作按钮
    function actionFormatter(value, row, index) {
        return '<button type="button" class="btn btn-primary" data-backdrop="static" data-toggle="modal"  onclick="openDlg(\'edit\',' + index + ')">修改 </button>&nbsp;&nbsp;<button type="button" class="btn btn-primary" data-backdrop="static" data-toggle="modal"  onclick="seeLabelRelaterticle(' + index + ')">查看关联文章 </button>';
    }

    //打开模态框
    function openDlg(action, index) {
        addOrEdit = action;
        if (action == 'add') {
            //先将表单中的数据清空
            $('#articleFm')[0].reset()
            $('#dlg').modal('show');
        } else if (action == 'edit') {
            //将该行数据加载
            var row = $("#articleLabelTable").bootstrapTable('getData')[index];
            //保存修改前的Label名
            nowSelectRowName = row['l_name'];
            $('#l_description').val(row['l_description']);
            $('#l_name').val(row['l_name']);
            //将标签ID保存起来
            nowSelectRowId = row['l_id'];
            $('#dlg').modal('show');
        }
    }

    //打开确认删除标签对话框
    function openDeleteArticleLabelDlg() {
        //清空信息
        $('#deleteContent').html('');
        var rows = $("#articleLabelTable").bootstrapTable('getSelections');
        if (rows.length > 0) {
            for (var i = 0; i < rows.length; i++) {
                //标签没有关联文章时才能进行删除
                //if (rows['relaterArticleCount'] == 0) {
                $('#deleteContent').append('<div style="padding:10px">' + rows[i]['l_name'] + '</div>');
                //}
            }
            //打开删除对框架
            $('#confirmDlg').modal('show');
        } else {
            alert("请先选择要删除的行!");
        }
    }

    //删除标签
    function deleteArticleLabel() {
        var rows = $("#articleLabelTable").bootstrapTable('getSelections');
        var allLabelId = '';
        for (var i = 0; i < rows.length; i++) {
            //if (rows['relaterArticleCount'] == 0) {
            allLabelId += rows[i]['l_id'] + ",";
            //}
        }
        //取出最后的逗号
        allLabelId = allLabelId.substring(0, allLabelId.length - 1);
        //发送删除请求
        $.ajax({
            url: 'deleteArticleLabel',
            type: 'post',
            data: {
                allLabelId: allLabelId
            },
            timeout: 20000,
            success: function (data) {
                if (data == 'ok') {
                    //关闭确认对话框
                    $('#confirmDlg').modal('hide');
                    alert("成功删除"+rows.length+"条记录!");
                    $("#articleLabelTable").bootstrapTable('refresh', {url: 'getArticleLabelJson'});
                } else {
                    alert("对不起,操作失败");
                }
            },
            error: function (XMLHttpRequest, textStatus, errorThrown) {
                alert("访问后台发生错误:" + XMLHttpRequest.status)
            }
        });
    }

    //修改标签
    function alterArticleLabel() {
        var l_name = $('#l_name').val();
        var l_description = $('#l_description').val();
        if (l_name == '') {
            alert('标签名不能为空!');
        } else if (l_name.length > 25) {     //js中获取字符串的长度也是使用length
            alert('标签名不能超过25个字符!');
        } else if (l_description.length > 50) {
            alert('标签描述不能超过50个字符!');
        } else {
            $.ajax({
                url: 'alterArticleLabel',
                type: 'post',
                data: {
                    l_id: nowSelectRowId,
                    l_name: $('#l_name').val(),
                    l_description: $('#l_description').val(),
                    pre_name: nowSelectRowName
                },
                timeout: 20000,
                success: function (data) {
                    if (data == 'ok') {
                        //关闭保存对话框
                        $('#dlg').modal('hide');
                        alert('修改成功');
                        $("#articleLabelTable").bootstrapTable('refresh', {url: 'getArticleLabelJson'});
                    } else if (data == 'alreadyExit') {
                        alert("该标签已存在,不能重复添加!");
                    } else {
                        alert("对不起,操作失败!");
                    }
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {
                    alert("访问后台发生错误:" + XMLHttpRequest.status)
                }
            });
        }
    }
    //更新获取增加标签内容
    function saveOrUpdateArticleLable() {
        if (addOrEdit == 'edit') {
            alterArticleLabel();
        } else if (addOrEdit == 'add') {
            saveArticleLable();
        }
    }

    //查看标签所关联的文章
    function seeLabelRelaterticle(index) {
        var row = $("#articleLabelTable").bootstrapTable('getData')[index];
        $.ajax({
            url: 'seeLabelRelaterticle',
            type: 'post',
            data: {
                labelId: row['l_id']
            },
            timeout: 20000,
            success: function (data) {
                //设置当前标签内容
                $('#nowLabel').text(row['l_name']);
                //加载文章内容
                $('#labelContactrticleTable').bootstrapTable("load",data);
                //打开面板
                $('#labelContactrticleDlg').modal('show');
            }
        });
    }
</script>

</#macro>