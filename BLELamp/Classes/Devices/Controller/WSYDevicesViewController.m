//
//  WSYDevicesViewController.m
//  BLELamp
//
//  Created by 王世勇 on 2018/5/30.
//  Copyright © 2018年 王世勇. All rights reserved.
//

#import "WSYDevicesViewController.h"
#import "WSYTabBarControllerConfig.h"
#import "WSYDevicesCell.h"
#import "WSYDefaultInstance.h"

@interface WSYDevicesViewController (){
    NSMutableArray *peripheralDataArray;
    BabyBluetooth *baby;
}

@property (strong, nonatomic) NSMutableString *currentLanguage;
@property (strong, nonatomic) NSMutableDictionary *mutableDic;
@property (assign, nonatomic) NSIndexPath *selIndex;
@property (copy, nonatomic) NSString *str;
@property (nonatomic, getter=isLoading) BOOL loading;

@end

@implementation WSYDevicesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = WSY(@"Orphek Atlantic");
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:WSY(@"Language") style:UIBarButtonItemStylePlain target:self action:@selector(changeLanguage)];
    _currentLanguage = [[WSYLanguageTool currentLanguageCode] mutableCopy];
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    peripheralDataArray = [[NSMutableArray alloc]init];
    
    //初始化BabyBluetooth 蓝牙库
    baby = [BabyBluetooth shareBabyBluetooth];
    //设置蓝牙委托
    [self babyDelegate];

    self.mutableDic = [[NSMutableDictionary alloc]init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    NSLog(@"viewDidAppear");
    //停止之前的连接
    [baby cancelAllPeripheralsConnection];
    //设置委托后直接可以使用，无需等待CBCentralManagerStatePoweredOn状态。
    baby.scanForPeripherals().begin();
    //    baby.scanForPeripherals().begin().stop(10);
}

- (void)changeLanguage {
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
    if ([self.currentLanguage isEqualToString:LanguageCode[0]]) {
        [alert addButton:@"中文" actionBlock:^(void) {
            [WSYUserDataTool setUserData:LanguageCode[1] forKey:CHANGE_LANGUAGE];
            [WSYLanguageTool userSelectedLanguage:LanguageCode[1]];
            [[NSNotificationCenter defaultCenter]postNotificationName:CHANGE_LANGUAGE_NOTICE object:nil];
        }];
    } else {
        [alert addButton:@"English" actionBlock:^(void) {
            [WSYUserDataTool setUserData:LanguageCode[0] forKey:CHANGE_LANGUAGE];
            [WSYLanguageTool userSelectedLanguage:LanguageCode[0]];
            [[NSNotificationCenter defaultCenter]postNotificationName:CHANGE_LANGUAGE_NOTICE object:nil];
        }];
    }
    alert.completeButtonFormatBlock = ^NSDictionary* (void) {
        NSMutableDictionary *buttonConfig = [[NSMutableDictionary alloc] init];
        buttonConfig[@"backgroundColor"] = [UIColor lightGrayColor];
        return buttonConfig;
    };
    [alert showCustom:[UIImage imageNamed:@"S_language"] color:[UIColor redColor] title:WSY(@"Language") subTitle:nil closeButtonTitle:WSY(@"Cancel") duration:0.0f];
}

//蓝牙网关初始化和委托方法设置
-(void)babyDelegate{
    
    __weak typeof(self) weakSelf = self;
    [baby setBlockOnCentralManagerDidUpdateState:^(CBCentralManager *central) {
        if (central.state == CBCentralManagerStatePoweredOn) {
//            [SVProgressHUD showInfoWithStatus:@"设备打开成功，开始扫描设备"];
        }
    }];
    
    //设置扫描到设备的委托
    [baby setBlockOnDiscoverToPeripherals:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
        
        NSLog(@"搜索到了设备:%@ %@",peripheral.name, RSSI);
        [weakSelf insertTableView:peripheral advertisementData:advertisementData RSSI:RSSI];
    }];
    
    
    //设置查找设备的过滤器
    [baby setFilterOnDiscoverPeripherals:^BOOL(NSString *peripheralName, NSDictionary *advertisementData, NSNumber *RSSI) {
        
        //最常用的场景是查找某一个前缀开头的设备
        //        if ([peripheralName hasPrefix:@"Pxxxx"] ) {
        //            return YES;
        //        }
        //        return NO;
        //设置查找规则是名称大于0 ， the search rule is peripheral.name length > 0
        if (peripheralName.length > 0) {
            return YES;
        }
        return NO;
    }];
    
    
    [baby setBlockOnCancelAllPeripheralsConnectionBlock:^(CBCentralManager *centralManager) {
        NSLog(@"setBlockOnCancelAllPeripheralsConnectionBlock");
    }];
    
    [baby setBlockOnCancelScanBlock:^(CBCentralManager *centralManager) {
        NSLog(@"setBlockOnCancelScanBlock");
    }];
    
    
    //示例:
    //扫描选项->CBCentralManagerScanOptionAllowDuplicatesKey:忽略同一个Peripheral端的多个发现事件被聚合成一个发现事件
    NSDictionary *scanForPeripheralsWithOptions = @{CBCentralManagerScanOptionAllowDuplicatesKey:@YES};
    //连接设备->
    [baby setBabyOptionsWithScanForPeripheralsWithOptions:scanForPeripheralsWithOptions connectPeripheralWithOptions:nil scanForPeripheralsWithServices:nil discoverWithServices:nil discoverWithCharacteristics:nil];
    
    
}

