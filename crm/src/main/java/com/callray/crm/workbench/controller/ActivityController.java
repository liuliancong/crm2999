package com.callray.crm.workbench.controller;

import com.callray.crm.commons.constant.Contants;
import com.callray.crm.commons.domain.ReturnObject;
import com.callray.crm.commons.utils.DateUtil;
import com.callray.crm.commons.utils.HSSFUtils;
import com.callray.crm.commons.utils.UUIDUtils;
import com.callray.crm.settings.domain.User;
import com.callray.crm.settings.service.UserService;
import com.callray.crm.workbench.domain.Activity;
import com.callray.crm.workbench.domain.ActivityRemark;
import com.callray.crm.workbench.service.ActivityRemarkService;
import com.callray.crm.workbench.service.ActivityService;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.DispatcherServlet;

import javax.annotation.Resource;
import javax.servlet.Servlet;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.*;
import java.util.*;

@Controller
public class ActivityController {

    @Resource
    private UserService userService;

    @Resource
    private ActivityService activityService;

    @Resource
    private ActivityRemarkService activityRemarkService;

    @RequestMapping("/workbench/activity/index.do")
    public String index(HttpServletRequest request){
        List<User> userList = userService.queryAllUsers();
        request.setAttribute("userList",userList);
        //请求转发到市场活动的主页面
        return "workbench/activity/index";
    }

