package cn.lwy.website.service;

import com.jfinal.aop.Before;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Record;
import com.jfinal.plugin.activerecord.tx.Tx;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

/**
 * Created by lwy on 2017/6/22.
 */
public class FriendLinkService {
    //添加友情链接
    public boolean addFriendLink(String fl_link_text,String fl_link_url){
        Record record=new Record();
        record.set("fl_link_text",fl_link_text);
        record.set("fl_link_url",fl_link_url);
        record.set("gmt_modified",new SimpleDateFormat("yyyy/MM/dd HH:mm:ss").format(new Date()));
        return Db.save("friendLink",record);
    }

    //获取友情链接列表
    public List<Record> getFriendLinkList(){
        return Db.find("select * from friendLink");
    }

    //修改友情链接
    public int updateFriendLink(String fl_id,String fl_link_text,String fl_link_url){
        String now=new SimpleDateFormat("yyyy/MM/dd HH:mm:ss").format(new Date());
        return Db.update("update friendLink set fl_link_text=?,fl_link_url=?,gmt_modified=? where fl_id=?",fl_link_text,fl_link_url,now,fl_id);
    }

    //删除友情链接
    @Before(Tx.class)
    public void deleteFriendLink(String allFriendLink){
        String[] ss=allFriendLink.split(",");
        for(String s:ss){
            Db.deleteById("friendLink","fl_id",s);
        }
    }
}
