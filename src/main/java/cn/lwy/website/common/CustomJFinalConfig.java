package cn.lwy.website.common;

import cn.dreampie.quartz.QuartzPlugin;
import cn.lwy.website.controller.*;
import com.jfinal.config.*;
import com.jfinal.core.Const;
import com.jfinal.ext.handler.ContextPathHandler;
import com.jfinal.ext.interceptor.SessionInViewInterceptor;
import com.jfinal.plugin.activerecord.ActiveRecordPlugin;
import com.jfinal.plugin.activerecord.dialect.AnsiSqlDialect;
import com.jfinal.plugin.c3p0.C3p0Plugin;
import com.jfinal.plugin.ehcache.EhCachePlugin;
import com.jfinal.render.FreeMarkerRender;
import com.jfinal.render.ViewType;
import com.jfinal.template.Engine;

/**
 * Created by lwy on 2017/5/25.
 */
public class CustomJFinalConfig extends JFinalConfig {

    @Override
    public void configConstant(Constants me) {
        // 加载少量必要配置，随后可用PropKit.get(...)获取值
        loadPropertyFile("a_little_config.txt");
        //PropKit.use("a_little_config.txt");
        //me.setDevMode(true);
        me.setViewType(ViewType.FREE_MARKER);
        //设置文件上传的路径
        //me.setBaseUploadPath("/images/articleAttachImage");
        me.setBaseDownloadPath("/");
        //最大上传200M
        me.setMaxPostSize(20* Const.DEFAULT_MAX_POST_SIZE);
    }

    @Override
    public void configRoute(Routes me) {
        me.add("/",ShowContentController.class);
        me.add("/article",ArticleController.class);
        me.add("/production",ProductionController.class);
        me.add("/mood",MoodController.class);
        me.add("/login", LoginController.class);
        me.add("/friendLink",FriendLinkController.class);
        me.add("/system",SystemController.class);
    }

    @Override
    public void configEngine(Engine me) {

    }

    @Override
    public void configPlugin(Plugins me) {
        // 配置C3p0数据库连接池插件
        C3p0Plugin c3p0Plugin = new C3p0Plugin(getProperty("jdbcUrl"), getProperty("user"), getProperty("password").trim(),getProperty("driver"));
        me.add(c3p0Plugin);
        // 配置ActiveRecord插件
        ActiveRecordPlugin arp = new ActiveRecordPlugin(c3p0Plugin);
        me.add(arp);
        arp.setDialect(new AnsiSqlDialect()); //此处是重点，不然会出错
        //arp.setShowSql(true);
        //添加ehcache
        me.add(new EhCachePlugin());
        //添加定时任务
        QuartzPlugin quartz = new QuartzPlugin();
        quartz.setJobs("jobs.properties");
        me.add(quartz);
    }

    @Override
    public void configInterceptor(Interceptors me) {
        //添加session支持,这样才能在freemarker汇总获取session数据,因为jfinal遵循resultful模式,所以没有提供相应的方式
        //HttpServletReuest.getSession(boolean) 方法中的参数决定了在 session不存在时是否要创建一个 session对象
        me.add(new SessionInViewInterceptor(true));
    }

    @Override
    public void configHandler(Handlers me) {
        me.add(new ContextPathHandler("base"));
    }

    //在JFinal初始化完成之后进行Freemarker的配置
    public void afterJFinalStart() {
        //当freemarker页面上出现null时不会抛出空指针异常,而是会将其转化成空串
        //FreeMarkerRender.getConfiguration().setClassicCompatible(true);
        FreeMarkerRender.getConfiguration().setDateTimeFormat("yyyy-MM-dd HH:mm:ss");
        FreeMarkerRender.getConfiguration().setTimeFormat("HH:mm:ss");
        //添加自定义的freemarker的异常处理机制
        FreeMarkerRender.getConfiguration().setTemplateExceptionHandler(new FreemarkerExceptionHandler());
        //设置每次都重新加载,实现每次修改了freemaker文件都会重新加载
        FreeMarkerRender.getConfiguration().setTemplateUpdateDelay(0);
    }
}
