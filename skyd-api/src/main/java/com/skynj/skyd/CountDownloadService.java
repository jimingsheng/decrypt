package com.skynj.skyd;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.UUID;

@Service
public class CountDownloadService {

    @Resource
    private CountDownloadMapper countDownloadMapper;

    public Integer setDesignResources() {
        LambdaQueryWrapper<CountDownloadDo> lqw = new LambdaQueryWrapper<>();
        lqw.eq(CountDownloadDo::getMetric, countDownloadEnum.DESIGN_RESOURCES.getName());
        CountDownloadDo record = countDownloadMapper.selectOne(lqw);
        if (record == null) {
            record.setId(UUID.randomUUID().toString());
            record.setMetric(countDownloadEnum.DESIGN_RESOURCES.getName());
            record.setValue(1);
            countDownloadMapper.insert(record);
        } else {
            record.setValue(record.getValue() + 1);
            countDownloadMapper.updateById(record);
        }
        return record.getValue();
    }


}
