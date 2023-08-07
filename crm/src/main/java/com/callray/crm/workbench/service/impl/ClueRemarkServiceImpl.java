package com.callray.crm.workbench.service.impl;

import com.callray.crm.workbench.domain.ClueRemark;
import com.callray.crm.workbench.mapper.ClueRemarkMapper;
import com.callray.crm.workbench.service.ClueRemarkService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Service("clueRemarkService")
public class ClueRemarkServiceImpl implements ClueRemarkService {

    @Resource
    private ClueRemarkMapper clueRemarkMapper;

    @Override
    public List<ClueRemark> queryClueRemarkListByClueIdOrderByCreateTimeAsc(String clueId) {
        return clueRemarkMapper.selectClueRemarkListByClueIdOrderByCreateTimeAsc(clueId);
    }

    @Override
    public int saveCreateClueRemark(ClueRemark clueRemark) {
        return clueRemarkMapper.insertClueRemark(clueRemark);
    }

    @Override
    public int saveEditClueRemarkById(ClueRemark clueRemark) {
        return clueRemarkMapper.updateClueRemarkById(clueRemark);
    }

    @Override
    public int deleteClueRemarkById(String id) {
        return clueRemarkMapper.deleteClueRemarkById(id);
    }

}
