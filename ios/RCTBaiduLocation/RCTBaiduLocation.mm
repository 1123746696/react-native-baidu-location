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
static NSString * const DidStopLocatingUser = @"DidStopLocatingUser";
static NSString * const DidUpdateBMKUserLocation = @"DidUpdateBMKUserLocation";
static NSString * const DidFailToLocateUserWithError = @"DidFailToLocateUserWithError";
static RCTBaiduLocation *_instance = nil;
@interface RCTBaiduLocation()<BMKLocationServiceDelegate>
@property(nonatomic,strong)BMKLocationService *locationService;
@end
@implementation RCTBaiduLocation
@synthesize bridge = _bridge;
RCT_EXPORT_MODULE()

+ (instancetype)sharedInstance {
    
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
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(_instance == nil) {
            _instance = [super allocWithZone:zone];
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
    return methodQueue;
    
}

- (dispatch_queue_t)methodQueue {
    return [RCTBaiduLocation sharedMethodQueue];
}
- (NSDictionary<NSString *, id> *)constantsToExport {
    return @{
             DidStopLocatingUser: DidStopLocatingUser,
             DidUpdateBMKUserLocation: DidUpdateBMKUserLocation,
             DidFailToLocateUserWithError: DidFailToLocateUserWithError,
             };
}
RCT_EXPORT_METHOD(startLocation){
    RCTBaiduLocation *location = [RCTBaiduLocation sharedInstance];
    location.locationService.distanceFilter=5;
    location.locationService.desiredAccuracy=kCLLocationAccuracyBest;
    location.locationService.pausesLocationUpdatesAutomatically=YES;
    location.locationService.allowsBackgroundLocationUpdates=false;
    
    [location.locationService startUserLocationService];
    NSLog(@"开始定位：%@",@"");
}
RCT_EXPORT_METHOD(stopLocation){
    RCTBaiduLocation *location = [RCTBaiduLocation sharedInstance];
    [location.locationService stopUserLocationService];
    NSLog(@"结束定位：%@",@"");
}




RCT_EXPORT_METHOD(setDistanceFilter:(NSNumber *)distanceFilter){
    RCTBaiduLocation *location = [RCTBaiduLocation sharedInstance];
    location.locationService.distanceFilter=[distanceFilter doubleValue];
}
RCT_EXPORT_METHOD(setDesiredAccuracy:(NSNumber *)desiredAccuracy){
    RCTBaiduLocation *location = [RCTBaiduLocation sharedInstance];
    location.locationService.desiredAccuracy=[desiredAccuracy doubleValue];
}
RCT_EXPORT_METHOD(setHeadingFilter:(NSNumber *)headingFilter){
    RCTBaiduLocation *location = [RCTBaiduLocation sharedInstance];
    location.locationService.headingFilter=[headingFilter doubleValue];
}
RCT_EXPORT_METHOD(setPausesLocationUpdatesAutomatically:(BOOL)canPause){
    RCTBaiduLocation *location = [RCTBaiduLocation sharedInstance];
    location.locationService.pausesLocationUpdatesAutomatically=canPause;
}
RCT_EXPORT_METHOD(setAllowsBackgroundLocationUpdates:(BOOL)isAllows){
    RCTBaiduLocation *location = [RCTBaiduLocation sharedInstance];
    location.locationService.allowsBackgroundLocationUpdates=isAllows;
}
- (void)willStartLocatingUser{
    NSLog(@"willStartLocatingUser：%@",@"");
}

/**
 *在停止定位后，会调用此函数
 */
-(void)didStopLocatingUser{
    NSLog(@"停止定位：%@",@"");
    [self.bridge.eventDispatcher sendAppEventWithName:DidStopLocatingUser body:@{@"message":@"停止定位"}];
}
/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
-(void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    NSDictionary *dic =@{@"latitude":@(userLocation.location.coordinate.latitude),
                         @"longitude":@(userLocation.location.coordinate.longitude),
                         @"address":@"定位成功",
                         @"locationDescribe":userLocation.location.description,
                         };
    NSLog(@"位置更新：%@",dic);
    [self.bridge.eventDispatcher sendAppEventWithName:DidUpdateBMKUserLocation body:dic];
}

/**
 *定位失败后，会调用此函数
 *@param error 错误号
 */
-(void)didFailToLocateUserWithError:(NSError *)error{
    NSLog(@"定位失败：%@",error);
    [self.bridge.eventDispatcher sendAppEventWithName:DidFailToLocateUserWithError body:@{@"code:":@(error.code),@"message":error.domain}];
}


@end
