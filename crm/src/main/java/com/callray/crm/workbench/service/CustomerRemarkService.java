package com.callray.crm.workbench.service;

import com.callray.crm.workbench.domain.CustomerRemark;

import java.util.List;

public interface CustomerRemarkService {

    List<CustomerRemark> queryCustomerRemarkListByCustomerId(String customerId);

    int saveEditCustomerRemarkByCustomerRemarkId(CustomerRemark customerRemark);

    int saveCreateCustomerRemarkByCustomerRemarkId(CustomerRemark customerRemark);

    int deleteCustomerRemarkByCustomerRemarkId(String customerRemarkId);

}
