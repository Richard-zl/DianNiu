//
//  DNActivityDetailViewC.m
//  Dianniu
//
//  Created by RIMI on 2017/2/12.
//  Copyright © 2017年 Dianniu. All rights reserved.
//

#import "DNActivityDetailViewC.h"
#import "DNActivityJoinCell.h"
#import "DNActivityDetailRequest.h"
#import "DNActivityJoinRequest.h"

#define DNActivityJoinCellHeight 25.0
@interface DNActivityDetailViewC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *joinDatas;
@property (weak, nonatomic) IBOutlet UIButton *joinButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableviewHeightCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeightCons;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *detailButton;//详情button
@property (weak, nonatomic) IBOutlet UITableView *tableView;

//text
@property (weak, nonatomic) IBOutlet UILabel *joinNumberLb;//参加人数
@property (weak, nonatomic) IBOutlet UILabel *dateLb; //时间
@property (weak, nonatomic) IBOutlet UILabel *amountLb; //AA制度 100元/每人
@property (weak, nonatomic) IBOutlet UILabel *locationLb;//地址
@property (weak, nonatomic) IBOutlet UILabel *tagLb;//报名权限
@property (weak, nonatomic) IBOutlet UILabel *mobileLb;//联系方式
@property (weak, nonatomic) IBOutlet UILabel *activityDesriptionLb;//活动简介
@property (weak, nonatomic) IBOutlet UILabel *titleLb;

@end

@implementation DNActivityDetailViewC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"活动详情";
    [self configurDetailButton];
    [self configurTableView];
    [self activityDetailRequest];
}

#pragma mark - UI Method
- (void)configurDetailButton{
    self.detailButton.layer.borderWidth = 1.0;
    self.detailButton.layer.borderColor = DNThemeColor.CGColor;
    self.detailButton.layer.cornerRadius = self.detailButton.height/2;
}

- (void)configurTableView{
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"DNActivityJoinCell" bundle:nil] forCellReuseIdentifier:@"DNActivityJoinCell"];
}

- (void)updateViewConstraints{
    [super updateViewConstraints];
    self.contentViewHeightCons.constant = ScreenHeight - 64 - 45;
}

#pragma mark - private
- (void)activityDetailRequest{
    DNActivityDetailRequest *request = [[DNActivityDetailRequest alloc] init];
    request.activityId = self.activityId;
    [request httpRequest:15 success:^(NSURLSessionDataTask *sessionTask, id respondObj) {
        NSDictionary *detailDict = [respondObj DNObjectForKey:@"detail"];
        NSInteger state = [[detailDict DNObjectForKey:@"status"] integerValue];
        NSInteger accountId = [[detailDict DNObjectForKey:@"accountId"] integerValue];
        if ([[DNUser sheared].userId integerValue] == accountId) {
            //本人发布的需要隐藏按钮
            state = 5;
        }
        self.joinDatas = [respondObj DNObjectForKey:@"activityInfos"];
        [self changeButtonTextWithState:state];
        [self changeTableViewHeight];
        [self changeTextWithDetailDict:detailDict];
    } failed:^(NSURLSessionDataTask *sessionTask, NSError *error) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)changeTextWithDetailDict:(NSDictionary *)detailDict{
    if (detailDict.allKeys.count > 5) {
        self.titleLb.text = [detailDict DNObjectForKey:@"subject"];
        self.joinNumberLb.text = [detailDict DNObjectForKey:@"persionSection"];
        self.dateLb.text  = [detailDict DNObjectForKey:@"startDate"];
        NSString *amount  = [detailDict DNObjectForKey:@"costTypeDesc"];
        if (amount.length > 0) {
            amount = [amount stringByAppendingString:[NSString stringWithFormat:@" %@",[detailDict DNObjectForKey:@"costTypeContent"]]];
        }
        self.amountLb.text = amount;
        self.locationLb.text = [detailDict DNObjectForKey:@"address"];
        NSString *tagStr = [detailDict DNObjectForKey:@"labels"];
        if (tagStr.length < 1) {
            tagStr = @"行业不限";
        }
        self.tagLb.text  = tagStr;
        NSString *mobile = [detailDict DNObjectForKey:@"mobile"];
        if ([[detailDict DNObjectForKey:@"status"] integerValue] != 3) {
            mobile = @"申请通过可见";
        }
        self.mobileLb.text = mobile;
        self.activityDesriptionLb.text = [detailDict DNObjectForKey:@"content"];
    }else{
        //数据异常
        [SVProgressHUD showErrorWithStatus:@"数据异常，请重试！"];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)changeTableViewHeight{
    NSInteger cellCount = self.joinDatas.count > 3 ? 3 : self.joinDatas.count;
    self.tableviewHeightCons.constant = cellCount * DNActivityJoinCellHeight;
    [self.tableView reloadData];
}

- (void)changeButtonTextWithState:(NSInteger)state{
    NSString *buttonText = @"加载中...";
    if (state == 0) {
        //申请加入
        buttonText = @"申请加入";
        self.joinButton.enabled = YES;
    }else if (state == 1){
        //等待通过
        buttonText = @"等待通过";
    }else if (state == 2){
        //已通过
        buttonText = @"已通过";
    }else if (state == 3){
        //拒绝加入
        buttonText = @"已拒绝";
    }else{
        //本人发布的需要隐藏
        [self.joinButton removeFromSuperview];
    }
    [self.joinButton setTitle:buttonText forState:UIControlStateNormal];
}

- (void)changeScrollViewHeight{
    
}

#pragma mark - Event
- (IBAction)joinButtonAction:(UIButton *)sender {
    DNActivityJoinRequest *joinRequest = [[DNActivityJoinRequest alloc] init];
    joinRequest.activityId = self.activityId;
    sender.enabled = NO;
    [SVProgressHUD showInfoWithStatus:@"正在申请..."];
    [joinRequest httpRequest:15 success:^(NSURLSessionDataTask *sessionTask, id respondObj) {
        [SVProgressHUD dismiss];
        [self changeButtonTextWithState:1];
    } failed:^(NSURLSessionDataTask *sessionTask, NSError *error) {
        sender.enabled = YES;
    }];
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.joinDatas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return DNActivityJoinCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DNActivityJoinCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DNActivityJoinCell" forIndexPath:indexPath];
    if (indexPath.row < self.joinDatas.count) {
        cell.dataSource = self.joinDatas[indexPath.row];
    }
    return cell;
}

#pragma mark - UITableView
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - getter
- (NSMutableArray *)joinDatas{
    if (!_joinDatas) {
        _joinDatas = [NSMutableArray array];
    }
    return _joinDatas;
}

@end
