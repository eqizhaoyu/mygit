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
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * Created by lwy on 2017/6/12.
 */
public class MoodService {
    public String saveMoodAttachImage(List<Record> list) {
        StringBuffer buffer = new StringBuffer();
        for (Record record : list) {
            Db.save("[file]", record);
            buffer.append(record.get("id") + ",");
        }
        return buffer.delete(buffer.length() - 1, buffer.length()).toString();
    }

    public void saveMoodContent(String m_publish_location, String m_share_publish_location, String m_share_to_other, String m_content, String m_attach_image) {
        SimpleDateFormat format = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
        Record record = new Record();
        record.set("m_publish_location", m_publish_location);
        record.set("m_share_publish_location", m_share_publish_location);
        record.set("m_share_to_other", m_share_to_other);
        record.set("m_content", m_content);
        record.set("m_attach_image", m_attach_image);
        record.set("gmt_modified", format.format(new Date()));
        record.set("m_publish_time", format.format(new Date()));
        Db.save("mood", record);
    }

    public List<Record> getMoodData() {
        List<Record> list=Db.find("select * from mood order by m_id desc");
        for (Record record : list) {
            //修改默认显示方式
            if (record.get("m_share_publish_location").toString().equals("true")) {
                record.set("m_share_publish_location", "公开");
            } else {
                record.set("m_share_publish_location", "不公开");
            }
            if (record.get("m_share_to_other").toString().equals("true")) {
                record.set("m_share_to_other", "公开");
            } else {
                record.set("m_share_to_other", "不公开");
            }
        }
        return list;
    }

    public List<String> getMoodAttachImage(String m_id) {
        String allImage = Db.findById("mood", "m_id", m_id).get("m_attach_image");
        List<String> list=null;
        //当没有数据的时候这里是一个空串
        if(allImage.equals("")){
            return list;
        }else{
            list= new ArrayList<String>();
            String[] ss = allImage.split(",");
            for (String s : ss) {
                list.add(Db.findById("[file]","f_id",s).getStr("f_url"));
            }
            return list;
        }
    }

    @Before(Tx.class)
    public void deleteMood(String allMoodId){
        String[] moods=allMoodId.split(",");
        for(String mood:moods){
            //获取心情所关联的图片
            String allImageId=Db.findById("mood","m_id",mood).getStr("m_attach_image");
            //有可能是没有配图的
            if(!allImageId.equals("")){
                String[] images=allImageId.split(",");
                for(String image:images){
                    //根据文件ID获取文件URL
                    String filePath=Db.findById("[file]","f_id",image).getStr("f_url");
                    //删除磁盘上的文件
                    File file=new File(PathKit.getWebRootPath()+filePath);
                    file.delete();
                    //删除图片文件记录
                    Db.deleteById("[file]","f_id",image);
                }
            }
            //删除心情记录
            Db.deleteById("mood","m_id",mood);
        }
    }

    //压缩图片
    public void compressImage(List<Record> list) throws Exception{
        for(Record record:list){
            //取出每张刚保存的图片
            String imageUrl=PathKit.getWebRootPath()+record.get("f_url");
            BufferedImage bimg = ImageIO.read(new File(imageUrl));
            int width=bimg.getWidth();
            int originalWidth = bimg.getWidth();
            //int height = bimg.getHeight();
            //System.out.println("width:"+originalWidth+",height:"+height);
            //当图片宽度超过限制则进行压缩,高度进行等比列压缩,将宽度压缩到450-900px
            while(width>900){
                width/=2;
            }
            //修改原图的大小
            File file = new File(imageUrl);
            Thumbnails.of(new FileInputStream(file)).scale(width*1.0/originalWidth).toFile(new File(imageUrl));
        }
    }
}
