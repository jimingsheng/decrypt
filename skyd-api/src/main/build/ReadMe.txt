*****部署说明：
    解压缩部署包 XXXXX-{VERSION}.zip

*****目录结构说明：
    bin     应用控制命令
        boot.bat    手动启动命令（Windows）
        boot.sh     手动启动命令（Linux）
        InstallService.bat      注册Windows服务
        UnInstallService.bat    卸载Windows服务
        RegisterService.exe     Windows服务注册机
        RegisterService.xml     Windows服务注册机配置

    config  Spring Boot 项目外置配置文件
        application.yml         应用程序公共配置
        application-dev.yml     应用程序开发环境配置
        application-prd.yml     应用程序生产环境配置

    XXXXX-{VERSION}.jar     主应用程序

*****配置文件修改说明：
    文件application.yml修改
    spring:
        profiles.active     开发环境配置为 dev；生产环境配置为 prd;
    attachment.folder   指明附件存储路径

    文件application-dev/prd.yml修改
    server:
        port: 开发端口号 配置后访问地址为：http://IP:端口

*****应用启动方式：
    1、手动启动
        直接双击运行 bin目录下的 boot.bat 文件
    2、Windows服务运行
        以管理员身份运行 bin目录下的 InstallService.bat 文件
        自动注册为Windows服务，并随计算机启动
    3、卸载Windows服务
        已管理员身份运行 bin目录下的 UnInstallService.bat 文件
    4、在Linux环境中运行
        输入命令：./boot.sh start/stop/status/restart
        解释：
            start   启动应用程序
            stop    停止应用程序
            status  查看应用程序状态
            restart 重启应用程序