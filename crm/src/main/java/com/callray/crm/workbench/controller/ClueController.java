package com.callray.crm.workbench.controller;

import com.callray.crm.commons.constant.Contants;
import com.callray.crm.commons.domain.ReturnObject;
import com.callray.crm.commons.utils.DateUtil;
import com.callray.crm.commons.utils.UUIDUtils;
import com.callray.crm.settings.domain.User;
import com.callray.crm.settings.service.UserService;
import com.callray.crm.workbench.domain.*;
import com.callray.crm.workbench.service.*;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.net.URL;
import java.util.*;

@Controller
public class ClueController {

    @Resource
    private UserService userService;

    @Resource
    private DicValueService dicValueService;

    @Resource
    private ClueService clueService;

    @Resource
    private ActivityService activityService;

    @Resource
    private ClueRemarkService clueRemarkService;

    @Resource
    private ClueActivityRelationService clueActivityRelationService;

    @RequestMapping("/workbench/clue/index.do")
    public String index(HttpServletRequest request){
        //将所有用户查询出来
        List<User> userList = userService.queryAllUsers();
        request.setAttribute("userList",userList);
        //将所有称呼查询出来
        List<DicValue>  appellationList = dicValueService.queryDicValueByTypeCodeForOrderNoSort(Contants.DIC_VALUE_TYPE_CODE_APPELLATION);
        request.setAttribute("appellationList",appellationList);
        //将所有线索状态查询出来
        List<DicValue> clueStateList = dicValueService.queryDicValueByTypeCodeForOrderNoSort(Contants.DIC_VALUE_TYPE_CODE_CLUE_STATE);
        request.setAttribute("clueStateList",clueStateList);
        //将所有线索来源查询出来
        List<DicValue> sourceList = dicValueService.queryDicValueByTypeCodeForOrderNoSort(Contants.DIC_VALUE_TYPE_CODE_SOURCE);
        request.setAttribute("sourceList",sourceList);
        return "workbench/clue/index";
    }

    @RequestMapping("/workbench/clue/saveCreateClue.do")
    @ResponseBody
    public Object saveCreateClue(Clue clue, HttpSession session){
        ReturnObject returnObject = new ReturnObject();
        User user = (User) session.getAttribute(Contants.SESSION_USER);

        clue.setId(UUIDUtils.getUUID());
        clue.setCreateBy(user.getId());
        clue.setCreateTime(DateUtil.formatDateTime(new Date()));

        try{
            int ret = clueService.saveCreateClue(clue);
            if(ret==1){
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
            }else{
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统正忙，请稍后再试....");
            }
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统正忙，请稍后再试....");
        }
        return returnObject;
    }

    @RequestMapping("/workbench/clue/queryClueByConditionForPage.do")
    @ResponseBody
    public Object queryClueByConditionForPage(String fullname,String company,String phone,String source,String owner,
                                              String mphone,String state,int pageNo,int pageSize){
        Map<String,Object> map = new HashMap<>();
        map.put("fullname",fullname);
        map.put("company",company);
        map.put("phone",phone);
        map.put("source",source);
        map.put("owner",owner);
        map.put("mphone",mphone);
        map.put("state",state);
        map.put("beginNo",(pageNo-1)*pageSize);
        map.put("pageSize",pageSize);

        List<Clue> clueList = clueService.queryClueByConditionForPage(map);
        int totalRows = clueService.queryCountClueByConditionForPage(map);

        Map<String,Object> resultMap = new HashMap<>();
        resultMap.put("clueList",clueList);
        resultMap.put("totalRows",totalRows);

        return resultMap;
    }

    @RequestMapping("/workbench/clue/queryClueById.do")
    @ResponseBody
    public Object queryClueById(String id){
        Clue clue = clueService.queryClueById(id);
        return clue;
    }

    @RequestMapping("/workbench/clue/saveEditClueById.do")
    @ResponseBody
    public Object saveEditClueById(Clue clue,HttpSession session){
        User user = (User) session.getAttribute(Contants.SESSION_USER);
        ReturnObject returnObject = new ReturnObject();

        clue.setEditBy(user.getId());
        clue.setEditTime(DateUtil.formatDateTime(new Date()));

        try{
            int ret = clueService.saveEditClueById(clue);
            if(ret==1){
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
            }else{
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统正忙，请稍后重试...");
            }
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统正忙，请稍后重试...");
        }
        return returnObject;
    }
    @RequestMapping("/workbench/clue/deleteClueByIds.do")
    @ResponseBody
    public Object deleteClueByIds(String[] id){
        ReturnObject returnObject = new ReturnObject();
        try{
            int ret = clueService.deleteClueByIds(id);
            if(ret>0){
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
            }else{
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统正忙，请稍后再试...");
            }
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统正忙，请稍后再试...");
        }
        return returnObject;
    }

    @RequestMapping("/workbench/clue/detailClue.do")
    public String detailClue(String id,HttpServletRequest request){
        //将clue详细信息传到request请求域中
        Clue clue = clueService.queryClueDetailById(id);
        request.setAttribute("clue",clue);

        //根据id将所有线索备注的信息查出来
        List<ClueRemark> clueRemarkList = clueRemarkService.queryClueRemarkListByClueIdOrderByCreateTimeAsc(id);
        request.setAttribute("clueRemarkList",clueRemarkList);

        //将与此线索关联的活动表查出来
        List<Activity> activityList = activityService.queryActivityForDetailClueByClueId(id);
        request.setAttribute("activityList",activityList);

        return "workbench/clue/detail";
    }

