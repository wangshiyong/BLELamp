//
//  AppDelegate.m
//  BLELamp
//
//  Created by 王世勇 on 2018/5/30.
//  Copyright © 2018年 王世勇. All rights reserved.
//

#import "AppDelegate.h"
#import "WSYTabBarControllerConfig.h"

@interface AppDelegate ()<UITabBarControllerDelegate, CYLTabBarControllerDelegate>

@property (strong, nonatomic) NSMutableString *currentLanguage;

@end

@implementation AppDelegate

#define RANDOM_COLOR [UIColor colorWithHue: (arc4random() % 256 / 256.0) saturation:((arc4random()% 128 / 256.0 ) + 0.5) brightness:(( arc4random() % 128 / 256.0 ) + 0.5) alpha:1]

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self setUpLanguage];
    [self setUpRootVC];
    [self setUpFixiOS11];
    
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:CHANGE_LANGUAGE_NOTICE object:nil]subscribeNext:^(id x){
        self.window.rootViewController = nil;
        [self.window resignKeyWindow];
        [self.window removeFromSuperview];
        [self setUpRootVC];
    }];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark ==========设置获取语言==========

- (void)setUpLanguage {
    if ([[WSYUserDataTool getUserData:CHANGE_LANGUAGE] isEqualToString:LanguageCode[1]]) {
        [WSYLanguageTool userSelectedLanguage:LanguageCode[1]];
    } else if ([[WSYUserDataTool getUserData:CHANGE_LANGUAGE] isEqualToString:LanguageCode[0]]) {
        [WSYLanguageTool userSelectedLanguage:LanguageCode[0]];
    } else {
        //获取切换语言
        _currentLanguage = [[WSYLanguageTool currentLanguageCode] mutableCopy];
        NSLog(@"%@=====",_currentLanguage);
    }
}

#pragma mark ==========适配==========

- (void)setUpFixiOS11 {
    if (@available(ios 11.0,*)) {
        UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        UITableView.appearance.estimatedRowHeight = 0;
        UITableView.appearance.estimatedSectionFooterHeight = 0;
        UITableView.appearance.estimatedSectionHeaderHeight = 0;
        UITableView.appearance.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    }
}

#pragma mark ==========根控制器==========

- (void)setUpRootVC {
    self.window = [[UIWindow alloc]init];
    self.window.frame = [UIScreen mainScreen].bounds;
    //    [CYLPlusButtonSubclass registerPlusButton];
    WSYTabBarControllerConfig *tabBarControllerConfig = [[WSYTabBarControllerConfig alloc] init];
    CYLTabBarController *tabBarController = tabBarControllerConfig.tabBarController;
    [self.window setRootViewController:tabBarController];
    
    tabBarController.delegate = self;
    [self.window makeKeyAndVisible];
    [self customizeInterfaceWithTabBarController:tabBarController];
}

- (void)customizeInterfaceWithTabBarController:(CYLTabBarController *)tabBarController {
    //设置导航栏
    [self setUpNavigationBarAppearance];
    
    [tabBarController hideTabBadgeBackgroundSeparator];
    //添加小红点
    UIViewController *viewController = tabBarController.viewControllers[0];
    UIView *tabBadgePointView0 = [UIView cyl_tabBadgePointViewWithClolor:RANDOM_COLOR radius:4.5];
    [viewController.tabBarItem.cyl_tabButton cyl_setTabBadgePointView:tabBadgePointView0];
    [viewController cyl_showTabBadgePoint];
    
    UIView *tabBadgePointView1 = [UIView cyl_tabBadgePointViewWithClolor:RANDOM_COLOR radius:4.5];
    @try {
        [tabBarController.viewControllers[1] cyl_setTabBadgePointView:tabBadgePointView1];
        [tabBarController.viewControllers[1] cyl_showTabBadgePoint];
        
        UIView *tabBadgePointView2 = [UIView cyl_tabBadgePointViewWithClolor:RANDOM_COLOR radius:4.5];
        [tabBarController.viewControllers[2] cyl_setTabBadgePointView:tabBadgePointView2];
        [tabBarController.viewControllers[2] cyl_showTabBadgePoint];
        
        [tabBarController.viewControllers[3] cyl_showTabBadgePoint];
        
        //添加提示动画，引导用户点击
        [self addScaleAnimationOnView:tabBarController.viewControllers[3].cyl_tabButton.cyl_tabImageView repeatCount:20];
    } @catch (NSException *exception) {}
}

/**
 *  设置navigationBar样式
 */
- (void)setUpNavigationBarAppearance {
//    UINavigationBar *navigationBarAppearance = [UINavigationBar appearance];
//    [navigationBarAppearance setBarTintColor:WSYTheme_Color];
//    NSDictionary *dict = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
//    [navigationBarAppearance setTitleTextAttributes:dict];
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}


#pragma mark ==========delegate==========

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
//    if ([[WSYUserDataTool getUserData:@"qqq"] isEqualToString:@"wwww"]) {
        [[self cyl_tabBarController] updateSelectionStatusIfNeededForTabBarController:tabBarController shouldSelectViewController:viewController];
        return YES;
//    }
    return NO;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectControl:(UIControl *)control {
    UIView *animationView;
    
    
    if ([control cyl_isTabButton]) {
        //更改红标状态
        if ([[self cyl_tabBarController].selectedViewController cyl_isShowTabBadgePoint]) {
            [[self cyl_tabBarController].selectedViewController cyl_removeTabBadgePoint];
        } else {
            [[self cyl_tabBarController].selectedViewController cyl_showTabBadgePoint];
        }
        
        animationView = [control cyl_tabImageView];
    }
    
    // 即使 PlusButton 也添加了点击事件，点击 PlusButton 后也会触发该代理方法。
    if ([control cyl_isPlusButton]) {
        UIButton *button = CYLExternPlusButton;
        animationView = button.imageView;
    }
    
    if ([self cyl_tabBarController].selectedIndex % 2 == 0) {
        [self addScaleAnimationOnView:animationView repeatCount:1];
    } else {
        [self addRotateAnimationOnView:animationView];
    }
}

//缩放动画
- (void)addScaleAnimationOnView:(UIView *)animationView repeatCount:(float)repeatCount {
    //需要实现的帧动画，这里根据需求自定义
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"transform.scale";
    animation.values = @[@1.0,@1.3,@0.9,@1.15,@0.95,@1.02,@1.0];
    animation.duration = 1;
    animation.repeatCount = repeatCount;
    animation.calculationMode = kCAAnimationCubic;
    [animationView.layer addAnimation:animation forKey:nil];
}

//旋转动画
- (void)addRotateAnimationOnView:(UIView *)animationView {
    // 针对旋转动画，需要将旋转轴向屏幕外侧平移，最大图片宽度的一半
    // 否则背景与按钮图片处于同一层次，当按钮图片旋转时，转轴就在背景图上，动画时会有一部分在背景图之下。
    // 动画结束后复位
    animationView.layer.zPosition = 65.f / 2;
    [UIView animateWithDuration:0.32 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        animationView.layer.transform = CATransform3DMakeRotation(M_PI, 0, 1, 0);
    } completion:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.70 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0.2 options:UIViewAnimationOptionCurveEaseOut animations:^{
            animationView.layer.transform = CATransform3DMakeRotation(2 * M_PI, 0, 1, 0);
        } completion:nil];
    });
}

@end
