package cn.lwy.website.controller;

import cn.lwy.website.interceptor.BackstageManageInterceptor;
import cn.lwy.website.interceptor.ClearMoodCacheInterceptor;
import cn.lwy.website.service.MoodService;
import com.jfinal.aop.Before;
import com.jfinal.aop.Enhancer;
import com.jfinal.core.Controller;
import com.jfinal.kit.PathKit;
import com.jfinal.plugin.activerecord.Record;
import com.jfinal.upload.UploadFile;

import java.io.*;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * Created by lwy on 2017/6/12.
 */
@Before({BackstageManageInterceptor.class, ClearMoodCacheInterceptor.class})
public class MoodController extends Controller {
    //因为要开启事务,所以需要在实例化该类时使用动态代理来增强,明天来测试...
    private static MoodService moodService= Enhancer.enhance(MoodService.class);

    public void getMoodAdminPage() {
        setAttr("currentModule", "心情管理");
        //在文章管理页面我们需要使用到所有的标签数据
        setAttr("body_file_path", "manageMood.ftl");
        render("/admin/main.ftl");
    }

    public void saveMood() {
        String m_publish_location = getPara("m_publish_location");
        String m_share_publish_location = getPara("m_share_publish_location");
        String m_share_to_other = getPara("m_share_to_other");
        String m_content = getPara("m_content");
        String m_attach_image=getPara("m_attach_image");
        moodService.saveMoodContent(m_publish_location,m_share_publish_location,m_share_to_other,m_content,m_attach_image);
        renderText("ok");
    }

    public void saveMoodAttachImage() throws Exception{
        //这里获取的是所有上传文件
        List<UploadFile> files = getFiles();
        List<Record> list = new ArrayList<Record>();
        for (UploadFile file : files) {
            //获取上传的文件
            File source = file.getFile();
            //获取文件全名
            String fileName = file.getFileName();
            //获取文件拓展名
            String extension = fileName.substring(fileName.lastIndexOf("."));
            String prefix;
            prefix = "upload/MoodAttachimage";
            fileName = System.currentTimeMillis() + extension;
            try {
                //创建文件输入流
                FileInputStream fis = new FileInputStream(source);
                //创建要保存的文件目录
                File targetDir = new File(PathKit.getWebRootPath() + "/" + prefix);
                //当该目录不存在时进行创建
                if (!targetDir.exists()) {
                    targetDir.mkdirs();
                }
                //将文件按照指定的路径进行保存
                File target = new File(targetDir, fileName);
                //当该文件不存在时创建一个新的文件
                if (!target.exists()) {
                    target.createNewFile();
                }
                //创建文件输出流
                FileOutputStream fos = new FileOutputStream(target);
                byte[] bts = new byte[1024];
                while (fis.read(bts, 0, 1024) != -1) {
                    fos.write(bts, 0, 1024);
                }
                fos.close();
                fis.close();
                //删除在默认路径下的文件
                source.delete();
                String filePath = "/" + prefix + "/" + fileName;
                Record record=new Record();
                record.set("f_name",fileName);
                record.set("f_url",filePath);
                record.set("f_description","心情配图");
                record.set("f_type","图片");
                record.set("f_link_type","心情");
                record.set("gmt_modified",new SimpleDateFormat("yyyy/MM/dd HH:mm:ss").format(new Date()));
                list.add(record);
            } catch (FileNotFoundException e) {
                renderHtml("<script type=\"text/javascript\">alert('没有发现上传的文件!')</script>");
            } catch (IOException e) {
                renderHtml("<script type=\"text/javascript\">alert('文件写入服务器出现错误，请稍后再上传!')</script>");
            } catch (Exception e) {
                renderHtml("<script type=\"text/javascript\">alert('出现未知的错误,请稍候再上传!')</script>");
            }
        }
        //压缩图片
        moodService.compressImage(list);
        Map<String,Object> map=new HashMap<String, Object>();
        map.put("allImageId",moodService.saveMoodAttachImage(list));
        renderJson(map);
    }

    //获取心情数据
    public void getMoodData(){
        renderJson(moodService.getMoodData());
    }

    //获取心情配图
    public void getMoodAttachImage(){
        String m_id=getPara("m_id");
        List<String> list=moodService.getMoodAttachImage(m_id);
        if(list==null){
            renderText("no data");
        }else{
            renderJson(list);
        }
    }

    //删除心情
    public void deleteMood(){
        String allMoodId=getPara("allMoodId");
        moodService.deleteMood(allMoodId);
        renderText("ok");
    }
}
