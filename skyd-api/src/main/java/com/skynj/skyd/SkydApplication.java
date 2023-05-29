package com.skynj.skyd;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;

@SpringBootApplication
@MapperScan("com.skynj.skyd")
@EnableScheduling
public class SkydApplication {

    public static void main(String[] args) {
        SpringApplication.run(SkydApplication.class, args);
    }
}
