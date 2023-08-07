package com.callray.crm.workbench.controller;

import com.callray.crm.commons.constant.Contants;
import com.callray.crm.commons.domain.ReturnObject;
import com.callray.crm.commons.utils.DateUtil;
import com.callray.crm.commons.utils.UUIDUtils;
import com.callray.crm.settings.domain.User;
import com.callray.crm.settings.service.UserService;
import com.callray.crm.workbench.domain.Contacts;
import com.callray.crm.workbench.domain.Customer;
import com.callray.crm.workbench.domain.CustomerRemark;
import com.callray.crm.workbench.domain.Tran;
import com.callray.crm.workbench.service.ContactsService;
import com.callray.crm.workbench.service.CustomerRemarkService;
import com.callray.crm.workbench.service.CustomerService;
import com.callray.crm.workbench.service.TranService;
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
public class CustomerController {

    @Resource
    private UserService userService;

    @Resource
    private CustomerService customerService;

    @Resource
    private CustomerRemarkService customerRemarkService;

    @Resource
    private TranService tranService;

    @Resource
    private ContactsService contactsService;

    @RequestMapping("/workbench/customer/index.do")
    public String index(HttpServletRequest request) {
        List<User> userList = userService.queryAllUsers();
        request.setAttribute("userList",userList);
        return "workbench/customer/index";
    }

    @RequestMapping("workbench/customer/queryCustomerByConditionForPage.do")
    @ResponseBody
    public Object queryCustomerByConditionForPage(String name,String owner,String phone,String website,int pageNo, int pageSize){
        //封装参数
        Map<String,Object> map = new HashMap<>();
        map.put("name", name);
        map.put("owner", owner);
        map.put("phone", phone);
        map.put("website", website);
        map.put("beginNo",(pageNo-1)*pageSize);
        map.put("pageSize",pageSize);
        //查询数据
        List<Customer> customerList = customerService.queryCustomerListByConditionForPage(map);
        int totalRows = customerService.queryCountOfCustomerListByCondition(map);

        Map<String, Object> customerListAndTotalRows = new HashMap<>();
        customerListAndTotalRows.put("customerList", customerList);
        customerListAndTotalRows.put("totalRows", totalRows);

        return customerListAndTotalRows;
    }

    @RequestMapping("/workbench/customer/saveCreateCustomer.do")
    @ResponseBody
    public Object saveCreateCustomer(Customer customer, HttpSession session){
        ReturnObject returnObject = new ReturnObject();
        //获取当前用户
        User user = (User) session.getAttribute(Contants.SESSION_USER);
        //id, owner, name, website, phone, create_by, create_time,contact_summary,next_contact_time, description, address
        customer.setId(UUIDUtils.getUUID());
        customer.setCreateBy(user.getId());
        customer.setCreateTime(DateUtil.formatDateTime(new Date()));
        try{
            //将customer对象保存到数据库中
            int ret = customerService.saveCreateCustomer(customer);
            if(ret>0){
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
            }
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统正忙，请稍后再试...");
        }
        return returnObject;
    }

    @RequestMapping("/workbench/customer/queryCustomerByCustomerId.do")
    @ResponseBody
    public Object queryCustomerByCustomerId(String customerId){
        Customer customer = customerService.queryCustomerByCustomerId(customerId);
        return customer;
    }

