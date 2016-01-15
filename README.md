###导出AppCan Native iOS 插件开发资源包
将此repo和 AppCaniOS引擎的repo clone至**同一文件夹**下，然后执行

```
sh export.sh 
```

###导出第三方资源库
3rdParty目录下先编辑compile_list，用`#`注释掉不需要导出的第三方库

然后执行以下命令

```
#导出真机用第三方库
sh compile.sh 
```

或者

```
#导出模拟器用第三方库
sh compile.sh simu
```

或者

```
#导出通用的第三方库
sh compile.sh dev
```
导出的第三方库在3rdParty/output文件夹中 均为**静态framework**

**欢迎各位提交PR更新/添加第三方库!!**