package com.callray.crm;

import com.callray.crm.commons.utils.HSSFUtils;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;

public class ParseExcelTest {

    public static void main(String[] args) throws IOException {
        //根据excel文件生成HSSFWorkbook对象，封装了excel文件的所有信息
        HSSFWorkbook wb = new HSSFWorkbook(new FileInputStream("C:\\excel\\export\\activityList1679556454947.xls"));

        //根据wb对象获取HSSFSheet每一页
        HSSFSheet sheet = wb.getSheetAt(0); //页的下标
        HSSFRow row = null;
        HSSFCell cell = null;
        //根据sheet获取HSSFRow对象，封装了一行的所有信息
        for (int i = 0; i <= sheet.getLastRowNum(); i++) {//sheet.getLastRowNum()最后一行的下表
             row = sheet.getRow(i);

             //根据row对象获取HSSFCell，每一列
            for (int j = 0; j < row.getLastCellNum(); j++) {//row.getLastCellNum() 最后一列的下表+1
                 cell = row.getCell(j);

                System.out.print(HSSFUtils.getCellValueForStr(cell)+" ");

            }
            System.out.println();

        }





    }



}
