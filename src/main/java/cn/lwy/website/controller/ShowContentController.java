package cn.lwy.website.controller;

import cn.lwy.website.interceptor.DaysHitsInterceptor;
import cn.lwy.website.interceptor.ExceptionAndLogInterceptor;
import cn.lwy.website.interceptor.ShowContentInterceptor;
import cn.lwy.website.service.ShowContentService;
import com.jfinal.aop.Before;
import com.jfinal.aop.Clear;
import com.jfinal.core.Controller;
import com.jfinal.ext.interceptor.SessionInViewInterceptor;
import com.jfinal.plugin.ehcache.CacheInterceptor;
import com.jfinal.plugin.ehcache.CacheName;
import org.apache.log4j.Logger;

import javax.servlet.http.Cookie;
import java.util.List;

/**
 * Created by lwy on 2017/5/25.
 * 我们将获取前端页面的控制器和管理后台页面的控制器进行分开,这样我们在不同的地方加上不同的AOP操作来防止非法用户进行后台的访问操作
 * 而且一般前端的页面数据和后台要获取的页面数据很大程度是不一样的,所以不存在代码冗余
 * 只有需要进行数据库操作的controller我们才进行缓存,其他的直接返回页面信息的我们不进行缓存
 */
@Before({ExceptionAndLogInterceptor.class,ShowContentInterceptor.class})
public class ShowContentController extends Controller {
    //获取日志输入对象
    private static Logger logger=Logger.getLogger(ShowContentController.class);

    private static ShowContentService showContentService = new ShowContentService();

    //获取首页
    @Before(CacheInterceptor.class)
    @CacheName("indexCache")
    public void index() {
        //获取当前所有的标签
        setAttr("allLabel", showContentService.getAllLabel());
        //获取当前推荐的文章
        setAttr("recommendArticle", showContentService.getArticleListPaging("recommend"));
        //获取当前点击率较高的文章
        setAttr("clickRateArticle", showContentService.getArticleListPaging("clickRate"));
        //获取最新发表的文章
        setAttr("newArticle", showContentService.getArticleListPaging("new"));
        //获取随机生成的作品推荐
        setAttr("recommendProduction",showContentService.recommendProduction());
        //获取友情链接
        setAttr("friendLink", showContentService.getFriendLink());
        setAttr("body_file_path", "index.ftl");
    }

    //获取关于我页面
    @CacheName("aboutMeCache")
    public void getAboutMe() {
        setAttr("body_file_path", "about.ftl");
    }

    //获取心情列表页面(在该页面上需要使用session,所以需要配置相应的拦截器)
    @Before(CacheInterceptor.class)
    @CacheName("moodListCache")
    public void getMyMood() {
        //初始化时获取头十条心情
        setAttr("moodList", showContentService.getMoodData(1, 10));
        //获取友情链接
        setAttr("friendLink", showContentService.getFriendLink());
        setAttr("body_file_path", "moodList.ftl");
    }

    //提供给外部分页获取数据的方法
    @Clear
    @Before(CacheInterceptor.class)
    @CacheName("moodListCache")
    public void getMoodData() {
        int pageNumber = getParaToInt("pageNumber");
        int pageSize = getParaToInt("pageSize");
        setAttr("moodList", showContentService.getMoodData(pageNumber, pageSize));
        setAttr("session",getSession());
        render("moodTemplate.ftl");
    }

