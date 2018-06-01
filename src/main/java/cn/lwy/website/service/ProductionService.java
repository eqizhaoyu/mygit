package cn.lwy.website.service;

import com.jfinal.aop.Before;
import com.jfinal.kit.PathKit;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Record;
import com.jfinal.plugin.activerecord.tx.Tx;
import net.coobird.thumbnailator.Thumbnails;

import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileInputStream;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by lwy on 2017/6/8.
 */
public class ProductionService {
    //保存作品信息
    public boolean saveProduction(String p_name, String p_developer, String p_type, String p_brief, String p_cover_url) {
        Record record = new Record();
        record.set("p_name", p_name);
        record.set("p_developer", p_developer);
        record.set("p_type", p_type);
        record.set("p_brief", p_brief);
        record.set("p_cover_url", p_cover_url);
        record.set("gmt_modified", new SimpleDateFormat("yyyy/MM/dd HH:mm:ss").format(new Date()));
        return Db.save("production", record);
    }

    public int updateProduction(String nowSelectProductionId,String p_name, String p_developer, String p_type, String p_brief, String p_cover_url){
        return Db.update("update production set p_name=?,p_developer=?,p_type=?,p_brief=?,p_cover_url=?,gmt_modified=?" +
                " where p_id=?",p_name,p_developer,p_type,p_brief,p_cover_url,new SimpleDateFormat("yyy/MM/dd HH:mm:ss").format(new Date()),nowSelectProductionId);
    }

    //获取所有作品信息
    public List<Record> getAllProduction() {
        return Db.find("select p_id,p_name,p_developer,p_type,gmt_modified from production");
    }

    //根据作品ID获取作品内容
    public Record getProductionContentById(String p_id) {
        Map<String,Object> map=new HashMap<String, Object>();
        return Db.find("select p_brief,p_cover_url from production where p_id=?",p_id).get(0);
    }

    public String saveProductionContactFile(String f_name, String f_url, String f_description, String f_type, String f_link_type) {
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("f_name", f_name);
        map.put("f_url", f_url);
        map.put("f_description", f_description);
        map.put("f_type", f_type);
        map.put("f_link_type", f_link_type);
        map.put("gmt_modified", new SimpleDateFormat("yyyy/MM/dd HH:mm:ss").format(new Date()));
        Record record = new Record().setColumns(map);
        Db.save("[file]", record);
        //返回刚刚插入的文件自动生成的ID
        return record.get("id").toString();
    }

    //获取要下载的文件路径
    public String getDownLoadFilePath(String fileId) {
        return Db.findById("[file]", "f_id", fileId).get("f_url");
    }

    //删除作品
    @Before(Tx.class)
    public void deleteProduction(String allProductionId){
        String[] ss=allProductionId.split(",");
        for(String s:ss){
            Db.deleteById("production","p_id",s);
        }
    }

    //压缩图片
    public void compressImage(String url) throws Exception{
            //取出每张刚保存的图片
            String imageUrl= PathKit.getWebRootPath()+url;
            BufferedImage bimg = ImageIO.read(new File(imageUrl));
            int originalWidth = bimg.getWidth();
            //将图片宽度压缩到250px
            //修改原图的大小
            File file = new File(imageUrl);
            Thumbnails.of(new FileInputStream(file)).scale(250*1.0/originalWidth).toFile(new File(imageUrl));
    }
}
