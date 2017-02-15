//
//  DNAccountSetingViewC.m
//  Dianniu
//
//  Created by RIMI on 2017/1/11.
//  Copyright © 2017年 Dianniu. All rights reserved.
//

#import "DNAccountSetingViewC.h"

#define DNAccountSetingCell @"DNAccountSetingCell"
@interface DNAccountSetingViewC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;

@end

@implementation DNAccountSetingViewC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"账号信息";
    [self configurSubViews];
}

- (void)configurSubViews{
    self.view.backgroundColor = RGBColor(241, 241, 241);
    [self.view addSubview:self.tableView];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DNAccountSetingCell];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:DNAccountSetingCell];
    }
    NSString *title = @[@"手机号",@"电钮密码"][indexPath.row];
    NSString *value = @[[DNUser sheared].mobile.description,@"已设置"][indexPath.row];
    cell.textLabel.text = title;
    cell.detailTextLabel.text = value;
    cell.textLabel.textColor = [UIColor darkGrayColor];
    if (indexPath.row == 1) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.detailTextLabel.textColor = DNThemeColor;
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 1) {
        //忘记密码
#warning 需要跳转到忘记密码页面
    }
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
