package com.callray.crm.workbench.service.impl;

import com.callray.crm.workbench.domain.Contacts;
import com.callray.crm.workbench.mapper.ContactsMapper;
import com.callray.crm.workbench.service.ContactsService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

@Service("contactsService")
public class ContactsServiceImpl implements ContactsService {

    @Resource
    private ContactsMapper contactsMapper;

    @Override
    public List<Contacts> queryContactsListByCustomerId(String customerId) {
        return contactsMapper.selectContactsListByCustomerId(customerId);
    }

    @Override
    public List<Contacts> queryContactsListByConditionForPage(Map<String, Object> map) {
        return contactsMapper.selectContactsListByConditionForPage(map);
    }

    @Override
    public int queryCountContactsListByCondition(Map<String, Object> map) {
        return contactsMapper.selectCountContactsListByCondition(map);
    }

    @Override
    public int saveCreateContacts(Contacts contacts) {
        return contactsMapper.insertContacts(contacts);
    }

    @Override
    public List<Contacts> queryContactsListByContactsName(String contactsName) {
        return contactsMapper.selectContactsListByContactsName(contactsName);
    }


}
