package com.callray.crm.commons.utils;

import org.apache.poi.hssf.usermodel.HSSFCell;

public class HSSFUtils {
    /**
     * 从指定的HSSFCell对象中获取列的值
     * @param cell
     * @return
     */
    public static String getCellValueForStr(HSSFCell cell){
        String ret = "";
        //获取列中的数据
        if(cell.getCellType()==HSSFCell.CELL_TYPE_STRING){
            ret = cell.getStringCellValue();
        }else if(cell.getCellType()==HSSFCell.CELL_TYPE_NUMERIC){
            ret = String.valueOf(cell.getNumericCellValue());
        }else if(cell.getCellType()==HSSFCell.CELL_TYPE_BOOLEAN){
            ret = String.valueOf(cell.getBooleanCellValue());
        }else if(cell.getCellType()==HSSFCell.CELL_TYPE_FORMULA){
            ret = String.valueOf(cell.getCellFormula());
        }else{
            ret = "";
        }
        return ret;
    }


}
