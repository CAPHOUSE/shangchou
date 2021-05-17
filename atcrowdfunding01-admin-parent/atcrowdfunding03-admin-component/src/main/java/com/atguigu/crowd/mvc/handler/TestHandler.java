package com.atguigu.crowd.mvc.handler;

import com.atguigu.crowd.entity.Admin;
import com.atguigu.crowd.entity.Student;
import com.atguigu.crowd.service.api.AdminService;
import com.atguigu.crowd.util.CrowdUtil;
import com.atguigu.crowd.util.ResultEntity;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

@Controller
public class TestHandler {

    @Autowired
    private AdminService adminService;

    private static final Logger logger = LoggerFactory.getLogger(TestHandler.class);


    @RequestMapping("/test/ssm.html")
    public String testSsm(ModelMap modelMap, HttpServletRequest request){
        boolean judgeRequest = CrowdUtil.judgeRequestType(request);
        logger.info(judgeRequest + "");

        List<Admin> adminList = adminService.getAll();
      modelMap.addAttribute("adminList",adminList);
      return "target";
    }

    @ResponseBody
    @RequestMapping("/send/array.html")
    public String testAjax(@RequestParam("array[]") List<Integer> array){
        for (Integer integer : array) {
            System.out.println(integer);
        }
        return "success";
    }

    @ResponseBody
    @RequestMapping("/send/array/two.html")
    public String testAjaxTwo(@RequestParam("array[]") List<Integer> array){
        for (Integer integer : array) {
            System.out.println(integer);
        }
        return "success";
    }

    @ResponseBody
    @RequestMapping("/send/array/three.html")
    public String testAjaxThree(@RequestBody List<Integer> array){

        for (Integer integer : array) {
            logger.info("number:"+integer);
        }
        return "success";
    }

    @ResponseBody
    @RequestMapping("/send/compose/object.json")
    public ResultEntity<Student> test(@RequestBody Student student,HttpServletRequest request){

        boolean judgeRequest = CrowdUtil.judgeRequestType(request);

        logger.info(judgeRequest + "");

        logger.info(student.toString());
        return ResultEntity.successWithData(student);
    }
}
