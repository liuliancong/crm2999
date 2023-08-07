package com.callray.crm.settings.web.controller;

import com.callray.crm.commons.constant.Contants;
import com.callray.crm.commons.domain.ReturnObject;
import com.callray.crm.commons.utils.DateUtil;
import com.callray.crm.settings.domain.User;
import com.callray.crm.settings.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

@Controller
public class UserController {

    @Resource
    private UserService userService;

    /**
     * url
     * @return url
     */
    @RequestMapping("/settings/qx/user/toLogin.do")
    public String toLogin(){
        return "settings/qx/user/login";
    }

    @RequestMapping("/settings/qx/user/login.do")
    @ResponseBody
    public Object login(String loginAct, String loginPwd, Boolean isRemPwd, HttpServletRequest request, HttpSession session, HttpServletResponse response){
        //封装参数
        Map<String,Object> map = new HashMap<>();
        map.put("loginAct",loginAct);
        map.put("loginPwd",loginPwd);
        //调用service层方法，查询用户
        User user = userService.queryUserByLoginActAndPwd(map);
        //根据查询结果，生成响应信息
        ReturnObject returnObject = new ReturnObject();
        if(user==null){
            //登录失败，用户名或者密码错误
             returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
             returnObject.setMessage("用户名或密码错误");
        }else{//进一步判断账号是否合法
            //获取用户的过期时间
            String expireTime = user.getExpireTime();
            //获取当前时间
            String dateTime = DateUtil.formatDateTime(new Date());
            if(expireTime.compareTo(dateTime) < 0){
                //账号已过期
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("账号已过期");
            }else if("0".equals(user.getLockState())){
                //状态被锁定，登录失败
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("状态被锁定");
            }else if(!user.getAllowIps().contains(request.getRemoteAddr())){
                //登录失败
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("IP受限");
            }else{
                //登录成功
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);

                //将登录信息写入session中
                session.setAttribute(Contants.SESSION_USER,user);

                //如果是记住密码，将前端cookie设置为10天
                if(isRemPwd){
                    Cookie c1 = new Cookie("loginAct",user.getLoginAct());
                    c1.setMaxAge(60*60*24*10);
                    response.addCookie(c1);
                    Cookie c2 = new Cookie("loginPwd",user.getLoginPwd());
                    c2.setMaxAge(60*60*24*10);
                    response.addCookie(c2);
                }else{
                    Cookie c1 = new Cookie("loginAct","1");
                    c1.setMaxAge(0);
                    response.addCookie(c1);
                    Cookie c2 = new Cookie("loginPwd","1");
                    c2.setMaxAge(0);
                    response.addCookie(c2);
                }
            }
        }
        return returnObject;
    }

    //安全退出
    @RequestMapping("/settings/qx/user/logout.do")
    public String logout(HttpSession session,HttpServletResponse response){

        //将session设置为无效的
        session.setMaxInactiveInterval(0);
        //将Cookie设置为无效的
        Cookie c1 = new Cookie("loginAct","1");
        c1.setMaxAge(0);
        response.addCookie(c1);
        Cookie c2 = new Cookie("loginPwd","1");
        c2.setMaxAge(0);
        response.addCookie(c2);

        return "redirect:/";
    }





}