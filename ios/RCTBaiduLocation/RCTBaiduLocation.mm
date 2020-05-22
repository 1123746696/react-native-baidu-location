
//  RCTBaiduLocation.m
//  RCTBaiduLocation
//
//  Created by user on 16/9/8.
//  Copyright © 2016年 baj. All rights reserved.
//

#import "RCTBaiduLocation.h"
#import "RCTEventDispatcher.h"
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <CoreLocation/CoreLocation.h>
static NSString * const DidStopLocatingUser = @"DidStopLocatingUser";
static NSString * const DidUpdateBMKUserLocation = @"DidUpdateBMKUserLocation";
static NSString * const DidFailToLocateUserWithError = @"DidFailToLocateUserWithError";
static RCTBaiduLocation *_instance = nil;


@interface RCTBaiduLocation()<BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate, CLLocationManagerDelegate>
@property(nonatomic,strong)BMKLocationService *locationService;
@property(nonatomic,strong)BMKGeoCodeSearch *geocodeSearch;
/** 定位管理者 */
@property (nonatomic, strong) CLLocationManager * locationManager;
@end
@implementation RCTBaiduLocation
@synthesize bridge = _bridge;
RCT_EXPORT_MODULE()

+ (instancetype)sharedInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(_instance == nil) {
            _instance = [[self alloc] init];
//            _instance.locationService=[[BMKLocationService alloc]init];
//            _instance.locationService.delegate=_instance;
//            _instance.geocodeSearch=[[BMKGeoCodeSearch alloc]init];
//            _instance.geocodeSearch.delegate=_instance;
                        _instance.locationManager = [[CLLocationManager alloc] init];
                        /** 导航类型 */
                        _instance.locationManager.activityType = CLActivityTypeFitness;
                        /** 设置代理, 非常关键 */
                        _instance.locationManager.delegate = _instance;
                        /** 想要定位的精确度, kCLLocationAccuracyBest:最好的 */
                        _instance.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
                        /** 获取用户的版本号 */
            //            if([[UIDevice currentDevice].systemVersion floatValue] >= 8.0){
                            [_instance.locationManager requestAlwaysAuthorization];
            
        }
    });
    return _instance;
}
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(_instance == nil) {
            _instance = [super allocWithZone:zone];
//            _instance.locationService=[[BMKLocationService alloc]init];
//            _instance.locationService.delegate=_instance;
            _instance.locationManager = [[CLLocationManager alloc] init];
            /** 导航类型 */
            _instance.locationManager.activityType = CLActivityTypeFitness;
            /** 设置代理, 非常关键 */
            _instance.locationManager.delegate = _instance;
            /** 想要定位的精确度, kCLLocationAccuracyBest:最好的 */
            _instance.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            /** 获取用户的版本号 */
//            if([[UIDevice currentDevice].systemVersion floatValue] >= 8.0){
            [_instance.locationManager requestAlwaysAuthorization];
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
    NSLog(@"开始定位：%@",@"嘻嘻嘻嘻嘻嘻");
    RCTBaiduLocation *location = [RCTBaiduLocation sharedInstance];
//    location.locationService.distanceFilter=5;
//    location.locationService.desiredAccuracy=kCLLocationAccuracyBest;
//    location.locationService.pausesLocationUpdatesAutomatically=YES;
//    location.locationService.allowsBackgroundLocationUpdates=false;
//    NSLog(@"开始定位：%@",@"嘻嘻嘻嘻嘻嘻");
//    if(!location.geocodeSearch){
//        location.geocodeSearch=[[BMKGeoCodeSearch alloc]init];
//        location.geocodeSearch.delegate=location;
//    }
//    [location.locationService startUserLocationService];
//
//    NSLog(@"开始定位：%@",@"");
    
    if([CLLocationManager locationServicesEnabled]) {
    //        多次定位
//            [location.locationManager startUpdatingLocation];
    //        只定位一次
            [location.locationManager requestLocation];
        } else {
            NSLog(@"不能定位呀");
        }
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
    //    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];//初始化反编码请求
    //    reverseGeocodeSearchOption.reverseGeoPoint = userLocation.location.coordinate;//设置反编码
    //    BOOL flag = [self.geocodeSearch reverseGeoCode:reverseGeocodeSearchOption];//发送反编码请求.并返回是否成功
    //    if(!flag)
    //    {
    //        [self.bridge.eventDispatcher sendAppEventWithName:DidFailToLocateUserWithError body:@{@"code:":@(-1),@"message":@"位置反解析失败"}];
    //    }
    
    [self reverseGeocodeLocation: userLocation.location];
    
}

-(void)locationManager:(nonnull CLLocationManager *)manager didUpdateLocations:(nonnull NSArray<CLLocation *> *)locations
{
      CLLocation *location = locations.lastObject;
    NSString* latitude = [NSString stringWithFormat:@"%f",location.coordinate.latitude];
    NSString* longitude = [NSString stringWithFormat:@"%f",location.coordinate.longitude];
//    NSLog(@"latitude ==", latitude);
//    NSLog(@"longitude ==", longitude);
    [self reverseGeocodeLocation: location];
    [manager stopUpdatingLocation];
}

