//
//  WSYHeadViewCell.m
//  Albatross
//
//  Created by wangshiyong on 2017/12/15.
//  Copyright © 2017年 王世勇. All rights reserved.
//

#import "WSYHeadView.h"

@implementation WSYHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
    }
    return self;
}

#pragma mark - UI
- (void)setUpUI {
    
}

#pragma mark - 布局
- (void)layoutSubviews
{
    [super layoutSubviews];
//    @weakify(self);
//    [self.headImage mas_makeConstraints:^(MASConstraintMaker *make){
//        @strongify(self);
//        make.left.equalTo(self).offset(16);
//        make.top.equalTo(self).offset(NAV_HEIGHT);
//        make.size.mas_equalTo(CGSizeMake(60, 60));
//    }];
    
    
}

@end
