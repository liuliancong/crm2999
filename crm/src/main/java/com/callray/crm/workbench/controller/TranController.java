package com.callray.crm.workbench.controller;

import com.callray.crm.commons.constant.Contants;
import com.callray.crm.commons.domain.ReturnObject;
import com.callray.crm.commons.utils.DateUtil;
import com.callray.crm.commons.utils.UUIDUtils;
import com.callray.crm.settings.domain.User;
import com.callray.crm.settings.service.UserService;
import com.callray.crm.workbench.domain.*;
import com.callray.crm.workbench.service.*;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.*;

@Controller
public class TranController {

    @Resource
    private DicValueService dicValueService;

    @Resource
    private TranService tranService;

    @Resource
    private UserService userService;

    @Resource
    private ActivityService activityService;

    @Resource
    private ContactsService contactsService;

    @Resource
    private CustomerService customerService;

    @Resource
    private TranRemarkService tranRemarkService;

    @Resource
    private TranHistoryService tranHistoryService;

    @RequestMapping("/workbench/transaction/index.do")
    public String index(HttpServletRequest request){
        List<DicValue> dicValueStageList = dicValueService.queryDicValueByTypeCodeForOrderNoSort(Contants.DIC_VALUE_TYPE_CODE_STAGE);
        List<DicValue> dicValueTransactionTypeList = dicValueService.queryDicValueByTypeCodeForOrderNoSort(Contants.DIC_VALUE_TYPE_CODE_TRANSACTION_TYPE);
        List<DicValue> dicValueSourceList = dicValueService.queryDicValueByTypeCodeForOrderNoSort(Contants.DIC_VALUE_TYPE_CODE_SOURCE);
        request.setAttribute("dicValueSourceList", dicValueSourceList);
        request.setAttribute("dicValueTransactionTypeList", dicValueTransactionTypeList);
        request.setAttribute("dicValueStageList", dicValueStageList);
        return "workbench/transaction/index";
    }


    @RequestMapping("/workbench/transaction/queryTranListByConditionForPage.do")
    @ResponseBody
    public Object queryTranListByConditionForPage(String owner,String name,String customerName,String stage,String type,String source,
                                                  String contactsName,int pageNo,int pageSize){
        //封装参数
        Map<String,Object> map = new HashMap<>();
        map.put("owner",owner);
        map.put("name",name);
        map.put("customerName", customerName);
        map.put("stage", stage);
        map.put("type", type);
        map.put("source", source);
        map.put("contactsName", contactsName);
        map.put("beginNo", (pageNo -1) * pageSize);
        map.put("pageSize", pageSize);

        List<Tran> tranList = tranService.queryTranListByConditionForPage(map);
        int totalRows = tranService.queryCountTranListByCondition(map);

        Map<String,Object> resultMap = new HashMap<>();
        resultMap.put("tranList",tranList);
        resultMap.put("totalRows", totalRows);

        return resultMap;
    }

    @RequestMapping("/workbench/transaction/toSaveCreateTran.do")
    public String toSaveCreateTran(HttpServletRequest request){
        List<User> userList = userService.queryAllUsers();
        List<DicValue> dicValueStageList = dicValueService.queryDicValueByTypeCodeForOrderNoSort(Contants.DIC_VALUE_TYPE_CODE_STAGE);
        List<DicValue> dicValueTransactionTypeList = dicValueService.queryDicValueByTypeCodeForOrderNoSort(Contants.DIC_VALUE_TYPE_CODE_TRANSACTION_TYPE);
        List<DicValue> dicValueSourceList = dicValueService.queryDicValueByTypeCodeForOrderNoSort(Contants.DIC_VALUE_TYPE_CODE_SOURCE);
        request.setAttribute("userList", userList);
        request.setAttribute("dicValueSourceList", dicValueSourceList);
        request.setAttribute("dicValueTransactionTypeList", dicValueTransactionTypeList);
        request.setAttribute("dicValueStageList", dicValueStageList);

        return "workbench/transaction/save";
    }

    @RequestMapping("/workbench/transaction/queryActivityByActivityName.do")
    @ResponseBody
    public Object queryActivityByActivityName(String activityName) {
        List<Activity> activityList = activityService.queryActivityByActivityName(activityName);
        return activityList;
    }

    @RequestMapping("/workbench/transaction/queryContactsListByContactsName.do")
    @ResponseBody
    public Object queryContactsListByContactsName(String contactsName) {
        List<Contacts> contactsList = contactsService.queryContactsListByContactsName(contactsName);
        return contactsList;
    }


    @RequestMapping("/workbench/transaction/getPossibilityForPage")
    @ResponseBody
    public Object getPossibilityForPage(String stage){
        ResourceBundle possibility = ResourceBundle.getBundle("possibility");
        String possibilityString = possibility.getString(stage);
        return possibilityString;
    }

    @RequestMapping("/workbench/transaction/queryCustomerNameByCustomerName.do")
    @ResponseBody
    public Object queryCustomerNameByCustomerName(String customerName){
        List<String> customerNameList = customerService.queryCustomerNameByCustomerName(customerName);
        return customerNameList;
    }

    @RequestMapping("/workbench/transaction/saveCreateTran.do")
    @ResponseBody
    public Object saveCreateTran(@RequestParam Map<String,Object> map, HttpSession session){
        map.put(Contants.SESSION_USER,session.getAttribute(Contants.SESSION_USER));
        ReturnObject returnObject = new ReturnObject();
        try{
            tranService.saveCreateTran(map);
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统忙,请稍后再试...");
        }
        return returnObject;
    }

