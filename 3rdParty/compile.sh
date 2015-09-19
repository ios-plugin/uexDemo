#! /bin/bash



# 根据是否#开头，判断是否忽略


var=$1


function compile_device(){
	name=$1
	if [ -d "./src/$name" ];then
		cd ./src/$name
		xctool -project ${name}.xcodeproj -scheme $name clean
		xctool -configuration Release -sdk iphoneos -project ${name}.xcodeproj -scheme $name build
		cd -
	fi
}
function compile_simulator(){
	name=$1
	if [ -d "./src/$name" ];then
		cd ./src/$name
		xctool -project ${name}.xcodeproj -scheme $name clean
		xctool -configuration Release -sdk iphonesimulator -project ${name}.xcodeproj -scheme $name build
		cd -
	fi
}

for LINE in `cat ./compile_list`  
do   
	if [[  $# -gt 0  &&  $var = "simu" ]];then
	compile_simulator $LINE
	else
    compile_device $LINE
	fi
done
for LINE in `cat ./compile_list`  
do  
	if [ -d "./output/${LINE}.framework" ];then
		lipo -info "./output/${LINE}.framework/${LINE}"
	fi
done