    @RequestMapping("/workbench/clue/queryActivityByActivityNameClueId.do")
    @ResponseBody
    public Object queryActivityByActivityNameClueId(String activityName,String clueId){
        //将参数放入map中
        Map<String,Object> map = new HashMap<>();
        map.put("activityName",activityName);
        map.put("clueId",clueId);
        //通过activityName和clueId查询activityList
        List<Activity> activityList = activityService.queryActivityByActivityNameClueId(map);
        return activityList;
    }

    @RequestMapping("/workbench/clue/saveCreateClueActivityRelationByList.do")
    @ResponseBody
    public Object saveCreateClueActivityRelationByList(String[] activityId,String clueId){
        //设置返回对象
        ReturnObject returnObject = new ReturnObject();
        //新建一个clueActivityRelationList对象
        List<ClueActivityRelation> clueActivityRelationList = new ArrayList<>();
        //将clueActivityRelation建在外面，节省栈空间内存
        ClueActivityRelation clueActivityRelation = null;

        //遍历activityIds，并将clueActivityRelation对象添加进clueActivityRelationList对象中
        for (String id: activityId) {
            clueActivityRelation = new ClueActivityRelation();

            clueActivityRelation.setId(UUIDUtils.getUUID());
            clueActivityRelation.setActivityId(id);
            clueActivityRelation.setClueId(clueId);

            clueActivityRelationList.add(clueActivityRelation);
        }

        try {
            //执行保存创建ClueActivityRelation对象
            int ret = clueActivityRelationService.saveCreateClueActivityRelationByList(clueActivityRelationList);
            //判断是否插入成功
            if (ret > 0) {
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
                //将添加的 活动与线索关系表记录 的活动查出来
                List<Activity> activityList = activityService.queryActivityForDetailByIds(activityId);
                //将记录返回给前端
                returnObject.setReturnData(activityList);

            } else {
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统正忙，请稍后再试...");
            }
        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统正忙，请稍后再试...");
        }
        return returnObject;
    }

    @RequestMapping("/workbench/clue/deleteClueActivityRelationByClueIdActivityId.do")
    @ResponseBody
    public Object deleteClueActivityRelationByClueIdActivityId(String activityId,String clueId){
        ReturnObject returnObject = new ReturnObject();
        ClueActivityRelation clueActivityRelation = new ClueActivityRelation();

        clueActivityRelation.setActivityId(activityId);
        clueActivityRelation.setClueId(clueId);

        try {
            int ret = clueActivityRelationService.deleteClueActivityRelationByClueIdActivityId(clueActivityRelation);
            if (ret > 0) {
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
            } else {
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统正忙，请稍后再试...");
            }
        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统正忙，请稍后再试...");
        }
        return returnObject;
    }

    @RequestMapping("/workbench/clue/toConvert.do")
    public String toConvert(String clueId,HttpServletRequest request){
        //查询该线索的详细信息
        Clue clue = clueService.queryClueDetailById(clueId);
        //将clue存入request中
        request.setAttribute("clue", clue);
        //查询DicValue为Contants的stage
        List<DicValue> dicValueList = dicValueService.queryDicValueByTypeCodeForOrderNoSort(Contants.DIC_VALUE_TYPE_CODE_STAGE);
        //将dicValueList存入request中
        request.setAttribute("dicValueList", dicValueList);
        return "workbench/clue/convert";
    }

    @RequestMapping("/workbench/clue/queryActivityByActivityName.do")
    @ResponseBody
    public Object queryActivityByActivityName(String activityName,String clueId){
        Map<String,Object> map = new HashMap<>();
        map.put("activityName",activityName);
        map.put("clueId", clueId);
        List<Activity> activityList = activityService.queryActivityForConvertByActivityNameClueId(map);
        return activityList;
    }

    /**
     * 用户在线索明细页面,点击"转换"按钮,跳转到线索转换页面;
     * 	用户在线索转换页面,如果需要创建创建交易,则填写交易表单数据,点击"转换"按钮,完成线索转换的功能.
     * 	*在线索转换页面,展示:fullName,appellation,company,owner
     * 	*市场活动源是可搜索的
     * 	*数据转换:
     * 	    把线索中有关公司的信息转换到客户表中
     * 	    把线索中有关个人的信息转换到联系人表中
     * 	    把线索的备注信息转换到客户备注表中一份
     * 	    把线索的备注信息转换到联系人备注表中一份
     * 	    把线索和市场活动的关联关系转换到联系人和市场活动的关联关系表中
     * 	    如果需要创建交易,还要往交易表中添加一条记录
     * 	    如果需要创建交易,还要把线索的备注信息转换到交易备注表中一份
     * 	    删除线索的备注
     * 	    删除线索和市场活动的关联关系
     * 	    删除线索
     *
     * 	    在一同个事务中完成.
     *     *转换成功之后,跳转到线索主页面
     *     *转换失败,提示信息,页面不跳转
     */
    @RequestMapping("/workbench/clue/saveConvertClue.do")
    @ResponseBody
    public Object saveConvertClue(String clueId,String money,String name,String expectedDate,String stage,String activityId,String isCreateTran,HttpSession session){
        ReturnObject returnObject = new ReturnObject();
        //封装参数
        Map<String,Object> map = new HashMap<>();
        map.put("clueId",clueId);
        map.put("money", money);
        map.put("name", name);
        map.put("expectedDate", expectedDate);
        map.put("stage", stage);
        map.put("activityId", activityId);
        map.put("isCreateTran", isCreateTran);
        map.put(Contants.SESSION_USER,session.getAttribute(Contants.SESSION_USER));
        try {
            //转换操作
            clueService.saveConvertClue(map);
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
        }catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统正忙，请稍后再试...");
        }
        return returnObject;
    }







}
