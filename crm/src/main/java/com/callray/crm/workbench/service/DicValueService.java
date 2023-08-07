package com.callray.crm.workbench.service;

import com.callray.crm.workbench.domain.DicValue;

import java.util.List;

public interface DicValueService {

    /**
     * 根据TypeCode查询出DicValue，并使用OrderNo进行排序
     * @param typeCode typeCode
     * @return DicValue
     */
    List<DicValue> queryDicValueByTypeCodeForOrderNoSort(String typeCode);
}
