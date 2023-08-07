package com.callray.crm;

import com.callray.crm.commons.constant.Contants;
import com.callray.crm.workbench.domain.ClueRemark;

import java.util.ArrayList;
import java.util.List;

public class Test {

    public static void main(String[] args) {
        ClueRemark clueRemark = new ClueRemark();
        clueRemark.setEditFlag(Contants.REMARK_EDIT_FLAG_NO_EDITED);

        List<ClueRemark> clueRemarkList = new ArrayList<>();
        clueRemarkList.add(clueRemark);

        for(ClueRemark remark: clueRemarkList){
            System.out.println(remark.getEditFlag()==Contants.REMARK_EDIT_FLAG_NO_EDITED);
        }


    }

}
