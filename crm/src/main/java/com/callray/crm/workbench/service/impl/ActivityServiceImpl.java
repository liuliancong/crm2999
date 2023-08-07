package com.callray.crm.workbench.service.impl;

import com.callray.crm.workbench.domain.Activity;
import com.callray.crm.workbench.mapper.ActivityMapper;
import com.callray.crm.workbench.service.ActivityService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

@Service("activityService")
public class ActivityServiceImpl implements ActivityService {

    @Resource
    private ActivityMapper activityMapper;

    @Override
    public int saveCreateActivity(Activity activity) {
        return activityMapper.insertActivity(activity);
    }

    @Override
    public List<Activity> queryActivityByConditionForPage(Map<String, Object> map) {
        return activityMapper.selectActivityByConditionForPage(map);
    }

    @Override
    public int queryCountOfActivityByCondition(Map<String, Object> map) {
        return activityMapper.selectCountOfActivityByCondition(map);
    }

    @Override
    public int deleteActivityByIds(String[] ids) {
        return activityMapper.deleteActivityByIds(ids);
    }

    @Override
    public Activity queryActivityById(String id) {
        return activityMapper.selectActivityById(id);
    }

    @Override
    public int saveEditActivityById(Activity activity) {
        return activityMapper.updateActivityById(activity);
    }

    @Override
    public List<Activity> queryAllActivity() {
        return activityMapper.selectAllActivity();
    }

    @Override
    public List<Activity> queryActivityByIds(String[] ids) {
        return activityMapper.selectActivityByIds(ids);
    }

    @Override
    public int saveCreateActivityByList(List<Activity> activityList) {
        return activityMapper.insertActivityByList(activityList);
    }

    @Override
    public Activity queryActivityForDetailById(String id) {
        return activityMapper.selectActivityForDetailById(id);
    }

    @Override
    public List<Activity> queryActivityForDetailClueByClueId(String clueId) {
        return activityMapper.selectActivityForDetailClueByClueId(clueId);
    }

    @Override
    public List<Activity> queryActivityByActivityNameClueId(Map<String, Object> map) {
        return activityMapper.selectActivityByActivityNameClueId(map);
    }

    @Override
    public List<Activity> queryActivityForDetailByIds(String[] ids) {
        return activityMapper.selectActivityForDetailByIds(ids);
    }

    @Override
    public List<Activity> queryActivityForConvertByActivityNameClueId(Map<String,Object> map) {
        return activityMapper.selectActivityForConvertByActivityNameClueId(map);
    }

    @Override
    public List<Activity> queryActivityByActivityName(String activityName) {
        return activityMapper.selectActivityByActivityName(activityName);
    }
}
