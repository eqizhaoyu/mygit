package cn.lwy.website.quartz;

import com.jfinal.aop.Before;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.IAtom;
import com.jfinal.plugin.activerecord.Record;
import com.jfinal.plugin.activerecord.tx.Tx;
import com.jfinal.plugin.ehcache.CacheKit;
import net.sf.ehcache.Cache;
import org.apache.log4j.Logger;
import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * Created by lwy on 2017/6/21.
 */
//每十分钟更新一次数据
public class QuartzJob implements Job {

    private static Logger logger=Logger.getLogger(QuartzJob.class);

    //定时任务定期将文章/作品点击量更新到数据库
    @Before(Tx.class)
    public void execute(JobExecutionContext jobExecutionContext) throws JobExecutionException {
        //获取文章列表缓存
        Cache cache = CacheKit.getCacheManager().getCache("articleDetailCache");
        List<String> keys = cache.getKeys();
        if (keys.size() != 0) {
            logger.info("检测到"+keys.size()+"篇文章需更新点击量...");
            List<Record> list = new ArrayList<Record>();
            //当有数据时更新记录到数据库
            for (String s : keys) {
                String info="";
                Map controllerMap = CacheKit.get("articleDetailCache", s);
                Record articleRecord=(Record)controllerMap.get("articleContent");
                if(articleRecord!=null){
                    list.add(articleRecord);
                    logger.info("文章标题:"+s+"(有效)\n");
                }else{
                    logger.info("文章标题:"+s+"(无效)\n");
                }
            }
            Db.batchUpdate("article","a_id", list, list.size());
            //清空和文章相关的缓存
            CacheKit.removeAll("indexCache");
            logger.info("成功清除首页缓存!");
            CacheKit.removeAll("articleListCache");
            logger.info("成功清除文章列表缓存!");
            CacheKit.removeAll("articleDetailCache");
            logger.info("成功清除文章详细信息缓存!");
            logger.info("成功更新文章点击量!");
        }
        //获取作品列表缓存
        cache = CacheKit.getCacheManager().getCache("productionDetailCache");
        keys = cache.getKeys();
        if (keys.size() != 0) {
            logger.info("检测到"+keys.size()+"个作品需更新点击量...");
            List<Record> list = new ArrayList<Record>();
            //当有数据时更新记录到数据库
            for (String s : keys) {
                Map controllerMap = CacheKit.get("productionDetailCache", s);
                Record productionRecord=(Record)controllerMap.get("productionContent");
                //当是正常的链接时才加入更新列表
                if(productionRecord!=null){
                    list.add(productionRecord);
                    logger.info("作品名字:"+s+"(有效)\n");
                }else{
                    logger.info("作品名字:"+s+"(无效)\n");
                }
            }
            Db.batchUpdate("production","p_id", list, list.size());
            logger.info("批量更新作品成功!");
            //清除和作品有关的缓存
            CacheKit.removeAll("productionListCache");
            logger.info("成功清除作品列表缓存!");
            CacheKit.removeAll("productionDetailCache");
            logger.info("成功清除作品详细信息缓存!");
            logger.info("成功更新作品点击量!");
        }
    }
}
