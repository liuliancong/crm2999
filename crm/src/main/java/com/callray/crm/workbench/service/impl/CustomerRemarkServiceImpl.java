package com.callray.crm.workbench.service.impl;

import com.callray.crm.workbench.domain.CustomerRemark;
import com.callray.crm.workbench.mapper.CustomerRemarkMapper;
import com.callray.crm.workbench.service.CustomerRemarkService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Service("customerRemarkService")
public class CustomerRemarkServiceImpl implements CustomerRemarkService {

    @Resource
    private CustomerRemarkMapper customerRemarkMapper;

    @Override
    public List<CustomerRemark> queryCustomerRemarkListByCustomerId(String customerId) {
        return customerRemarkMapper.selectCustomerRemarkListByCustomerId(customerId);
    }

    @Override
    public int saveEditCustomerRemarkByCustomerRemarkId(CustomerRemark customerRemark) {
        return customerRemarkMapper.updateCustomerRemarkByCustomerRemarkId(customerRemark);
    }

    @Override
    public int saveCreateCustomerRemarkByCustomerRemarkId(CustomerRemark customerRemark) {
        return customerRemarkMapper.insertCustomerRemark(customerRemark);
    }

    @Override
    public int deleteCustomerRemarkByCustomerRemarkId(String customerRemarkId) {
        return customerRemarkMapper.deleteCustomerRemarkByCustomerRemarkId(customerRemarkId);
    }

}
