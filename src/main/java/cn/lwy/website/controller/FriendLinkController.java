package cn.lwy.website.controller;

import cn.lwy.website.interceptor.ClearFriendLinkCacheInterceptor;
import cn.lwy.website.service.FriendLinkService;
import com.jfinal.aop.Before;
import com.jfinal.aop.Enhancer;
import com.jfinal.core.Controller;

/**
 * Created by lwy on 2017/6/22.
 */
//当修改了友情链接之后要清空缓存
@Before(ClearFriendLinkCacheInterceptor.class)
public class FriendLinkController extends Controller {
    private static FriendLinkService friendLinkService = Enhancer.enhance(FriendLinkService.class);

    //获取友情链接管理首页
    public void getFriendLinkAdminPage(){
        setAttr("currentModule", "友情链接管理");
        setAttr("body_file_path", "manageFriendLink.ftl");
        render("/admin/main.ftl");
    }

    //添加友情链接
    public void addFriendLink() {
        String fl_link_text = getPara("fl_link_text");
        String fl_link_url = getPara("fl_link_url");
        if (friendLinkService.addFriendLink(fl_link_text, fl_link_url)) {
            renderText("ok");
        } else {
            renderText("error");
        }
    }

    //获取友情链接列表
    public void getFriendLinkList() {
        renderJson(friendLinkService.getFriendLinkList());
        ;
    }

    //修改友情链接
    public void updateFriendLink() {
        String fl_id = getPara("fl_id");
        String fl_link_text = getPara("fl_link_text");
        String fl_link_url = getPara("fl_link_url");
        if (friendLinkService.updateFriendLink(fl_id, fl_link_text, fl_link_url) > 0) {
            renderText("ok");
        } else {
            renderTemplate("error");
        }
    }

    //删除友情链接
    public void deleteFriendLink() {
        String allFriendLink = getPara("allFriendLink");
        friendLinkService.deleteFriendLink(allFriendLink);
        renderText("ok");
    }
}
