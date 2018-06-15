//
//  WSYDefaultInstance.h
//  BLELamp
//
//  Created by 王世勇 on 2018/6/1.
//  Copyright © 2018年 王世勇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WSYDefaultInstance : NSObject

@property(strong,nonatomic) CBPeripheral *currPeripheral;
@property(strong,nonatomic) BabyBluetooth *baby;

+(instancetype)sharedInstance;

@end
