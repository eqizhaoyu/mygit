package cn.lwy.website.interceptor;

import com.jfinal.aop.Interceptor;
import com.jfinal.aop.Invocation;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Record;
import com.jfinal.plugin.ehcache.CacheKit;

import java.util.List;
import java.util.Map;

/**
 * Created by lwy on 2017/6/20.
 */
public class DaysHitsInterceptor implements Interceptor {
    public void intercept(Invocation inv) {
        if (inv.getActionKey().equals("/getArticleDetailInfo")) { //当是文章时
            String articleId = inv.getController().getPara("articleId");
            Map articleRecord = CacheKit.get("articleDetailCache", "/getArticleDetailInfo?articleId=" + articleId);
            if (articleRecord != null) {    //当缓存中存在该文章时
                Record articleContent=(Record)articleRecord.get("articleContent");
                int hits=Integer.parseInt(articleContent.get("a_hits").toString());
                //点击量+1
                articleContent.set("a_hits", hits + 1);
            }
        } else if (inv.getActionKey().equals("/getProductionContent")) { //当是作品时
            String productionId = inv.getController().getPara("productionId");
            Map productionRecord = CacheKit.get("productionDetailCache", "/getProductionContent?productionId=" + productionId);
            if (productionRecord != null) {    //当缓存中存在该作品时
                Record productionContent=(Record)productionRecord.get("productionContent");
                int hits=Integer.parseInt(productionContent.get("p_hits").toString());
                //点击量+1
                productionContent.set("p_hits", hits + 1);
            }
        }
        inv.invoke();
    }
}
