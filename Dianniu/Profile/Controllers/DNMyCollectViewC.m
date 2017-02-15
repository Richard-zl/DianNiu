//
//  DNMyCollectViewC.m
//  Dianniu
//
//  Created by RIMI on 2017/1/12.
//  Copyright © 2017年 Dianniu. All rights reserved.
//

#import "DNMyCollectViewC.h"
#import "DNCollectCell.h"
#import "DNCollectListRequest.h"
#import <MJRefresh.h>
#import "DNDianniuQ_AViewModel.h"
#import "DNQ_ADetailViewC.h"

#define DNMyCollectCell @"DNMyCollectCell"
@interface DNMyCollectViewC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) NSMutableArray<DNDianniuQ_AViewModel *> *dataSource;
@end

@implementation DNMyCollectViewC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的收藏";
    self.view.backgroundColor = RGBColor(241, 241, 241);
    [self configurSubViews];
}
#pragma mark - UI methoed
- (void)configurSubViews{
    [self.view addSubview:self.tableview];
    [self.tableview registerNib:[UINib nibWithNibName:@"DNCollectCell" bundle:nil] forCellReuseIdentifier:DNMyCollectCell];
    self.tableview.estimatedRowHeight = 60.0;
    [self configurMjrefresh];
    [self.tableview.mj_header beginRefreshing];
}

- (void)configurMjrefresh{
    self.tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        ((MJRefreshNormalHeader *)self.tableview.mj_header).lastUpdatedTimeLabel.hidden = YES;
        // 隐藏状态
        ((MJRefreshNormalHeader *)self.tableview.mj_header).stateLabel.hidden = YES;
        [self requestCollect:YES];
    
    }];
    self.tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        NSInteger page = self.dataSource.count;
        if (page % 20 == 0) {
            //还可以请求数据
            [self requestCollect:NO];
        }else{
            //没有数据了
            [self.tableview.mj_footer endRefreshingWithNoMoreData];
        }
    }];
}

#pragma mark private func
- (void)requestCollect:(BOOL)isPull{
    DNCollectListRequest *request = [[DNCollectListRequest alloc] init];
    request.accountId = [DNUser sheared].userId;
    request.page = isPull ? 0 : self.dataSource.count;
    [request httpRequest:15 success:^(NSURLSessionDataTask *sessionTask, id respondObj) {
        if (isPull) {
            [self.dataSource removeAllObjects];
            [self.tableview.mj_header endRefreshing];
        }else{
            [self.tableview.mj_footer endRefreshing];
        }
        if ([respondObj count] < 20) {
            [self.tableview.mj_footer endRefreshingWithNoMoreData];
        }
        for (NSDictionary *dataDict in respondObj) {
            DNDianniuQ_AModel *model = [DNDianniuQ_AModel modelWithQ_ADictionary:dataDict];
            DNDianniuQ_AViewModel *viewModel = [[DNDianniuQ_AViewModel alloc] initWithQ_AModel:model];
            [self.dataSource addObject:viewModel];
        }
        [self.tableview reloadData];
    } failed:^(NSURLSessionDataTask *sessionTask, NSError *error) {
        if (isPull) {
            [self.tableview.mj_header endRefreshing];
        }else{
            [self.tableview.mj_footer endRefreshing];
        }
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < self.dataSource.count) {
        return self.dataSource[indexPath.row].cellHeight;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DNCollectCell *cell = [tableView dequeueReusableCellWithIdentifier:DNMyCollectCell forIndexPath:indexPath];
    if (indexPath.row < self.dataSource.count) {
        cell.viewModel = self.dataSource[indexPath.row];
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DNQ_ADetailViewC *detailC = [[DNQ_ADetailViewC alloc] initWithNibName:@"DNQ_ADetailViewC" bundle:nil];
    detailC.type = DNHomeListType_questions;
    detailC.q_aModel = self.dataSource[indexPath.row];
    detailC.title = @"查看问答";
    [self.navigationController pushViewController:detailC animated:YES];
}

#pragma mark - getter
- (UITableView *)tableview{
    if (!_tableview) {
        _tableview = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableview.tableFooterView = [UIView new];
        _tableview.backgroundColor = RGBColor(241, 241, 241);
        _tableview.delegate = self;
        _tableview.dataSource = self;
    }
    return _tableview;
}

- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}


@end
