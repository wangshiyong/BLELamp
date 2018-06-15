//
//  WSYStatusViewCell.m
//  BLELamp
//
//  Created by 王世勇 on 2018/5/31.
//  Copyright © 2018年 王世勇. All rights reserved.
//

#import "WSYStatusViewCell.h"

@interface WSYStatusViewCell ()


@property (strong , nonatomic)UIView *bgView;
@property (strong , nonatomic)UIButton *itemBtn;

@end

@implementation WSYStatusViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI {
    self.backgroundColor = WSYSubTheme_Color;
//    self.bgView = [UIView new];
//    self.bgView.backgroundColor = [UIColor redColor];
//    [self addSubview:self.bgView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    @weakify(self);
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(10, 5, 0, 5));
    }];
    
}


@end
