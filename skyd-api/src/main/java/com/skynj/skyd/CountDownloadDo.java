package com.skynj.skyd;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

@Data
@TableName("count_download")
public class CountDownloadDo {

    private String id;
    private String metric;
    private Integer value;

}
