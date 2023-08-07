package com.callray.crm.commons.interceptor;

import com.callray.crm.commons.constant.Contants;
import com.callray.crm.settings.domain.User;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class LoginInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {

        //判断用户是否登录，可以从session中获取sessionUser的值
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute(Contants.SESSION_USER);
        if(user==null){
            //重定向：跳转到登录页面
            response.sendRedirect(request.getContextPath());
            return false;
        }
        return HandlerInterceptor.super.preHandle(request, response, handler);
    }


}
