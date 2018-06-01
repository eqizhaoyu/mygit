package cn.lwy.website.common;

import freemarker.core.Environment;
import freemarker.template.TemplateException;
import freemarker.template.TemplateExceptionHandler;

import java.io.Writer;

/**
 * Created by lwy on 2017/7/3.
 */
public class FreemarkerExceptionHandler implements TemplateExceptionHandler {
    public void handleTemplateException(TemplateException e, Environment environment, Writer writer) throws TemplateException {
        //手动抛出异常(这个方法应该是在jfinalcontroller拦截器前面执行的,这样我们才能获取大请求的客户端地址
        try{
            writer.write("出错啦,请联系博主!");
        }catch(Exception ee){
            throw new TemplateException(
                    "Failed to print error message. Cause: " + ee, environment);
        }
    }
}
