package com.skynj.skyd;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;

@RestController()
public class CountDownloadApi {

    @Resource
    private CountDownloadService countDownloadService;

    @GetMapping("/design-count")
    public ResponseEntity<Integer> setCount() {
        return ResponseEntity.ok(countDownloadService.setDesignResources());
    }

}