    @RequestMapping("/workbench/customer/saveEditCustomerByCustomerId.do")
    @ResponseBody
    public Object saveEditCustomerByCustomerId(Customer customer,HttpSession session){
        ReturnObject returnObject = new ReturnObject();
        User user = (User) session.getAttribute(Contants.SESSION_USER);
        //封装参数
        customer.setEditBy(user.getId());
        customer.setEditTime(DateUtil.formatDateTime(new Date()));
        try {
            int ret = customerService.saveEditCustomerByCustomerId(customer);
            if (ret == 1) {
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
            }
        }catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统正忙，请稍后再试...");
        }
        return returnObject;
    }

    @RequestMapping("/workbench/customer/deleteCustomerByCustomerIds.do")
    @ResponseBody
    public Object deleteCustomerByCustomerIds(String[] id) {
        ReturnObject returnObject = new ReturnObject();
        try {
            int ret = customerService.deleteCustomerByCustomerIds(id);
            if (ret > 0) {
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
                returnObject.setMessage("选中"+id.length+"条数据,成功删除了"+ret+"条数据!");
            }
        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统异常，请稍后再试...");
        }
        return returnObject;
    }

    @RequestMapping("/workbench/customer/detailCustomer.do")
    public String detail(String customerId,HttpServletRequest request){
        //根据客户id查询详细信息
        Customer customer = customerService.queryCustomerByCustomerIdForDetails(customerId);
        //将customer存入request中
        request.setAttribute("customer", customer);
        //根据客户id查询备注信息
        List<CustomerRemark> customerRemarkList = customerRemarkService.queryCustomerRemarkListByCustomerId(customerId);
        //将customerRemarkList存入request
        request.setAttribute("customerRemarkList", customerRemarkList);
        //根据客户id查询交易信息
        List<Tran> tranList = tranService.queryTranListByCustomerId(customerId);
        //将tranList存入request
        request.setAttribute("tranList", tranList);
        //根据客户id查询联系人信息
        List<Contacts> contactsList = contactsService.queryContactsListByCustomerId(customerId);
        //将contacts存入request中
        request.setAttribute("contactsList", contactsList);

        return "/workbench/customer/detail";
    }


    @RequestMapping("/workbench/customer/saveEditCustomerRemarkByCustomerRemarkId.do")
    @ResponseBody
    public Object saveEditCustomerRemarkByCustomerRemarkId(CustomerRemark customerRemark,HttpSession session){
        ReturnObject returnObject = new ReturnObject();
        User user = (User) session.getAttribute(Contants.SESSION_USER);
        customerRemark.setEditBy(user.getId());
        customerRemark.setEditTime(DateUtil.formatDateTime(new Date()));
        customerRemark.setEditFlag(Contants.REMARK_EDIT_FLAG_YES_EDITED);
        try {
            int ret = customerRemarkService.saveEditCustomerRemarkByCustomerRemarkId(customerRemark);
            if (ret == 1) {
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
                returnObject.setReturnData(customerRemark);
            }
        }catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统正忙，请稍后再试...");
        }
        return returnObject;
    }

    @RequestMapping("/workbench/customer/saveCreateCustomerRemarkByCustomerRemarkId.do")
    @ResponseBody
    public Object saveCreateCustomerRemarkByCustomerRemarkId(CustomerRemark customerRemark,HttpSession session){
        ReturnObject returnObject = new ReturnObject();
        User user = (User) session.getAttribute(Contants.SESSION_USER);
        //封装参数
        customerRemark.setId(UUIDUtils.getUUID());
        customerRemark.setCreateBy(user.getId());
        customerRemark.setCreateTime(DateUtil.formatDateTime(new Date()));
        customerRemark.setEditFlag(Contants.REMARK_EDIT_FLAG_NO_EDITED);
        try {
           int ret = customerRemarkService.saveCreateCustomerRemarkByCustomerRemarkId(customerRemark);
           if (ret == 1) {
               returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
               returnObject.setReturnData(customerRemark);
           }else{
               returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
               returnObject.setMessage("系统繁忙，请稍后再试...");
           }
        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统忙，请稍后再试...");
        }
        return returnObject;
    }

    @RequestMapping("/workbench/customer/deleteCustomerRemarkByCustomerRemarkId.do")
    @ResponseBody
    public Object deleteCustomerRemarkByCustomerRemarkId(String customerRemarkId){
        ReturnObject returnObject = new ReturnObject();
        try {
            int ret = customerRemarkService.deleteCustomerRemarkByCustomerRemarkId(customerRemarkId);
            if (ret == 1) {
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
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













}