/**
*原生定位
*用户位置更新后，会调用此函数
*@param userLocation 新的用户位置
*/
- (void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    [manager stopUpdatingLocation];
//      CLLocation *location = locations.lastObject;
//
    NSString* latitude = [NSString stringWithFormat:@"%f",newLocation.coordinate.latitude];
    NSString* longitude = [NSString stringWithFormat:@"%f",newLocation.coordinate.longitude];
//    NSLog(@"latitude ==", latitude);
//    NSLog(@"longitude ==", longitude);
    [self reverseGeocodeLocation: newLocation];
    [manager stopUpdatingLocation];
//   [self reverseGeocodeLocation: userLocation.location]; NSLog(@"位置信息维度%f,经度%f,海拔%f,方向%f,速度%fM/s,时间%@,水平精确度%f",location.coordinate.latitude,location.coordinate.longitude,location.altitude,location.course,location.speed,location.timestamp,location.horizontalAccuracy);
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
 
    NSLog(@"定位失败");
}


- (void)reverseGeocodeLocation: (CLLocation*)userLocation{
    CLGeocoder* geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:userLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if(error || placemarks.count == 0){
            NSLog(@"error = %@",error);
            [self.bridge.eventDispatcher sendAppEventWithName:DidFailToLocateUserWithError body:@{@"code:":@(-1),@"message":@"位置反解析失败"}];
        }else{
            CLPlacemark* placemark = placemarks.firstObject;
            NSDictionary* addressDictionary = [placemark addressDictionary];
            
            
            NSString* province = [addressDictionary objectForKey:@"State"] ? [addressDictionary objectForKey:@"State"] : [addressDictionary objectForKey:@"City"];
            
            NSString* city = [addressDictionary objectForKey:@"City"] ? [addressDictionary objectForKey:@"City"] : @"";
            NSString* district = [addressDictionary objectForKey:@"SubLocality"] ? [addressDictionary objectForKey:@"SubLocality"] : @"";
            NSString* streetName = [addressDictionary objectForKey:@"Street"] ? [addressDictionary objectForKey:@"Street"] : @"";
            NSString* streetNumber = [addressDictionary objectForKey:@"streetNumber"] ? [addressDictionary objectForKey:@"streetNumber"] : @"";
            
            NSMutableDictionary* locationDict = [NSMutableDictionary dictionary];
            [locationDict setObject:@(userLocation.coordinate.latitude) forKey:@"latitude"];
            [locationDict setObject:@(userLocation.coordinate.longitude) forKey:@"longitude"];
            [locationDict setObject:[[addressDictionary objectForKey:@"FormattedAddressLines"] componentsJoinedByString:@""] forKey:@"address"];
            [locationDict setObject:[[addressDictionary objectForKey:@"FormattedAddressLines"] componentsJoinedByString:@""] forKey:@"locationDescribe"];
            [locationDict setObject:province forKey:@"province"];
            [locationDict setObject:city forKey:@"city"];
            [locationDict setObject:district forKey:@"district"];
            [locationDict setObject:streetName forKey:@"streetName"];
            [locationDict setObject:streetNumber forKey:@"streetNumber"];
            
            [self.bridge.eventDispatcher sendAppEventWithName:DidUpdateBMKUserLocation body:locationDict];
        }
    }];
}

/**
 *定位失败后，会调用此函数
 *@param error 错误号
 */
-(void)didFailToLocateUserWithError:(NSError *)error{
    NSLog(@"定位失败：%@",error);
    [self.bridge.eventDispatcher sendAppEventWithName:DidFailToLocateUserWithError body:@{@"code:":@(error.code),@"message":error.domain}];
}

-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (error == 0) {
        NSDictionary *dic =@{@"latitude":@(result.location.latitude),
        @"longitude":@(result.location.longitude),
        @"address":result.address,
        @"locationDescribe":result.address,
        @"province":result.addressDetail.province,
        @"city":result.addressDetail.city,
        @"district":result.addressDetail.district,
        @"streetName":result.addressDetail.streetName,
        @"streetNumber":result.addressDetail.streetNumber,
    };
    NSLog(@"位置更新：%@",dic);
    [self.bridge.eventDispatcher sendAppEventWithName:DidUpdateBMKUserLocation body:dic];
}else{
    [self.bridge.eventDispatcher sendAppEventWithName:DidFailToLocateUserWithError body:@{@"code:":@(error),@"message":@"位置反解析失败"}];
}
}


+(id)shareMapManager{
    static BMKMapManager *_mapManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _mapManager = [[BMKMapManager alloc] init];
    });
    return _mapManager;
    
}

RCT_EXPORT_METHOD(start:(NSString *)key){
    BMKMapManager *_mapManager = [RCTBaiduLocation shareMapManager];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:key  generalDelegate:_mapManager];
    if (!ret) {
        NSLog(@"manager start failed!");
    }else{
        NSLog(@"map success");
    }
}

- (void)onGetNetworkState:(int)iError
{
    if (0 == iError) {
        NSLog(@"联网成功");
    }
    else{
        NSLog(@"onGetNetworkState %d",iError);
    }
    
}

- (void)onGetPermissionState:(int)iError
{
    if (0 == iError) {
        NSLog(@"授权成功");
    }
    else {
        NSLog(@"onGetPermissionState %d",iError);
    }
}


@end

