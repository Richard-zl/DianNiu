//
//  DNPrivacySettingViewC.m
//  Dianniu
//
//  Created by RIMI on 2017/1/11.
//  Copyright © 2017年 Dianniu. All rights reserved.
//

#import "DNPrivacySettingViewC.h"
#import "DNProfileModifyRequest.h"

#define DNPrivicySettingCell @"DNPrivicySettingCell"
@interface DNPrivacySettingViewC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;

@end

@implementation DNPrivacySettingViewC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"隐私设置";
    [self configurSubViews];
}

- (void)configurSubViews{
    self.view.backgroundColor = RGBColor(241, 241, 241);
    [self.view addSubview:self.tableView];
   
}

#pragma mark - private func
- (void)modifyReqeustWithType:(DNProfileModifyType)type value:(NSInteger)aValue{
    if (aValue < 0 || aValue > 1) {
        [SVProgressHUD showErrorWithStatus:@"错误的类型"];
        return;
    }
    DNProfileModifyRequest *request = [[DNProfileModifyRequest alloc] init];
    request.accountId = [DNUser sheared].userId;
    request.type      = type;
    request.value     = @(aValue);
    [SVProgressHUD showWithStatus:@"正在设置..."];
    [request httpRequest:15 success:^(NSURLSessionDataTask *sessionTask, id respondObj) {
        [SVProgressHUD dismiss];
        BOOL temp = !aValue;
        if (type == DNProfileModifyType_BeFirend) {
            [DNUser sheared].canAddfriend = temp;
        }else{
            [DNUser sheared].allowviewpro = temp;
        }
        [[DNUser sheared] dump];
        [self.tableView reloadData];
    } failed:^(NSURLSessionDataTask *sessionTask, NSError *error) {
        
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DNPrivicySettingCell];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:DNPrivicySettingCell];
    }
    NSString *privcyStr = [DNUser sheared].allowviewpro ? @"所有人可见":@"好友可见";
    NSString *frendStr  = [DNUser sheared].canAddfriend ? @"所有人":@"不允许加为好友";
    NSString *title = @[@"谁可以看我资料",@"谁可以加我好友"][indexPath.row];
    NSString *value = @[privcyStr,frendStr][indexPath.row];
    cell.textLabel.text = title;
    cell.detailTextLabel.text = value;
    cell.textLabel.textColor = [UIColor darkGrayColor];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.detailTextLabel.textColor = DNThemeColor;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DNProfileModifyType type;
    NSString *firstTitle, *secondTitle;
    if (indexPath.row == 0) {
        type = DNProfileModifyType_DataPrivacy;
        firstTitle = @"所有人可见";
        secondTitle = @"好友可见";
    }else{
        type = DNProfileModifyType_BeFirend;
        firstTitle = @"所有人";
        secondTitle = @"不允许加为好友";
    }
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:firstTitle,secondTitle, nil];
    [actionSheet bk_setWillDismissBlock:^(UIActionSheet *sheet, NSInteger index) {
        if ([sheet cancelButtonIndex] != index) {
            [self modifyReqeustWithType:type value:index];
        }
    }];
    [actionSheet showInView:self.view];
}

#pragma mark - getter
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = RGBColor(241, 241, 241);
    }
    return _tableView;
}
@end
