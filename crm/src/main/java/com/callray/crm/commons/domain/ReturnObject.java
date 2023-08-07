package com.callray.crm.commons.domain;

public class ReturnObject {

    private String code;//处理成功获取标记 1表示成功，2表示失败
    private String message;//提示信息
    private Object returnData; //返回其他数据

    public ReturnObject() {
    }

    public ReturnObject(String code, String message, Object returnData) {
        this.code = code;
        this.message = message;
        this.returnData = returnData;
    }



    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public Object getReturnData() {
        return returnData;
    }

    public void setReturnData(Object returnData) {
        this.returnData = returnData;
    }
}
