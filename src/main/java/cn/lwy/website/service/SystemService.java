package cn.lwy.website.service;

import com.jfinal.plugin.activerecord.Db;

/**
 * Created by lwy on 2017/6/22.
 */
public class SystemService {
    //修改密码
    public int alterPassword(String password){
        return  Db.update("update [user] set password=? where name='lwyBlog'",password);
    }

}
