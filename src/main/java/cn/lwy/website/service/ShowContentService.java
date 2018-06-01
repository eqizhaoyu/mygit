package cn.lwy.website.service;

import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Page;
import com.jfinal.plugin.activerecord.Record;
import com.jfinal.plugin.ehcache.CacheKit;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by lwy on 2017/6/11.
 */
public class ShowContentService {
    //获取作品前端主页面所需要的数据
    public List<Record> getProductionData(String type) {
        if (type == null || type.equals("")) {
            return Db.find("select * from production order by p_id desc");
        } else {
            return Db.find("select * from production where p_type=?", type);
        }
    }

    //获取作品的详细信息
    public Record getProductionContentById(int productionId) {
        //进行点击量更新
        Db.update("update production set p_hits=p_hits+1 where p_id=?", productionId);
        return Db.findById("production", "p_id", productionId);
    }

    public List<Record> getMoodData(int pageNumber, int pageSize) {
        List<Record> list = Db.paginate(pageNumber, pageSize, "select *", "from mood order by m_id desc").getList();
        //获取心情的配图
        for (Record record : list) {
            String allImageId = record.get("m_attach_image");
            //当当前心情是有配图的
            if (!allImageId.equals("")) {
                List<String> imageList = new ArrayList<String>();
                String[] ss = allImageId.split(",");
                for (String s : ss) {
                    imageList.add(Db.findById("[file]", "f_id", s).getStr("f_url"));
                }
                //覆盖以前的图片ID
                record.set("m_attach_image", imageList);
            }

        }
        return list;
    }

    //获取当前所有的标签
    public List<Record> getAllLabel() {
        List<Record> list = Db.find("select l_id,l_name,l_description from label");
        //遍历获取每个标签当前所关联的文章数
        for (Record record : list) {
            record.set("relatedArticleCount", Db.find("select al_id from article_label where l_id=?", record.get("l_id")).size());
        }
        return list;
    }

    //根据类型获取文章列表
    public List<Record> getArticleListPaging(String type) {
        List<Record> list = null;
        if (type.equals("clickRate")) {   //点击率
            list = Db.find("select top 6 a_id,a_title,a_content,a_publish_time,a_hits from article where a_is_draft='false' order by a_hits desc");
        } else if (type.equals("new")) {      //最新
            list = Db.find("select top 6 a_id,a_title,a_content,a_publish_time,a_hits from article where a_is_draft='false' order by a_publish_time desc");
        } else if (type.equals("recommend")) {     //推荐
            list = Db.find("select a_id,a_title,a_content,a_publish_time,a_hits from article where a_recommend='true' and a_is_draft='false' order by a_hits desc");
        }
        return alterArticleList(list);
    }

    //获取文章具体内容
    public Record getArticleContentById(int articleId) {
        //进行点击量更新
        Db.update("update article set a_hits=a_hits+1 where a_id=?", articleId);
        return Db.findById("article", "a_id", articleId);
    }

    //根据标签获取文章列表
    public List<Record> getArticleList(int labelId, int pageNumber, int pageSize) {
        List<Record> articleList = null;
        //当是获取所有文章,也就是点击链接上的文章进入的页面
        if (labelId == 0) {
            articleList = Db.paginate(pageNumber, pageSize, "select *", "from article where a_is_draft='false' order by a_publish_time desc").getList();
        } else {
            //先获取当前标签所关联的文章集合
            List<Record> articleIdList = Db.paginate(pageNumber, pageSize, "select article.a_id", "from article_label,article where article_label.a_id=article.a_id and article_label.l_id=? and article.a_is_draft='false' order by article.gmt_modified desc", labelId).getList();
            articleList = new ArrayList<Record>();
            //遍历获取到的文章ID,获取文章ID
            for (Record record : articleIdList) {
                articleList.add(Db.findById("article", "a_id", record.get("a_id")));
            }
        }
        return alterArticleList(articleList);
    }

    //获取文章的总记录数
    public int getArticleSum(int labelId){
        if(labelId==0){ //获取所有记录
            return Db.find("select a_id from article where a_is_draft='false' ").size();
        }else{
            return Db.find("select article.a_id from article_label,article where article_label.a_id=article.a_id and article_label.l_id=? and article.a_is_draft='false' order by article.gmt_modified desc ",labelId).size();
        }
    }

    //为每篇文章自动生成配图01-05,并修改简介内容
    private List<Record> alterArticleList(List<Record> list) {
        //为每篇文章自动生成配图01-05
        for (Record record : list) {
            //产生1-6的随机数
            int rand = (int) (Math.random() * 10) % 6 + 1;
            String s = "0" + rand;
            record.set("attachImg", s);
            //设置文章简介
            StringBuffer buffer = new StringBuffer(record.getStr("a_content"));
            // 当字符串中还有标记的时候
            while (buffer.indexOf("<") != -1) {
                int start = buffer.indexOf("<");
                int end = buffer.indexOf(">");
                buffer.delete(start, end + 1);
            }
            String articleBrief = buffer.toString().replace("&nbsp;", " ").replaceAll("\\s{1,}", " ");
            record.set("a_content", articleBrief);
        }
        return list;
    }

    //根据作品的动态获取作品列表
    public List<Record> getProductionListByState(String state) {
        List<Record> list = null;
        //当是获取最新的作品时,我们获取5个作品(都是web相关的)
        if (state.equals("new")) {
            list = Db.find("select top 5 p_id,p_name from production order by gmt_modified desc");
        } else if (state.equals("hits")) {
            list = Db.find("select top 5 p_id,p_name from production order by p_hits desc ");
        }
        return list;
    }

    //获取文章或者作品的上一个和下一个
    public Record getLastOrNext(String type, String state, int id) {
        Record record = null;
        List<Record> list = null;
        //当是作品时
        if (type.equals("production")) {
            if (state.equals("next")) {   //当是获取上一个作品
                list = Db.find("select top 1 p_id,p_name from production where p_id<?  order by p_id desc", id);
                //当获取到了数据
                if (list.size() > 0) {
                    record = list.get(0);
                }
            } else {
                list = Db.find("select top 1 p_id,p_name from production where p_id>?  order by p_id asc;", id);
                if (list.size() > 0) {
                    record = list.get(0);
                }
            }
        } else if (type.equals("article")) {
            if (state.equals("next")) {   //当是获取上一篇文章
                list = Db.find("select top 1 a_id,a_title from article where a_id<?  order by a_publish_time desc", id);
                if (list.size() > 0) {
                    record = list.get(0);
                }
            } else {
                list = Db.find("select top 1 a_id,a_title from article where a_id>?  order by a_publish_time asc;", id);
                if (list.size() > 0) {
                    record = list.get(0);
                }
            }
        }
        return record;
    }

    //获取所有友情链接
    public List<Record> getFriendLink(){
        //先判断是否有数据,若没有则从数据库中查询数据放到缓存里面
        List<Record> cacheList=CacheKit.get("friendLinkCache","nowFriendLink");
        //当还未创建该key,或者后期清空了缓存则获取数据并将其加入到缓存中
        if(cacheList==null || cacheList.size()==0){
            List<Record> list= Db.find("select fl_link_text,fl_link_url from friendLink");
            CacheKit.put("friendLinkCache","nowFriendLink",list);
            return list;
        }else{
            //返回缓存中的数据
            return CacheKit.get("friendLinkCache","nowFriendLink");
        }
    }

    //随机生成推荐的作品显示在首页
    public List<Record> recommendProduction(){
        return Db.find("select top 5 * from production order by NEWID()");
    }
}


