package com.callray.crm.workbench.service;

import com.callray.crm.workbench.domain.TranHistory;

import java.util.List;

public interface TranHistoryService {

    List<TranHistory> queryTranHistoryListByTranIdOrderByCreateTime(String tranId);

}
