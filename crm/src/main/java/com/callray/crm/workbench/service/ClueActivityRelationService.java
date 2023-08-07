package com.callray.crm.workbench.service;

import com.callray.crm.workbench.domain.ClueActivityRelation;

import java.util.List;

public interface ClueActivityRelationService {

    int saveCreateClueActivityRelationByList(List<ClueActivityRelation> clueActivityRelationList);

    int deleteClueActivityRelationByClueIdActivityId(ClueActivityRelation clueActivityRelation);

}
