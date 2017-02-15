//
//  DNSearchViewC.m
//  Dianniu
//
//  Created by RIMI on 2017/1/20.
//  Copyright © 2017年 Dianniu. All rights reserved.
//

#import "DNSearchViewC.h"
#import "DNDianniuQ_AViewModel.h"
#import "DNQuestionsSearchRequest.h"
#import "DNQ_ADetailHederView.h"
#import <MJRefresh.h>
#import "DNQ_ADetailViewC.h"
#import "DNUserDetailC.h"
#import <Masonry.h>

@interface DNSearchViewC ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<DNDianniuQ_AViewModel *> *dataSource;
@end

@implementation DNSearchViewC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.type == 1 ? @"问答搜索":@"匿名搜索";
    [self configurSubViews];
    [self configurMjrefresh];
}

#pragma mark - UI Metheod
- (void)configurSubViews{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.estimatedRowHeight = 200.0;
    self.view.backgroundColor = self.tableView.backgroundColor;
    [self.view addSubview:self.searchBar];
    [self.view addSubview:self.tableView];
}

#pragma mark - private func

- (void)configurMjrefresh{
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        [self searchRequest:YES];
    }];
    [self.tableView.mj_footer setState:MJRefreshStateNoMoreData];
}

- (void)searchRequest:(BOOL)isLoadMore{
    DNQuestionsSearchRequest *request = [[DNQuestionsSearchRequest alloc] init];
    request.accountId = [DNUser sheared].userId;
    request.type      = self.type;
    request.page      = isLoadMore ? self.dataSource.count : 0;
    request.content   = self.searchBar.text;
    [SVProgressHUD showWithStatus:@"正在搜索..."];
    [request httpRequest:15 success:^(NSURLSessionDataTask *sessionTask, id respondObj) {
        [SVProgressHUD dismiss];
        if (isLoadMore) {
            [self.tableView.mj_footer endRefreshing];
        }else{
            [self.tableView.mj_footer setState:MJRefreshStateIdle];
            [self.dataSource removeAllObjects];
        }
        if ([respondObj count] < 20) {
            [self.tableView.mj_footer setState:MJRefreshStateNoMoreData];
        }
        for (NSDictionary *dataDic in respondObj) {
            DNDianniuQ_AModel *model = [DNDianniuQ_AModel modelWithQ_ADictionary:dataDic];
            DNDianniuQ_AViewModel *viewModel = [[DNDianniuQ_AViewModel alloc] initWithQ_AModel:model];
            [self.dataSource addObject:viewModel];
        }
        //这儿如果用reloadData会遇到问题（该问题待解决）
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    } failed:^(NSURLSessionDataTask *sessionTask, NSError *error) {
        if (isLoadMore) {
            [self.tableView.mj_footer endRefreshing];
        }
    }];
}

#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    if (searchBar.text.length < 1) {
        [SVProgressHUD showErrorWithStatus:@"请输入要搜索的内容"];
        return;
    }
    [self searchRequest:NO];
    [searchBar resignFirstResponder];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < self.dataSource.count) {
        CGFloat height = self.dataSource[indexPath.row].cellHeight;
        return height;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DNSearchCell" forIndexPath:indexPath];
    DNQ_ADetailHederView *detailView = [cell.contentView viewWithTag:250];
    if (!detailView) {
        detailView = [[[NSBundle mainBundle] loadNibNamed:@"DNQ_ADetailHederView" owner:nil options:nil] firstObject];
        detailView.tag = 250;
        [cell.contentView addSubview:detailView];
        [detailView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView.mas_left);
            make.top.equalTo(cell.contentView.mas_top);
            make.width.equalTo(cell.contentView.mas_width);
            make.height.equalTo(cell.contentView.mas_height);
        }];
    }
    DNWeakself
    if (indexPath.row < self.dataSource.count) {
        detailView.type = self.type;
        detailView.model = self.dataSource[indexPath.row];
        detailView.didClickDetailView = ^{
            if (weakSelf.type == DNHomeListType_questions) {
                DNUserDetailC *userDetailC = [[DNUserDetailC alloc] initWithNibName:@"DNUserDetailC" bundle:nil];
                userDetailC.accountId = self.dataSource[indexPath.row].q_aModel.accountId;
                [weakSelf.navigationController pushViewController:userDetailC animated:YES];
            }
        };
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row < self.dataSource.count) {
        DNQ_ADetailViewC *detalC = [[DNQ_ADetailViewC alloc] initWithNibName:@"DNQ_ADetailViewC" bundle:nil];
        detalC.type = self.type;
        detalC.q_aModel = self.dataSource[indexPath.row];
        [self.navigationController pushViewController:detalC animated:YES];
    }
}

#pragma mark - getter
- (UISearchBar *)searchBar{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
        _searchBar.barTintColor = [UIColor whiteColor];
        _searchBar.delegate = self;
        _searchBar.placeholder = @"搜索关键字";
    }
    return _searchBar;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.searchBar.bottom, ScreenWidth, ScreenHeight - self.searchBar.bottom - self.navigationController.navigationBar.bottom)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = RGBColor(241, 241, 241);
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"DNSearchCell"];
    }
    return _tableView;
}

- (NSMutableArray <DNDianniuQ_AViewModel *>*)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end
