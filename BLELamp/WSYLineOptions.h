//
//  WSYLineOptions.h
//  BLELamp
//
//  Created by 王世勇 on 2018/5/31.
//  Copyright © 2018年 王世勇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <iOS_Echarts/iOS-Echarts.h>

@interface WSYLineOptions : NSObject

+ (PYOption *)standardLineOptionWithSubtitle:(NSString *)subtitle
                               withTimeArray:(NSArray *)timeArray
                              withTotalArray:(NSArray *)totalArray
                                withEndEqual:(NSNumber *)value;

@end
