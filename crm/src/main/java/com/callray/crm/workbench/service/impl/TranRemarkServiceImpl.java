package com.callray.crm.workbench.service.impl;

import com.callray.crm.workbench.domain.Tran;
import com.callray.crm.workbench.domain.TranRemark;
import com.callray.crm.workbench.mapper.TranRemarkMapper;
import com.callray.crm.workbench.service.TranRemarkService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Service("tranRemarkService")
public class TranRemarkServiceImpl implements TranRemarkService {

    @Resource
    private TranRemarkMapper tranRemarkMapper;

    @Override
    public List<TranRemark> queryTranRemarkListByTranId(String tranId) {
        return tranRemarkMapper.selectTranRemarkListByTranId(tranId);
    }

    @Override
    public int saveCreateTranRemark(TranRemark tranRemark) {
        return tranRemarkMapper.insertTranRemark(tranRemark);
    }

    @Override
    public int saveEditTranRemark(TranRemark tranRemark) {
        return tranRemarkMapper.updateTranRemark(tranRemark);
    }

    @Override
    public int deleteTranRemarkByTranRemarkId(String tranRemarkId) {
        return tranRemarkMapper.deleteTranRemarkByTranRemarkId(tranRemarkId);
    }
}
