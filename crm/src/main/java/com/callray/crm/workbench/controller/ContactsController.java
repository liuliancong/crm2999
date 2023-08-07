package com.callray.crm.workbench.controller;

import com.callray.crm.commons.constant.Contants;
import com.callray.crm.commons.domain.ReturnObject;
import com.callray.crm.commons.utils.DateUtil;
import com.callray.crm.commons.utils.UUIDUtils;
import com.callray.crm.settings.domain.User;
import com.callray.crm.settings.mapper.UserMapper;
import com.callray.crm.settings.service.UserService;
import com.callray.crm.workbench.domain.Contacts;
import com.callray.crm.workbench.domain.DicValue;
import com.callray.crm.workbench.service.ContactsService;
import com.callray.crm.workbench.service.DicValueService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class ContactsController {

    @Resource
    private UserService userService;

    @Resource
    private DicValueService dicValueService;

    @Resource
    private ContactsService contactsService;

    @RequestMapping("workbench/contacts/index.do")
    public String index(HttpServletRequest request) {
        List<User> userList = userService.queryAllUsers();
        request.setAttribute("userList", userList);
        List<DicValue> dicValueSourceList = dicValueService.queryDicValueByTypeCodeForOrderNoSort(Contants.DIC_VALUE_TYPE_CODE_SOURCE);
        request.setAttribute("dicValueSourceList", dicValueSourceList);
        List<DicValue> dicValueAppellationList= dicValueService.queryDicValueByTypeCodeForOrderNoSort(Contants.DIC_VALUE_TYPE_CODE_APPELLATION);
        request.setAttribute("dicValueAppellationList", dicValueAppellationList);

        return "workbench/contacts/index";
    }

    @RequestMapping("/workbench/contacts/queryContactsListByConditionForPage.do")
    @ResponseBody
    public Object queryContactsListByConditionForPage(String owner,String fullname,String customerName,String source,int pageNo, int pageSize){
        Map<String,Object> map = new HashMap<String, Object>();
        map.put("owner", owner);
        map.put("fullname", fullname);
        map.put("customerName", customerName);
        map.put("source", source);
        map.put("beginNo",(pageNo-1)*pageSize);
        map.put("pageSize", pageSize);
        //根据条件分页查询所有联系人信息
        List<Contacts> contactsList = contactsService.queryContactsListByConditionForPage(map);
        //根据条件查询所有记录数量
        int totalRows = contactsService.queryCountContactsListByCondition(map);
        // 创建一个返回值对象
        Map<String, Object> result = new HashMap<String, Object>();
        result.put("contactsList", contactsList);
        result.put("totalRows", totalRows);

        return result;
    }

    @RequestMapping("/workbench/contacts/saveCreateContacts.do")
    @ResponseBody
    public Object saveCreateContacts(Contacts contacts, HttpSession session){
        ReturnObject returnObject = new ReturnObject();
        User user = (User) session.getAttribute(Contants.SESSION_USER);
        contacts.setId(UUIDUtils.getUUID());
        contacts.setCreateBy(user.getId());
        contacts.setCreateTime(DateUtil.formatDateTime(new Date()));
        try{
            int ret = contactsService.saveCreateContacts(contacts);
            if(ret==1){
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
            }else{
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统正忙，请稍后再试!");
            }
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统正忙，请稍后再试!");
        }
        return returnObject;
    }





}
