package cn.lwy.website.interceptor;

import com.jfinal.aop.Interceptor;
import com.jfinal.aop.Invocation;
import com.jfinal.plugin.ehcache.CacheKit;

/**
 * Created by lwy on 2017/6/21.
 */
public class ClearArticleCacheInterceptor implements Interceptor {
    public void intercept(Invocation inv) {
        //清空和作品有关的缓存
        CacheKit.removeAll("indexCache");
        CacheKit.removeAll("articleListCache");
        CacheKit.removeAll("articleDetailCache");
        inv.invoke();
    }
}
