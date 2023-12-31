package com.callray.crm.workbench.mapper;

import com.callray.crm.workbench.domain.Customer;

import java.util.List;
import java.util.Map;

public interface CustomerMapper {
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_customer
     *
     * @mbggenerated Fri May 05 17:11:07 CST 2023
     */
    int deleteByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_customer
     *
     * @mbggenerated Fri May 05 17:11:07 CST 2023
     */
    int insert(Customer record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_customer
     *
     * @mbggenerated Fri May 05 17:11:07 CST 2023
     */
    int insertSelective(Customer record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_customer
     *
     * @mbggenerated Fri May 05 17:11:07 CST 2023
     */
    Customer selectByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_customer
     *
     * @mbggenerated Fri May 05 17:11:07 CST 2023
     */
    int updateByPrimaryKeySelective(Customer record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_customer
     *
     * @mbggenerated Fri May 05 17:11:07 CST 2023
     */
    int updateByPrimaryKey(Customer record);

    /**
     * 插入一条客户记录
     * @param customer customer
     * @return int
     */
    int insertCustomer(Customer customer);

    /**
     * 根据条件，分页查询客户列表
     * @param map map
     * @return CustomerList
     */
    List<Customer> selectCustomerListByConditionForPage(Map<String,Object> map);

    /**
     * 根据条件，查询客户总数
     * @param map map
     * @return int
     */
    int selectCountOfCustomerListByCondition(Map<String, Object> map);

    /**
     * 根据customer的id查询客户
     * @param customerId id
     * @return customer
     */
    Customer selectCustomerByCustomerId(String customerId);

    /**
     * 根据customer的id修改客户
     * @param customer customer
     * @return int
     */
    int updateCustomerByCustomerId(Customer customer);

    /**
     *根据id的数组删除客户
     * @param ids id数组
     * @return int
     */
    int deleteCustomerByCustomerIds(String[] ids);

    /**
     * 根据id查询客户详情
     * @param customerId id
     * @return customer
     */
    Customer selectCustomerByCustomerIdForDetails(String customerId);

    /**
     * 根据客户名模糊查询客户名称
     * @param customerName 客户名称
     * @return stringList
     */
    List<String> selectCustomerNameByCustomerName(String customerName);

    /**
     * 根据客户名称精准查询客户信息
     * @param customerName 客户名称
     * @return customerId
     */
    Customer selectCustomerByCustomerName(String customerName);


}