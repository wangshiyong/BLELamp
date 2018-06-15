//
//  Macros.h
//  Albatross
//
//  Created by wangshiyong on 2017/11/27.
//  Copyright © 2017年 王世勇. All rights reserved.
//

#ifndef Macros_h
#define Macros_h

/** 屏幕高度 */
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
/** 屏幕宽度 */
#define kScreenWidth [UIScreen mainScreen].bounds.size.width

#define NAV_HEIGHT (iphoneX ? 88 : 64)
#define TABBAR_HEIGHT (iphoneX ? 83 : 49)

/*****************  屏幕适配  ******************/
#define iphone5 (kScreenHeight == 568)
#define iphoneX (kScreenHeight == 812)


/** RGB颜色(16进制) */
#define WSYColor_HEX(rgbValue, a) \
[UIColor colorWithRed:((CGFloat)((rgbValue & 0xFF0000) >> 16)) / 255.0 \
green:((CGFloat)((rgbValue & 0xFF00) >> 8)) / 255.0 \
blue:((CGFloat)(rgbValue & 0xFF)) / 255.0 alpha:(a)]

#define WSYColor(r,g,b) [UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:1.0]
#define WSYTheme_Color  [UIColor colorWithRed:48.0/255.0 green:55.0/255.0 blue:88.0/255.0 alpha:1.0]
#define WSYSubTheme_Color  [UIColor colorWithRed:70.0/255.0 green:76.0/255.0 blue:111.0/255.0 alpha:1.0]

#endif /* Macros_h */
