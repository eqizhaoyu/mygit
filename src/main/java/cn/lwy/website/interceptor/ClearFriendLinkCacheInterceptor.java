package cn.lwy.website.interceptor;

import com.jfinal.aop.Interceptor;
import com.jfinal.aop.Invocation;
import com.jfinal.plugin.ehcache.CacheKit;

/**
 * Created by lwy on 2017/6/22.
 */
public class ClearFriendLinkCacheInterceptor implements Interceptor{

    public void intercept(Invocation inv) {
        //清空友情链接缓存
        CacheKit.removeAll("friendLinkCache");
        inv.invoke();
    }
}
