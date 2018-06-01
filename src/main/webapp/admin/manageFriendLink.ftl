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
            <button type="button" class="btn btn-primary" onclick="openDeleteFriendLinkDlg()">删除</button>
        </div>
    </div>
    <h4>当前已有友情链接列表</h4>
    <!--bootstrap table-->
    <table id="friendLinkTable">
        <thead>
        <tr>
            <th data-field="state" data-checkbox="true"></th>
            <th class="col-xs-4" data-field="fl_id" data-align="center">链接号</th>
            <th class="col-xs-1" data-field="fl_link_text" data-align="center">链接文本</th>
            <th class="col-xs-1" data-field="fl_link_url" data-align="center">链接地址</th>
            <th class="col-xs-6" data-field="gmt_modified" data-align="center">修改时间</th>
            <th data-field="operation" data-formatter="actionFormatter" data-events="actionEvents" data-align="center">
                操作
            </th>
        </tr>
        </thead>
    </table>
    <!--保存标签对话框-->
    <div id="dlg" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-header">
            <h3 id="myModalLabel">添加友情链接</h3>
        </div>
        <div class="modal-body">
            <form id="friendLinkFm">
                <table>
                    <tr>
                        <td>
                            <label class="control-label" for="l_name">链接文本：</label>
                        </td>
                        <td>
                            <input id="fl_link_text" type="text">
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <label class="control-label" for="trueName">链接地址:</label>
                        </td>
                        <td>
                            <input id="fl_link_url" type="text">
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
    <!--确认删除友情链接对话框-->
    <div id="confirmDlg" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel"
         aria-hidden="true">
        <div class="modal-header">
            <h3 id="myModalLabel">删除友情链接</h3>
        </div>
        <div class="modal-body">
            <div style="margin:10px;">
                确定删除以下友情链接吗?
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
</div>

<script type="text/javascript">
    var addOrEdit;
    var now_fl_id;
    /*初始化table数据*/
    $(function () {
        $("#friendLinkTable").bootstrapTable({
            url: 'getFriendLinkList',
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

    function addFriendLink() {
        var fl_link_text = $('#fl_link_text').val();
        var fl_link_url = $('#fl_link_url').val();
        if (fl_link_text == '') {
            alert('链接文本不能为空!');
        } else if (fl_link_text.length > 20) {     //js中获取字符串的长度也是使用length
            alert('链接文本不能超过20个字符!');
        } else if (fl_link_url == "") {
            alert('链接地址不能为空!');
        }else if(fl_link_url.length>100){
            alert('链接地址不能超过100个字符!');
        } else {
            $.ajax({
                url: 'addFriendLink',
                type: 'post',
                data: {
                    fl_link_text: fl_link_text,
                    fl_link_url: fl_link_url
                },
                timeout: 20000,
                success: function (data) {
                    if (data == 'ok') {
                        //关闭保存对话框
                        $('#dlg').modal('hide');
                        alert('添加成功');
                        $("#friendLinkTable").bootstrapTable('refresh', {url: 'getFriendLinkList'});
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
        return '<button type="button" class="btn btn-primary" data-backdrop="static" data-toggle="modal"  onclick="openDlg(\'edit\',' + index + ')">修改 </button>&nbsp;&nbsp;<button type="button" class="btn btn-primary" data-backdrop="static" data-toggle="modal"  onclick="visitFriendLink(\'' + row['fl_link_url'] + '\')">访问友情链接 </button>';
    }

    //打开模态框
    function openDlg(action, index) {
        addOrEdit = action;
        if (action == 'add') {
            //先将表单中的数据清空
            $('#friendLinkFm')[0].reset();
            $('#dlg').modal('show');
        } else if (action == 'edit') {
            //将该行数据加载
            var row = $("#friendLinkTable").bootstrapTable('getData')[index];
            $('#fl_link_text').val(row['fl_link_text']);
            $('#fl_link_url').val(row['fl_link_url']);
            now_fl_id=row['fl_id'];
            $('#dlg').modal('show');
        }
    }

    //打开确认删除友情链接对话框
    function openDeleteFriendLinkDlg() {
        //清空信息
        $('#deleteContent').html('');
        var rows = $("#friendLinkTable").bootstrapTable('getSelections');
        if (rows.length > 0) {
            for (var i = 0; i < rows.length; i++) {
                //标签没有关联文章时才能进行删除
                //if (rows['relaterArticleCount'] == 0) {
                $('#deleteContent').append('<div style="padding:10px">' + rows[i]['fl_link_text'] + '</div>');
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
        var rows = $("#friendLinkTable").bootstrapTable('getSelections');
        var allFriendLinkId = '';
        for (var i = 0; i < rows.length; i++) {
            allFriendLinkId += rows[i]['fl_id'] + ",";
        }
        //取出最后的逗号
        allFriendLinkId = allFriendLinkId.substring(0, allFriendLinkId.length - 1);
        //发送删除请求
        $.ajax({
            url: 'deleteFriendLink',
            type: 'post',
            data: {
                allFriendLink: allFriendLinkId
            },
            timeout: 20000,
            success: function (data) {
                if (data == 'ok') {
                    //关闭确认对话框
                    $('#confirmDlg').modal('hide');
                    alert("成功删除"+rows.length+"条记录!");
                    $("#friendLinkTable").bootstrapTable('refresh', {url: 'getFriendLinkList'});
                } else {
                    alert("对不起,操作失败");
                }
            },
            error: function (XMLHttpRequest, textStatus, errorThrown) {
                alert("访问后台发生错误:" + XMLHttpRequest.status)
            }
        });
    }

    //修改友情链接
    function alterFriendLink() {
        var fl_link_text = $('#fl_link_text').val();
        var fl_link_url = $('#fl_link_url').val();
        if (fl_link_text == '') {
            alert('链接文本不能为空!');
        } else if (fl_link_text.length > 20) {     //js中获取字符串的长度也是使用length
            alert('链接文本不能超过20个字符!');
        } else if (fl_link_url == "") {
            alert('链接地址不能为空!');
        }else if(fl_link_url.length>100){
            alert('链接地址不能超过100个字符!');
        } else {
            $.ajax({
                url: 'updateFriendLink',
                type: 'post',
                data: {
                    fl_link_text: fl_link_text,
                    fl_link_url: fl_link_url,
                    fl_id:now_fl_id
                },
                timeout: 20000,
                success: function (data) {
                    if (data == 'ok') {
                        //关闭保存对话框
                        $('#dlg').modal('hide');
                        alert('修改成功');
                        $("#friendLinkTable").bootstrapTable('refresh', {url: 'getFriendLinkList'});
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
            alterFriendLink();
        } else if (addOrEdit == 'add') {
            addFriendLink();
        }
    }

    //访问友情链接
    function visitFriendLink(fl_link_url){
        window.open(fl_link_url);
    }
</script>

</#macro>