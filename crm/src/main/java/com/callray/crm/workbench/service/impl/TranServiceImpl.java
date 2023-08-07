package com.callray.crm.workbench.service.impl;

import com.callray.crm.commons.constant.Contants;
import com.callray.crm.commons.utils.DateUtil;
import com.callray.crm.commons.utils.UUIDUtils;
import com.callray.crm.settings.domain.User;
import com.callray.crm.workbench.domain.Customer;
import com.callray.crm.workbench.domain.Tran;
import com.callray.crm.workbench.domain.TranHistory;
import com.callray.crm.workbench.mapper.CustomerMapper;
import com.callray.crm.workbench.mapper.TranHistoryMapper;
import com.callray.crm.workbench.mapper.TranMapper;
import com.callray.crm.workbench.service.TranService;
import com.callray.crm.workbench.vo.StageVo;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@Service("tranService")
public class TranServiceImpl implements TranService {

    @Resource
    private TranMapper tranMapper;

    @Resource
    private CustomerMapper customerMapper;

    @Resource
    private TranHistoryMapper tranHistoryMapper;

    @Override
    public List<Tran> queryTranListByCustomerId(String customerId) {
        return tranMapper.selectTranListByCustomerId(customerId);
    }

    @Override
    public List<Tran> queryTranListByConditionForPage(Map<String, Object> map) {
        return tranMapper.selectTranListByConditionForPage(map);
    }

    @Override
    public int queryCountTranListByCondition(Map<String, Object> map) {
        return tranMapper.selectCountTranListByCondition(map);
    }

    @Override
    public void saveCreateTran(Map<String, Object> map) {
        //根据customerName查询出customerId
        String customerName = (String)map.get("customerName");
        User user = (User) map.get(Contants.SESSION_USER);
        Customer customer = customerMapper.selectCustomerByCustomerName(customerName);
        if(customer==null){
            customer = new Customer();
            customer.setId(UUIDUtils.getUUID());
            customer.setName(customerName);
            customer.setOwner(user.getId());
            customer.setCreateBy(user.getId());
            customer.setCreateTime(DateUtil.formatDateTime(new Date()));
            //判断是否有这个客户，如果没有则创建
            customerMapper.insertCustomer(customer);
        }
        //插入tran
        Tran tran = new Tran();
        tran.setId(UUIDUtils.getUUID());
        tran.setOwner((String) map.get("owner"));
        tran.setMoney((String) map.get("money"));
        tran.setName((String) map.get("name"));
        tran.setExpectedDate((String) map.get("expectedDate"));
        tran.setCustomerId(customer.getId());
        tran.setStage((String) map.get("stage"));
        tran.setType((String) map.get("type"));
        tran.setSource((String) map.get("source"));
        tran.setActivityId((String) map.get("activityId"));
        tran.setContactsId((String) map.get("contactsId"));
        tran.setDescription((String) map.get("description"));
        tran.setContactSummary((String) map.get("contactSummary"));
        tran.setNextContactTime((String) map.get("nextContactTime"));
        tran.setCreateBy(user.getId());
        tran.setCreateTime(DateUtil.formatDateTime(new Date()));
        //插入tran
        tranMapper.insertTran(tran);
        //赋值
        TranHistory tranHistory = new TranHistory();
        tranHistory.setId(UUIDUtils.getUUID());
        tranHistory.setCreateBy(user.getId());
        tranHistory.setCreateTime(DateUtil.formatDateTime(new Date()));
        tranHistory.setMoney(tran.getMoney());
        tranHistory.setStage(tran.getStage());
        tranHistory.setExpectedDate(tran.getExpectedDate());
        tranHistory.setTranId(tran.getId());
        //插入tran_history
        tranHistoryMapper.insertTranHistory(tranHistory);
    }

    @Override
    public Tran queryTranDetailByTranId(String tranId) {
        return tranMapper.selectTranDetailByTranId(tranId);
    }

    @Override
    public Tran queryTranCustomerNameActivityNameContactsNameStageValue(String tranId) {
        return tranMapper.selectTranCustomerNameActivityNameContactsNameStageValue(tranId);
    }

    @Override
    public void saveEditTran(Map<String, Object> map) {
        //根据customerName查询出customerId
        String customerName = (String)map.get("customerName");
        User user = (User) map.get(Contants.SESSION_USER);
        Customer customer = customerMapper.selectCustomerByCustomerName(customerName);
        if(customer==null){
            customer = new Customer();
            customer.setId(UUIDUtils.getUUID());
            customer.setName(customerName);
            customer.setOwner(user.getId());
            customer.setCreateBy(user.getId());
            customer.setCreateTime(DateUtil.formatDateTime(new Date()));
            //判断是否有这个客户，如果没有则创建
            customerMapper.insertCustomer(customer);
        }
        //插入tran
        Tran tran = new Tran();
        tran.setId((String) map.get("id"));
        tran.setOwner((String) map.get("owner"));
        tran.setMoney((String) map.get("money"));
        tran.setName((String) map.get("name"));
        tran.setExpectedDate((String) map.get("expectedDate"));
        tran.setCustomerId(customer.getId());
        tran.setStage((String) map.get("stage"));
        tran.setType((String) map.get("type"));
        tran.setSource((String) map.get("source"));
        tran.setActivityId((String) map.get("activityId"));
        tran.setContactsId((String) map.get("contactsId"));
        tran.setDescription((String) map.get("description"));
        tran.setContactSummary((String) map.get("contactSummary"));
        tran.setNextContactTime((String) map.get("nextContactTime"));
        tran.setEditBy(user.getId());
        tran.setEditTime(DateUtil.formatDateTime(new Date()));
        //插入tran
        tranMapper.updateTranByTranId(tran);
        //赋值
        TranHistory tranHistory = new TranHistory();
        tranHistory.setId(UUIDUtils.getUUID());
        tranHistory.setCreateBy(user.getId());
        tranHistory.setCreateTime(DateUtil.formatDateTime(new Date()));
        tranHistory.setMoney(tran.getMoney());
        tranHistory.setStage(tran.getStage());
        tranHistory.setExpectedDate(tran.getExpectedDate());
        tranHistory.setTranId(tran.getId());
        //插入tran_history
        tranHistoryMapper.insertTranHistory(tranHistory);

    }

    @Override
    public Tran queryTranForDetailByTranId(String tranId) {
        return tranMapper.selectTranForDetailByTranId(tranId);
    }

    @Override
    public List<StageVo> queryTranStageVoGroupByStage() {
        return tranMapper.selectTranStageVoGroupByStage();
    }


}
