package com.callray.crm.workbench.service;

import com.callray.crm.workbench.domain.ClueRemark;

import java.util.List;

public interface ClueRemarkService {

    /**
     * 根据clue的id查询clueRemark并使用创建时间排序
     * @param clueId clue的id
     * @return clueRemarkList
     */
    List<ClueRemark> queryClueRemarkListByClueIdOrderByCreateTimeAsc(String clueId);

    /**
     * 保存新建的备注
     * @param clueRemark clueRemark
     * @return int
     */
    int saveCreateClueRemark(ClueRemark clueRemark);

    /**
     * 根据id保存修改的线索备注
     * @param clueRemark 备注
     * @return int
     */
    int saveEditClueRemarkById(ClueRemark clueRemark);

    /**
     * 根据id删除线索备注
     * @param id id
     * @return int
     */
    int deleteClueRemarkById(String id);

}
