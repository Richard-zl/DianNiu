//
//  DNSettingViewC.m
//  Dianniu
//
//  Created by RIMI on 2017/1/11.
//  Copyright © 2017年 Dianniu. All rights reserved.
//

#import "DNSettingViewC.h"
#import "DNAccountSetingViewC.h"
#import "DNPrivacySettingViewC.h"
#import "DNShareSDKManager.h"
#import "DNWebViewController.h"

#define DNSettingCell @"DNSettingCell"
@interface DNSettingViewC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@end

@implementation DNSettingViewC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    [self configurSubViews];
}

- (void)configurSubViews{
    self.view.backgroundColor = RGBColor(241, 241, 241);
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return section == 0 ? 2 : 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DNSettingCell];
    NSString *title = @[@[@"账号信息",@"隐私设置"],
                        @[@"关于电钮",@"分享给好友",@"邀请好友加入",@"检测更新",@"退出账号"]][indexPath.section][indexPath.row];
    cell.textLabel.text = title;
    cell.textLabel.textColor = [UIColor darkGrayColor];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIViewController *controller;
    NSString *title = @[@[@"账号信息",@"隐私设置"],
                        @[@"关于电钮",@"分享给好友",@"邀请好友加入",@"检测更新",@"退出账号"]][indexPath.section][indexPath.row];
    if ([title isEqualToString:@"账号信息"]) {
        controller = [[DNAccountSetingViewC alloc] init];
    }else if ([title isEqualToString:@"隐私设置"]){
        controller = [[DNPrivacySettingViewC alloc] init];
    }else if ([title isEqualToString:@"关于电钮"]){
        NSString *path = [[NSBundle mainBundle].bundlePath stringByAppendingPathComponent:@"webResource/aboutDianniu.html"];
        controller = [[DNWebViewController alloc] initWithFilePath:path script:[NSString stringWithFormat:@"document.getElementsByClassName('version-title')[0].innerText = '版本：%@';",DNAppVersion]];
        controller.title = @"关于";
        
    }else if ([title isEqualToString:@"分享给好友"]){
        [[DNShareSDKManager shared] shareContentWithType:DNShareType_app content:@"加入电纽，身价百倍！" shareId:nil
    imagePath:[UIImage imageNamed:@"setting_logo_icon"] success:^(NSInteger platform) {
        [SVProgressHUD showSuccessWithStatus:@"分享成功"];
    }];
    }else if ([title isEqualToString:@"邀请好友加入"]){
        
    }else if ([title isEqualToString:@"检测更新"]){
        
    }else if ([title isEqualToString:@"退出账号"]){
        DNTextAlert(nil, @"确认退出吗？", @[@"确认",@"取消"], ^(NSInteger index) {
            if (index == 0) {
                DNEvent(kDNKeyNoticeLogout, nil);
                DNSharedDelegate.tableBarC = nil;
            }
        });
    }
    controller ? [self.navigationController pushViewController:controller animated:YES] : nil;
}

#pragma mark - getter
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = RGBColor(241, 241, 241);
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:DNSettingCell];
    }
    return _tableView;
}

@end
