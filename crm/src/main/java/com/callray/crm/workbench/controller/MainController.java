package com.callray.crm.workbench.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class MainController {

    @RequestMapping("/workbench/main/index.do")
    public String mainIndex(){
        return "workbench/main/index";
    }
}
