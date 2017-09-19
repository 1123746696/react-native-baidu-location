package com.example.rctbaidulocation;

import android.app.Application;
import android.support.annotation.Nullable;
import android.util.Log;

import com.baidu.location.BDLocation;
import com.baidu.location.BDLocationListener;
import com.baidu.location.LocationClient;
import com.baidu.location.LocationClientOption;
import com.baidu.location.Poi;
import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.LifecycleEventListener;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;

import org.json.JSONObject;

import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

/**
 * Created by user on 16/9/8.
 */

public class BaiduLocationModule extends ReactContextBaseJavaModule implements LifecycleEventListener {
    protected static final String TAG = BaiduLocationModule.class.getSimpleName();
    protected static final String WillStartLocatingUser = "WillStartLocatingUser";
    protected static final String DidStopLocatingUser = "DidStopLocatingUser";

    protected static final String DidUpdateUserHeading = "DidUpdateUserHeading";
    protected static final String DidUpdateBMKUserLocation = "DidUpdateBMKUserLocation";
    protected static final String DidFailToLocateUserWithError = "DidFailToLocateUserWithError";

    private ReactApplicationContext mReactContext;
    private LocationClientOption option = null;
    private LocationClient mLocationClient = null;


    @Override
    public String getName() {
        return "BaiduLocation";
    }


    public BaiduLocationModule(ReactApplicationContext reactContext) {
        super(reactContext);
        mReactContext = reactContext;
        mReactContext.addLifecycleEventListener(this);

//        mLocationClient = new LocationClient(reactContext.getBaseContext());     //声明LocationClient类
//        mLocationClient.registerLocationListener(new BDLocationListener() {
//            @Override
//            public void onReceiveLocation(BDLocation location) {
//                Log.v(TAG, "onReceiveLocation");
//                if (location.getLocType() == BDLocation.TypeGpsLocation||location.getLocType() == BDLocation.TypeNetWorkLocation||location.getLocType() == BDLocation.TypeOffLineLocation) {// 定位成功
//                    Log.v(TAG, "get location " + location.getCity());
//                    sendSuccessEvent(location);
//                } else {
//                    Log.v(TAG, "get failed ");
//                    sendFailureEvent(location);
//                }
//            }
//        });
    }
    @Override
    public Map<String, Object> getConstants() {
        final Map<String, Object> constants = new HashMap<>();
        constants.put(DidStopLocatingUser, DidStopLocatingUser);
        constants.put(DidUpdateBMKUserLocation, DidUpdateBMKUserLocation);
        constants.put(DidFailToLocateUserWithError, DidFailToLocateUserWithError);
        return constants;
    }

    @ReactMethod
    public void setLocationOption(ReadableMap optionMap){
        LocationClientOption option = new LocationClientOption();
        option.setLocationMode(LocationClientOption.LocationMode.Hight_Accuracy
        );//可选，默认高精度，设置定位模式，高精度，低功耗，仅设备
        int span=1000;
        option.setScanSpan(span);//可选，默认0，即仅定位一次，设置发起定位请求的间隔需要大于等于1000ms才是有效的
        option.setIsNeedAddress(true);//可选，设置是否需要地址信息，默认不需要
        option.setOpenGps(true);//可选，默认false,设置是否使用gps
        option.setLocationNotify(false);//可选，默认false，设置是否当gps有效时按照1S1次频率输出GPS结果
        option.setIsNeedLocationDescribe(true);//可选，默认false，设置是否需要位置语义化结果，可以在BDLocation.getLocationDescribe里得到，结果类似于“在北京天安门附近”
        option.setIsNeedLocationPoiList(true);//可选，默认false，设置是否需要POI结果，可以在BDLocation.getPoiList里得到
        option.setIgnoreKillProcess(false);//可选，默认true，定位SDK内部是一个SERVICE，并放到了独立进程，设置是否在stop的时候杀死这个进程，默认不杀死
        option.SetIgnoreCacheException(false);//可选，默认false，设置是否收集CRASH信息，默认收集
        option.setEnableSimulateGps(false);//可选，默认false，设置是否需要过滤gps仿真结果，默认需要
        mLocationClient.setLocOption(option);
    }

