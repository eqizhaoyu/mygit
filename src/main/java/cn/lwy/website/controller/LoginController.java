package cn.lwy.website.controller;

import cn.lwy.website.common.CustomObjectMapper;
import cn.lwy.website.entity.User;
import cn.lwy.website.entity.UserInfo;
import cn.lwy.website.entity.UserLoginState;
import cn.lwy.website.service.LoginService;
import com.jfinal.aop.Before;
import com.jfinal.core.Controller;
import com.jfinal.plugin.ehcache.CacheInterceptor;
import com.jfinal.plugin.ehcache.CacheName;
import org.apache.log4j.Logger;

import javax.servlet.http.Cookie;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by lwy on 2017/6/18.
 */
public class LoginController extends Controller {
    private Logger logger=Logger.getLogger(LoginController.class);

    private static LoginService loginService=new LoginService();

    //缓存的话只是将数据保存起来,当接受到相同的参数的时候会将数据直接返回而不会进行controller的访问,所以说如果我们在controller值进行了一些状态保存操作的话有可能就不会执行到了
    //缓存插件暂时不支持缓存text类型的数据,但是支持json类型的数据
    //这里当参数不同的时候也是返回的以前的数据,这就比较尴尬了..
    //预编译的可以防止sqlserver注入
    //@Before(CacheInterceptor.class)
    //@CacheName("loginCache")
    public void index(){
        String userId=getPara("userId");
        String userPassword=getPara("userPassword");
        String rememberMe=getPara("rememberMe");
        logger.info("记住我:"+rememberMe);
        //当用户勾选了记住我之后,将cookie发送到客户端
        if(rememberMe.equals("true")){
            Cookie usernameCookie=new Cookie("username",userId);
            //设置过期未一年
            usernameCookie.setMaxAge(1*365*24*60*60);
            Cookie passwordCookie=new Cookie("password",userPassword);
            //设置过期未一年
            passwordCookie.setMaxAge(1*365*24*60*60);
            //添加cookie(可多次进行添加)
            getResponse().addCookie(usernameCookie);
            getResponse().addCookie(passwordCookie);
        }
        //当存在该用户,跳转
        if(loginService.userLogin(userId,userPassword)>0){
            //保存登录状态
            setSessionAttr("alreadyLogin","lwy");
            //设置session的超时时间为12小时,所以说登录之后最好要安全退出.
            //这样的设置是因为有可能我们在写文章的时候可能会间隔很长一段时间才会进行提交操作(毕竟写文章很慢),session过期了的话就会导致回到首页,以前的数据都没有了...
            getSession().setMaxInactiveInterval(12*60*60);
            renderText("ok");
        }else{
            //当用户输入了错误密码之后
            Object userLoginState=getSession().getAttribute("userLoginState");
            //当用户是第一次登录平台时
            if(userLoginState==null){
                getSession().setAttribute("userLoginState",new UserLoginState(false,new Date(),1));
                renderText("error");
            }else{  //当该用户已经不是第一次进行登录操作了
                //判断是否需要将其进行封锁
                UserLoginState nowUserLoginState=(UserLoginState)userLoginState;
                if(nowUserLoginState.getForbidden()==true){
                    renderText("forbidden");
                }else{  //当还未被冻结
                    nowUserLoginState.setErrorTimes(nowUserLoginState.getErrorTimes()+1);
                    if(nowUserLoginState.getErrorTimes()==3){   //当已输错三次密码
                        nowUserLoginState.setForbidden(true);
                    }
                    renderText("error");
                }
            }
        }
    }

    //退出登录
    public void loginOut(){
        getSession().removeAttribute("alreadyLogin");
        renderText("ok");
    }

    //下面的方法为单点登录获取是否登录的接口方法
    //这里不能使用缓存...
    public void getUserInfo() throws Exception{
        //获取回调函数
        String callback=getPara("callback");
        String loginStatus=getSessionAttr("alreadyLogin");
        UserInfo userinfo = new UserInfo();
        if(loginStatus==null){
            userinfo.setIs_login(0);//用户未登录
        }else{
            userinfo.setIs_login(1);//用户已登录
            User user = new User();
            user.setUser_id(666); //该值具体根据自己用户系统设定
            user.setNickname("lwy"); //该值具体根据自己用户系统设定
            user.setImg_url("/images/userHead/my.png"); //该值具体根据自己用户系统设定，可以为空
            user.setProfile_url("");//该值具体根据自己用户系统设定，可以为空
            user.setSign(""); //签名已弃用，任意赋值即可
            userinfo.setUser(user);
        }
        CustomObjectMapper objectMapper=new CustomObjectMapper();
        //这里就是使用的jsonp
        renderJavascript(callback+"("+objectMapper.writeValueAsString(userinfo)+")");    //拼接成jsonp格式
    }
}
