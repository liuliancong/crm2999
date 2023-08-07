package com.callray.crm.workbench.mapper;

import com.callray.crm.workbench.domain.ClueActivityRelation;

import java.util.List;

public interface ClueActivityRelationMapper {
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_clue_activity_relation
     *
     * @mbggenerated Thu Apr 20 10:42:54 CST 2023
     */
    int deleteByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_clue_activity_relation
     *
     * @mbggenerated Thu Apr 20 10:42:54 CST 2023
     */
    int insert(ClueActivityRelation record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_clue_activity_relation
     *
     * @mbggenerated Thu Apr 20 10:42:54 CST 2023
     */
    int insertSelective(ClueActivityRelation record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_clue_activity_relation
     *
     * @mbggenerated Thu Apr 20 10:42:54 CST 2023
     */
    ClueActivityRelation selectByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_clue_activity_relation
     *
     * @mbggenerated Thu Apr 20 10:42:54 CST 2023
     */
    int updateByPrimaryKeySelective(ClueActivityRelation record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_clue_activity_relation
     *
     * @mbggenerated Thu Apr 20 10:42:54 CST 2023
     */
    int updateByPrimaryKey(ClueActivityRelation record);

    /**
     * 插入活动与线索的关系记录
     * @param clueActivityRelationList clueActivityRelationList
     * @return int
     */
    int insertClueActivityRelationByList(List<ClueActivityRelation> clueActivityRelationList);

    /**
     * 根据clueId和activityId删除clueActivityRelation
     * @param clueActivityRelation clueActivityRelation
     * @return int
     */
    int deleteClueActivityRelationByClueIdActivityId(ClueActivityRelation clueActivityRelation);

    /**
     * 根据clueId查询关联的的活动
     * @param clueId clueId
     * @return clueActivityRelationList
     */
    List<ClueActivityRelation> selectClueActivityRelationListByClueId(String clueId);

    /**
     * 通过clueId删除线索和市场活动的关联关系
     * @param clueId clueId
     * @return int
     */
    int deleteClueActivityRelationByClueId(String clueId);



}