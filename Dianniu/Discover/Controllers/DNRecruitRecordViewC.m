//
//  DNRecruitRecordViewC.m
//  Dianniu
//
//  Created by RIMI on 2017/1/25.
//  Copyright © 2017年 Dianniu. All rights reserved.
//

#import "DNRecruitRecordViewC.h"
#import "DNMyRecruitList.h"
#import "DNApplyRecordViewC.h"

@interface DNRecruitRecordViewC ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;
@end

@implementation DNRecruitRecordViewC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = self.tableView.backgroundColor;
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDataSource

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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DNRecordCell"];
    NSString *title = self.dataSource[indexPath.row];
    cell.textLabel.text = title;
    cell.textLabel.textColor = [UIColor darkGrayColor];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIViewController *controller;
    switch (indexPath.row) {
        case 0:
        case 1:
            controller = [[DNMyRecruitList alloc] init];
            ((DNMyRecruitList *)controller).type = indexPath.row + 1;
            break;
        case 2:
            //申请记录
        case 3:
            //应聘记录
            controller = [[DNApplyRecordViewC alloc] init];
            ((DNApplyRecordViewC *)controller).type = indexPath.row == 3 ? 2 : 1;
            break;
    }
    for (UIView* next = [self.view superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]] && controller) {
            [((UIViewController*)nextResponder).navigationController pushViewController:controller animated:YES];
        }
    }
}

#pragma mark - getter
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.backgroundColor = RGBColor(241, 241, 241);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"DNRecordCell"];
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (NSArray *)dataSource{
    if (!_dataSource) {
        _dataSource = @[@"已发布的求职",@"已发布的招聘",@"申请记录",@"应聘记录"];
    }
    return _dataSource;
}


@end
