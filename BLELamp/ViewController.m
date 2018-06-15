//
//  ViewController.m
//  BLELamp
//
//  Created by 王世勇 on 2018/5/30.
//  Copyright © 2018年 王世勇. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (strong, nonatomic) NSMutableString *currentLanguage;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"21312313" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(www) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = (CGRect){100, 100, 100, 100};
    [self.view addSubview:btn];
}

- (void)www {
    [WSYUserDataTool setUserData:LanguageCode[0] forKey:CHANGE_LANGUAGE];
    [WSYLanguageTool userSelectedLanguage:LanguageCode[0]];
    [[NSNotificationCenter defaultCenter]postNotificationName:CHANGE_LANGUAGE_NOTICE object:nil];
    NSLog(@"213123");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
