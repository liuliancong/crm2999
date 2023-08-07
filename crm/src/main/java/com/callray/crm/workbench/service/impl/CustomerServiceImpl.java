package com.callray.crm.workbench.service.impl;

import com.callray.crm.workbench.domain.Customer;
import com.callray.crm.workbench.mapper.CustomerMapper;
import com.callray.crm.workbench.service.CustomerService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

@Service("customerService")
public class CustomerServiceImpl implements CustomerService {
    
    @Resource
    private CustomerMapper customerMapper;
    
    @Override
    public int saveCreateCustomer(Customer customer) {
        return customerMapper.insertCustomer(customer);
    }

    @Override
    public List<Customer> queryCustomerListByConditionForPage(Map<String, Object> map) {
        return customerMapper.selectCustomerListByConditionForPage(map);
    }

    @Override
    public int queryCountOfCustomerListByCondition(Map<String, Object> map) {
        return customerMapper.selectCountOfCustomerListByCondition(map);
    }

    @Override
    public Customer queryCustomerByCustomerId(String customerId) {
        return customerMapper.selectCustomerByCustomerId(customerId);
    }

    @Override
    public int saveEditCustomerByCustomerId(Customer customer) {
        return customerMapper.updateCustomerByCustomerId(customer);
    }

    @Override
    public int deleteCustomerByCustomerIds(String[] ids) {
        return customerMapper.deleteCustomerByCustomerIds(ids);
    }

    @Override
    public Customer queryCustomerByCustomerIdForDetails(String customerId) {
        return customerMapper.selectCustomerByCustomerIdForDetails(customerId);
    }

    @Override
    public List<String> queryCustomerNameByCustomerName(String customerName) {
        return customerMapper.selectCustomerNameByCustomerName(customerName);
    }
}
