package cn.lwy.website.controller;

import cn.lwy.website.interceptor.BackstageManageInterceptor;
import cn.lwy.website.interceptor.ClearProductionCacheInterceptor;
import cn.lwy.website.service.ProductionService;
import com.jfinal.aop.Before;
import com.jfinal.aop.Enhancer;
import com.jfinal.core.Controller;
import com.jfinal.kit.PathKit;
import com.jfinal.upload.UploadFile;

import java.io.*;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by lwy on 2017/6/8.
 */
@Before({BackstageManageInterceptor.class, ClearProductionCacheInterceptor.class})
public class ProductionController extends Controller {
    static ProductionService productionService = Enhancer.enhance(ProductionService.class);

    public void getProductionAdminPage() {
        setAttr("currentModule", "作品管理");
        //在文章管理页面我们需要使用到所有的标签数据
        setAttr("body_file_path", "manageProduction.ftl");
        render("/admin/main.ftl");
    }

    //保存作品信息
    public void operateProduction() {
        String p_name = getPara("p_name");
        String p_developer = getPara("p_developer");
        String p_type = getPara("p_type");
        String p_brief = getPara("p_brief");
        String p_cover_url=getPara("p_cover_url");
        String operateType=getPara("operateType");
        String nowSelectProductionId=getPara("nowSelectProductionId");
        if(operateType.equals("add")){
            productionService.saveProduction(p_name,p_developer,p_type,p_brief,p_cover_url);
        }else if(operateType.equals("update")){
            productionService.updateProduction(nowSelectProductionId,p_name,p_developer,p_type,p_brief,p_cover_url);
        }
        renderText("ok");
    }

    //获取所有作品信息
    public void getAllProduction() {
        renderJson(productionService.getAllProduction());
    }

    //根据作品ID获取作品内容以及作品配图
    public void getProductionContentById() {
        String p_id = getPara("p_id");
        renderJson(productionService.getProductionContentById(p_id));
    }

    //保存作品所关联的图片或者是待下载的文件
    public void saveProductionContactFile() {
        String CKEditorFuncNum = getPara("CKEditorFuncNum");
        String fileType = "";
        //将文件根据上传日期创建文件夹
        String path = new SimpleDateFormat("yyyy-MM-dd").format(new Date());
        //获取上传的文件,并设置要保存的根路径
        UploadFile file = getFile("upload");
        //获取上传的文件
        File source = file.getFile();
        //获取文件全名
        String fileName = file.getFileName();
        //获取文件拓展名
        String extension = fileName.substring(fileName.lastIndexOf("."));
        String prefix;
        //当上传的是图片文件
        if (".png".equals(extension.toLowerCase()) || ".jpg".equals(extension.toLowerCase()) || ".gif".equals(extension.toLowerCase()) || ".jpeg".equals(extension.toLowerCase())) {
            prefix = "upload/productionAttachImage";
            fileName = System.currentTimeMillis() + extension;
            fileType = "image";
        } else {  //当上传的是非图片,也就是要下载的文件
            prefix = "upload/productionAttachFile";
        }
        try {
            //创建文件输入流
            FileInputStream fis = new FileInputStream(source);
            //创建要保存的文件目录
            File targetDir = new File(PathKit.getWebRootPath() + "/" + prefix + "/"
                    + path);
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
            String filePath = "/" + prefix + "/" + path + "/" + fileName;
            //若上传的是非图片文件需要将其路径保存在数据库,这样才能进行文件下载操作
            if (fileType.equals("image")) {   //上传的是文件
                String contextPath = PathKit.getWebRootPath();
                String returnStr = "<script type=\"text/javascript\">window.parent.CKEDITOR.tools.callFunction(" + CKEditorFuncNum + ",'" + filePath + "','')</script>";
                renderHtml(returnStr);
            } else {  //上传的是非图片文件
                //将文件路径保存在数据库,方便用户进行下载
                String f_description = "作品中供下载的资源";
                String f_type = "非图片";
                String f_link_type = "作品";
                String fileId = productionService.saveProductionContactFile(fileName, filePath, f_description, f_type, f_link_type);
                renderHtml("<a href=\"downloadProductionAttachFile?fileId=" + fileId + "\">点我下载</a>");
            }
        } catch (FileNotFoundException e) {
            renderHtml("<script type=\"text/javascript\">alert('没有发现上传的文件!')</script>");
        } catch (IOException e) {
            renderHtml("<script type=\"text/javascript\">alert('文件写入服务器出现错误，请稍后再上传!')</script>");
        } catch (Exception e) {
            renderHtml("<script type=\"text/javascript\">alert('出现未知的错误,请稍候再上传!')</script>");
        }
    }

    //保存作品的封面图片
    public void saveProductionCover() {
        //获取上传的文件,并设置要保存的根路径
        UploadFile file = getFile("productionConver");
        //获取上传的文件
        File source = file.getFile();
        //获取文件全名
        String fileName = file.getFileName();
        //获取文件拓展名
        String extension = fileName.substring(fileName.lastIndexOf("."));
        String prefix;
        prefix = "upload/productionCover";
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
            //返回文件全路径,方便在前端进行显示
            Map<String, Object> map = new HashMap<String, Object>();
            map.put("pathUrl","/" + prefix + "/" + fileName);
            //将图片进行压缩
            productionService.compressImage("/" + prefix + "/" + fileName);
            renderJson(map);
        } catch (FileNotFoundException e) {
            renderHtml("<script type=\"text/javascript\">alert('没有发现上传的文件!')</script>");
        } catch (IOException e) {
            renderHtml("<script type=\"text/javascript\">alert('文件写入服务器出现错误，请稍后再上传!')</script>");
        } catch (Exception e) {
            renderHtml("<script type=\"text/javascript\">alert('出现未知的错误,请稍候再上传!')</script>");
        }
    }

    //进行作品关联文件的下载
    public void downloadProductionAttachFile() {
        String fileId = getPara("fileId");
        String filePath = productionService.getDownLoadFilePath(fileId);
        File file=new File(PathKit.getWebRootPath()+filePath);
        if(file.exists()){
            renderFile(file);
        }else{
            renderText("该文件不存在文件!");
        }
    }

    //删除作品
    public void deleteProduction(){
        String allProductionId=getPara("allProductionId");
        productionService.deleteProduction(allProductionId);
        renderText("ok");
    }
}
