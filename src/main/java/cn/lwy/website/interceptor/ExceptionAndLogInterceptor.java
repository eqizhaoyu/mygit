package cn.lwy.website.interceptor;

import com.jfinal.aop.Interceptor;
import com.jfinal.aop.Invocation;
import com.jfinal.core.Controller;
import eu.bitwalker.useragentutils.UserAgent;
import org.apache.log4j.Logger;

/**
 * Created by lwy on 2017/7/3.
 */
public class ExceptionAndLogInterceptor implements Interceptor {
    private static final Logger log = Logger.getLogger(ExceptionAndLogInterceptor.class);

    public void intercept(Invocation inv) {
        //log.debug("执行了ExceptionAndLogInterceptor...");
        Controller controller=inv.getController();
        //捕获在目标函数(controller)调用过程中抛出的异常
        try{
            inv.invoke();
            //controller方法中的代码执行完毕后下面的代码就将被执行,也就是说这下面的代码是拦截不到freemarker的异常的
            //TODO
        }catch(Exception e){
            //其实如果别人想随便输入非法的字符的话是无法避免的,那么后台肯定就会抛出异常,这也是无法避免的,我们无法从根本上消除这种问题,所以只有捕获异常
            //我们打印错误的相信信息和访问该链接的客户机信息
            StringBuffer buffer=new StringBuffer();
            buffer.append("controller抛出异常!\n");
            buffer.append("客户机地址:"+controller.getRequest().getRemoteAddr()+"\n");
            buffer.append("请求的方法:"+controller.getRequest().getMethod()+"\n");
            UserAgent userAgent = UserAgent.parseUserAgentString(controller.getRequest().getHeader("User-Agent"));
            buffer.append("浏览器:"+userAgent.getBrowser()+"\n");
            buffer.append("浏览器版本:"+userAgent.getBrowserVersion()+"\n");
            buffer.append("操作系统:"+userAgent.getOperatingSystem()+"\n");
            log.error(buffer.toString(),e);
            controller.render("error.ftl");
        }
    }
}
