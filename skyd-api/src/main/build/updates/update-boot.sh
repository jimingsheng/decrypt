#!/bin/bash
#=============================================================================
# Filename: update-boot.sh
# Copyright (C) 2018 Sinosoft
# Author: sunqian - sunqian@skynj.com
# Create: 2018-08-09 11:00
# Description: Springboot应用部署自动化更新脚本
# 部署目录规范:
#		xxxxx-{version1}.jar      #必须且只能有1个jar
#		bin
#			boot.sh
#       updates
#			update-boot.sh 		          #一键更新部署命令
#			xxxxx-{version2}.jar          #新jar包，更新的jar不可与原有的jar同名
#			{YYYYMMDDHHMI}  
#				xxxxx-{version1}-bak.jar  
#				xxxxx-{version2}.jar      
#=============================================================================

set -e

jarName="unknown"
function checkEvn(){
	cd $DEPLOY_FOLDER
	jarCount=$(find . -maxdepth 1 -name "*.jar"|wc -l)
	if [ "$jarCount" != "1" ];then
	   echo "必须且只能有1个jar" 
	   exit 1
	fi
	jarName=$(basename $(find . -maxdepth 1 -name "*.jar"))
	if [ $jarName = $updateFile ];then
		echo "更新的jar不可与原有的jar同名" 
		exit 1
	fi
}

function ExecUpdateTask(){

	#当前系统时间，用于解压更新包时建立的文件夹名称以及备份应用系统时建议的文件夹名称
	time=$(date "+%Y%m%d%H%M") 
	
	UPDATE_FOLDER=$UPDATE_FOLDER_ROOT/$time
	
	echo 第一步：创建更新目录*************************
	mkdir $UPDATE_FOLDER
	
	echo 第二步：停止应用程序*************************
	cd $DEPLOY_FOLDER/bin
	./boot.sh stop
	sleep 2
	
	echo 第三步：备份应用程序*************************
	bakJarName=$(basename $jarName .jar)
	mv $DEPLOY_FOLDER/*.jar $UPDATE_FOLDER/$bakJarName-bak.jar
	
	echo 第四步：更新应用程序*************************
	cp $UPDATE_FOLDER_ROOT/$updateFile $DEPLOY_FOLDER
	
	echo 第五步：重新启动应用程序*************************	
	cd $DEPLOY_FOLDER/bin
    ./boot.sh start
	
	#将更新包移至更新目录中
	mv $UPDATE_FOLDER_ROOT/$updateFile $UPDATE_FOLDER
	#回到初始路径中
	cd $UPDATE_FOLDER_ROOT 
	echo 自动更新已经完成，请确认结果*************************
}


#设置应用程序路径
DEPLOY_FOLDER=$(dirname $(pwd))
	
#设置更新包根路径
UPDATE_FOLDER_ROOT=$DEPLOY_FOLDER/updates  
	
updateFile=$1
if [ ! $updateFile ];then
	echo 请输入更新包文件名
	exit 1
fi

if [ ! -f $UPDATE_FOLDER_ROOT/$updateFile ];then
	echo "更新包($UPDATE_FOLDER_ROOT/$updateFile)不存在"
	exit 1
fi
	
read -p "确认是否执行本次更新否[N],是[Y]:" execable

if [ "$execable" = "N" ];then
    exit 0
elif [ "$execable" = "Y" ];then
	echo 开始更新
	checkEvn
	ExecUpdateTask
else 
	echo 非法输入
	exit 1
fi
exit 0
