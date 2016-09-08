package com.example.rctbaidulocation;

import com.facebook.react.bridge.LifecycleEventListener;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
/**
 * Created by user on 16/9/8.
 */

public class BaiduLocationModule extends ReactContextBaseJavaModule implements LifecycleEventListener {
    protected static final String didUpdateUserLocation = "didUpdateUserLocation";
    protected static final String didFailureLocation = "didFailureLocation";
    public BaiduLocationModule(ReactApplicationContext reactContext) {
        super(reactContext);
    }

    @Override
    public String getName() {
        return "BaiduLocation";
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
}