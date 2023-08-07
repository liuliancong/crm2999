package com.callray.crm.workbench.controller;

import com.callray.crm.commons.constant.Contants;
import com.callray.crm.commons.domain.ReturnObject;
import com.callray.crm.commons.utils.DateUtil;
import com.callray.crm.commons.utils.UUIDUtils;
import com.callray.crm.settings.domain.User;
import com.callray.crm.workbench.domain.ActivityRemark;
import com.callray.crm.workbench.service.ActivityRemarkService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;
import java.util.Date;

@Controller
public class ActivityRemarkController {

    @Resource
    private ActivityRemarkService activityRemarkService;

    @RequestMapping("/workbench/activity/saveCreateActivityRemark.do")
    @ResponseBody
    public Object saveCreateActivityRemark(ActivityRemark activityRemark, HttpSession session){
        //保存创建的活动备注
        User user = (User) session.getAttribute(Contants.SESSION_USER);

        activityRemark.setId(UUIDUtils.getUUID());
        activityRemark.setCreateTime(DateUtil.formatDateTime(new Date()));
        activityRemark.setCreateBy(user.getId());
        activityRemark.setEditFlag(Contants.REMARK_EDIT_FLAG_NO_EDITED);

        ReturnObject returnObject = new ReturnObject();

        try{
            int ret = activityRemarkService.saveCreateActivityRemark(activityRemark);
            if(ret>0){
               returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
               returnObject.setReturnData(activityRemark);
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

    @RequestMapping("/workbench/activity/deleteActivityRemarkById.do")
    @ResponseBody
    public Object deleteActivityRemarkById(String id){
        ReturnObject returnObject = new ReturnObject();

        try{
            int ret = activityRemarkService.deleteActivityRemarkById(id);
            if(ret==1){
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
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

    @RequestMapping("/workbench/activity/saveEditActivityRemarkById.do")
    @ResponseBody
    public Object saveEditActivityRemarkById(ActivityRemark activityRemark,HttpSession session){
        User user = (User) session.getAttribute(Contants.SESSION_USER);
        ReturnObject returnObject = new ReturnObject();

        String editTime = DateUtil.formatDateTime(new Date());
        String editBy = user.getId();

        activityRemark.setEditTime(editTime);
        activityRemark.setEditBy(editBy);
        activityRemark.setEditFlag(Contants.REMARK_EDIT_FLAG_YES_EDITED);

        try{
            int ret = activityRemarkService.saveEditActivityRemarkById(activityRemark);
            if(ret==1){
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
                returnObject.setReturnData(activityRemark);
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




}
