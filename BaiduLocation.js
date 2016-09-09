import React, {
    NativeModules,
    DeviceEventEmitter, //android
    NativeAppEventEmitter, //ios
    Platform,
    AppState,
} from 'react-native';

const BaiduLocationModule = NativeModules.BaiduLocation;

var willStartLocatingUserSubscript,
    didStopLocatingUserSubscript,
    didUpdateUserHeadingSubscript,
    didUpdateBMKUserLocationSubscript,
    didFailToLocateUserWithErrorSubscript;

var BaiduLocation = {
    /***
     *  设定定位的最小更新距离
     */
    setDistanceFilter(distanceFilter:number){
        BaiduLocationModule.setDistanceFilter(distanceFilter);
    },
    /***
     *  设定定位精度
     */
    setDesiredAccuracy(desiredAccuracy:number){
        BaiduLocationModule.setDesiredAccuracy(desiredAccuracy);
    },
    /***
     *  设定最小更新角度。默认为1度
     */
    setHeadingFilter(headingFilter:number){
        BaiduLocationModule.setHeadingFilter(headingFilter);
    },
    /***
     *  指定定位是否会被系统自动暂停。默认为YES,只在iOS 6.0之后起作用。
     */
    setPausesLocationUpdatesAutomatically(canPause:boolean){
        BaiduLocationModule.setPausesLocationUpdatesAutomatically(canPause);
    },
    /***
     *  指定定位：是否允许后台定位更新。默认为NO。
     */
    setAllowsBackgroundLocationUpdates(isAllows:boolean){
        BaiduLocationModule.setAllowsBackgroundLocationUpdates(isAllows);
    },
    startLocation(){
        BaiduLocationModule.startLocation();
    },
    stopLocation(){
        BaiduLocationModule.stopLocation();
    },
    willStartLocatingUser(handler: Function){
        willStartLocatingUserSubscript = this.addEventListener(BaiduLocationModule.WillStartLocatingUser, handler);
    },
    didStopLocatingUser(handler: Function){
        didStopLocatingUserSubscript = this.addEventListener(BaiduLocationModule.DidStopLocatingUser, handler);
    },
    didUpdateUserHeading(handler: Function){
        didUpdateUserHeadingSubscript = this.addEventListener(BaiduLocationModule.DidUpdateUserHeading, handler);
    },
    didUpdateBMKUserLocation(handler: Function){
        didUpdateBMKUserLocationSubscript = this.addEventListener(BaiduLocationModule.DidUpdateBMKUserLocation, message => {
            //处于后台时，拦截收到的消息
            if(AppState.currentState === 'background') {
                return;
            }
            handler(message);
        });
    },
    didFailToLocateUserWithError(handler: Function){
        didFailToLocateUserWithErrorSubscript = this.addEventListener(BaiduLocationModule.DidFailToLocateUserWithError, handler);
    },
    addEventListener(eventName: string, handler: Function) {
        if(Platform.OS === 'android') {
            return DeviceEventEmitter.addListener(eventName, (event) => {
                handler(event);
            });
        }
        else {
            return NativeAppEventEmitter.addListener(
                eventName, (userInfo) => {
                    handler(userInfo);
                });
        }
    },
};

module.exports = BaiduLocation;