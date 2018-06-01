package cn.lwy.website.interceptor;

import com.jfinal.aop.Interceptor;
import com.jfinal.aop.Invocation;

/**
 * Created by lwy on 2017/5/26.
 */
public class ShowContentInterceptor implements Interceptor {
    public void intercept(Invocation inv) {
        //调用目标方法
        inv.invoke();
        //目标方法调用完成之后再调用下面的代码段
        inv.getController().render("layout.ftl");
    }
}
