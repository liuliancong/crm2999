package com.callray.crm.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class IndexController {

    //访问index.jsp
    @RequestMapping("/")
    public String Index(){
        return "index"; //请求转发
    }



}
