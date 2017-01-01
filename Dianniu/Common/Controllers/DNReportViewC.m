//
//  DNReportViewC.m
//  Dianniu
//
//  Created by RIMI on 2016/12/26.
//  Copyright © 2016年 Dianniu. All rights reserved.
//

#import "DNReportViewC.h"

@interface DNReportViewC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSNumber *target;
@property (nonatomic, assign)DNReportType type;
@property (nonatomic, strong)NSArray *dataSource;
@property (nonatomic, strong)NSIndexPath *currentdexPath;
@end

@implementation DNReportViewC

- (instancetype)initWithReportType:(DNReportType)type tergetId:(NSNumber *)kid{
    self = [super init];
    if (self) {
        self.type = type;
        self.target = kid;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"举报";
    [self.view addSubview:self.tableView];
    [self.view addSubview:[self creatCommitBut]];
}

#pragma mark - private
- (UIButton *)creatCommitBut{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat butHeight = 45.0;
    button.frame = CGRectMake(15, ScreenHeight - 50.0, ScreenWidth - 30, butHeight);
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundColor:DNThemeColor];
    [button addTarget:self action:@selector(commitButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"提交" forState:UIControlStateNormal];
    button.layer.cornerRadius = 4.0;
    return button;
}

#pragma mark - Event
- (void)commitButtonAction{
    if (self.currentdexPath) {
        DNReportRequest *request = [[DNReportRequest alloc] init];
        request.targetId = self.target;
        request.type     = self.type;
        request.reasonModel = self.dataSource[self.currentdexPath.row];
        request.accountId   = [DNUser sheared].userId;
        [request httpRequest:15 success:^(NSURLSessionDataTask *sessionTask, id respondObj) {
            [SVProgressHUD showSuccessWithStatus:@"举报成功"];
            [self.navigationController popViewControllerAnimated:YES];
        } failed:nil];
    }else{
        [SVProgressHUD showErrorWithStatus:@"请选择举报原因"];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DNReportViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DNReportViewCell"];
    }
    if (self.currentdexPath && self.currentdexPath.row == indexPath.row) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.textLabel.text = self.dataSource[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.currentdexPath = indexPath;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.tableView reloadData];
}

#pragma mark - getter and setter
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = RGBColor(247, 247, 247);
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (NSArray *)dataSource{
    if (!_dataSource) {
        _dataSource = @[@"违法/政治敏感",@"广告",@"身份作假",@"色情",@"其他（水贴、骚扰、鸡汤等）"];
    }
    return _dataSource;
}

@end
