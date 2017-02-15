//
//  DNDianniuAnswerCell.m
//  Dianniu
//
//  Created by RIMI on 2016/12/16.
//  Copyright © 2016年 Dianniu. All rights reserved.
//

#import "DNAnswerCell.h"

@interface DNAnswerCell ()
@property (weak, nonatomic) IBOutlet UIImageView *hedaerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UILabel *tagLb;
@property (weak, nonatomic) IBOutlet UIButton *praiseBut;
@property (weak, nonatomic) IBOutlet UILabel *contentLb;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLbWidthCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLbHeightCons;


@end

@implementation DNAnswerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentLbWidthCons.constant = ScreenWidth -55 -10;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setViewModel:(DNAnswerViewModel *)viewModel{
    _viewModel = viewModel;
    [self configurSunViews];
    if (_viewModel.cellHeight == 0) {
        _viewModel.cellHeight = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingExpandedSize].height + 1;
    }
}

- (void)configurSunViews{
    if (self.type == DNHomeListType_anonymity) {
        [self configurAnonymityAnswerViews];
    }else{
        [self configurDianniuAnswerViews];
    }
    self.praiseBut.selected = self.viewModel.isGood;
    [self.praiseBut setTitle:[NSString stringWithFormat:@"%ld",(long)_viewModel.goodCount] forState:UIControlStateNormal];
    [self.praiseBut setTitle:[NSString stringWithFormat:@"%ld",(long)_viewModel.allGoodCount] forState:UIControlStateSelected];

    self.contentLb.text = _viewModel.content;
}

- (void)configurDianniuAnswerViews{
    self.tagLb.hidden = NO;
    self.tagLb.text = _viewModel.label;
    self.nameLbHeightCons.constant = 16.0;
    self.nameLb.text = _viewModel.realName;
    NSURL *hederURL = [NSURL URLWithString:[DNAliSDKManager aliMediaSDKImagePath:_viewModel.headPic]];
    [self.hedaerImageView sd_setImageWithURL:hederURL placeholderImage:[UIImage imageNamed:@"default_head_icon"]];
}

- (void)configurAnonymityAnswerViews{
    self.tagLb.hidden = YES;
    self.nameLbHeightCons.constant = 32.0;
    self.nameLb.text = _viewModel.aliasName;
    NSURL *hederURL = [NSURL URLWithString:[DNAliSDKManager aliMediaSDKImagePath:_viewModel.aliasHeadPic]];
    [self.hedaerImageView sd_setImageWithURL:hederURL placeholderImage:[UIImage imageNamed:@"default_head_icon"]];
}

#pragma mark - event
- (IBAction)praiseButtonAction:(id)sender {
    DNAnswerPraiseRequest *request = [[DNAnswerPraiseRequest alloc] init];
    request.accountId = [DNUser sheared].userId;
    request.questId  = _viewModel.questId;
    request.answerId = _viewModel.answerId;
    [request httpRequest:15 success:^(NSURLSessionDataTask *sessionTask, id respondObj) {
        self.praiseBut.selected = !self.praiseBut.isSelected;
    } failed:^(NSURLSessionDataTask *sessionTask, NSError *error) {
        //基类做了处理
    }];
}

@end
