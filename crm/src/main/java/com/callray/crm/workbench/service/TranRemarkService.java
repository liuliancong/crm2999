package com.callray.crm.workbench.service;

import com.callray.crm.workbench.domain.Tran;
import com.callray.crm.workbench.domain.TranRemark;

import java.util.List;

public interface TranRemarkService {

    List<TranRemark> queryTranRemarkListByTranId(String tranId);

    int saveCreateTranRemark(TranRemark tranRemark);

    int saveEditTranRemark(TranRemark tranRemark);

    int deleteTranRemarkByTranRemarkId(String tranRemarkId);

}
