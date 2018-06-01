package cn.lwy.website.controller;

import cn.lwy.website.service.SystemService;
import com.jfinal.core.Controller;
import com.jfinal.plugin.ehcache.CacheKit;

/**
 * Created by lwy on 2017/6/22.
 */
public class SystemController extends Controller {
    private static SystemService systemService = new SystemService();

    //获取修改密码页面
    public void getAlterPasswordAdminPage(){
        setAttr("currentModule", "修改密码");
        setAttr("body_file_path", "alterPassword.ftl");
        render("/admin/main.ftl");
    }

    //修改密码
    public void alterPassword() {
        String password = getPara("password");
        if (systemService.alterPassword(password) > 0) {
            renderText("ok");
        } else {
            renderText("error");
        }
    }

    //清空系统缓存
    public void clearSystemCache() {
        CacheKit.removeAll("indexCache");
        CacheKit.removeAll("moodListCache");
        CacheKit.removeAll("articleListCache");
        CacheKit.removeAll("productionListCache");
        CacheKit.removeAll("articleDetailCache");
        CacheKit.removeAll("productionDetailCache");
        CacheKit.removeAll("friendLinkCache");
        //要将静态页面的缓存全部清除才行,不然每次修改过后都要重新修改一次
        CacheKit.removeAll("aboutMeCache");
        CacheKit.removeAll("messageBoardCache");
        renderText("ok");
    }
}
