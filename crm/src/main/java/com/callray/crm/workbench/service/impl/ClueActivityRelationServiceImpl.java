package com.callray.crm.workbench.service.impl;

import com.callray.crm.workbench.domain.ClueActivityRelation;
import com.callray.crm.workbench.mapper.ClueActivityRelationMapper;
import com.callray.crm.workbench.service.ClueActivityRelationService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Service("clueActivityRelationService")
public class ClueActivityRelationServiceImpl implements ClueActivityRelationService {

    @Resource
    private ClueActivityRelationMapper clueActivityRelationMapper;

    @Override
    public int saveCreateClueActivityRelationByList(List<ClueActivityRelation> clueActivityRelationList) {
        return clueActivityRelationMapper.insertClueActivityRelationByList(clueActivityRelationList);
    }

    @Override
    public int deleteClueActivityRelationByClueIdActivityId(ClueActivityRelation clueActivityRelation) {
        return clueActivityRelationMapper.deleteClueActivityRelationByClueIdActivityId(clueActivityRelation);
    }


}
