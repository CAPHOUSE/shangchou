package com.atguigu.crowd.exception;

/**
 * 删除抛出的异常
 */
public class RemoveException extends RuntimeException {

    private static final long serialVersionUID = 1L;

    public RemoveException() {
    }

    public RemoveException(String message) {
        super(message);
    }

    public RemoveException(String message, Throwable cause) {
        super(message, cause);
    }

    public RemoveException(Throwable cause) {
        super(cause);
    }

    public RemoveException(String message, Throwable cause, boolean enableSuppression, boolean writableStackTrace) {
        super(message, cause, enableSuppression, writableStackTrace);
    }
}
