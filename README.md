# react-native-baidu-location
集成百度的定位功能，支持IOS和Android
##安装
```
npm install react-native-baidu-location
rnpm link react-native-baidu-location
```

##集成到iOS
1.请在你的工程目录结构中，添加百度定位SDK引用，在选项TARGETS--> Build Phases-->Link Binary With Libraries-->Add Other，选择文件node_modules/react-native-baidu-location/ios/BaiduLocation/BaiduMapAPI_Base.framework<br>
node_modules/react-native-baidu-location/ios/BaiduLocation/BaiduMapAPI_Location.framework<br>
node_modules/react-native-baidu-location/ios/BaiduLocation/BaiduMapAPI_Search.framework<br>

2.在工程目录结构中,添加百度定位SDK引用,在TARGETS-->Build Settings-->Framework Search Paths, 添加:
$(SRCROOT)/../node_modules/react-native-baidu-location/ios/BaiduLocation<br>


注：自iOS8起，系统定位功能进行了升级，开发者在使用定位功能之前，需要在info.plist里添加（以下二选一，两个都添加默认使用NSLocationWhenInUseUsageDescription）：
NSLocationWhenInUseUsageDescription ，允许在前台使用时获取GPS的描述
NSLocationAlwaysUsageDescription ，允许永久使用GPS的描述

详情参考：[百度定位IOS集成指南](http://lbsyun.baidu.com/index.php?title=iossdk/guide/location)<br>

##集成到android


####添加配置
在项目工程的`AndroidManifest.xml`中的<Application>标签下添加:

```
<meta-data
android:name="com.baidu.lbsapi.API_KEY"
android:value="AK" />       //key:开发者申请的Key
```
在Application标签中声明SERVICE组件,每个APP拥有自己单独的定位SERVICE
```
<service android:name="com.baidu.location.f" android:enabled="true" android:process=":remote">
</service>
```
声明使用权限
```
<!-- 这个权限用于进行网络定位-->
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"></uses-permission>
<!-- 这个权限用于访问GPS定位-->
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"></uses-permission>
<!-- 用于访问wifi网络信息，wifi信息会用于进行网络定位-->
<uses-permission android:name="android.permission.ACCESS_WIFI_STATE"></uses-permission>
<!-- 获取运营商信息，用于支持提供运营商信息相关的接口-->
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"></uses-permission>
<!-- 这个权限用于获取wifi的获取权限，wifi信息会用来进行网络定位-->
<uses-permission android:name="android.permission.CHANGE_WIFI_STATE"></uses-permission>
<!-- 用于读取手机当前的状态-->
<uses-permission android:name="android.permission.READ_PHONE_STATE"></uses-permission>
<!-- 写入扩展存储，向扩展卡写入数据，用于写入离线定位数据-->
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"></uses-permission>
<!-- 访问网络，网络定位需要上网-->
<uses-permission android:name="android.permission.INTERNET" />
<!-- SD卡读取权限，用户写入离线定位数据-->
<uses-permission android:name="android.permission.MOUNT_UNMOUNT_FILESYSTEMS"></uses-permission>
```

详情参考：[百度定位android集成指南](http://lbsyun.baidu.com/index.php?title=android-locsdk)<br>

##API

| API | Note |    
|---|---|
| `startLocation` | 开始定位 |
| `stopLocation` | 停止定位 |
| `didUpdateBMKUserLocation` | 定位刷新的回调方法 |
| `didStopLocatingUser` | 定位停止的回调方法 |
| `didFailToLocateUserWithError` | 定位失败的回调方法 |

##Usage

```
import BaiduLocation from 'react-native-baidu-location'

//开始定位
BaiduLocation.startLocation();

//停止定位
BaiduLocation.stopLocation();

//定位刷新回调
BaiduLocation.didUpdateBMKUserLocation(param=>{
    console.log('didUpdateBMKUserLocation',param);
})

//定位失败的回调
BaiduLocation.didFailToLocateUserWithError(param=>{
    console.log('didFailToLocateUserWithError',param);
})

//定位停止的回调
BaiduLocation.didStopLocatingUser(param=>{
    console.log('didStopLocatingUser',param);
})

```
