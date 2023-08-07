package com.callray.crm.workbench.controller;

import com.callray.crm.workbench.service.TranService;
import com.callray.crm.workbench.vo.StageVo;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import java.util.List;

@Controller
public class EchartsController {

    @Resource
    private TranService tranService;

    @RequestMapping("/workbench/chart/transaction/index.do")
    public String toTransactionIndex(){
        return "workbench/chart/transaction/index";
    }

    @RequestMapping("/workbench/chart/transaction/queryTranStageVoGroupByStage.do")
    @ResponseBody
    public Object queryTranStageVoGroupByStage(){
        List<StageVo> stageVoList = tranService.queryTranStageVoGroupByStage();
        return stageVoList;
    }

}
