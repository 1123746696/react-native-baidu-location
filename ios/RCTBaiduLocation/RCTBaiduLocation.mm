//
//  RCTBaiduLocation.m
//  RCTBaiduLocation
//
//  Created by user on 16/9/8.
//  Copyright © 2016年 baj. All rights reserved.
//

#import "RCTBaiduLocation.h"
#import "RCTEventDispatcher.h"
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
static NSString * const WillStartLocatingUser = @"WillStartLocatingUser";
static NSString * const DidStopLocatingUser = @"DidStopLocatingUser";
static NSString * const DidUpdateUserHeading = @"DidUpdateUserHeading";
static NSString * const DidUpdateBMKUserLocation = @"DidUpdateBMKUserLocation";
static NSString * const DidFailToLocateUserWithError = @"DidFailToLocateUserWithError";

@interface RCTBaiduLocation()<BMKLocationServiceDelegate>
@property(nonatomic,strong)BMKLocationService *locationService;
@end
@implementation RCTBaiduLocation
@synthesize bridge = _bridge;
RCT_EXPORT_MODULE()

+ (instancetype)sharedInstance {
    static RCTBaiduLocation *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(_instance == nil) {
            _instance = [[self alloc] init];
            _instance.locationService=[[BMKLocationService alloc]init];
            _instance.locationService.delegate=_instance;
        }
    });
    return _instance;
}
+ (dispatch_queue_t)sharedMethodQueue {
    static dispatch_queue_t methodQueue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        methodQueue = dispatch_queue_create("com.baj.baidulocation", DISPATCH_QUEUE_SERIAL);
    });
    BMKLocationService *location = [[BMKLocationService alloc]init];
    return methodQueue;
    
}

- (dispatch_queue_t)methodQueue {
    return [RCTBaiduLocation sharedMethodQueue];
}
- (NSDictionary<NSString *, id> *)constantsToExport {
    return @{
             WillStartLocatingUser: WillStartLocatingUser,
             DidStopLocatingUser: DidStopLocatingUser,
             DidUpdateUserHeading: DidUpdateUserHeading,
             DidUpdateBMKUserLocation: DidUpdateBMKUserLocation,
             DidFailToLocateUserWithError: DidFailToLocateUserWithError,
             };
}
RCT_EXPORT_METHOD(startLocation{
    RCTBaiduLocation *location = [RCTBaiduLocation sharedInstance];
    [location.locationService startUserLocationService];
})
RCT_EXPORT_METHOD(stopLocation{
    RCTBaiduLocation *location = [RCTBaiduLocation sharedInstance];
    [location.locationService stopUserLocationService];
})
RCT_EXPORT_METHOD(setDistanceFilter:(NSNumber *)distanceFilter{
    RCTBaiduLocation *location = [RCTBaiduLocation sharedInstance];
    location.locationService.distanceFilter=[distanceFilter doubleValue];
})
RCT_EXPORT_METHOD(setDesiredAccuracy:(NSNumber *)desiredAccuracy{
    RCTBaiduLocation *location = [RCTBaiduLocation sharedInstance];
    location.locationService.desiredAccuracy=[desiredAccuracy doubleValue];
})
RCT_EXPORT_METHOD(setHeadingFilter:(NSNumber *)headingFilter{
    RCTBaiduLocation *location = [RCTBaiduLocation sharedInstance];
    location.locationService.headingFilter=[headingFilter doubleValue];
})
RCT_EXPORT_METHOD(setPausesLocationUpdatesAutomatically:(BOOL)canPause{
    RCTBaiduLocation *location = [RCTBaiduLocation sharedInstance];
    location.locationService.pausesLocationUpdatesAutomatically=canPause;
})
RCT_EXPORT_METHOD(setAllowsBackgroundLocationUpdates:(BOOL)isAllows{
    RCTBaiduLocation *location = [RCTBaiduLocation sharedInstance];
    location.locationService.allowsBackgroundLocationUpdates=isAllows;
})

/**
 *在将要启动定位时，会调用此函数
 */
-(void)willStartLocatingUser{
    [self.bridge.eventDispatcher sendAppEventWithName:WillStartLocatingUser body:@{}];
}

/**
 *在停止定位后，会调用此函数
 */
-(void)didStopLocatingUser{
    [self.bridge.eventDispatcher sendAppEventWithName:DidStopLocatingUser body:@{}];
}

/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
-(void)didUpdateUserHeading:(BMKUserLocation *)userLocation{
    [self.bridge.eventDispatcher sendAppEventWithName:DidUpdateUserHeading body:@{}];
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
-(void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    [self.bridge.eventDispatcher sendAppEventWithName:DidUpdateBMKUserLocation body:@{}];
}

/**
 *定位失败后，会调用此函数
 *@param error 错误号
 */
-(void)didFailToLocateUserWithError:(NSError *)error{
    [self.bridge.eventDispatcher sendAppEventWithName:DidFailToLocateUserWithError body:@{@"code:":@(error.code),@"message":error.domain}];
}


@end
