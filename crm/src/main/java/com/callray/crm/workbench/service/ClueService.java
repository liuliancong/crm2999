package com.callray.crm.workbench.service;

import com.callray.crm.workbench.domain.Clue;

import java.util.List;
import java.util.Map;

public interface ClueService {
    /**
     * 保存创建的clue
     * @param clue 线索
     * @return int
     */
    int saveCreateClue(Clue clue);

    /**
     *根据条件分页查询
     * @param map
     * @return ClueList
     */
    List<Clue> queryClueByConditionForPage(Map<String,Object> map);

    /**
     * 查询‘根据条件分页查询‘的记录数
     * @param map
     * @return
     */
    int queryCountClueByConditionForPage(Map<String,Object> map);

    /**
     * 根据id查询clue
     * @param id id
     * @return clue
     */
    Clue queryClueById(String id);

    /**
     * 保存修改的Clue
     * @param clue clue
     * @return int
     */
    int saveEditClueById(Clue clue);

    /**
     * 根据id数组删除clue
     * @param ids id数组
     * @return int
     */
    int deleteClueByIds(String[] ids);

    /**
     * 根据id查询clue详细信息
     * @param id id
     * @return clue
     */
    Clue queryClueDetailById(String id);

    /**
     * 保存转换线索
     * @param map 参数
     */
    void saveConvertClue(Map<String,Object> map);


}
