package com.atguigu.crowd.mvc.config;

import com.atguigu.crowd.constant.CrowdConstant;
import com.atguigu.crowd.exception.LoginAcctAlreadyInUseException;
import com.atguigu.crowd.exception.LoginAcctAlreadyInUseForUpdateException;
import com.atguigu.crowd.exception.RemoveException;
import com.atguigu.crowd.util.CrowdUtil;
import com.atguigu.crowd.util.ResultEntity;
import com.google.gson.Gson;
import com.atguigu.crowd.exception.LoginFailedException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@ControllerAdvice
public class CrowdExceptionResolver {

    @ExceptionHandler(value = LoginAcctAlreadyInUseForUpdateException.class)
    public ModelAndView resolveLoginAcctAlreadyInUseForUpdateException(
            LoginAcctAlreadyInUseForUpdateException exception,
            HttpServletRequest request,
            HttpServletResponse response
    ) throws IOException {

        String viewName = "system-error";

        return commonResolve(viewName, exception, request, response);
    }

    @ExceptionHandler(value = LoginAcctAlreadyInUseException.class)
    public ModelAndView resolveLoginAcctAlreadyInUseException(
            LoginAcctAlreadyInUseException exception,
            HttpServletRequest request,
            HttpServletResponse response
    ) throws IOException {

        String viewName = "admin-add";

        return commonResolve(viewName, exception, request, response);
    }

    @ExceptionHandler(value = RemoveException.class)
    public ModelAndView resolveRemoveException( LoginAcctAlreadyInUseException exception,
                                                HttpServletRequest request,
                                                HttpServletResponse response) throws IOException {
        String viewName = "admin-page";

        return commonResolve(viewName, exception, request, response);
    }


    @ExceptionHandler(value = LoginFailedException.class)
    public ModelAndView resolveLoginFailedException(
            LoginFailedException exception,
            HttpServletRequest request,
            HttpServletResponse response
    ) throws IOException {

        String viewName = "admin-login";

        return commonResolve(viewName, exception, request, response);
    }

    @ExceptionHandler(value = ArithmeticException.class)
    public ModelAndView resolveMathException(
            ArithmeticException exception,
            HttpServletRequest request,
            HttpServletResponse response
    ) throws IOException {
        String viewName = "system-error";
        return commonResolve(viewName, exception, request, response);
    }


    @ExceptionHandler(value = NullPointerException.class)
    public ModelAndView resolveNullPointerException(
            NullPointerException exception,
            HttpServletRequest request,
            HttpServletResponse response) throws IOException {
        String viewName = "system-error";
        return commonResolve(viewName, exception, request, response);
    }
    // @ExceptionHandler?????????????????????????????????????????????????????????
    private ModelAndView commonResolve(
            // ????????????????????????????????????
            String viewName,
            // ??????????????????????????????
            Exception exception,
            // ??????????????????
            HttpServletRequest request,
            // ??????????????????
            HttpServletResponse response) throws IOException {
        // 1.????????????????????????
        boolean judgeResult = CrowdUtil.judgeRequestType(request);
        // 2.?????????Ajax??????
        if(judgeResult) {
            // 3.??????ResultEntity??????
            ResultEntity<Object> resultEntity = ResultEntity.failed(exception.getMessage());
            // 4.??????Gson??????
            Gson gson = new Gson();
            // 5.???ResultEntity???????????????JSON?????????
            String json = gson.toJson(resultEntity);
            // 6.???JSON??????????????????????????????????????????
            response.getWriter().write(json);
            // 7.?????????????????????????????????response???????????????????????????????????????ModelAndView??????
            return null;
        }
        // 8.????????????Ajax???????????????ModelAndView??????
        ModelAndView modelAndView = new ModelAndView();
        // 9.???Exception??????????????????
        modelAndView.addObject(CrowdConstant.ATTR_NAME_EXCEPTION, exception);
        // 10.???????????????????????????
        modelAndView.setViewName(viewName);
        // 11.??????modelAndView??????
        return modelAndView;
    }

}
