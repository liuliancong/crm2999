package com.callray.crm.workbench.service;

import com.callray.crm.workbench.domain.ActivityRemark;

import java.util.List;

public interface ActivityRemarkService {

    /**
     * 通过activityId查询所有流言
     * @param activityId activityId
     * @return activityRemarkList
     */
    List<ActivityRemark> queryActivityRemarkForDetailByActivityId(String activityId);

    /**
     * 保存创建活动备注
     * @param activityRemark 活动备注
     * @return 插入条数int
     */
    int saveCreateActivityRemark(ActivityRemark activityRemark);

    /**
     * 根据id删除备注
     * @param id id
     * @return int
     */
    int deleteActivityRemarkById(String id);

    /**
     * 根据activityRemark的id修改备注
     * @param activityRemark activityRemark
     * @return int
     */
    int saveEditActivityRemarkById(ActivityRemark activityRemark);

}
