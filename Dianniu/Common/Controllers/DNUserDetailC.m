//
//  DNUserDetail.m
//  Dianniu
//
//  Created by RIMI on 2016/12/19.
//  Copyright © 2016年 Dianniu. All rights reserved.
//

#import "DNUserDetailC.h"
#import <UIImageView+WebCache.h>
#import "DNShareSDKManager.h"
#import "DNFollowRequest.h"
#import "DNAddFirendRequest.h"
#import "DNShieldRequest.h"
#import "DNBlacklistRequest.h"
#import "DNReportViewC.h"

typedef NS_ENUM(NSUInteger, DNUserDetailActionSheetIndex) {
    DNUserDetailActionSheetIndex_Shared = 0, //分享名片
    DNUserDetailActionSheetIndex_Shield,     //屏蔽
    DNUserDetailActionSheetIndex_BlackList,  //拉黑
    DNUserDetailActionSheetIndex_Report      //举报
};

@interface DNUserDetailC ()<UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *hederImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UIImageView *genderImageView;
@property (weak, nonatomic) IBOutlet UILabel *joinTimeLb;
@property (weak, nonatomic) IBOutlet UILabel *tagLb;
@property (weak, nonatomic) IBOutlet UILabel *desciptionLb;  //个性签名
@property (weak, nonatomic) IBOutlet UIButton *followBut;   //关注按钮
@property (weak, nonatomic) IBOutlet UIButton *beFriendBut; //加好友

@property (nonatomic, strong) DNUserDetailModel *model;
@end

@implementation DNUserDetailC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self dealBrowsingSelf];
    [self creatRightCollecBut];
    [self requestUserDetailInfo];
}

#pragma mark - UI Method

- (void)dealBrowsingSelf{
    self.title = @"查看资料";
    if (self.accountId.integerValue == [DNUser sheared].userId.integerValue) {
        self.followBut.hidden = YES;
        self.beFriendBut.hidden = YES;
    }
}

- (void)creatRightCollecBut{
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"sandian"] style:UIBarButtonItemStylePlain target:self action:@selector(navigationRightButAction)];
    rightItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)configurSubViewsWithDetailModel:(DNUserDetailModel *)detailModel{
    self.followBut.selected   = detailModel.isFollow;
    self.beFriendBut.selected = detailModel.isFriend;
    self.nameLb.text          = detailModel.realName;
    self.tagLb.text           = detailModel.label;
    self.desciptionLb.text    = detailModel.describe;
    [self.hederImageView sd_setImageWithURL:[NSURL URLWithString:detailModel.headPic]];
}

#pragma mark - private func
- (void)requestUserDetailInfo{
    DNUserDetailRequest *request = [[DNUserDetailRequest alloc] init];
    request.accountId = [DNUser sheared].userId;
    request.friendAccountId = self.accountId;
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
    [request httpRequest:15 success:^(NSURLSessionDataTask *sessionTask, id respondObj) {
        DNUserDetailModel *detailModel = [[DNUserDetailModel alloc] initWhitDictionary:respondObj];
        [SVProgressHUD dismiss];
        self.model = detailModel;
        [self configurSubViewsWithDetailModel:detailModel];
    } failed:^(NSURLSessionDataTask *sessionTask, NSError *error) {
        //基类处理过
    }];
}

//分享名片
- (void)sharedDetailInfo{
    NSString *content = [NSString stringWithFormat:@"昵称:%@\n标签:%@",self.model.realName,self.model.label];
    [[DNShareSDKManager shared] shareContentWithType:DNShareType_profile content:content shareId:self.accountId imagePath:self.model.headPic success:nil];
}

//屏蔽
- (void)shieldRequest{
    DNShieldRequest *request = [[DNShieldRequest alloc] init];
    request.accountId = [DNUser sheared].userId;
    request.shieldAccountId = self.model.userId;
    [request httpRequest:15 success:^(NSURLSessionDataTask *sessionTask, id respondObj) {
        [SVProgressHUD showSuccessWithStatus:@"已屏蔽"];
    } failed:nil];
}

//拉黑
- (void)blacklistRequest{
    DNBlacklistRequest *request = [[DNBlacklistRequest alloc] init];
    request.accountId = [DNUser sheared].userId;
    request.blackAccountId = self.model.userId;
    [request httpRequest:15 success:^(NSURLSessionDataTask *sessionTask, id respondObj) {
        [SVProgressHUD showSuccessWithStatus:@"拉黑成功"];
    } failed:nil];
}

//举报
- (void)pushReportViewC{
    DNReportViewC *viewC = [[DNReportViewC alloc] initWithReportType:DNReportType_User tergetId:self.model.userId];
    [self.navigationController pushViewController:viewC animated:YES];
}

#pragma mark - Event
- (IBAction)buttonAction:(UIButton *)sender {
    DNWebServiceBaseModel *request;
    if (sender.tag == 0) {
        //关注
        request = [[DNFollowRequest alloc] init];
    }else{
        //加好友
        request = [[DNAddFirendRequest alloc] init];
    }
    ((DNFollowRequest *)request).accountId       = [DNUser sheared].userId;
    ((DNFollowRequest *)request).friendAccountId = self.accountId;
    [request httpRequest:15 success:^(NSURLSessionDataTask *sessionTask, id respondObj) {
        sender.selected = !sender.isSelected;
    } failed:^(NSURLSessionDataTask *sessionTask, NSError *error) {
       //基类已经做了处理
    }];
}

- (void)navigationRightButAction{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"分享名片",@"屏蔽",@"拉黑",@"举报", nil];
    [sheet bk_setDidDismissBlock:^(UIActionSheet *actionSheet, NSInteger index) {
        DNWebServiceBaseModel *request;
        switch (index) {
            case DNUserDetailActionSheetIndex_Shared:
                //分享名片
                [self sharedDetailInfo];
                break;
            case DNUserDetailActionSheetIndex_Shield:
                //屏蔽
                [self shieldRequest];
                break;
            case DNUserDetailActionSheetIndex_BlackList:
                //拉黑
                [self blacklistRequest];
                break;
            case DNUserDetailActionSheetIndex_Report:
                //举报
                [self pushReportViewC];
                break;
        }
    }];
    [sheet showInView:self.view];
}


@end