    @RequestMapping("/workbench/transaction/editTran.do")
    public String editTran(String tranId,HttpServletRequest request){
        List<User> userList = userService.queryAllUsers();
        List<DicValue> dicValueStageList = dicValueService.queryDicValueByTypeCodeForOrderNoSort(Contants.DIC_VALUE_TYPE_CODE_STAGE);
        List<DicValue> dicValueTransactionTypeList = dicValueService.queryDicValueByTypeCodeForOrderNoSort(Contants.DIC_VALUE_TYPE_CODE_TRANSACTION_TYPE);
        List<DicValue> dicValueSourceList = dicValueService.queryDicValueByTypeCodeForOrderNoSort(Contants.DIC_VALUE_TYPE_CODE_SOURCE);
        request.setAttribute("userList", userList);
        request.setAttribute("dicValueSourceList", dicValueSourceList);
        request.setAttribute("dicValueTransactionTypeList", dicValueTransactionTypeList);
        request.setAttribute("dicValueStageList", dicValueStageList);
        request.setAttribute("tranId",tranId);
        return "workbench/transaction/edit";
    }

    @RequestMapping("/workbench/transaction/queryTranByTranId")
    @ResponseBody
    public Object queryTranByTranId(String tranId){
        //根据tranId查询出所有tran信息
        Tran tran = tranService.queryTranDetailByTranId(tranId);

        //根据tranId查询出customerName，activityName,contactsName,stage
        Tran tranCustomerNameActivityNameContactsNameStage = tranService.queryTranCustomerNameActivityNameContactsNameStageValue(tranId);
        //根据stage的值查询出possibility
        ResourceBundle bundle = ResourceBundle.getBundle("possibility");
        String possibility = bundle.getString(tranCustomerNameActivityNameContactsNameStage.getStage());
        tranCustomerNameActivityNameContactsNameStage.setPossibility(possibility);

        //封装数据
        Map<String,Object> map = new HashMap<>();
        map.put("tran", tran);
        map.put("tranCustomerNameActivityNameContactsNameStage",tranCustomerNameActivityNameContactsNameStage);
        return  map;
    }

    @RequestMapping("/workbench/transaction/saveEditTran.do")
    @ResponseBody
    public Object saveEditTran(@RequestParam Map<String,Object> map,HttpSession session){
        User user = (User) session.getAttribute(Contants.SESSION_USER);
        map.put(Contants.SESSION_USER,user);
        ReturnObject returnObject = new ReturnObject();
        try{
            tranService.saveEditTran(map);
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
        }catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统忙，请稍后再试...");
        }
        return returnObject;
    }

    @RequestMapping("/workbench/transaction/detailTran.do")
    public String detailTran(String tranId,HttpServletRequest request){
        //查出交易信息
        Tran tran = tranService.queryTranForDetailByTranId(tranId);
        ResourceBundle bundle = ResourceBundle.getBundle("possibility");
        String possibility = bundle.getString(tran.getStage());
        tran.setPossibility(possibility);
        request.setAttribute("tran",tran);
        //根据tranId查询所有交易备注信息
        List<TranRemark> tranRemarkList = tranRemarkService.queryTranRemarkListByTranId(tranId);
        request.setAttribute("tranRemarkList", tranRemarkList);
        //根据tranId查询所有交易内容信息
        List<TranHistory> tranHistoryList = tranHistoryService.queryTranHistoryListByTranIdOrderByCreateTime(tranId);
        request.setAttribute("tranHistoryList", tranHistoryList);
        //查询出所有的stage
        List<DicValue> stageList = dicValueService.queryDicValueByTypeCodeForOrderNoSort(Contants.DIC_VALUE_TYPE_CODE_STAGE);
        request.setAttribute("stageList", stageList);

        return "workbench/transaction/detail";
    }

    @RequestMapping("/workbench/transaction/saveCreateTranRemark.do")
    @ResponseBody
    public Object saveCreateTranRemark(TranRemark tranRemark,HttpSession session){
        User user = (User)session.getAttribute(Contants.SESSION_USER);
        tranRemark.setId(UUIDUtils.getUUID());
        tranRemark.setCreateBy(user.getId());
        tranRemark.setCreateTime(DateUtil.formatDateTime(new Date()));
        tranRemark.setEditFlag(Contants.REMARK_EDIT_FLAG_NO_EDITED);
        ReturnObject returnObject = new ReturnObject();
        try{
            int ret = tranRemarkService.saveCreateTranRemark(tranRemark);
            if(ret==1){
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
                returnObject.setReturnData(tranRemark);
            }else{
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统忙，请稍后再试...");
            }
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统忙，请稍后再试...");
        }
        return returnObject;
    }

    @RequestMapping("/workbench/transaction/saveEditTranRemark.do")
    @ResponseBody
    public Object saveEditTranRemark(TranRemark tranRemark,HttpSession session){
        ReturnObject returnObject = new ReturnObject();
        User user = (User)session.getAttribute(Contants.SESSION_USER);
        tranRemark.setEditFlag(Contants.REMARK_EDIT_FLAG_YES_EDITED);
        tranRemark.setEditTime(DateUtil.formatDateTime(new Date()));
        tranRemark.setEditBy(user.getId());
        try{
            int ret = tranRemarkService.saveEditTranRemark(tranRemark);
            if(ret==1){
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
                returnObject.setReturnData(tranRemark);
            }else{
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统忙，请稍后再试...");
            }
        }catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统忙，请稍后再试...");
        }
        return returnObject;
    }

    @RequestMapping("/workbench/transaction/deleteTranRemarkByTranRemarkId.do")
    @ResponseBody
    public Object deleteTranRemarkByTranRemarkId(String tranRemarkId){
        ReturnObject returnObject = new ReturnObject();
        try{
            int ret = tranRemarkService.deleteTranRemarkByTranRemarkId(tranRemarkId);
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






}



