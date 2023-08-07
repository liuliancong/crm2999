package com.callray.crm.workbench.service.impl;

import com.callray.crm.workbench.domain.TranHistory;
import com.callray.crm.workbench.mapper.TranHistoryMapper;
import com.callray.crm.workbench.service.TranHistoryService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Service("tranHistoryService")
public class TranHistoryServiceImpl implements TranHistoryService {

    @Resource
    private TranHistoryMapper tranHistoryMapper;

    @Override
    public List<TranHistory> queryTranHistoryListByTranIdOrderByCreateTime(String tranId) {
        return tranHistoryMapper.selectTranHistoryListByTranIdOrderByCreateTime(tranId);
    }
}
