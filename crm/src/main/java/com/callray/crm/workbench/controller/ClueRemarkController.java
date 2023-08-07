package com.callray.crm.workbench.controller;

import com.callray.crm.commons.constant.Contants;
import com.callray.crm.commons.domain.ReturnObject;
import com.callray.crm.commons.utils.DateUtil;
import com.callray.crm.commons.utils.UUIDUtils;
import com.callray.crm.settings.domain.User;
import com.callray.crm.workbench.domain.Clue;
import com.callray.crm.workbench.domain.ClueRemark;
import com.callray.crm.workbench.service.ClueRemarkService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;
import java.util.Date;

@Controller
public class ClueRemarkController {

    @Resource
    private ClueRemarkService clueRemarkService;

    @RequestMapping("/workbench/clue/saveCreateClueRemark.do")
    @ResponseBody
    public Object saveCreateClueRemark(ClueRemark clueRemark, HttpSession session){
        User user = (User) session.getAttribute(Contants.SESSION_USER);
        ReturnObject returnObject = new ReturnObject();

        clueRemark.setId(UUIDUtils.getUUID());
        clueRemark.setCreateBy(user.getId());
        clueRemark.setEditFlag(Contants.REMARK_EDIT_FLAG_NO_EDITED);
        clueRemark.setCreateTime(DateUtil.formatDateTime(new Date()));

        try{
            int ret = clueRemarkService.saveCreateClueRemark(clueRemark);
            if(ret==1){
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
                returnObject.setReturnData(clueRemark);
            }else{
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统正忙，请稍后再试...");
            }
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统正忙，请稍后再试...");
        }
        return returnObject;
    }

    @RequestMapping("/workbench/clue/saveEditClueRemarkById.do")
    @ResponseBody
    public Object saveEditClueRemarkById(ClueRemark clueRemark,HttpSession session){
        User user = (User) session.getAttribute(Contants.SESSION_USER);
        ReturnObject returnObject = new ReturnObject();

        clueRemark.setEditBy(user.getId());
        clueRemark.setEditTime(DateUtil.formatDateTime(new Date()));
        clueRemark.setEditFlag(Contants.REMARK_EDIT_FLAG_YES_EDITED);

        try{
            int ret = clueRemarkService.saveEditClueRemarkById(clueRemark);
            if(ret==1){
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
                returnObject.setReturnData(clueRemark);
            }else {
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统正忙，请稍后再试...");
            }
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统正忙，请稍后再试...");
        }

        return returnObject;
    }

    @RequestMapping("/workbench/clue/deleteClueRemarkById.do")
    @ResponseBody
    public Object deleteClueRemarkById(String id){
        ReturnObject returnObject = new ReturnObject();

        try{
            int ret = clueRemarkService.deleteClueRemarkById(id);
            if(ret==1){
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
            }else {
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统正忙，请稍后再试...");
            }
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统正忙，请稍后再试...");
        }
        return returnObject;
    }













}
