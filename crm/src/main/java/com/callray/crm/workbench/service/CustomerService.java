package com.callray.crm.workbench.service;

import com.callray.crm.workbench.domain.Customer;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

public interface CustomerService {

    /**
     * 保存创建客户
     * @param customer customer
     * @return int
     */
    int saveCreateCustomer(Customer customer);

    /**
     * 根据条件分页查询客户列表
     * @param map map
     * @return customerList
     */
    List<Customer> queryCustomerListByConditionForPage(Map<String, Object> map);

    /**
     * 根据条件查询客户总数
     * @param map map
     * @return int
     */
    int queryCountOfCustomerListByCondition(Map<String, Object> map);

    /**
     * 根据customer的id查询客户
     * @param customerId id
     * @return customer
     */
    Customer queryCustomerByCustomerId(String customerId);

    /**
     * 根据customer的id修改客户
     * @param customer customer
     * @return int
     */
    int saveEditCustomerByCustomerId(Customer customer);

    /**
     * 根据客户id数组删除客户
     * @param ids id数组
     * @return int
     */
    int deleteCustomerByCustomerIds(String[] ids);

    /**
     * 根据客户id查询客户详细信息
     * @param customerId id
     * @return customer
     */
    Customer queryCustomerByCustomerIdForDetails(String customerId);

    /**
     * 根据客户名模糊查询客户名称
     * @param customerName 客户名称
     * @return stringList
     */
    List<String> queryCustomerNameByCustomerName(String customerName);

}
