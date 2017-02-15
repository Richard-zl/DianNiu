//
//  DNQ_ATableViewC.m
//  Dianniu
//
//  Created by RIMI on 2016/12/16.
//  Copyright © 2016年 Dianniu. All rights reserved.
//

#import "DNQ_ATableViewC.h"
#import "DNQ_ADetailViewC.h"

@interface DNQ_ATableViewC ()
@end

@implementation DNQ_ATableViewC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configurUI];
    [self configurMjrefresh];
}

- (void)configurUI{
    self.tableView.estimatedRowHeight = 180.0;
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] init];
}

- (void)configurMjrefresh{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        [self.requestdelegate refreshRequestWithPage:0 counts:20 type:self.type finish:^{
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer resetNoMoreData];
        }];
    }];
    
    ((MJRefreshNormalHeader *)self.tableView.mj_header).lastUpdatedTimeLabel.hidden = YES;
    // 隐藏状态
    ((MJRefreshNormalHeader *)self.tableView.mj_header).stateLabel.hidden = YES;
    
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        NSArray *hotArr    = self.dianniuQ_ADataSource[@"hotContent"];
        NSArray *contetArr = self.dianniuQ_ADataSource[@"content"];
        NSInteger page = (hotArr.count + contetArr.count);
        if (page % 20 == 0) {
            //还可以请求数据
            [self.requestdelegate refreshRequestWithPage:page counts:20 type:self.type finish:^{
                [self.tableView.mj_footer endRefreshing];
            }];
        }else{
            //没有数据了
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
}

- (void)tableViewNeedReload:(NSMutableDictionary <NSString *,DNDianniuQ_AViewModel *> *)dataDict isRefresh:(BOOL)isRefresh{
    //字典结构:
    //@{@"hotContent":@[viewModel,viewModel]
    //  @"content    :@[viewModel,viewModel]"}
    if (isRefresh) {
        self.dianniuQ_ADataSource = dataDict;
    }else{
        NSMutableArray *hotContent = self.dianniuQ_ADataSource[@"hotContent"];
        NSMutableArray *content    = self.dianniuQ_ADataSource[@"content"];
        [hotContent addObjectsFromArray:[dataDict[@"hotContent"] mutableCopy]];
        [content addObjectsFromArray:[dataDict[@"content"] mutableCopy]];
    }
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger sections = 1;
    NSArray *hotContent = self.dianniuQ_ADataSource[@"hotContent"];
    if (hotContent.count > 0) {
        sections = 2;
    }
    
    return sections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rows = 0;
    NSArray *hotContent = self.dianniuQ_ADataSource[@"hotContent"];
    NSArray *content    = self.dianniuQ_ADataSource[@"content"];
    if (hotContent.count > 0) {
        rows = section == 0 ? hotContent.count : content.count;
    }else{
        rows = content.count;
    }
    
    return rows;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *title = @"";
    NSArray *hotContent = self.dianniuQ_ADataSource[@"hotContent"];
    if (hotContent.count > 0 && section == 0) {
        title = @"热门置顶";
    }
    return title;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    DNDianniuQ_AViewModel *viewModel;
    NSArray *hotContent = self.dianniuQ_ADataSource[@"hotContent"];
    NSArray *content    = self.dianniuQ_ADataSource[@"content"];
    if (hotContent.count > 0) {
        viewModel = indexPath.section == 0 ? hotContent[indexPath.row] : content[indexPath.row];
    }else{
        viewModel = content[indexPath.row];
    }
    return viewModel.cellHeight;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DNDianniuQ_AViewModel *viewModel;
    NSArray *hotContent = self.dianniuQ_ADataSource[@"hotContent"];
    NSArray *content    = self.dianniuQ_ADataSource[@"content"];
    if (hotContent.count > 0) {
        viewModel = indexPath.section == 0 ? hotContent[indexPath.row] : content[indexPath.row];
    }else{
        viewModel = content[indexPath.row];
    }
    
    DNQ_ADetailViewC *detailC = [[DNQ_ADetailViewC alloc] init];
    detailC.type = self.type;
    detailC.q_aModel = viewModel;
    [self.navigationController pushViewController:detailC animated:YES];
}
#pragma mark - getter and setter
- (NSMutableDictionary *)dianniuQ_ADataSource{
    if (!_dianniuQ_ADataSource) {
        _dianniuQ_ADataSource = [NSMutableDictionary dictionary];
    }
    return _dianniuQ_ADataSource;
}

@end
