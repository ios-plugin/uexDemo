#!/bin/bash

# 更新插件开发demo的脚本
# By CeriNo


# 获取脚本文件夹的绝对路径
shellPath=$(cd "$(dirname "$0")"; pwd)
echo $shellPath
# 引擎文件夹路径
enginePath=${shellPath}/../appcan-ios
# 资源文件路径
resPath=${shellPath}/res/iOS
# 临时文件路径
tmpPath=${shellPath}/iOS
#如果引擎文件夹不存在 直接返回
if [ ! -d $enginePath ]; then
	echo "ERROR!!"
  	echo "此脚本依赖AppCan引擎"
  	echo "请先在uexDemo的上级目录同步引擎工程"
  	echo "进入uexDemo的上级目录，然后执行以下命令即可:"
  	echo "git clone https://github.com/AppCanOpenSource/appcan-ios.git"
  	echo "请同步完成后再重新执行此脚本"
  	exit 0;
fi

#以下假设引擎文件夹里的内容是完整的]
rm -rf $tmpPath
cp -rf $resPath $shellPath

#调试插件的工程目录
projPath=${tmpPath}/开发插件演示demo/调试插件的工程/

echo "复制引擎工程..."
cp -rf ${enginePath}/AppCanPlugin $projPath

echo "编译通用的引擎静态库..."
xcodebuild -project ${enginePath}/AppCanEngine/AppCanEngine.xcodeproj -scheme AppCanPluginDevEngine clean
xcodebuild -project ${enginePath}/AppCanEngine/AppCanEngine.xcodeproj -scheme AppCanPluginDevEngine build
echo "替换引擎文件..."
cp -rf ${enginePath}/AppCanEngine/libAppCanEngine.a ${projPath}/AppCanPlugin/AppCanPlugin/engine/libAppCanEngine.a
echo "编译通用的第三方依赖库"
close
cd ${shellPath}/3rdParty/
sh compile.sh dev
cd -
#uexFrameworkPath
frwkPath=${projPath}/AppCanPlugin/AppCanPlugin/uexFrameworks
echo "替换第三方依赖库"
rm -rf ${frwkPath}/Ono.framework
mv -f ${shellPath}/3rdParty/output/Ono.framework $frwkPath
rm -rf ${frwkPath}/pop.framework
mv -f ${shellPath}/3rdParty/output/pop.framework $frwkPath
echo "导出zip..."
cd $shellPath
zip -r "iOS.zip" "iOS"
cd -
rm -rf $tmpPath