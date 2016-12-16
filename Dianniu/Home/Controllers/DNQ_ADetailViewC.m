//
//  DNQ_ADetailViewC.m
//  Dianniu
//
//  Created by RIMI on 2016/12/14.
//  Copyright © 2016年 Dianniu. All rights reserved.
//

#import "DNQ_ADetailViewC.h"
#import "DNQ_ADetailHederView.h"
#import "DNAnswerCell.h"
#import "DNAnswerViewModel.h"

@interface DNQ_ADetailViewC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<DNAnswerViewModel *>* dataSource;
@end

@implementation DNQ_ADetailViewC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configurSubViews];
}

- (void)configurSubViews{
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self configurTableView];
    [self configurMjrefresh];
}

- (void)configurTableView{
   __block DNQ_ADetailHederView *hederView = [[[NSBundle mainBundle] loadNibNamed:@"DNQ_ADetailHederView" owner:nil options:nil] firstObject];
    hederView.type = self.type;
    hederView.model = self.q_aModel;
    [self.tableView setTableHeaderView:hederView];
    self.tableView.estimatedRowHeight = 80.0;
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] init];
}

- (void)configurMjrefresh{
    DNAnswerListRequest *request = [[DNAnswerListRequest alloc] init];
    request.accountId = self.q_aModel.q_aModel.accountId;
    request.questId   = self.q_aModel.q_aModel.q_aId;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        request.page = 0;
        [request httpRequest:15 success:^(NSURLSessionDataTask *sessionTask, id respondObj) {
            [self.tableView.mj_header endRefreshing];
            [self.dataSource removeAllObjects];
            NSArray *listArray = respondObj[@"list"];
            if (listArray.count != 20) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self.tableView.mj_footer resetNoMoreData];
            }
            for (NSDictionary *dict in listArray) {
                DNAnswerViewModel *viewModel = [[DNAnswerViewModel alloc] initWhitDictionary:dict];
                [self.dataSource addObject:viewModel];
            }
            [self.tableView reloadData];
        } failed:^(NSURLSessionDataTask *sessionTask, NSError *error) {
            //基类已经做了处理
            [self.tableView.mj_header endRefreshing];
        }];
    }];
    
    [self.tableView.mj_header beginRefreshing];
    ((MJRefreshNormalHeader *)self.tableView.mj_header).lastUpdatedTimeLabel.hidden = YES;
    ((MJRefreshNormalHeader *)self.tableView.mj_header).stateLabel.hidden = YES;
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        request.page = self.dataSource.count;
        [request httpRequest:15 success:^(NSURLSessionDataTask *sessionTask, id respondObj) {
            [self.tableView.mj_header endRefreshing];
            NSArray *listArray = respondObj[@"list"];
            if (listArray.count == 20) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self.tableView.mj_footer resetNoMoreData];
            }
            for (NSDictionary *dict in listArray) {
                DNAnswerViewModel *viewModel = [[DNAnswerViewModel alloc] initWhitDictionary:dict];
                [self.dataSource addObject:viewModel];
            }
            [self.tableView reloadData];
        } failed:^(NSURLSessionDataTask *sessionTask, NSError *error) {
            //基类已经做了处理
            [self.tableView.mj_header endRefreshing];
        }];
    }];
    [((MJRefreshNormalHeader *)self.tableView.mj_footer) setTitle:@"" forState:MJRefreshStateNoMoreData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DNAnswerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DNAnswerCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([DNAnswerCell class]) owner:nil options:nil] firstObject];
    }
    cell.viewModel = self.dataSource[indexPath.row];
    return cell;
}

#pragma mark - getter and setter
- (NSMutableArray<DNAnswerViewModel *> *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end