    //获取文章列表页面
    @Before(CacheInterceptor.class)
    @CacheName("articleListCache")
    public void getMyArticle() {
        //获取标签类型以及当前页码
        int labelId = getParaToInt("labelId");
        int pageNumber = getParaToInt("pageNumber");
        int pageSize = getParaToInt("pageSize");
        setAttr("articleList", showContentService.getArticleList(labelId, pageNumber, pageSize));
        //获取当前点击率较高的文章
        setAttr("clickRateArticle", showContentService.getArticleListPaging("clickRate"));
        //获取最新发表的文章
        setAttr("newArticle", showContentService.getArticleListPaging("new"));
        //设置当前页码
        setAttr("currentPage", pageNumber);
        //设置总页数
        int totalRecord = showContentService.getArticleSum(labelId);
        setAttr("totalPages", totalRecord % pageSize == 0 ? totalRecord / pageSize : totalRecord / pageSize + 1);
        //设置当前标签
        setAttr("labelId", labelId);
        //获取友情链接
        setAttr("friendLink", showContentService.getFriendLink());
        setAttr("body_file_path", "articleList.ftl");
    }

    //获取作品列表(因为作品不是很多,所以一次性获取完)
    @Before(CacheInterceptor.class)
    @CacheName("productionListCache")
    public void getMyProduction() {
        String type = getPara("type");
        setAttr("productList", showContentService.getProductionData(type));
        setAttr("newProduction", showContentService.getProductionListByState("new"));
        setAttr("clickRateProduction", showContentService.getProductionListByState("hits"));
        //获取友情链接
        setAttr("friendLink", showContentService.getFriendLink());
        setAttr("body_file_path", "productionList.ftl");
    }

    //获取作品的详细信息
    @Before({DaysHitsInterceptor.class, CacheInterceptor.class})
    @CacheName("productionDetailCache")
    public void getProductionContent() {
        int productionId = getParaToInt("productionId");
        setAttr("productionContent", showContentService.getProductionContentById(productionId));
        setAttr("newProduction", showContentService.getProductionListByState("new"));
        setAttr("clickRateProduction", showContentService.getProductionListByState("hits"));
        //设置上一个作品
        setAttr("lastProduction", showContentService.getLastOrNext("production", "last", productionId));
        //设置下一个作品
        setAttr("nextProduction", showContentService.getLastOrNext("production", "next", productionId));
        //获取友情链接
        setAttr("friendLink", showContentService.getFriendLink());
        setAttr("body_file_path", "productionDetailInfo.ftl");
        setAttr("productionId", productionId);
    }

    //获取文章详细信息页面
    @Before({DaysHitsInterceptor.class, CacheInterceptor.class})
    @CacheName("articleDetailCache")
    public void getArticleDetailInfo() {
        int articleId = getParaToInt("articleId");
        setAttr("articleContent", showContentService.getArticleContentById(articleId));
        //获取当前点击率较高的文章
        setAttr("clickRateArticle", showContentService.getArticleListPaging("clickRate"));
        //获取最新发表的文章
        setAttr("newArticle", showContentService.getArticleListPaging("new"));
        //设置上一篇文章
        setAttr("lastArticle", showContentService.getLastOrNext("article", "last", articleId));
        //设置下一篇文章
        setAttr("nextArticle", showContentService.getLastOrNext("article", "next", articleId));
        //获取友情链接
        setAttr("friendLink", showContentService.getFriendLink());
        setAttr("body_file_path", "articleDetailInfo.ftl");
        setAttr("articleId", articleId);
    }

    //获取留言页面
    @CacheName("messageBoardCache")
    public void getMessageBoard() {
        String autoOpenLogin=getPara("autoOpenLogin");
        if(autoOpenLogin!=null && autoOpenLogin.equals("true")){
            setAttr("autoOpenLogin","true");
        }
        setAttr("body_file_path", "messageBoard.ftl");
    }

    //获取登录页面
    @Clear      //清除类拦截
    public void userLogin() {
        //获取cookie
        Cookie[] cookies=getRequest().getCookies();
        logger.info("cookie个数:"+cookies.length);
        for(Cookie cookie:cookies){
            if(cookie.getName().equals("username")){
                logger.info("username"+cookie.getValue());
                setAttr("username",cookie.getValue());
            } else if(cookie.getName().equals("password")){
                logger.info("password"+cookie.getValue());
                setAttr("password",cookie.getValue());
            }
        }
        render("login.ftl");
    }

}
