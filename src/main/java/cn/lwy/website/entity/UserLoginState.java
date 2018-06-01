package cn.lwy.website.entity;

import java.util.Date;

/**
 * Created by lwy on 2017/6/20.
 */
public class UserLoginState {
    private String ip;
    private boolean forbidden;
    private Date lastLoginTime;
    private int errorTimes;

    public UserLoginState(boolean forbidden,Date lastLoginTime,int errorTimes){
        this.forbidden=forbidden;
        this.lastLoginTime=lastLoginTime;
        this.errorTimes=errorTimes;
    }

    public String getIp() {
        return ip;
    }

    public void setIp(String ip) {
        this.ip = ip;
    }

    public boolean getForbidden() {
        return forbidden;
    }

    public void setForbidden(boolean forbidden) {
        this.forbidden = forbidden;
    }

    public Date getLastLoginTime() {
        return lastLoginTime;
    }

    public void setLastLoginTime(Date lastLoginTime) {
        this.lastLoginTime = lastLoginTime;
    }

    public int getErrorTimes() {
        return errorTimes;
    }

    public void setErrorTimes(int errorTimes) {
        this.errorTimes = errorTimes;
    }
}
