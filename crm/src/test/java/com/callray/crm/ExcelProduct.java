package com.callray.crm;

import org.apache.poi.hssf.usermodel.*;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.HorizontalAlignment;

import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;

public class ExcelProduct {

    public static void main(String[] args) throws IOException {

        //创建一个HSSFWorkbook对象
        HSSFWorkbook wb = new HSSFWorkbook();
        //使用HSSFWorkbook创建HSSFSheet对象
        HSSFSheet sheet = wb.createSheet("学生列表");
        //使用HSSFSheet对象，创建HSSFRow（行）
        HSSFRow row = sheet.createRow(0);
        //使用HSSFRow创建列
        HSSFCell cell = row.createCell(0); //第一列
        cell.setCellValue("学号");
        cell = row.createCell(1); //第二列
        cell.setCellValue("姓名");
        cell = row.createCell(2); //第三列
        cell.setCellValue("年龄");

        HSSFCellStyle style = wb.createCellStyle();
        style.setAlignment(HorizontalAlignment.CENTER);

        for(int i=1;i<=100;i++){
            row = sheet.createRow(i);

            cell = row.createCell(0);
            cell.setCellValue(100+i);
            cell = row.createCell(1);
            cell.setCellValue("name"+i);
            cell = row.createCell(2);

            cell.setCellStyle(style);
            cell.setCellValue(20+i);
        }

        FileOutputStream fos = new FileOutputStream("C:\\excel\\studentList.xls");
        wb.write(fos);

        wb.close();
        fos.close();

        System.out.println("=======ok========");
    }

}
