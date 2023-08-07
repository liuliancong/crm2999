package com.callray.crm.workbench.service.impl;

import com.callray.crm.workbench.domain.ActivityRemark;
import com.callray.crm.workbench.mapper.ActivityRemarkMapper;
import com.callray.crm.workbench.service.ActivityRemarkService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Service("activityRemarkService")
public class ActivityRemarkServiceImpl implements ActivityRemarkService {

    @Resource
    private ActivityRemarkMapper activityRemarkMapper;

    @Override
    public List<ActivityRemark> queryActivityRemarkForDetailByActivityId(String activityId) {
        return activityRemarkMapper.selectActivityRemarkForDetailByActivityId(activityId);
    }

    @Override
    public int saveCreateActivityRemark(ActivityRemark activityRemark) {
        return activityRemarkMapper.insertActivityRemark(activityRemark);
    }

    @Override
    public int deleteActivityRemarkById(String id) {
        return activityRemarkMapper.deleteActivityRemarkById(id);
    }

    @Override
    public int saveEditActivityRemarkById(ActivityRemark activityRemark) {
        return activityRemarkMapper.updateActivityRemarkById(activityRemark);
    }
}
