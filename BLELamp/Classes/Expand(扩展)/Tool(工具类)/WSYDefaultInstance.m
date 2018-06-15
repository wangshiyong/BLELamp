//
//  WSYDefaultInstance.m
//  BLELamp
//
//  Created by 王世勇 on 2018/6/1.
//  Copyright © 2018年 王世勇. All rights reserved.
//

#import "WSYDefaultInstance.h"

@implementation WSYDefaultInstance

//+(instancetype)sharedInstance {
//    static WSYDefaultInstance *shareInfo = nil;
//    if (shareInfo == nil) {
//        shareInfo = [[WSYDefaultInstance alloc] init];
//    }
//    return shareInfo;
//}

+ (instancetype)sharedInstance {
    static WSYDefaultInstance *shareInfo = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        shareInfo = [[WSYDefaultInstance alloc] init];
    });
    
    return shareInfo;
}

- (instancetype)init {
    self = [super init];
    if (self == nil) return nil;
    return self;
}

@end
