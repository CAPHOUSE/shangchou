package com.atguigu.crowd;


import com.atguigu.crowd.util.CrowdUtil;
import org.junit.Test;

public class Test01 {

    @Test
    public void test02(){
        String s = CrowdUtil.md5("123456");
        System.out.println(s);
    }
}
