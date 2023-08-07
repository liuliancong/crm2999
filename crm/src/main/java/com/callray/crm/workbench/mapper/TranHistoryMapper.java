package com.callray.crm.workbench.mapper;

import com.callray.crm.workbench.domain.TranHistory;

import java.util.List;

public interface TranHistoryMapper {
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_tran_history
     *
     * @mbggenerated Wed May 17 16:16:41 CST 2023
     */
    int deleteByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_tran_history
     *
     * @mbggenerated Wed May 17 16:16:41 CST 2023
     */
    int insert(TranHistory record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_tran_history
     *
     * @mbggenerated Wed May 17 16:16:41 CST 2023
     */
    int insertSelective(TranHistory record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_tran_history
     *
     * @mbggenerated Wed May 17 16:16:41 CST 2023
     */
    TranHistory selectByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_tran_history
     *
     * @mbggenerated Wed May 17 16:16:41 CST 2023
     */
    int updateByPrimaryKeySelective(TranHistory record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_tran_history
     *
     * @mbggenerated Wed May 17 16:16:41 CST 2023
     */
    int updateByPrimaryKey(TranHistory record);

    /**
     * 插入交易历史记录
     * @param tranHistory 交易历史信息
     * @return int
     */
    int insertTranHistory(TranHistory tranHistory);

    /**
     * 查询交易历史记录列表根据时间排序
     * @param tranId tranId
     * @return tranHistoryList
     */
    List<TranHistory> selectTranHistoryListByTranIdOrderByCreateTime(String tranId);
}