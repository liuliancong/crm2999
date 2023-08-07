package com.callray.crm.workbench.service;

import com.callray.crm.workbench.domain.Activity;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public interface ActivityService {

    /**
     * 保存创建市场活动
     * @param activity
     * @return
     */
    int saveCreateActivity(Activity activity);

    /**
     *根据条件分页查询活动
     * @return 活动集合
     */
    List<Activity> queryActivityByConditionForPage(Map<String,Object> map);

    /**
     * 根据条件查询记录总数
     * @param map 条件
     * @return 记录总数
     */
    int queryCountOfActivityByCondition(Map<String,Object> map);

    /**
     * 根据id数组删除
     * @param ids id数组
     * @return 数量
     */
    int deleteActivityByIds(String[] ids);

    /**
     * 根据id查询活动
     * @param id id
     * @return 活动记录
     */
    Activity queryActivityById(String id);

    /**
     * 根据id保存修改活动信息
     * @param activity 活动信息
     * @return 0表示更新成功，1表示更新失败
     */
    int saveEditActivityById(Activity activity);

    /**
     * 查询出所有的活动
     * @return 查询出所有的活动
     */
    List<Activity> queryAllActivity();

    /**
     * 根据id查询活动
     * @param ids id
     * @return 活动记录
     */
    List<Activity> queryActivityByIds(String[] ids);

    /**
     * 保存创建活动集合
     * @param activityList 需要保存的活动集合
     * @return 保存成功的记录数
     */
    int saveCreateActivityByList(List<Activity> activityList);

    /**
     * 通过id查询市场活动所有信息
     * @param id id
     * @return activity
     */
    Activity queryActivityForDetailById(String id);

    /**
     * 通过t_clue_activity_relation这张表查询clueId对应的activity
     * @param clueId clueId
     * @return activityList
     */
    List<Activity> queryActivityForDetailClueByClueId(String clueId);

    /**
     *通过activityNam和没有与clueId关联的活动来查询活动
     * @return activityList
     */
    List<Activity> queryActivityByActivityNameClueId(Map<String,Object> map);

    /**
     *根据id数组查询相关的活动详细信息
     * @param ids ids
     * @return activityList
     */
    List<Activity> queryActivityForDetailByIds(String[] ids);

    /**
     * 根据activityName查询activityList
     * @param map activityName
     * @return activityList
     */
    List<Activity> queryActivityForConvertByActivityNameClueId(Map<String,Object> map);

    /**
     * 根据活动名查询活动信息
     * @param activityName 活动名
     * @return 活动信息
     */
    List<Activity> queryActivityByActivityName(String activityName);
}
