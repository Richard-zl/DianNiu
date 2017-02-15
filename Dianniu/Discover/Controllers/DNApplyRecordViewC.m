//
//  DNApplyRecordViewC.m
//  Dianniu
//
//  Created by RIMI on 2017/2/5.
//  Copyright © 2017年 Dianniu. All rights reserved.
//

#import "DNApplyRecordViewC.h"
#import <MJRefresh.h>
#import "DNApplyRecordCell.h"

@interface DNApplyRecordViewC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation DNApplyRecordViewC

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.type == DNRecruitDetailType_JOB) {
        self.title = @"我申请的招聘";
    }else{
        self.title = @"我的求职";
    }
    [self configurSubViews];
}

- (void)configurSubViews{
    self.view.backgroundColor = self.tableView.backgroundColor;
    [self.view addSubview:self.tableView];
    [self configurMjRefresh];
    [self requestWithType:self.type isRefresh:YES];
}

- (void)configurMjRefresh{
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        [self requestWithType:self.type isRefresh:NO];
    }];
}

- (void)requestWithType:(DNRecruitDetailType)type isRefresh:(BOOL)isRefresh{
    DNRecruitApplyListRequest *request = [[DNRecruitApplyListRequest alloc] init];
    request.accountId = [DNUser sheared].userId;
    request.type = self.type;
    request.page = isRefresh ? 0 : self.dataSource.count;
    [request httpRequest:15 success:^(NSURLSessionDataTask *sessionTask, id respondObj) {
        if (isRefresh) {
            [self.dataSource removeAllObjects];
        }else{
            [self.tableView.mj_footer endRefreshing];
        }
        if ([respondObj count] >= 20) {
            [self.tableView.mj_footer setState:MJRefreshStateIdle];
        }else{
            [self.tableView.mj_footer setState:MJRefreshStateNoMoreData];
        }
        for (NSDictionary *dataDict in respondObj) {
            [self.dataSource addObject:dataDict];
        }
        [self.tableView reloadData];
    } failed:^(NSURLSessionDataTask *sessionTask, NSError *error) {
        [self.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 115.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DNApplyRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DNApplyRecordCell" forIndexPath:indexPath];
    if (indexPath.row < self.dataSource.count) {
        cell.dataSource = self.dataSource[indexPath.row];
        cell.type = self.type;
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DNRecruitDetailViewC *detailC = [[DNRecruitDetailViewC alloc] init];
    detailC.type = self.type;
    detailC.requestId = self.dataSource[indexPath.row][@"businessId"];
    [self.navigationController pushViewController:detailC animated:YES];
}

#pragma mark - getter
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.backgroundColor = RGBColor(241, 241, 241);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:@"DNApplyRecordCell" bundle:nil] forCellReuseIdentifier:@"DNApplyRecordCell"];
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}


@end
