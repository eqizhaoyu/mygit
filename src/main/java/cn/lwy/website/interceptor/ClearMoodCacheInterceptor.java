package cn.lwy.website.interceptor;

import com.jfinal.aop.Interceptor;
import com.jfinal.aop.Invocation;
import com.jfinal.plugin.ehcache.CacheKit;

/**
 * Created by lwy on 2017/6/21.
 */
public class ClearMoodCacheInterceptor implements Interceptor {
    public void intercept(Invocation inv) {
        //先清空缓存
        CacheKit.removeAll("moodListCache");
        inv.invoke();
    }
}