    @ReactMethod
    public void startLocation() {
        if (mLocationClient == null) {
            mLocationClient = new LocationClient(mReactContext.getBaseContext());     //声明LocationClient类
            mLocationClient.registerLocationListener(new BDLocationListener() {
                @Override
                public void onReceiveLocation(BDLocation location) {
                    Log.v(TAG, "onReceiveLocation");
                    if (location.getLocType() == BDLocation.TypeGpsLocation||location.getLocType() == BDLocation.TypeNetWorkLocation||location.getLocType() == BDLocation.TypeOffLineLocation) {// 定位成功
                        Log.v(TAG, "get location " + location.getCity());
                        sendSuccessEvent(location);
                    } else {
                        Log.v(TAG, "get failed ");
                        sendFailureEvent(location);
                    }
                }
            });
        }

        setLocationOption(null);
        mLocationClient.start();
    }
    @ReactMethod
    public void stopLocation() {
        mLocationClient.stop();
        sendDidStopEvent();
    }

    protected  void sendSuccessEvent(BDLocation location){
        WritableMap map = Arguments.createMap();
        map.putDouble("latitude",location.getLatitude());
        map.putDouble("longitude",location.getLongitude());
        map.putString("address",location.getAddrStr());


        map.putString("province",location.getProvince());
        map.putString("city",location.getCity());
        map.putString("district",location.getDistrict());
        map.putString("streetName",location.getStreet());
        map.putString("streetNumber",location.getStreetNumber());
        if (location.getLocType() == BDLocation.TypeGpsLocation){// GPS定位结果
            map.putString("describe","gps定位成功");
        } else if (location.getLocType() == BDLocation.TypeNetWorkLocation){// 网络定位结果
            map.putString("describe","网络定位成功");
        } else if (location.getLocType() == BDLocation.TypeOffLineLocation) {// 离线定位结果
            map.putString("describe","离线定位成功");
        }
        map.putString("locationDescribe",location.getLocationDescribe());
        sendEvent(DidUpdateBMKUserLocation,map);
    }
    protected  void sendFailureEvent(BDLocation location){
        WritableMap map = Arguments.createMap();
        map.putInt("code",BDLocation.TypeServerError);
        if (location.getLocType() == BDLocation.TypeServerError) {
            map.putString("message","服务端网络定位失败，可以反馈IMEI号和大体定位时间到loc-bugs@baidu.com，会有人追查原因");
        } else if (location.getLocType() == BDLocation.TypeNetWorkException) {
            map.putString("message","网络不同导致定位失败，请检查网络是否通畅");
        } else if (location.getLocType() == BDLocation.TypeCriteriaException) {
            map.putString("message","无法获取有效定位依据导致定位失败，一般是由于手机的原因，处于飞行模式下一般会造成这种结果，可以试着重启手机");
        }else{
            map.putString("message","定位失败");
        }
        map.putString("locationDescribe",location.getLocationDescribe());
        sendEvent(DidFailToLocateUserWithError,map);
    }
    protected  void sendDidStopEvent(){
        WritableMap map = Arguments.createMap();
        map.putString("message", "停止定位");
        sendEvent(DidStopLocatingUser,map);
    }

    private void sendEvent(String eventName, @Nullable WritableMap params) {
        //此处需要添加hasActiveCatalystInstance，否则可能造成崩溃
        //问题解决参考: https://github.com/walmartreact/react-native-orientation-listener/issues/8
        if(mReactContext.hasActiveCatalystInstance()) {
            Log.i(TAG, "hasActiveCatalystInstance");
            mReactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                    .emit(eventName, params);
        }
        else {
            Log.i(TAG, "not hasActiveCatalystInstance");
        }
    }


    @Override
    public void onHostResume() {
    }

    @Override
    public void onHostPause() {
    }

    @Override
    public void onHostDestroy() {
    }
    
    /***
     * 设置baiduMap的Key
     * @param key     baiduMap的key
     */
    @ReactMethod
    public void start(String key) {//该key暂时没用，已经写死在AndroidManifest.xml里边
        SDKInitializer.initialize(getReactApplicationContext().getApplicationContext());
    }

}
