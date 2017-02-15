//
//  DNAboutMeViewC.m
//  Dianniu
//
//  Created by RIMI on 2017/1/12.
//  Copyright © 2017年 Dianniu. All rights reserved.
//

#import "DNAboutMeViewC.h"
#import "DNMyQuestingViewC.h"
#import "DNMyAnswerViewC.h"
#import "DNBlacklistViewC.h"

#define DNAboutMeViewCell @"DNAboutMeViewCell"
@interface DNAboutMeViewC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation DNAboutMeViewC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"与我相关";
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
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DNAboutMeViewCell];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:DNAboutMeViewCell];
    }
    NSString *title = @[@"我的问题",@"我的回答",@"我的屏蔽",@"我的黑名单"][indexPath.row];
    cell.textLabel.text = title;
    cell.textLabel.textColor = UIColorFromRGB(0x383838);
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIViewController *viewController;
    switch (indexPath.row) {
        case 0:
            viewController = [[DNMyQuestingViewC alloc] init];
            break;
        case 1:
            viewController = [[DNMyAnswerViewC alloc] init];
            break;
        case 2:
        case 3:
            viewController = [[DNBlacklistViewC alloc] init];
            ((DNBlacklistViewC *)viewController).listType = indexPath.row == 2 ? DNRequestListType_Shield : DNRequestListType_Blacklist;
            break;
    }
    viewController ? [self.navigationController pushViewController:viewController animated:YES] : nil;
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
