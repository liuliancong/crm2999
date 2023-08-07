package com.callray.crm.workbench.service;

import com.callray.crm.workbench.domain.Contacts;

import java.util.List;
import java.util.Map;

public interface ContactsService {

    List<Contacts> queryContactsListByCustomerId(String customerId);

    List<Contacts> queryContactsListByConditionForPage(Map<String, Object> map);

    int queryCountContactsListByCondition(Map<String,Object> map);

    int saveCreateContacts(Contacts contacts);

    List<Contacts> queryContactsListByContactsName(String contactsName);

}