    @RequestMapping("/workbench/activity/saveCreateActivity.do")
    @ResponseBody
    public Object saveActivity(Activity activity, HttpSession session){
        //创建者
        User user = (User) session.getAttribute(Contants.SESSION_USER);
        activity.setCreateBy(user.getId());
        //创建时间
        activity.setCreateTime(DateUtil.formatDateTime(new Date()));
        //使用UUID自动生成的字符串作为id
        activity.setId(UUIDUtils.getUUID());

        ReturnObject returnObject = new ReturnObject();
        try{
            int ret = activityService.saveCreateActivity(activity);
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

    @RequestMapping("/workbench/activity/queryActivityByConditionForPage.do")
    @ResponseBody
    public Object queryActivityByConditionForPage(String name,String owner,String startDate,String endDate,int pageNo,int pageSize){

        //封装参数
        Map<String,Object> map = new HashMap<>();
        map.put("name",name);
        map.put("owner",owner);
        map.put("startDate",startDate);
        map.put("endDate",endDate);
        map.put("beginNo",(pageNo-1)*pageSize);
        map.put("pageSize",pageSize);

        //根据条件查询
        List<Activity> activityList = activityService.queryActivityByConditionForPage(map);
        int totalRows = activityService.queryCountOfActivityByCondition(map);

        //将两个结果添加进map集合中
        Map<String,Object>  activityAndTotalRows = new HashMap<>();
        activityAndTotalRows.put("activityList",activityList);
        activityAndTotalRows.put("totalRows",totalRows);

        //将结果返回给前端
        return activityAndTotalRows;
    }

    @RequestMapping("/workbench/activity/deleteActivityByIds.do")
    @ResponseBody
    public Object deleteActivityByIds(String[] id){
        ReturnObject returnObject = new ReturnObject();
        try{
            //删除市场活动
            int ret = activityService.deleteActivityByIds(id);
            if(ret>0){
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
            }else{
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统正忙，请稍后重试...");
            }
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统正忙，请联系系统管理员...");
        }

        return returnObject;
    }

    @RequestMapping("/workbench/activity/queryActivityById.do")
    @ResponseBody
    public Object queryActivityById(String id){
        Activity activity = activityService.queryActivityById(id);
        return activity;
    }

    @RequestMapping("/workbench/activity/saveEditActivityById.do")
    @ResponseBody
    public Object saveEditActivityById(Activity activity,HttpSession session){
        //获取session中的用户
        User user = (User) session.getAttribute(Contants.SESSION_USER);
        String editBy = user.getId();
        String editTime = DateUtil.formatDateTime(new Date());
        activity.setEditBy(editBy);
        activity.setEditTime(editTime);

        ReturnObject returnObject = new ReturnObject();

        try{
            int ret = activityService.saveEditActivityById(activity);
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
    @RequestMapping("/workbench/filedownloadexcel.do")
    public void filedownloadexcel(HttpServletResponse response) throws IOException {
        //设置响应类型
        response.setContentType("application/octet-stream;charset=UTF-8");

        //获取输出流
        ServletOutputStream os = response.getOutputStream();

        //设置响应头
        response.addHeader("Content-Disposition","attachment;filename=studentList"+DateUtil.formatDateTime(new Date())+".xls");

        //获取输入流
        FileInputStream fis = new FileInputStream("C:\\excel\\studentList.xls");

        byte[] buff = new byte[1024];
        int len = 0;
        while((len=fis.read(buff))!=-1){
            os.write(buff,0,len);
        }

        fis.close();
        os.flush();
    }

    @RequestMapping("/workbench/activity/exportAllActivity.do")
    public void exportAllActivity(HttpServletResponse response) throws IOException {
        //将需要导出的结果查询出来
        List<Activity> activityList = activityService.queryAllActivity();

        //创建HSSFWorkBook对象
        HSSFWorkbook wb = new HSSFWorkbook();

        HSSFSheet sheet = wb.createSheet("市场活动列表");
        //创建行
        HSSFRow row = sheet.createRow(0);
        //创建列
        HSSFCell cell = row.createCell(0);
        cell.setCellValue("ID");
        cell = row.createCell(1);
        cell.setCellValue("所有者");
        cell = row.createCell(2);
        cell.setCellValue("活动名称");
        cell = row.createCell(3);
        cell.setCellValue("开始日期");
        cell = row.createCell(4);
        cell.setCellValue("结束日期");
        cell = row.createCell(5);
        cell.setCellValue("成本");
        cell = row.createCell(6);
        cell.setCellValue("活动内容");
        cell = row.createCell(7);
        cell.setCellValue("创建时间");
        cell = row.createCell(8);
        cell.setCellValue("创建者");
        cell = row.createCell(9);
        cell.setCellValue("修改时间");
        cell = row.createCell(10);
        cell.setCellValue("修改者");

        //遍历activityList，创建HSSFRow对象，生成所有的数据行
       if(activityList != null && activityList.size()>0){
           Activity activity = null;
           for(int i = 0;i < activityList.size(); i++){
               activity = activityList.get(i);

               row = sheet.createRow(i+1);
               //创建列
               cell = row.createCell(0);
               cell.setCellValue(activity.getId());
               cell = row.createCell(1);
               cell.setCellValue(activity.getOwner());
               cell = row.createCell(2);
               cell.setCellValue(activity.getName());
               cell = row.createCell(3);
               cell.setCellValue(activity.getStartDate());
               cell = row.createCell(4);
               cell.setCellValue(activity.getEndDate());
               cell = row.createCell(5);
               cell.setCellValue(activity.getCost());
               cell = row.createCell(6);
               cell.setCellValue(activity.getDescription());
               cell = row.createCell(7);
               cell.setCellValue(activity.getCreateTime());
               cell = row.createCell(8);
               cell.setCellValue(activity.getCreateBy());
               cell = row.createCell(9);
               cell.setCellValue(activity.getEditTime());
               cell = row.createCell(10);
               cell.setCellValue(activity.getEditBy());
           }
       }

       //根据wb对象，生成excel文件
        Long dateTime = new Date().getTime();
/*        String fileNameAddress = "C:\\excel\\activityList"+dateTime+".xls";
       OutputStream os = new FileOutputStream(fileNameAddress);
       wb.write(os);
       //关闭资源
       os.close();
       wb.close();*/

       //响应到前台
        response.setContentType("application/octet-stream;charset=UTF-8");
        response.addHeader("Content-Disposition","attachment;filename=activityList"+dateTime+".xls");
        //响应输出流
        OutputStream out = response.getOutputStream();
/*        //获取输入流
        InputStream fis = new FileInputStream(fileNameAddress);
        byte[] buff = new byte[256];
        int len = 0;
        while((len=fis.read(buff))!=-1){
           out.write(buff,0,len);
        }

        fis.close();
        out.flush();*/

        wb.write(out);

        wb.close();
        out.flush();
    }


    @RequestMapping("/workbench/activity/exportActiviryByIds.do")
    public void exportActiviryByIds(String[] id,HttpServletResponse response) throws IOException {
        //将结果查询出来
        List<Activity> activityList = activityService.queryActivityByIds(id);
        //创建HSSFWorkBook对象
        HSSFWorkbook wb = new HSSFWorkbook();

        HSSFSheet sheet = wb.createSheet("市场活动列表");
        //创建行
        HSSFRow row = sheet.createRow(0);
        //创建列
        HSSFCell cell = row.createCell(0);
        cell.setCellValue("ID");
        cell = row.createCell(1);
        cell.setCellValue("所有者");
        cell = row.createCell(2);
        cell.setCellValue("活动名称");
        cell = row.createCell(3);
        cell.setCellValue("开始日期");
        cell = row.createCell(4);
        cell.setCellValue("结束日期");
        cell = row.createCell(5);
        cell.setCellValue("成本");
        cell = row.createCell(6);
        cell.setCellValue("活动内容");
        cell = row.createCell(7);
        cell.setCellValue("创建时间");
        cell = row.createCell(8);
        cell.setCellValue("创建者");
        cell = row.createCell(9);
        cell.setCellValue("修改时间");
        cell = row.createCell(10);
        cell.setCellValue("修改者");

        //遍历activityList，创建HSSFRow对象，生成所有的数据行
        if(activityList != null && activityList.size()>0){
            Activity activity = null;
            for(int i = 0;i < activityList.size(); i++){
                activity = activityList.get(i);

                row = sheet.createRow(i+1);
                //创建列
                cell = row.createCell(0);
                cell.setCellValue(activity.getId());
                cell = row.createCell(1);
                cell.setCellValue(activity.getOwner());
                cell = row.createCell(2);
                cell.setCellValue(activity.getName());
                cell = row.createCell(3);
                cell.setCellValue(activity.getStartDate());
                cell = row.createCell(4);
                cell.setCellValue(activity.getEndDate());
                cell = row.createCell(5);
                cell.setCellValue(activity.getCost());
                cell = row.createCell(6);
                cell.setCellValue(activity.getDescription());
                cell = row.createCell(7);
                cell.setCellValue(activity.getCreateTime());
                cell = row.createCell(8);
                cell.setCellValue(activity.getCreateBy());
                cell = row.createCell(9);
                cell.setCellValue(activity.getEditTime());
                cell = row.createCell(10);
                cell.setCellValue(activity.getEditBy());
            }
        }

        Long dateTime = new Date().getTime();

        //响应到前台
        response.setContentType("application/octet-stream;charset=UTF-8");
        response.addHeader("Content-Disposition","attachment;filename=activityListById"+dateTime+".xls");
        //响应输出流
        OutputStream out = response.getOutputStream();

        wb.write(out);

        wb.close();
        out.flush();
    }

    /**
     * 配置springmvc的文件上传解析器
     * @param userName
     * @param myFile
     * @return
     */
    @RequestMapping("/workbench/activity/fileUpload.do")
    @ResponseBody
    public Object fileUpload(String userName, MultipartFile myFile) throws Exception{
        System.out.println("userName = "+userName);
        String originalFilename = myFile.getOriginalFilename();
        //把文件在服务器指定的目录中生成一个同样的文件
        File file = new File("C:\\excel\\export\\",originalFilename);
        myFile.transferTo(file);

        ReturnObject returnObject = new ReturnObject();
        returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
        returnObject.setMessage("上传成功");

        return returnObject;
    }

    @RequestMapping("/workbench/activity/importActivity.do")
    @ResponseBody
    public Object importActivity(MultipartFile activityFile,String userName,HttpSession session){
        System.out.println("userName = "+userName);
        ReturnObject returnObject = new ReturnObject();
        User user = (User) session.getAttribute(Contants.SESSION_USER);
        try {
            //把接收到的文件写入到磁盘目录中
//            String originalFilename = activityFile.getOriginalFilename();
//            //把文件在服务器指定的目录中生成一个同样的文件
//            File file = new File("C:\\excel\\export\\",originalFilename);
//            activityFile.transferTo(file);

            //解析excel文件，获取文件中的数据，并且封装成activityList
//            FileInputStream is = new FileInputStream("C:\\excel\\export\\"+originalFilename);

            //直接从内存中获取流
            InputStream is = activityFile.getInputStream();

            HSSFWorkbook wb = new HSSFWorkbook(is);
            //根据wb对象获取HSSFSheet每一页
            HSSFSheet sheet = wb.getSheetAt(0); //页的下标
            HSSFRow row = null;
            HSSFCell cell = null;
            Activity activity = null;
            List<Activity> activityList = new ArrayList<>();
            //根据sheet获取HSSFRow对象，封装了一行的所有信息
            for (int i = 1; i <= sheet.getLastRowNum(); i++) {//sheet.getLastRowNum()最后一行的下标

                activity = new Activity();
                //导入市场活动的id通过系统创建
                activity.setId(UUIDUtils.getUUID());
                //导入市场活动的所有者的id为当前用户的id
                activity.setOwner(user.getId());
                activity.setCreateTime(DateUtil.formatDateTime(new Date()));
                activity.setCreateBy(user.getId());

                row = sheet.getRow(i);

                //根据row对象获取HSSFCell，每一列
                for (int j = 0; j < row.getLastCellNum(); j++) {//row.getLastCellNum() 最后一列的下标+1
                    cell = row.getCell(j);

                    String cellValue = HSSFUtils.getCellValueForStr(cell);
                    if(j==0){
                        activity.setName(cellValue);
                    }else if(j==1){
                        activity.setStartDate(cellValue);
                    }else if(j==2){
                        activity.setEndDate(cellValue);
                    }else if(j==3){
                        activity.setCost(cellValue);
                    }else if(j==4){
                        activity.setDescription(cellValue);
                    }
                }
                //每一行所有列都封装完成之后，把activity保存到list中
                activityList.add(activity);
            }
            //调用service方法，保存市场活动
            int ret = activityService.saveCreateActivityByList(activityList);
            //只要不报错，就返回信息
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
            returnObject.setReturnData(ret);

        } catch (IOException e) {
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统忙，请稍后重试!");
        }
        return returnObject;
    }

    @RequestMapping("/workbench/activity/detailActivity.do")
    public String detailActivity(String id,HttpServletRequest request){
        //调用service层方法，查询数据
        Activity activity = activityService.queryActivityForDetailById(id);
        List<ActivityRemark> remarkList = activityRemarkService.queryActivityRemarkForDetailByActivityId(id);
        //将数据存入request请求域中
        request.setAttribute("activity",activity);
        request.setAttribute("remarkList",remarkList);

        return "workbench/activity/detail";
    }












}
