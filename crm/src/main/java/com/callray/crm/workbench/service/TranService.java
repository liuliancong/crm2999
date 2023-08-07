package com.callray.crm.workbench.service;

import com.callray.crm.workbench.domain.Tran;
import com.callray.crm.workbench.vo.StageVo;

import java.util.List;
import java.util.Map;

public interface TranService {

  List<Tran> queryTranListByCustomerId(String customerId);

  List<Tran> queryTranListByConditionForPage(Map<String, Object> map);

  int queryCountTranListByCondition(Map<String, Object> map);

  void saveCreateTran(Map<String,Object> map);

  Tran queryTranDetailByTranId(String tranId);

  Tran queryTranCustomerNameActivityNameContactsNameStageValue(String tranId);

  void saveEditTran(Map<String, Object> map);

  Tran queryTranForDetailByTranId(String tranId);

  List<StageVo> queryTranStageVoGroupByStage();





}
