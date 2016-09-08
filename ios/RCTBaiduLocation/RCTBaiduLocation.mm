//
//  RCTBaiduLocation.m
//  RCTBaiduLocation
//
//  Created by user on 16/9/8.
//  Copyright © 2016年 baj. All rights reserved.
//

#import "RCTBaiduLocation.h"
#import "BMKLocationService.h"
@implementation RCTBaiduLocation
@synthesize bridge = _bridge;
RCT_EXPORT_MODULE()

+ (instancetype)sharedInstance {
    static RCTBaiduLocation *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(_instance == nil) {
            _instance = [[self alloc] init];
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
@end
