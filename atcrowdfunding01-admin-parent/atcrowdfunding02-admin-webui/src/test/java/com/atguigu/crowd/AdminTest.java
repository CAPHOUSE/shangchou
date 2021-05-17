package com.atguigu.crowd;

import com.atguigu.crowd.entity.Admin;
import com.atguigu.crowd.entity.Role;
import com.atguigu.crowd.mapper.AdminMapper;
import com.atguigu.crowd.mapper.RoleMapper;
import com.atguigu.crowd.service.api.AdminService;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import javax.sql.DataSource;
import java.sql.SQLException;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"classpath:spring-persist-mybatis.xml","classpath:spring-persist-tx.xml"})
public class AdminTest {

    @Autowired
    private DataSource dataSource;

    @Autowired
    private AdminMapper adminMapper;

    @Autowired
    private AdminService adminService;

    @Autowired
    private RoleMapper roleMapper;

    @Test
    public void test() throws SQLException {
//        获取logger日志
        Logger logger = LoggerFactory.getLogger(AdminTest.class);

//        打印不同级别的日志
        logger.debug("Hello I am Debug level!");
        logger.debug("Hello I am Debug level!");
        logger.debug("Hello I am Debug level!");

        logger.info("Info level!");
        logger.info("Info level!");
        logger.info("Info level!");

        logger.warn("Warn level");
        logger.warn("Warn level");
        logger.warn("Warn level");

        logger.error("Error level");
        logger.error("Error level");
        logger.error("Error level");
    }

    @Test
    public void tet(){
        Admin admin = new Admin(null, "jerry", "123", "介入", "jerry.qq.com", null);
        adminService.saveAdmin(admin);
    }

    @Test
    public void test02(){
        for (int i = 0; i < 200; i++) {
            roleMapper.insert(new Role(null,"role" + i));
        }
    }
}
