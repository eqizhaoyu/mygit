<#macro head>
<script type="text/javascript" src="${base}/ckEditor/ckeditor.js"></script>
<link href="/admin/bootstrap-fileinput/css/fileinput.css" media="all" rel="stylesheet" type="text/css" />
<script src="/admin/bootstrap-fileinput/js/fileinput.js" type="text/javascript"></script>
<script src="/admin/bootstrap-fileinput/js/locales/zh.js" type="text/javascript"></script>
</#macro>
<#macro body>
<div style="padding: 10px">
    <div id="toolbar" class="btn-group">
        <div style="float:left;margin-right: 10px">
            <button type="button" class="btn btn-info" data-backdrop="static" data-toggle="modal"
                    onclick="openOperateAlterProductiondlg('add',0)">
                添加作品
            </button>
        </div>
        <div style="float:left">
            <button type="button" class="btn btn-info" onclick="openDeleteProductionDlg()">删除作品</button>
        </div>
    </div>
    <!--bootstrap table-->
    <table id="productionTable" data-search="true"
           data-show-refresh="true"
           data-show-toggle="true"
           data-show-columns="true"
           data-toolbar="#toolbar"
           data-query-params="queryParams"
           data-pagination="true"
           pageNumber:1,
           pageSize: 10,
           pageList: [10, 25, 50, 100]>
        <thead>
        <tr>
            <th data-field="state" data-checkbox="true"></th>
            <th class="col-xs-4" data-field="p_id" data-align="center">作品号</th>
            <th class="col-xs-1" data-field="p_name" data-align="center">作品名</th>
            <th class="col-xs-1" data-field="p_developer" data-align="center">作者</th>
            <th class="col-xs-6" data-field="gmt_modified" data-align="center">编辑时间</th>
            <th class="col-xs-6" data-field="p_type" data-align="center">作品类型</th>
            <th data-field="operation" data-formatter="actionFormatter" data-events="actionEvents" data-align="center">
                操作
            </th>
        </tr>
        </thead>
    </table>
    <!--添加/修改作品对话框-->
    <div id="alterProductiondlg" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel"
         aria-hidden="true" style="width:60%;left:550px">
        <div class="modal-header">
            <h3 id="myModalLabel">修改作品内容</h3>
        </div>
        <div class="modal-body">
                <table>
                    <tr>
                        <td align="right">
                            <label class="control-label" for="l_name">作品名称：</label>
                        </td>
                        <td>
                            <input id="p_name" type="text">
                        </td>
                    </tr>
                    <tr>
                        <td align="right">
                            <label class="control-label" for="trueName">作者:</label>
                        </td>
                        <td>
                            <input id="p_developer" type="text">
                        </td>
                    </tr>
                    <tr>
                        <td align="right">
                            <label class="control-label" for="trueName">作品类型:</label>
                        </td>
                        <td>
                            <select class="combobox" id="p_type">
                                <option value="小游戏">小游戏</option>
                                <option value="网站">网站</option>
                                <option value="B/S系统">B/S系统</option>
                                <option value="移动APP">移动APP</option>
                            </select>
                        </td>
                    </tr>
                    <tr id="productionCoverImageTr">
                        <td align="right">
                            <label class="control-label" for="trueName">作品当前配图:</label>
                        </td>
                        <td>
                            <img id="productionCoverImage" style="width:170px">
                        </td>
                    </tr>
                </table>

                    <input id="productionConver" name="productionConver" class="file" type="file" multiple data-min-file-count="1">

                <!-- CKeditor区域 -->
                <div style="margin-bottom: 10px; margin-top: 20px" id="ckEditor">
                    <textarea name="CkEditor" id="CkEditor"></textarea>
                </div>
        </div>
        <div class="modal-footer">
            <button class="btn" data-dismiss="modal" aria-hidden="true">关闭
            </button>
            <button class="btn btn-primary" onclick="operateProduction()">保存</button>
        </div>
    </div>

    <!--确认删除作品对话框-->
    <div id="confirmDlg" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel"
         aria-hidden="true">
        <div class="modal-header">
            <h3>删除作品</h3>
        </div>
        <div class="modal-body">
            <div style="margin:10px;">
                确定删除以下作品吗?
            </div>
            <div id="deleteContent">

            </div>
        </div>
        <div class="modal-footer">
            <button class="btn" data-dismiss="modal" aria-hidden="true">取消
            </button>
            <button class="btn btn-primary" onclick="deleteProduction()">确定</button>
        </div>
    </div>
