//
//  DNNearByTableViewC.m
//  Dianniu
//
//  Created by RIMI on 2017/2/9.
//  Copyright © 2017年 Dianniu. All rights reserved.
//

#import "DNActivityTableViewC.h"
#import "DNActivityCell.h"
#import "DNActivityListRequest.h"
#import "DNActivityDetailViewC.h"
#import <MJRefresh.h>
#import "DNPhone.h"

@interface DNActivityTableViewC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)NSMutableArray *dataSource;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation DNActivityTableViewC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configurSubViews];
    [self activityListRequest:YES];
}

- (void)configurSubViews{
//    self.view.backgroundColor = RGBColor(241, 241, 241);
    self.view.height = ScreenHeight - 64 - 45;
    [self.view addSubview:self.tableView];
    [self configurMjrefresh];
    [self configurTipView];
}

- (void)configurTipView{
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, self.tableView.width, 40)];
    tipLabel.tag = DNTableViewTipLabelTag;
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.text = @"电纽圈未找到";
    tipLabel.textColor = [UIColor darkGrayColor];
    [self.tableView addSubview:tipLabel];
}

- (void)configurMjrefresh{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        [self activityListRequest:YES];
    }];
    
    ((MJRefreshNormalHeader *)self.tableView.mj_header).lastUpdatedTimeLabel.hidden = YES;
    // 隐藏状态
    ((MJRefreshNormalHeader *)self.tableView.mj_header).stateLabel.hidden = YES;
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        [self activityListRequest:NO];
    }];
    self.tableView.mj_footer.automaticallyHidden = YES;
}

#pragma mark - private
- (void)activityListRequest:(BOOL)isPull{
    DNActivityListRequest *request = [[DNActivityListRequest alloc] init];
    request.accountId = [DNUser sheared].userId;
    request.activityType = self.activityType;
    request.loaction = [DNPhone shared].selectCity;
    request.page = isPull ? 0 : self.dataSource.count;
    [request httpRequest:15 success:^(NSURLSessionDataTask *sessionTask, id respondObj) {
        if (isPull) {
            self.dataSource = [respondObj mutableCopy];
            [self.tableView.mj_header endRefreshing];
            MJRefreshState state;
            state = [respondObj count] < 20 ? MJRefreshStateNoMoreData : MJRefreshStateIdle;
            [self.tableView.mj_footer setState:state];
        }else{
            [self.dataSource addObjectsFromArray:respondObj];
            [respondObj count] < 20 ? [self.tableView.mj_footer endRefreshingWithNoMoreData] : [self.tableView.mj_footer endRefreshing];
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    UILabel *tipLabel = [tableView viewWithTag:DNTableViewTipLabelTag];
    if (self.dataSource.count < 1) {
        tipLabel.hidden = NO;
    }else{
        tipLabel.hidden = YES;
    }
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 178.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DNActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DNActivityCell" forIndexPath:indexPath];
    if (indexPath.row < self.dataSource.count) {
        cell.dataSource = self.dataSource[indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row < self.dataSource.count) {
        NSNumber *activityId = [self.dataSource[indexPath.row] DNObjectForKey:@"id"];
        if (activityId) {
            DNActivityDetailViewC *activityDetailC = [[DNActivityDetailViewC alloc] initWithNibName:@"DNActivityDetailViewC" bundle:nil];
            activityDetailC.activityId = activityId;
            for (UIView* next = [self.view superview]; next; next = next.superview) {
                UIResponder* nextResponder = [next nextResponder];
                if ([nextResponder isKindOfClass:[UIViewController class]]) {
                    [((UIViewController*)nextResponder).navigationController pushViewController:activityDetailC animated:YES];
                }
            }
        }
    }
}


#pragma mark - getter

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = self.view.backgroundColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:@"DNActivityCell" bundle:nil] forCellReuseIdentifier:@"DNActivityCell"];
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
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
