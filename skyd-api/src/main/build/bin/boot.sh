#!/bin/bash
#===============================================================================
# Filename: boot.sh
# Copyright (C) 2018 Sinosoft
# Author: huangpen - huangpen@skynj.com
# Create: 2018-08-01 13:00
# Description: SpringBoot应用的启停脚本，输入参数：start|stop|restart|status。
# Modified by weigang at 2018-08-08 14:00 for 增加自定义进程名参数CUSTOM_APP_NAME；完善相应的启停方法。
# Modified by weigang at 2018-08-23 10:30 for 修改“备份控制台输出日志文件”的bug，只在启动前处理。
# Modified by sunqian at 2018-08-28 16:00 for 支持jar或者war启动。
#===============================================================================

#自定义应用名称。当一台服务器上运行两个相同应用时，必须设置以区分。
#CUSTOM_APP_NAME=

BOOT_HOME=..

# springboot的jar放同级目录下即可，只能有一个jar文件
APP_JAR_PATH=$(find $BOOT_HOME -maxdepth 1 -name "*.jar" -o -name "*.war")
APP_JAR_NAME=${APP_JAR_PATH##*/}
APP_NAME=${APP_JAR_NAME%.*}

if [ ! -z "$CUSTOM_APP_NAME" ] ; then
    APP_NAME=$CUSTOM_APP_NAME

fi

if [ "$1" = "" ];
then
    echo -e " 未输入操作名    {start|stop|restart|status} "
    exit 1
fi

if [ "$APP_NAME" = "" ];
then
    echo -e " 未找到应用名 "
    exit 1
fi

pid=0
#pid.txt存在且其中的pid合法
if [ -f pid.txt ] ; then 
	dpid=$(cat pid.txt)
	if [ $(ps -p $dpid|grep $dpid |wc -l) = 1 ] ; then
		pid=$dpid
	fi
fi
#pid.txt没找到合法pid，但是存在CUSTOM_APP_NAME
if [ "$pid" = "0" ] && [ ! -z "$CUSTOM_APP_NAME" ] ; then
    appcount=$(ps -ef|grep java|grep $APP_NAME|grep -v grep|wc -l)
	if [ "$appcount" -gt "1" ] ; then
		echo "存在多个自定义应用名 $APP_NAME 的进程！！！异常退出！！！" 
		exit 1;
	elif [ "$appcount" = "1" ] ; then
		pid=$(ps -ef |grep java|grep $APP_NAME|grep -v grep|awk '{print $2}')
	fi
fi

function start()
{
	if [ "$pid" -gt "0" ];then
		echo "$APP_NAME $pid is already running. Cannot start again."
	else
		#备份控制台输出日志文件
		if [ -f nohup.out ] ; then
			mv nohup.out `date +%Y%m%d`"-bak.log"
		fi
		nohup java -Dapp=$APP_NAME -verbose:gc -Xmx4096m -Xms2048m -jar $APP_JAR_PATH --spring.config.additional-location=file:$BOOT_HOME/config/ >nohup.out & echo $! > pid.txt
		echo "Starting $APP_NAME..."
	fi
}

function stop()
{
	echo "Stopping $APP_NAME..."
	#先根据pid停止进程；如果不存在，则根据应用名停止进程。
	if [ "$pid" -gt "0" ] ; then
		echo "stop by pid $pid"
		kill -9 $pid
	else
		if [ $(ps -ef|grep java|grep $APP_NAME|grep -v grep|wc -l) = 1 ] ; then
			echo "stop by app $APP_NAME"
			kill -9 $(ps -ef |grep java|grep $APP_NAME|grep -v grep|awk '{print $2}')
		else
			echo "Process $APP_NAME $pid does not exist." 
		fi
	fi
}

function restart()
{
	stop
	pid=0
	sleep 1
	start
}

function status()
{
	if [ "$pid" -gt "0" ] ; then
		echo "$APP_NAME is running..."
    else
        echo "$APP_NAME is not running..."
    fi
}

case $1 in
	start)
	start;;
	stop)
	stop;;
	restart)
	restart;;
	status)
	status;;
	*)

	echo -e " Usage:    $0  {start|stop|restart|status}   Example:   $0  start"
esac
