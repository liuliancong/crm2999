package com.callray.crm.commons.utils;

import java.text.SimpleDateFormat;
import java.util.Date;

public class DateUtil {

    /**
     * 传入日期类型对象，返回日期格式字符串：yyyy-MM-dd HH:mm:ss
     * @param date 日期
     * @return
     */
    public static String formatDateTime(Date date){
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        return sdf.format(date);
    }

    /**
     * 传入日期类型对象，返回日期格式字符串：yyyy-MM-dd HH:mm:ss
     * @param date 日期
     * @return
     */
    public static String formatDate(Date date){
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        return sdf.format(date);
    }

    /**
     * 传入日期类型对象，返回日期格式字符串：yyyy-MM-dd HH:mm:ss
     * @param date 日期
     * @return
     */
    public static String formatTime(Date date){
        SimpleDateFormat sdf = new SimpleDateFormat("HH:mm:ss");
        return sdf.format(date);
    }

}
