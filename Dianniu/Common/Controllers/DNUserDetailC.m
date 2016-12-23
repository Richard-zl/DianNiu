//
//  DNUserDetail.m
//  Dianniu
//
//  Created by RIMI on 2016/12/19.
//  Copyright © 2016年 Dianniu. All rights reserved.
//

#import "DNUserDetailC.h"
#import <UIImageView+WebCache.h>
#import "DNFollowRequest.h"
#import "DNAddFirendRequest.h"

@interface DNUserDetailC ()
@property (weak, nonatomic) IBOutlet UIImageView *hederImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UIImageView *genderImageView;
@property (weak, nonatomic) IBOutlet UILabel *joinTimeLb;
@property (weak, nonatomic) IBOutlet UILabel *tagLb;
@property (weak, nonatomic) IBOutlet UILabel *desciptionLb;  //个性签名
@property (weak, nonatomic) IBOutlet UIButton *followBut;   //关注按钮
@property (weak, nonatomic) IBOutlet UIButton *beFriendBut; //加好友

@end

@implementation DNUserDetailC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self dealBrowsingSelf];
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
        [self configurSubViewsWithDetailModel:detailModel];
    } failed:^(NSURLSessionDataTask *sessionTask, NSError *error) {
        //基类处理过
    }];
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


@end
