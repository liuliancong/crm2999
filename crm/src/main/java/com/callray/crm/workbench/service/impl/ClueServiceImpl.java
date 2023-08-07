package com.callray.crm.workbench.service.impl;

import com.callray.crm.commons.constant.Contants;
import com.callray.crm.commons.domain.ReturnObject;
import com.callray.crm.commons.utils.DateUtil;
import com.callray.crm.commons.utils.UUIDUtils;
import com.callray.crm.settings.domain.User;
import com.callray.crm.workbench.domain.*;
import com.callray.crm.workbench.mapper.*;
import com.callray.crm.workbench.service.ClueService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

@Service("clueService")
public class ClueServiceImpl implements ClueService {

    @Resource
    private ClueMapper clueMapper;

    @Resource
    private CustomerMapper customerMapper;

    @Resource
    private ContactsMapper contactsMapper;

    @Resource
    private ClueRemarkMapper clueRemarkMapper;

    @Resource
    private CustomerRemarkMapper customerRemarkMapper;

    @Resource
    private ContactsRemarkMapper contactsRemarkMapper;

    @Resource
    private ClueActivityRelationMapper clueActivityRelationMapper;

    @Resource
    private ContactsActivityRelationMapper contactsActivityRelationMapper;

    @Resource
    private TranMapper tranMapper;

    @Resource
    private TranRemarkMapper tranRemarkMapper;


    @Override
    public int saveCreateClue(Clue clue) {
        return clueMapper.insertClue(clue);
    }

    @Override
    public List<Clue> queryClueByConditionForPage(Map<String, Object> map) {
        return clueMapper.selectClueByConditionForPage(map);
    }

    @Override
    public int queryCountClueByConditionForPage(Map<String, Object> map) {
        return clueMapper.selectCountClueByConditionForPage(map);
    }

    @Override
    public Clue queryClueById(String id) {
        return clueMapper.selectClueById(id);
    }

    @Override
    public int saveEditClueById(Clue clue) {
        return clueMapper.updateClueById(clue);
    }

    @Override
    public int deleteClueByIds(String[] ids) {
        return clueMapper.deleteClueByIds(ids);
    }

    @Override
    public Clue queryClueDetailById(String id) {
        return clueMapper.selectClueDetailById(id);
    }


