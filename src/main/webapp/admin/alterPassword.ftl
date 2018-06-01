<#macro body>
<div style="padding: 20px;">
    <table>
        <tr>
            <td>
                <label class="control-label" for="l_name">新密码：</label>
            </td>
            <td>
                <input id="password" type="password">
            </td>
        </tr>
        <tr>
            <td>
                <label class="control-label" for="trueName">确认密码:</label>
            </td>
            <td>
                <input id="rePassword" type="password">
            </td>
        </tr>
        <tr>
            <td colspan="2">
                <button type="button" class="btn btn-info" onclick="alterPassword()">确认修改</button>&nbsp;&nbsp;<button type="button" class="btn btn-info" onclick="reset()">重置</button>
            </td>
        </tr>
    </table>
</div>
<script type="text/javascript">
    //修改密码
    function alterPassword(){
        var password=$('#password').val();
        var rePassword=$('#rePassword').val();
        if(password=="" || rePassword==""){
            alert("密码框不能不空!")
        }else if(password!=rePassword){
            alert("密码不一致!请重新输入!")
        }else{
            $.ajax({
                url: '/system/alterPassword',
                type: 'post',
                timeout: 20000,
                data:{
                    password:password
                },
                success: function (data) {
                    if (data == 'ok') {
                        alert("密码修改成功!");
                        reset();
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

    //重置两密码框
    function reset(){
        $('#password').val('');
        $('#rePassword').val('');
    }
</script>
</#macro>