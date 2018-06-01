package cn.lwy.website.service;

import com.jfinal.plugin.activerecord.Db;

/**
 * Created by lwy on 2017/6/18.
 */
public class LoginService {
    public int userLogin(String userId,String userPassword){
        return Db.find("select * from [user] where name=? and password=?",userId,userPassword).size();
    }
}