</div>
<script type="text/javascript">
    var nowSelectProductionId;
    var productonCoverImageUrl=''; //保存文件上传的路径值,需要保存到数据库,默认值为空
    if (CKEDITOR.instances['CkEditor']) {
        CKEDITOR.remove(CKEDITOR.instances['CkEditor']);
    }
    //初始化CKeditor
    CKEDITOR.replace('CkEditor', {
        //保存文章图片路径
        filebrowserImageUploadUrl: 'saveProductionContactFile',
        language: 'zh-cn',
        height: '500px',
        width: '100%'
    });
    //初始化bootstrap-input
    $("#productionConver").fileinput({
        uploadUrl:'saveProductionCover', // 后台使用js方法
        uploadAsync: false,
        minFileCount: 1,
        maxFileCount: 1,
        language : 'zh',
        msgFilesTooMany:'1',
        allowedFileExtensions: ['jpg','png','jpeg'],
        initialPreviewAsData: true // identify if you are sending preview data only and not the markup
    }).on('filebatchpreupload', function(event, data) {
        if($('.imgClass').length>=1){
            var img = $(".kv-preview-thumb");
            img[3].remove();
            $(".kv-upload-progress").addClass("hide");
            return {
                message: "最多只能上传一张!"
            };
        }
    });

    $('#productionConver').on('filebatchuploadsuccess', function(event, data, previewId, index) {
        var response = data.response;
        productonCoverImageUrl=response['pathUrl'];
        $('.file-caption-name').append('&nbsp;&nbsp;图片上传成功:完整文件路径:<span style="color:red">'+response['pathUrl']+'</span>')
    });
    $(".fileinput-remove-button").on("click",function(){  //删除按钮
        $('.imgClass').remove();
    });

    //操作作品信息
    function operateProduction(){
        var type='';
        if($('#productionCoverImageTr').css("display")=="none"){
            type="add";
        }else{
            type="update";
        }
        var p_name=$('#p_name').val();
        var p_developer=$('#p_developer').val();
        var p_type=$('#p_type').val();
        var p_brief=CKEDITOR.instances.CkEditor.getData();
        //客户端验证
        if(p_name==''){
            alert('作品名不能为空!');
        }else if(p_developer==''){
            alert('作品开发者不能为空');
        }else if(p_brief==''){
            alert('作品简介不能为空');
        }else if(productonCoverImageUrl=='') {
            alert("作品封面配图不能为空");
        }else{
            $.ajax({
                url: 'operateProduction',
                type: 'post',
                data:{
                    p_name:p_name,
                    p_developer:p_developer,
                    p_type:p_type,
                    p_brief:p_brief,
                    p_cover_url:productonCoverImageUrl,
                    operateType:type,
                    nowSelectProductionId:nowSelectProductionId
                },
                timeout: 20000,
                success: function (data) {
                    if(type=='add'){
                        alert("作品添加成功!");
                    }else if(type=="update"){
                        alert("作品修改成功!");
                        $('#alterProductiondlg').modal('hide');
                    }
                    //将当前信息清空
                    clearProductionContent();
                    //重新加载数据
                    $("#productionTable").bootstrapTable('refresh', {url: 'getAllProduction'});
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {
                    alert("访问后台发生错误:" + XMLHttpRequest.status)
                }
            });
        }
    }

    //将文本框里面的内容清空
    function clearProductionContent(){
        $('#p_name').val('');
        $('#p_developer').val('');
        $('#p_type').val('');
        CKEDITOR.instances.CkEditor.setData('');
        productonCoverImageUrl='';
        $('.close.fileinput-remove').click();
    }

    /*初始化table数据*/
    $(function () {
        $("#productionTable").bootstrapTable({
            url: 'getAllProduction'
        });
        //数据加载成功之后执行的操作
        $("#productionTable").on('load-success.bs.table', function (data) {

        });
    });    //向服务器发送保存标签的请求

    //这里面的参数是发送到服务器端的
    function queryParams() {
        return {
            type: 'owner',
            sort: 'updated',
            direction: 'desc',            //排序方向
            per_page: 10,                //一次加载数据条数
            page: 1                        //加载数据第几次
        };
    }

    //格式化操作按钮
    function actionFormatter(value, row, index) {
        return '<button type="button" class="btn btn-info" data-backdrop="static" data-toggle="modal"  onclick="openOperateAlterProductiondlg(\'edit\',' + index + ')">修改 </button>';
    }

    //打开修改/添加作品面板
    function openOperateAlterProductiondlg(type,index) {
        //当是添加作品时,直接打开面板
        if(type=='add'){
            clearProductionContent();
            $('#myModalLabel').text("添加作品");
            //隐藏当前作品图片区域
            $('#productionCoverImageTr').css("display","none");
            $('#alterProductiondlg').modal('show');
        }else if(type=='edit'){
            $('#myModalLabel').text("修改作品信息");
            //现在当前作品图片区域
            $('#productionCoverImageTr').css("display","");
            //获取当前行数据
            var row = $("#productionTable").bootstrapTable('getData')[index];
            //加载数据
            $('#p_name').val(row['p_name']);
            $('#p_developer').val(row['p_developer']);
            $('#p_type').val(row['p_type']);
            nowSelectProductionId=row['p_id'];
            $('.close.fileinput-remove').click();
            //发送请求获取当前作品的内容以及封面图片
            $.ajax({
                url: 'getProductionContentById',
                type: 'post',
                data:{
                    p_id:row['p_id']
                },
                timeout: 20000,
                success: function (data) {
                    //设置当前配图路径
                    productonCoverImageUrl=data['p_cover_url'];
                    CKEDITOR.instances.CkEditor.setData(data['p_brief']);
                    $('#productionCoverImage').attr("src",data['p_cover_url']);
                    $('#alterProductiondlg').modal('show');
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {
                    alert("访问后台发生错误:" + XMLHttpRequest.status)
                }
            });
        }
    }

    //打开删除文章提示对话框
    function openDeleteProductionDlg() {
        //清空信息
        $('#deleteContent').html('');
        var rows = $("#productionTable").bootstrapTable('getSelections');
        if (rows.length > 0) {
            for (var i = 0; i < rows.length; i++) {
                //标签没有关联文章时才能进行删除
                //if (rows['relaterArticleCount'] == 0) {
                $('#deleteContent').append('<div style="padding:10px">' + rows[i]['p_name'] + '</div>');
                //}
            }
            //打开删除对框架
            $('#confirmDlg').modal('show');
        } else {
            alert("请先选择要删除的行!");
        }
    }

    //删除作品(批量的)
    function deleteProduction() {
        var rows = $("#productionTable").bootstrapTable('getSelections');
        var allProductionId='';
        for(var i=0;i<rows.length;i++){
            allProductionId+=rows[i]['p_id']+",";
        }
        allProductionId=allProductionId.substring(0,allProductionId.length-1);
        $.ajax({
            url: 'deleteProduction',
            type: 'post',
            data: {
                allProductionId: allProductionId
            },
            timeout: 20000,
            success: function (data) {
                if (data == "ok") {
                    alert("成功删除"+rows.length+"条记录!");
                    //关闭对话框
                    $('#confirmDlg').modal('hide');
                    //重新加载数据
                    $("#productionTable").bootstrapTable('refresh', {url: 'getAllProduction'});
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