//
//  WSYDevicesCell.m
//  BLELamp
//
//  Created by 王世勇 on 2018/5/30.
//  Copyright © 2018年 王世勇. All rights reserved.
//

#import "WSYDevicesCell.h"

@implementation WSYDevicesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    selected = !selected;
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
