package com.callray.crm.workbench.mapper;

import com.callray.crm.workbench.domain.CustomerRemark;

import java.util.List;

public interface CustomerRemarkMapper {
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_customer_remark
     *
     * @mbggenerated Sat May 06 10:58:11 CST 2023
     */
    int deleteByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_customer_remark
     *
     * @mbggenerated Sat May 06 10:58:11 CST 2023
     */
    int insert(CustomerRemark record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_customer_remark
     *
     * @mbggenerated Sat May 06 10:58:11 CST 2023
     */
    int insertSelective(CustomerRemark record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_customer_remark
     *
     * @mbggenerated Sat May 06 10:58:11 CST 2023
     */
    CustomerRemark selectByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_customer_remark
     *
     * @mbggenerated Sat May 06 10:58:11 CST 2023
     */
    int updateByPrimaryKeySelective(CustomerRemark record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_customer_remark
     *
     * @mbggenerated Sat May 06 10:58:11 CST 2023
     */
    int updateByPrimaryKey(CustomerRemark record);

    /**
     * 插入customerRemark
     * @param customerRemarkList customerRemarkList
     * @return int
     */
    int insertCustomerRemarkList(List<CustomerRemark> customerRemarkList);

    /**
     * 根据customerId查询与之关联的customerRemark信息
     * @param customerId customerId
     * @return customerRemarkList
     */
    List<CustomerRemark> selectCustomerRemarkListByCustomerId(String customerId);

    /**
     * 根据customerRemarkId更新customerRemark
     * @param customerRemark customerRemark
     * @return int
     */
    int updateCustomerRemarkByCustomerRemarkId(CustomerRemark customerRemark);

    /**
     * 根据customerRemarkId删除customerRemark
     * @param customerRemarkId id
     * @return int
     */
    int deleteCustomerRemarkByCustomerRemarkId(String customerRemarkId);

    /**
     * 插入customerRemark
     * @param customerRemark 客户备注
     * @return int
     */
    int insertCustomerRemark(CustomerRemark customerRemark);
}