    @Override
    public void saveConvertClue(Map<String, Object> map) {

       //先将clue查出来
        String id = (String)map.get("clueId");
        Clue clue = clueMapper.selectClueById(id);
        //将user用户从map中取出
        User user = (User) map.get(Contants.SESSION_USER);
        //将clue中的数据存入Customer对象中
        //#{id}, #{owner}, #{name}, #{website}, #{phone}, #{create_by}, #{createTime},#{contactSummary}, #{nextContactTime}, #{description}, #{address}
        Customer customer = new Customer();
        customer.setId(UUIDUtils.getUUID());
        customer.setOwner(user.getId());
        customer.setName(clue.getCompany());
        customer.setWebsite(clue.getWebsite());
        customer.setPhone(clue.getPhone());
        customer.setCreateBy(user.getId());
        customer.setCreateTime(DateUtil.formatDateTime(new Date()));
        customer.setContactSummary(clue.getContactSummary());
        customer.setNextContactTime(clue.getNextContactTime());
        customer.setDescription(clue.getDescription());
        customer.setAddress(clue.getAddress());
        //将customer对象存入数据库中
        customerMapper.insertCustomer(customer);

        //将clue中的对象存入Contacts中
        //#{id}, #{owner}, #{source}, #{customerId}, #{fullname}, #{appellation}, #{email}, #{mphone}, #{job}, #{createBy},#{createTime}, #{description}, #{contactSummary}, #{nextContactTime}, #{address}
        Contacts contacts = new Contacts();
        contacts.setId(UUIDUtils.getUUID());
        contacts.setOwner(user.getId());
        contacts.setSource(clue.getSource());
        contacts.setCustomerId(customer.getId());
        contacts.setFullname(clue.getFullname());
        contacts.setAppellation(clue.getAppellation());
        contacts.setEmail(clue.getEmail());
        contacts.setMphone(clue.getPhone());
        contacts.setJob(clue.getJob());
        contacts.setCreateBy(user.getId());
        contacts.setCreateTime(DateUtil.formatDateTime(new Date()));
        contacts.setDescription(clue.getDescription());
        contacts.setContactSummary(clue.getContactSummary());
        contacts.setNextContactTime(clue.getNextContactTime());
        contacts.setAddress(clue.getAddress());
        //将customer对象存入数据库中
        contactsMapper.insertContacts(contacts);

        //将clue关联的ClueRemark通过clueId查询出来
        List<ClueRemark> clueRemarkList = clueRemarkMapper.selectClueRemarkListByClueId(id);
        if(clueRemarkList != null && clueRemarkList.size() > 0) {
            //将clueRemark中的数据存入CustomerRemark对象中
            //#{id}, #{noteContent}, #{createBy}, #{createTime}, #{editBy}, #{editTime}, #{editFlag}, #{customerId}
            List<CustomerRemark> customerRemarkList = new ArrayList<>();
            CustomerRemark customerRemark = null;

            //将clueRemark中的数据存入ContactsRemark对象中
            //#{id}, #{obj.noteContent}, #{obj.createBy}, #{obj.createTime}, #{obj.editBy},#{obj.editTime}, #{obj.editFlag}, #{obj.contactsId}
            List<ContactsRemark> contactsRemarkList = new ArrayList<>();
            ContactsRemark contactsRemark = null;

            for (ClueRemark clueRemark: clueRemarkList) {
                customerRemark = new CustomerRemark();
                customerRemark.setId(UUIDUtils.getUUID());
                customerRemark.setNoteContent(clueRemark.getNoteContent());
                customerRemark.setCreateBy(clueRemark.getCreateBy());
                customerRemark.setCreateTime(clueRemark.getCreateTime());
                customerRemark.setEditBy(clueRemark.getEditBy());
                customerRemark.setEditTime(clueRemark.getEditTime());
                customerRemark.setEditFlag(clueRemark.getEditFlag());
                customerRemark.setCustomerId(customer.getId());
                customerRemarkList.add(customerRemark);

                contactsRemark = new ContactsRemark();
                contactsRemark.setId(UUIDUtils.getUUID());
                contactsRemark.setNoteContent(clueRemark.getNoteContent());
                contactsRemark.setCreateBy(clueRemark.getCreateBy());
                contactsRemark.setCreateTime(clueRemark.getCreateTime());
                contactsRemark.setEditBy(clueRemark.getEditBy());
                contactsRemark.setEditTime(clueRemark.getEditTime());
                contactsRemark.setEditFlag(clueRemark.getEditFlag());
                contactsRemark.setContactsId(contacts.getId());
                contactsRemarkList.add(contactsRemark);
            }
            //将customerRemarkList存入数据库中
            customerRemarkMapper.insertCustomerRemarkList(customerRemarkList);

            //将contactsRemarkList存入数据库中
            contactsRemarkMapper.insertContactsRemarkList(contactsRemarkList);
        }

        //将Clue与Activity的关系查询出来
        List<ClueActivityRelation> clueActivityRelationList = clueActivityRelationMapper.selectClueActivityRelationListByClueId(id);
        if (clueActivityRelationList != null && clueActivityRelationList.size() > 0) {
            //将clueActivityRelation中的转换成ContactsActivityRelation中的数据
            //#{obj.id}, #{obj.contactsId}, #{obj.activityId}
            List<ContactsActivityRelation> contactsActivityRelationList = new ArrayList<>();
            ContactsActivityRelation contactsActivityRelation = null;
            for (ClueActivityRelation clueActivityRelation: clueActivityRelationList) {
                contactsActivityRelation = new ContactsActivityRelation();
                contactsActivityRelation.setId(UUIDUtils.getUUID());
                contactsActivityRelation.setContactsId(contacts.getId());
                contactsActivityRelation.setActivityId(clueActivityRelation.getActivityId());
                contactsActivityRelationList.add(contactsActivityRelation);
            }
            //将contactsActivityRelationList存入数据库中
            contactsActivityRelationMapper.insertContactsActivityRelationList(contactsActivityRelationList);
        }

        //如果需要创建交易,还要往交易表中添加一条记录
        //从map中取出isCreateTran对象，判断前端是否选中
        String isCreateTran = (String) map.get("isCreateTran");
        if("true".equals(isCreateTran)){
            Tran tran = new Tran();
            //封装参数
            // money name expectedDate stage activityId isCreateTran
            String money = (String) map.get("money");
            String name = (String) map.get("name");
            String expectedDate = (String) map.get("expectedDate");
            String stage = (String) map.get("stage");
            String activityId = (String) map.get("activityId");

            //#{id}, #{owner}, #{money}, #{name}, #{expectedDate}, #{customerId}, #{stage}, #{type}, #{source}, #{activityId},
            //         #{contactsId}, #{createBy}, #{createTime}, #{description}, #{contactSummary}, #{nextContactTime}
            tran.setId(UUIDUtils.getUUID());
            tran.setOwner(user.getId());
            tran.setMoney(money);
            tran.setName(name);
            tran.setExpectedDate(expectedDate);
            tran.setCustomerId(customer.getId());
            tran.setStage(stage);
            tran.setActivityId(activityId);
            tran.setContactsId(contacts.getId());
            tran.setCreateBy(user.getId());
            tran.setCreateTime(DateUtil.formatDateTime(new Date()));

            tranMapper.insertTran(tran);

            //判断是否需要创建交易备注(看线索备注里面的数据是否为空，list集合是否大于0)
            // 如果需要创建交易备注,还要把线索的备注信息转换到交易备注表中一份
            //#{obj.id}, #{obj.noteContent}, #{obj.createBy}, #{obj.createTime}, #{obj.editBy}, #{obj.editTime}, #{obj.editFlag}, #{obj.tranId}
            if(clueRemarkList != null && clueRemarkList.size()>0){
                List<TranRemark> tranRemarkList = new ArrayList<>();
                TranRemark tranRemark = null;
                for (ClueRemark clueRemark:clueRemarkList) {
                    tranRemark = new TranRemark();
                    tranRemark.setId(UUIDUtils.getUUID());
                    tranRemark.setNoteContent(clueRemark.getNoteContent());
                    tranRemark.setCreateBy(clueRemark.getCreateBy());
                    tranRemark.setCreateTime(clueRemark.getCreateTime());
                    tranRemark.setEditBy(clueRemark.getEditBy());
                    tranRemark.setEditBy(clueRemark.getEditBy());
                    tranRemark.setEditFlag(clueRemark.getEditFlag());
                    tranRemark.setTranId(tran.getId());
                    tranRemarkList.add(tranRemark);
                }
                tranRemarkMapper.insertTranRemarkList(tranRemarkList);
            }
        }

        //通过clueId删除线索的备注
        clueRemarkMapper.deleteClueRemarkByClueId(id);

        //通过clueId删除线索和市场活动的关联关系
        clueActivityRelationMapper.deleteClueActivityRelationByClueId(id);

        //通过clueId删除线索
        clueMapper.deleteClueByClueId(id);
    }


}
