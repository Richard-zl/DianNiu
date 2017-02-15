//
//  DNMyQuestingViewC.m
//  Dianniu
//
//  Created by RIMI on 2017/1/19.
//  Copyright © 2017年 Dianniu. All rights reserved.
//

#import "DNMyQuestingViewC.h"
#import "DNCollectCell.h"
#import "DNDianniuQ_AViewModel.h"
#import <MJRefresh.h>
#import "DNHomeListRequestModel.h"
#import "DNQ_ADetailViewC.h"

@interface DNMyQuestingViewC ()
@property (nonatomic, strong) NSMutableArray<DNDianniuQ_AViewModel *> *dataSource;

@end

@implementation DNMyQuestingViewC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的问题";
    [self configTableView];
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - private
- (void)configTableView{
    self.tableView.estimatedRowHeight = 45.0;
    self.tableView.backgroundColor = RGBColor(241, 241, 241);
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerNib:[UINib nibWithNibName:@"DNCollectCell" bundle:nil] forCellReuseIdentifier:@"DNMyCollectCell"];
    [self configurMjrefresh];
}

- (void)configurMjrefresh{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        ((MJRefreshNormalHeader *)self.tableView.mj_header).lastUpdatedTimeLabel.hidden = YES;
        // 隐藏状态
        ((MJRefreshNormalHeader *)self.tableView.mj_header).stateLabel.hidden = YES;
        [self myQuestingRequest:YES];
        
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        NSInteger page = self.dataSource.count;
        if (page % 20 == 0) {
            //还可以请求数据
            [self myQuestingRequest:NO];
        }else{
            //没有数据了
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
}

- (void)myQuestingRequest:(BOOL)isPull{
    DNHomeListRequestModel *request = [[DNHomeListRequestModel alloc] init];
    request.accountId = [DNUser sheared].userId;
    request.page      = isPull ? @(0) : @(self.dataSource.count);
    request.counts    = @(20);
    request.type      = DNHomeListType_My;
    [request httpRequest:15 success:^(NSURLSessionDataTask *sessionTask, id respondObj) {
        if (isPull) {
            [self.dataSource removeAllObjects];
            [self.tableView.mj_header endRefreshing];
        }else{
            [self.tableView.mj_footer endRefreshing];
        }
        if ([respondObj count] < 20) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        for (NSDictionary *dataDict in respondObj) {
            DNDianniuQ_AModel *model = [DNDianniuQ_AModel modelWithQ_ADictionary:dataDict];
            DNDianniuQ_AViewModel *viewModel = [[DNDianniuQ_AViewModel alloc] initWithQ_AModel:model];
            [self.dataSource addObject:viewModel];
        }
        [self.tableView reloadData];
    } failed:^(NSURLSessionDataTask *sessionTask, NSError *error) {
        if (isPull) {
            [self.tableView.mj_header endRefreshing];
        }else{
            [self.tableView.mj_footer endRefreshing];
        }
    }];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < self.dataSource.count) {
        return self.dataSource[indexPath.row].cellHeight;
    }else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DNCollectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DNMyCollectCell" forIndexPath:indexPath];
    cell.viewModel = self.dataSource[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row < self.dataSource.count) {
        DNQ_ADetailViewC *detailC = [[DNQ_ADetailViewC alloc] init];
        detailC.q_aModel = self.dataSource[indexPath.row];
        detailC.title = @"查看问答";
        detailC.type  = DNHomeListType_questions;
        [self.navigationController pushViewController:detailC animated:YES];
    }
}

#pragma mark - getter
- (NSMutableArray<DNDianniuQ_AViewModel *> *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end
