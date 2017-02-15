//
//  DNJobViewC.m
//  Dianniu
//
//  Created by RIMI on 2017/1/23.
//  Copyright © 2017年 Dianniu. All rights reserved.
//

#import "DNJobViewC.h"
#import "DNDiscoverCollectionView.h"
#import "DNJobListRequest.h"
#import <MJRefresh.h>
#import "DNJobCell.h"
#import "DNRecruitDetailViewC.h"

#define DNTableViewTipLabelTag 0x1234
@interface DNJobViewC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataSource;
@property (nonatomic, copy) NSString *currentPostStr;
@property (nonatomic, strong)DNJobListRequest *lastRequest;
@end

@implementation DNJobViewC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configurSubViews];
    [self requestJobList:self.currentPostStr Refresh:YES];
}

- (void)dealloc{
    NSLog(@"求职页面被销毁了");
}

#pragma mark - UI Metheod
- (void)configurSubViews{
    self.view.height = ScreenHeight - 64 - 45;
    self.view.backgroundColor = RGBColor(241, 241, 241);
    [self configurCollectionView];
    [self configurTableView];
}

- (void)configurCollectionView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    DNDiscoverCollectionView *collectionView = [[DNDiscoverCollectionView alloc] initWithFrame:CGRectMake(self.view.left, self.view.top, self.view.width, 90) collectionViewLayout:layout];
    collectionView.didClickTypeButton = [self didClickTypeButtonBlock];
    [self.view addSubview:collectionView];
}

- (void)configurTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(self.view.left, 90, self.view.width, self.view.height - 90) style:UITableViewStylePlain];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"DNJobCell" bundle:nil] forCellReuseIdentifier:@"DNJobCell"];
    [self.view addSubview:self.tableView];
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, self.tableView.width, 40)];
    tipLabel.tag = DNTableViewTipLabelTag;
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.text = @"电纽圈未找到";
    tipLabel.textColor = [UIColor darkGrayColor];
    [self.tableView addSubview:tipLabel];
}

- (void)configurMjRefresh{
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        [self requestJobList:self.currentPostStr Refresh:NO];
    }];
}

#pragma mark - private func
- (void)requestJobList:(NSString *)postStr Refresh:(BOOL)isRefresh{
    [self.lastRequest cancelCurrentRequest];
    DNJobListRequest *request= [[DNJobListRequest alloc] init];
    self.lastRequest = request;
    request.accountId = [DNUser sheared].userId;
    request.page = isRefresh ? 0 : self.dataSource.count;
    request.post = postStr;
    request.type = 1;
    [request httpRequest:15 success:^(NSURLSessionDataTask *sessionTask, id respondObj) {
        if (isRefresh) {
            [self.dataSource removeAllObjects];
        }
        if ([respondObj count] >= 20) {
            if (!self.tableView.mj_footer) {
                [self configurMjRefresh];
            }else{
                [self.tableView.mj_footer endRefreshing];
            }
        }else{
            self.tableView.mj_footer = nil;
        }
        for (NSDictionary *dataDict in respondObj) {
            [self.dataSource addObject:dataDict];
        }
        [self.tableView reloadData];
    } failed:^(NSURLSessionDataTask *sessionTask, NSError *error) {
        [self.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark - Event
- (void(^)(NSString *str))didClickTypeButtonBlock{
    DNWeakself
    return ^(NSString *typeButton){
        if ([typeButton isEqualToString:@"全部"]) {
            weakSelf.currentPostStr = nil;
        }else{
            weakSelf.currentPostStr = typeButton;
        }
        [weakSelf requestJobList:weakSelf.currentPostStr Refresh:YES];
    };
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    UILabel *tipLabel = [tableView viewWithTag:DNTableViewTipLabelTag];
    if (self.dataSource.count < 1) {
        tipLabel.hidden = NO;
    }else{
        tipLabel.hidden = YES;
    }
    return self.dataSource.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DNJobCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DNJobCell" forIndexPath:indexPath];
    if (indexPath.row < self.dataSource.count) {
        cell.dataSource = self.dataSource[indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DNRecruitDetailViewC *detailC = [[DNRecruitDetailViewC alloc] init];
    detailC.type = DNRecruitDetailType_JOB;
    detailC.requestId = self.dataSource[indexPath.row][@"id"];
    for (UIView* next = [self.view superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            [((UIViewController*)nextResponder).navigationController pushViewController:detailC animated:YES];
        }
    }
}

#pragma mark - getter
- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}


@end
