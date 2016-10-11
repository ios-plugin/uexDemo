#! /bin/bash

var=$1


function compile_device(){
	name=$1
	if [ -d "./src/$name" ];then
		cd ./src/$name
		xcodebuild -configuration Release -project ${name}.xcodeproj -scheme $name clean | xcpretty
		xcodebuild -configuration Release -sdk iphoneos -project ${name}.xcodeproj -scheme $name build | xcpretty
		cd -
	fi
}
function compile_simulator(){
	name=$1
	if [ -d "./src/$name" ];then
		cd ./src/$name
		xcodebuild -configuration Release -project ${name}.xcodeproj -scheme $name clean | xcpretty
		xcodebuild -configuration Release -sdk iphonesimulator -project ${name}.xcodeproj -scheme $name build | xcpretty
		cd -
	fi
}

function compile_dev(){
	name=$1
	if [ -d "./src/$name" ];then
	rm -rf "tmp"
	mkdir "tmp"
	execPath="./output/${name}.framework/${name}"
	compile_simulator $name
	mv $execPath "tmp/simu"
	compile_device $name
	mv $execPath "tmp/device"
	lipo -create "tmp/simu" "tmp/device" -output $execPath
	rm -rf "tmp"
	fi
}

for LINE in `cat ./compile_list`  
do   
	if [[  $# -gt 0  &&  $var = "simu" ]];then
	compile_simulator $LINE
	elif [[  $# -gt 0  &&  $var = "dev" ]];then
	compile_dev $LINE
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



