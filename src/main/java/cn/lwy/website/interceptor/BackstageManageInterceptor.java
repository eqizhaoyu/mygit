package cn.lwy.website.interceptor;

import com.jfinal.aop.Interceptor;
import com.jfinal.aop.Invocation;

/**
 * Created by lwy on 2017/6/18.
 */
public class BackstageManageInterceptor implements Interceptor {
    //拦截获取后台页面的请求
    public void intercept(Invocation inv) {
        String loginStatus=inv.getController().getSessionAttr("alreadyLogin");
        if(loginStatus==null || !loginStatus.equals("lwy")){
            inv.getController().forwardAction("/userLogin");
        }else{
            inv.invoke();
        }
    }
}
