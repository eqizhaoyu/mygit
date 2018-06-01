package cn.lwy.website.service;

import com.jfinal.aop.Before;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Record;
import com.jfinal.plugin.activerecord.tx.Tx;

import java.text.SimpleDateFormat;
import java.util.*;

/**
 * Created by lwy on 2017/5/30.
 */
public class ArticleService {
    //保存新标签
    public String saveArticleLabel(String l_name, String l_description) {
        String returnStr = "";
        int count = Db.find("select l_id from label where l_name=?", l_name).size();
        if (count > 0) {
            returnStr = "alreadyExit";
        } else {
            Map<String, Object> map = new HashMap<String, Object>();
            map.put("l_name", l_name);
            map.put("l_description", l_description);
            map.put("gmt_modified", new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()));
            //直接保存从前台传递进来的数据
            Record articleLabel = new Record().setColumns(map);
            Db.save("label", articleLabel);
            returnStr = "ok";
        }
        return returnStr;
    }

    //获取标签表格的json数据
    public List<Record> getArticleLabel() {
        List<Record> list = Db.find("select * from label");
        //还要获取每个标签所关联的文章的个数
        for (Record record : list) {
            //获取文章ID
            String labelId = record.get("l_id").toString();
            int count = Db.find("select count(*) as count from article_label where l_id=?", labelId).get(0).get("count");
            record.set("relaterArticleCount", count);
        }
        return list;
    }

    //删除标签
    public void deleteArticleLabel(String allLabelId) {
        String[] labelIds = allLabelId.split(",");
        for (String s : labelIds) {
            Db.deleteById("label", "l_id", s);
        }
    }

    //修改标签
    public String alterArticleLabel(String l_id, String l_name, String l_description, String pre_name) {
        SimpleDateFormat format = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
        String returnStr = "";
        int flag = 0;
        //如果修改了标签名要先判断该标签是否已经存在了
        if (!pre_name.equals(l_name)) {
            int count = Db.find("select l_id from label where l_name=?", l_name).size();
            if (count > 0) {
                returnStr = "alreadyExit";
                flag = 1;
            }
        }
        if (flag == 0) {
            Db.update("update label set l_name=?,l_description=?,gmt_modified=? where l_id=?", l_name, l_description, format.format(new Date()), l_id);
            returnStr = "ok";
        }
        return returnStr;
    }

    //查看每个标签所关联的文章
    public List<Record> seeLabelRelaterticle(String labelId) {
        List<Record> list = Db.find("select a_title,a_publish_time,a_publisher,a_type,a_is_draft from article where a_id in" +
                "(select a_id from article_label where l_id=?)", labelId);
        for (Record record : list) {
            if (record.get("a_is_draft").equals("true")) {
                record.set("a_is_draft", "草稿");
            } else {
                record.set("a_is_draft", "已发表");
            }
        }
        return list;
    }

    @Before(Tx.class)       //因为方法内涉及多个数据库操作,所以这里使用事务进行操作
    //保存文章(正式发表或者是保存为草稿)
    public void saveArticle(String saveType, String publisher, String articleType, String articleContent, String nowSelectLabel, String articleTitle) {
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("a_title", articleTitle);
        map.put("a_content", articleContent);
        map.put("gmt_modified", new SimpleDateFormat("yyyy/MM/dd HH:mm:ss").format(new Date()));
        map.put("a_type", articleType);
        map.put("a_title", articleTitle);
        map.put("a_publisher", publisher);
        map.put("a_attach_label", nowSelectLabel);
        //当当前文章为要正式发表
        if (saveType.equals("publish")) {
            //保存发表时间
            map.put("a_publish_time", new SimpleDateFormat("yyyy/MM/dd HH:mm:ss").format(new Date()));
            map.put("a_is_draft", false);
        } else if (saveType.equals("draft")) {
            //在保存草稿时不保存发表时间
            map.put("a_is_draft", true);
        }
        Record article = new Record().setColumns(map);
        //将发表的文章保存在文章表中
        Db.save("article", article);
        //获取自动生成的文章主键
        String articleId = article.get("id").toString();
        //在文章-标签表中建立文章和标签的对应关系
        String[] ss = nowSelectLabel.split(",");
        List<Record> list = new ArrayList<Record>();
        SimpleDateFormat format = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
        for (String s : ss) {
            Record record = new Record();
            record.set("a_id", articleId);
            record.set("l_id", s);
            record.set("gmt_modified", format.format(new Date()));
            list.add(record);
        }
        //批量插入
        Db.batchSave("article_label", list, list.size());
    }

    //保存文章所附加的文件的路径(一般为供别人下载的文件)
    public String saveArticleAttachFile(String f_name, String f_url, String f_description, String f_type, String f_link_type) {
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("f_name", f_name);
        map.put("f_url", f_url);
        map.put("f_description", f_description);
        map.put("f_type", f_type);
        map.put("f_link_type", f_link_type);
        map.put("gmt_modified", new SimpleDateFormat("yyyy/MM/dd HH:mm:ss").format(new Date()));
        Record record = new Record().setColumns(map);
        Db.save("[file]", record);
        //返回刚刚插入的文件自动生成的ID,这里要写成id而不能写成数据库中自动生成的ID字段
        return record.get("id").toString();
    }

    //获取要下载的文件路径
    public String getDownLoadFilePath(String fileId) {
        return Db.findById("[file]","f_id", fileId).get("f_url");
    }

    //分页获取文章列表(不包括文章内容)
    public List<Record> getArticleExceptContent(String type) {
        List<Record> list = null;
        if (type.equals("publish")) {
            list=Db.find("select a_id,a_title,a_attach_label,a_publish_time,a_publisher,a_type,gmt_modified,a_recommend from article where a_is_draft='false'");
        } else if (type.equals("draft")) {
            list=Db.find("select a_id,a_title,a_attach_label,a_publish_time,a_publisher,a_type,gmt_modified from article where a_is_draft='true'");
        }
        StringBuffer buffer = new StringBuffer();
        //当查询结果为空时返回的是null,所以在这里我们需要先判断一下
        if (list != null) {
            //遍历获取每篇文章的标签
            for (Record record : list) {
                //获取所有的标签内容
                String attachLabel = record.get("a_attach_label");
                String[] ss = attachLabel.split(",");
                for (String s : ss) {
                    buffer.append(Db.findById("label", "l_id", s).get("l_name") + ",");
                }
                //将标签ID覆盖成标签名
                record.set("a_attach_label", buffer.delete(buffer.length() - 1, buffer.length()).toString());
                //清空缓冲区中的内容
                buffer.delete(0, buffer.length());
                //当是已经发表的文章,修改是否推荐的信息
                if(type.equals("publish")){
                    if(record.get("a_recommend").toString().equals("true")){
                        record.set("a_recommend","推荐");
                    }else{
                        record.set("a_recommend","不推荐");
                    }
                }
            }
        }
        return list;
    }

    //根据文章ID获取文章内容
    public String getArticleContent(String articleId) {
        return Db.findById("article", "a_id", articleId).get("a_content");
    }

    //保存修改后文章的内容
    public int saveModifiedArticleContent( String id,String content) {
        SimpleDateFormat format = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
        int count =Db.update("update article set a_content=?,gmt_modified=? where a_id=?", content, format.format(new Date()), id);
        return count;
    }

    //保存修改后的非文章主体内容
    @Before(Tx.class)
    public void saveModifiedArticleExceptContent(String a_id, String a_title, String a_publish_time, String a_publisher, String a_type, String a_attach_label) {
        //将其致空,不然会让时间变成1900的
        if(a_publish_time==""){
            a_publish_time=null;
        }
        String[] ss = a_attach_label.split(",");
        StringBuffer buffer=new StringBuffer();
        //获取标签所对应的ID号
        for (String s : ss) {
            buffer.append(Db.find("select l_id from label where l_name=?",s).get(0).get("l_id")+",");
        }
        //去除最后一个逗号
        a_attach_label=buffer.deleteCharAt(buffer.length()-1).toString();
        SimpleDateFormat format = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
        //更新文章表中的内容
        Db.update("update article set a_publish_time=?,a_publisher=?,a_type=?,a_attach_label=?,a_title=?,gmt_modified=? where a_id=?", a_publish_time, a_publisher,a_type, a_attach_label, a_title, format.format(new Date()), a_id);
        //更新文章-标签中的关系
        //首先删除以前和该文章相关联的记录
        Db.update("delete from article_label where a_id=?", a_id);
        //建立新的文章-标签关系
        ss = a_attach_label.split(",");
        for (String s : ss) {
            Record record = new Record();
            record.set("a_id", a_id);
            record.set("l_id", s);
            record.set("gmt_modified", format.format(new Date()));
            Db.save("article_label", record);
        }
    }

    //删除文章
    @Before(Tx.class)
    public void deleteArticle(String allArticleId){
        String[] ss=allArticleId.split(",");
        for(String s:ss){
            //先文章与标签之间的关联(该表中有外键,所以需要先删除)
            Db.update("delete from article_label where a_id=?",s);
            //删除文章(文章ID是被其他表相关联的,所以必须先将其他相关联的记录删除)
            Db.deleteById("article","a_id",s);
        }
    }

    //草稿发表成文章
    public int realPublishArticle(String a_id){
        String now=new SimpleDateFormat("yyy/MM/dd HH:mm:ss").format(new Date());
        return Db.update("update article set a_is_draft='false',a_publish_time=?,gmt_modified=? where a_id=?",now,now,a_id);
    }

    //修改文章推荐
    public int setArticleRecommend(String a_id,String a_recommend){
        return Db.update("update article set a_recommend=? where a_id=?",a_recommend,a_id);
    }
}
