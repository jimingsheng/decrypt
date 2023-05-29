package com.skynj.skyd;

public enum countDownloadEnum {

    DESIGN_RESOURCES("设计资源");

    private String name;

    private countDownloadEnum(String name) {
        this.name = name;
    }

    public String getName() {
        return this.name;
    }
}
