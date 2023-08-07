package com.callray.crm.commons.constant;

public class Contants {

    //保存ReturnObject类中的code值
    /**
     * 1表示成功
     */
    public static final String RETURN_OBJECT_CODE_SUCCESS = "1" ;
    /**
     * 2表示失败
     */
    public static final String RETURN_OBJECT_CODE_FAIL = "2" ;

    /**
     * session用户
     */
    public static final String SESSION_USER = "sessionUser";

    //备注的修改标记
    /**
     * 0表示没有修改
     */
    public static final String REMARK_EDIT_FLAG_NO_EDITED="0";
    /**
     * 1表示已经被修改
     */
    public static final String REMARK_EDIT_FLAG_YES_EDITED="1";
    /**
     * 称呼：
     *      教授
     *      博士
     *      先生
     *      夫人
     *      女士
     */
    public static final String DIC_VALUE_TYPE_CODE_APPELLATION = "appellation";

    /**
     * 线索状态：
     *        虚假线索
     *        将来联系
     *        丢失线索
     *        试图联系
     *        未联系
     *        已联系
     *        需要条件
     */
    public static final String DIC_VALUE_TYPE_CODE_CLUE_STATE = "clueState";

    /**
     * 优先权：
     *      最高
     *      低
     *      高
     *      常规
     *      最低
     *
     */
    public static final String DIC_VALUE_TYPE_CODE_RETURN_PRIORITY="returnPriority";

    /**
     * 状态：
     *      未启动
     *      进行中
     *      推迟
     *      完成
     *      等待某人
     */
    public static final String DIC_VALUE_TYPE_CODE_RETURN_STATE="returnState";

    /**
     * 线索来源：
     *          销售邮件
     *          交易会
     *          聊天
     *          广告
     *          合作伙伴研讨会
     *          web调研
     *          合作伙伴
     *          内部研讨会
     *          推销电话
     *          web下载
     *          员工介绍
     *          在线商场
     *          公开媒介
     *          外部介绍
     */
    public static final String DIC_VALUE_TYPE_CODE_SOURCE = "source";

    /**
     * 阶段：
     *      成交
     *      资质审查
     *      丢失的线索
     *      因竞争丢失关闭
     *      需求分析
     *      提案/报价
     *      价值建议
     *      确定决策者
     *      谈判/复审
     */
    public static final String DIC_VALUE_TYPE_CODE_STAGE = "stage";

    /**
     * 业务类型：
     *      已有业务
     *      新业务
     */
    public static final String DIC_VALUE_TYPE_CODE_TRANSACTION_TYPE = "transactionType";




}
