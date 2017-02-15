//
//  DNBlacklistViewC.m
//  Dianniu
//
//  Created by RIMI on 2017/1/19.
//  Copyright © 2017年 Dianniu. All rights reserved.
//

#import "DNBlacklistViewC.h"
#import "DNUserCell.h"
#import <MJRefresh.h>

@interface DNBlacklistViewC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)UILabel *tipLabel;
@property (nonatomic, strong)NSMutableArray *dataSource;
@end

@implementation DNBlacklistViewC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configSubViews];
    [self.tableView.mj_header beginRefreshing];
}

- (void)configSubViews{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = RGBColor(241, 241, 241);
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, self.tipLabel.height)];
    topView.backgroundColor = RGBColor(231, 231, 231);
    [topView addSubview:self.tipLabel];
    [self.view addSubview:topView];
    [self.view addSubview: self.tableView];
    [self configurMjrefresh];
}

- (void)configurMjrefresh{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        ((MJRefreshNormalHeader *)self.tableView.mj_header).lastUpdatedTimeLabel.hidden = YES;
        // 隐藏状态
        ((MJRefreshNormalHeader *)self.tableView.mj_header).stateLabel.hidden = YES;
        [self listRequest:YES];
        
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        NSInteger page = self.dataSource.count;
        if (page % 20 == 0) {
            //还可以请求数据
            [self listRequest:NO];
        }else{
            //没有数据了
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
}

- (void)listRequest:(BOOL)isPull{
    DNShieldListRequest *request = [[DNShieldListRequest alloc] init];
    request.accountId = [DNUser sheared].userId;
    request.page = isPull ? 0 : self.dataSource.count;
    request.listType = self.listType;
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
            [self.dataSource addObject:dataDict];
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
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DNUserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DNUserCell" forIndexPath:indexPath];
    if (indexPath.row < self.dataSource.count) {
        cell.userDic = self.dataSource[indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - getter
- (UILabel *)tipLabel{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(8,0, ScreenWidth - 16, 0)];
        _tipLabel.numberOfLines = 2;
        _tipLabel.textColor = [UIColor darkGrayColor];
        if (self.listType == DNRequestListType_Shield) {
            self.title = @"我的屏蔽";
            _tipLabel.text = @"屏蔽后不会看到被屏蔽人提出的问题";
            _tipLabel.height = 36;
        }else{
            self.title  = @"我的黑名单";
            _tipLabel.text = @"加入黑名单后不显示任何信息和不能进行任何电纽相关操作";
            _tipLabel.height = 56;
        }
    }
    return _tipLabel;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.tipLabel.bottom, ScreenWidth, ScreenHeight - self.tipLabel.bottom) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = RGBColor(241, 241, 241);
        _tableView.tableFooterView = [UIView new];
        [_tableView registerNib:[UINib nibWithNibName:@"DNUserCell" bundle:nil] forCellReuseIdentifier:@"DNUserCell"];
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
