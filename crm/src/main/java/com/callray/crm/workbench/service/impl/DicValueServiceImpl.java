package com.callray.crm.workbench.service.impl;

import com.callray.crm.workbench.domain.DicValue;
import com.callray.crm.workbench.mapper.DicValueMapper;
import com.callray.crm.workbench.service.DicValueService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Service("dicValueService")
public class DicValueServiceImpl implements DicValueService {

    @Resource
    private DicValueMapper dicValueMapper;

    @Override
    public List<DicValue> queryDicValueByTypeCodeForOrderNoSort(String typeCode) {
        return dicValueMapper.selectDicValueByTypeCodeForOrderNoSort(typeCode);
    }
}
