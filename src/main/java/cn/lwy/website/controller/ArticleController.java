package cn.lwy.website.controller;

import cn.lwy.website.interceptor.BackstageManageInterceptor;
import cn.lwy.website.interceptor.ClearArticleCacheInterceptor;
import cn.lwy.website.service.ArticleService;
import com.jfinal.aop.Before;
import com.jfinal.aop.Enhancer;
import com.jfinal.core.Controller;
import com.jfinal.kit.PathKit;
import com.jfinal.plugin.activerecord.Record;
import com.jfinal.upload.UploadFile;
import org.apache.log4j.Logger;

import java.io.*;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by lwy on 2017/5/29.
 */
@Before({BackstageManageInterceptor.class, ClearArticleCacheInterceptor.class})
public class ArticleController extends Controller {
    static ArticleService articleService = Enhancer.enhance(ArticleService.class);
    private final Logger logger = Logger.getLogger("");

    public void getArticleAdminPage() {
        setAttr("currentModule", "文章管理");
        //在文章管理页面我们需要使用到所有的标签数据
        setAttr("allArticleLabel", articleService.getArticleLabel());
        setAttr("body_file_path", "manageArticle.ftl");
        render("/admin/main.ftl");
    }

    //获取标签管理页面
    public void getArticleLabelAdminPage() {
        setAttr("currentModule", "标签管理");
        setAttr("body_file_path", "manageArticleLabel.ftl");
        render("/admin/main.ftl");
    }

    //保存新标签
    public void saveArticleLabel() throws Exception {
        //获取传递的文章标签json值
        Map<String, Object> map = new HashMap<String, Object>();
        String l_label = getPara("l_name");
        String l_description = getPara("l_description");
        String status = articleService.saveArticleLabel(l_label, l_description);
        renderText(status);
    }

    //获取标签表格的json数据
    public void getArticleLabelJson() {
        renderJson(articleService.getArticleLabel());
    }

    //删除标签
    public void deleteArticleLabel() {
        String allLabelId = getPara("allLabelId");
        articleService.deleteArticleLabel(allLabelId);
        renderText("ok");
    }

    //修改标签内容
    public void alterArticleLabel() {
        String l_id = getPara("l_id");
        String l_name = getPara("l_name");
        String l_description = getPara("l_description");
        String pre_name = getPara("pre_name");
        String returnStr = articleService.alterArticleLabel(l_id, l_name, l_description, pre_name);
        renderText(returnStr);
    }

    //获取发表文章的页面
    public void getPublishArticlePage() {
        //在这里保存两个路径值,在前段判断该字段是否是两个字符的拼接,是的话就显示两个
        //获取所有的标签
        setAttr("allArticleLabel", articleService.getArticleLabel());
        setAttr("currentModule", "文章管理");
        setAttr("body_file_path", "publishArticle.ftl");
        render("/admin/main.ftl");
    }

    //文章相关文件上传
    public void uploadArticleAttachFile() {
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
            prefix = "upload/articleAttachImage";
            fileName = System.currentTimeMillis() + extension;
            fileType = "image";
        } else {  //当上传的是非图片,也就是要下载的文件
            prefix = "upload/articleAttachFile";
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
                String f_description = "文章中供下载的资源";
                String f_type = "非图片";
                String f_link_type = "文章";
                String fileId = articleService.saveArticleAttachFile(fileName, filePath, f_description, f_type, f_link_type);
                //这里是将文件进行保存之后直接获取的其ID,然后在HTML文本中直接就可以进行链接设置了
                renderHtml("<a href=\"downloadArticleAttachFile?fileId=" + fileId + "\">点我下载</a>");
            }
        } catch (FileNotFoundException e) {
            renderHtml("<script type=\"text/javascript\">alert('没有发现上传的文件!')</script>");
        } catch (IOException e) {
            renderHtml("<script type=\"text/javascript\">alert('文件写入服务器出现错误，请稍后再上传!')</script>");
        } catch (Exception e) {
            renderHtml("<script type=\"text/javascript\">alert('出现未知的错误,请稍候再上传!')</script>");
        }
    }

    //保存文章(正式发表或者是保存为草稿)
    public void saveArticle() {
        String saveType = getPara("saveType");
        String publisher = getPara("publisher");
        String articleType = getPara("articleType");
        String articleContent = getPara("articleContent");
        String nowSelectLabel = getPara("nowSelectLabel");
        String articleTitle = getPara("articleTitle");
        articleService.saveArticle(saveType, publisher, articleType, articleContent, nowSelectLabel, articleTitle);
        renderText("ok");
    }

    //进行文章关联文件的下载
    public void downloadArticleAttachFile() {
        String fileId = getPara("fileId");
        String filePath = articleService.getDownLoadFilePath(fileId);
        File file = new File(PathKit.getWebRootPath() + filePath);
        if (file.exists()) {
            renderFile(file);
        } else {
            renderText("该文件不存在文件!");
        }
    }

    //分页获取文章列表(不包括文章内容)
    public void getArticleExceptContent() {
        String articleStatus = getPara("articleStatus");
        List<Record> list = articleService.getArticleExceptContent(articleStatus);
        renderJson(list);
    }

    //根据文章ID获取文章内容
    public void getArticleContent() {
        String articleId = getPara("articleId");
        renderText(articleService.getArticleContent(articleId));
    }

    //保存修改后文章的内容
    public void saveModifiedArticleContent() {
        String articleId = getPara("articleId");
        String articleContent = getPara("articleContent");
        int count = articleService.saveModifiedArticleContent(articleId, articleContent);
        if (count == 1) {
            renderText("ok");
        } else {
            renderText("error");
        }
    }

    //保存修改后的非文章主体内容(标签修改之后需要修改多个表中的内容)
    public void saveModifiedArticleExceptContent() {
        String a_title = getPara("a_title");
        String a_publish_time = getPara("a_publish_time");
        String a_publisher = getPara("a_publisher");
        String a_type = getPara("a_type");
        String a_attach_label = getPara("a_attach_label");
        String a_id = getPara("a_id");
        articleService.saveModifiedArticleExceptContent(a_id, a_title, a_publish_time, a_publisher, a_type, a_attach_label);
        renderText("ok");
    }

    //查看每个标签所关联的文章
    public void seeLabelRelaterticle() {
        renderJson(articleService.seeLabelRelaterticle(getPara("labelId")));
    }

    //删除文章
    public void deleteArticle() {
        String allArticleId = getPara("allArticleId");
        articleService.deleteArticle(allArticleId);
        renderText("ok");
    }

    //将保存的草稿发表成正式的文章
    public void realPublishArticle() {
        String a_id = getPara("a_id");
        if (articleService.realPublishArticle(a_id) > 0) {
            renderText("ok");
        } else {
            renderText("error");
        }
    }

    //修改文章推荐
    public void setArticleRecommend() {
        String a_id = getPara("a_id");
        String a_recommend = getPara("a_recommend");
        int count = articleService.setArticleRecommend(a_id, a_recommend);
        if (count > 0) {
            renderText("ok");
        } else {
            renderText("error");
        }
    }
}
