<#macro head>
<script type="text/javascript" src="${base}/ckEditor/ckeditor.js"></script>
</#macro>
<#macro body>
<div style="padding: 5px 10px">
    <table style="width: 100%;">
        <tr>
            <td align="right">
                <label class="control-label" for="l_name">文章标题：</label>
            </td>
            <td>
                <input type="text" id="articleTitle">
            </td>
            <td align="right">
                <label class="control-label" for="l_name">发表人: </label>
            </td>
            <td>
                <input type="text"  id="publisher">
            </td>
            <td align="right">
                <label class="control-label" for="l_name">文章类型: </label>
            </td>
            <td>
                <select class="combobox" id="articleType">
                    <option value="原创">原创</option>
                    <option value="转载">转载</option>
                </select>
            </td>
        </tr>

        <tr>
            <td align="right">
                <label class="control-label" for="l_name">文章标签: </label>
            </td>
            <td colspan="5">
                <div style="float: left">
                    <select class="combobox" id="articleLabel">
                        <#list allArticleLabel as item>
                            <option value="${item.l_id}">${item.l_name}</option>
                        </#list>
                    </select>
                </div>
                <div style="float: left;margin-left:2%">
                    <button type="button" class="btn btn-info" onclick="getArticleLabel()">选择下拉框中的标签</button>
                    <button type="button" class="btn btn-info" onclick="clearLabel()">清空已选所有标签</button>
                    &nbsp;&nbsp;<span style="color: #0A9DDA">已选标签: </span><span style="color: red" id="nowSelectLabel">暂无选择的标签</span>
                </div>
            </td>

        </tr>
        <tr>
            <td align="right">
                <label class="control-label" for="l_name">文章内容: </label>
            </td>
            <td colspan="5">
                <!-- CKeditor区域 -->
                <div style="margin-bottom: 10px; margin-top: 10px" id="ckEditor">
                    <textarea name="CkEditor" id="CkEditor"></textarea>
                </div>
            </td>
        </tr>
    </table>
    <div style="float: right; margin-right: 10%">
        <button type="button" class="btn btn-info" onclick="clearContent()">清空已填内容</button>
        <button type="button" class="btn btn-info" onclick="saveArticle('draft')">保存草稿</button>
        <button type="button" class="btn btn-info" onclick="articlePreview()">文章预览</button>
        <button type="button" class="btn btn-info" onclick="saveArticle('publish')">确认发表</button>
    </div>
</div>
<script type="text/javascript">
    //全局变量,保存当前被选择的
    //文章所关联的标签
    var nowSelectLabel = '';  //一定要初始化,不然就其值就是undifined
    //文章标题
    var articleTitle='';
    //发表人
    var publisher='';
    //文章类型
    var articleType='';
    //文章内容
    var articleContent='';
    if (CKEDITOR.instances['CkEditor']) {
        CKEDITOR.remove(CKEDITOR.instances['CkEditor']);
    }
    //初始化CKeditor
    CKEDITOR.replace('CkEditor', {
        //保存文章图片路径
        filebrowserImageUploadUrl: 'uploadArticleAttachFile',
        language: 'zh-cn',
        height: '230px',
        width: '92.5%'
    });
    //获取下拉框里面的内容
    function getArticleLabel() {
        //追加内容
        if ($('#nowSelectLabel').text() == '暂无选择的标签') {
            $('#nowSelectLabel').text('');
            $('#nowSelectLabel').append($("#articleLabel").find("option:selected").text());
            nowSelectLabel += $('#articleLabel').val();
        } else {     //判断是否已经加入了该标签
            var arr = nowSelectLabel.split(',');
            var now = $('#articleLabel').val();
            for (var i = 0; i < arr.length; i++) {
                if (now == arr[i]) {
                    alert('该标签已被选择!');
                    return;
                }
            }
            $('#nowSelectLabel').append("," + $("#articleLabel").find("option:selected").text());
            nowSelectLabel += "," + $('#articleLabel').val();
        }
    }

    //清空标签
    function clearLabel() {
        $('#nowSelectLabel').text('暂无选择的标签');
        nowSelectLabel = '';
    }

    //进行文章预览,打开一个新的页面,在新的页面进行文章内容显示
    function articlePreview() {

    }

    //进行将文章保存为草稿或者是实际发布
    function saveArticle(type){
        getArticleContent();
        if(articleTitle==''){
            alert("请填写文章标题!");
        }else if(publisher==''){
            alert("请填写文章作者!");
        }else if(nowSelectLabel==''){
            alert("请选择文章所在标签!");
        }else if(articleContent==''){
            alert("请填写文章内容!");
        }else {
            $.ajax({
                url: 'saveArticle',
                type: 'post',
                data: {
                    saveType: type,
                    articleTitle: articleTitle,
                    publisher: publisher,
                    articleType: articleType,
                    articleContent: articleContent,
                    nowSelectLabel: nowSelectLabel
                },
                timeout: 20000,
                success: function (data) {
                    if (data == 'ok') {
                        alert('添加成功');
                        clearContent();
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

    //获取文章内容
    function getArticleContent(){
        articleTitle=$('#articleTitle').val();
        publisher=$('#publisher').val();
        articleType=$('#articleType').val();
        articleContent=CKEDITOR.instances.CkEditor.getData();
    }

    //清空所有内容
    function clearContent(){
        $('#articleTitle').val('');
        $('#publisher').val('');
        clearLabel();
        nowSelectLabel='';
        CKEDITOR.instances.CkEditor.setData('');
    }
</script>
</#macro>