#pragma mark -UIViewController 方法
//插入table数据
-(void)insertTableView:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI{
    
    NSArray *peripherals = [peripheralDataArray valueForKey:@"peripheral"];
    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:peripherals.count inSection:0];
    if(![peripherals containsObject:peripheral]) {
        //        NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
        //        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:peripherals.count inSection:0];
        [indexPaths addObject:indexPath];

        NSMutableDictionary *item = [[NSMutableDictionary alloc] init];
        [item setValue:peripheral forKey:@"peripheral"];
        [item setValue:RSSI forKey:@"RSSI"];
        [item setValue:advertisementData forKey:@"advertisementData"];
        [peripheralDataArray addObject:item];

        [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    }

    if([peripherals containsObject:peripheral]) {
//        //        NSLog(@"%ld====",(long)indexPath.row);
        NSMutableDictionary *item = [peripheralDataArray objectAtIndex:indexPath.row - 1];
        if (RSSI != [item objectForKey:@"RSSI"]) {
            [item setValue:RSSI forKey:@"RSSI"];
        }
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        for (int i = 0; i < indexPath.row; i ++) {
            [dic setValue:RSSI forKey:[NSString stringWithFormat:@"%d",i]];
            [self.mutableDic addEntriesFromDictionary:dic];
            //        [[NSNotificationCenter defaultCenter]postNotificationName:@"1" object:nil];
            NSLog(@"%@====",self.mutableDic);
        }
//        [dic setValue:RSSI forKey:[NSString stringWithFormat:@"%ld",indexPath.row - 1]];
//        [self.mutableDic addEntriesFromDictionary:dic];
////        [[NSNotificationCenter defaultCenter]postNotificationName:@"1" object:nil];
//        NSLog(@"%@====",self.mutableDic);
    }
}


#pragma mark ==========Table view data source==========

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return peripheralDataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell"];
    NSDictionary *item = [peripheralDataArray objectAtIndex:indexPath.row];
    CBPeripheral *peripheral = [item objectForKey:@"peripheral"];
    NSDictionary *advertisementData = [item objectForKey:@"advertisementData"];
    NSNumber *RSSI = [item objectForKey:@"RSSI"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    if (_selIndex == indexPath) {
        cell.selectionStyle = UITableViewCellAccessoryCheckmark;
    } else {
        cell.selectionStyle = UITableViewCellAccessoryNone;
    }
    
    
    //peripheral的显示名称,优先用kCBAdvDataLocalName的定义，若没有再使用peripheral name
    NSString *peripheralName;
    if ([advertisementData objectForKey:@"kCBAdvDataLocalName"]) {
        peripheralName = [NSString stringWithFormat:@"%@",[advertisementData objectForKey:@"kCBAdvDataLocalName"]];
    }else if(!([peripheral.name isEqualToString:@""] || peripheral.name == nil)){
        peripheralName = peripheral.name;
    }else{
        peripheralName = [peripheral.identifier UUIDString];
    }

    cell.textLabel.text = peripheralName;
    //信号和服务
    cell.detailTextLabel.text = [NSString stringWithFormat:@"RSSI:%@",RSSI];
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"1" object:nil]subscribeNext:^(NSNotification *notice){
        for (int i = 0;i < indexPath.row + 1; i++) {
//            [self.mutableDic objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]]
            cell.detailTextLabel.text = [NSString stringWithFormat:@"RRSI:%@",[self.mutableDic objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]]];
        }

        
    }];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //停止扫描
    [baby cancelScan];
    [WSYUserDataTool setUserData:@"wwww" forKey:@"qqq"];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *celled = [tableView cellForRowAtIndexPath:_selIndex];
    celled.accessoryType = UITableViewCellAccessoryNone;
    //记录当前选中的位置索引
    _selIndex = indexPath;
    //当前选择的打勾
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    
//    PeripheralViewController *vc = [[PeripheralViewController alloc]init];
    NSDictionary *item = [peripheralDataArray objectAtIndex:indexPath.row];
    CBPeripheral *peripheral = [item objectForKey:@"peripheral"];
    [WSYDefaultInstance sharedInstance].currPeripheral = peripheral;
    [WSYDefaultInstance sharedInstance].baby = baby;
}

@end
