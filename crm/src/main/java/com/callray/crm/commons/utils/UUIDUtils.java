package com.callray.crm.commons.utils;

import java.util.UUID;

public class UUIDUtils {

    /**
     * 获取随机32个字符的字符串
     * @return
     */
    public static String getUUID(){
        return UUID.randomUUID().toString().replaceAll("-","");
    }

}
