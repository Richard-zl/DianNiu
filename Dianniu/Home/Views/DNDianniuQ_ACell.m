//
//  DNDianniuQ_ACell.m
//  Dianniu
//
//  Created by RIMI on 2016/11/30.
//  Copyright © 2016年 Dianniu. All rights reserved.
//

#import "DNDianniuQ_ACell.h"
#import <UIImageView+WebCache.h>
#import "DNContentImageCollectionView.h"

#define DNDianniuQ_ACellEdgemargin 30
#define DNContentImageMargin   5

@interface DNDianniuQ_ACell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;

@property (weak, nonatomic) IBOutlet UIButton *addFriendBut;
@property (weak, nonatomic) IBOutlet UILabel *contentTextLb;
@property (weak, nonatomic) IBOutlet UIView *bottomToolView;
@property (weak, nonatomic) IBOutlet UIButton *moerButn;
@property (weak, nonatomic) IBOutlet UIButton *praiseButn;
@property (weak, nonatomic) IBOutlet UIButton *commentButn;
@property (weak, nonatomic) IBOutlet DNContentImageCollectionView *collectionView;

//约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tagLabelWidthCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentTextLbWidthCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *picCollectionViewWidthCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *picCollectionViewHeightCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *picCollectionViewBottomCons;
@end

@implementation DNDianniuQ_ACell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configurSubViews];
}

- (void)configurSubViews{
    self.contentTextLbWidthCons.constant = ScreenWidth - DNDianniuQ_ACellEdgemargin *2;
    self.addFriendBut.layer.borderColor  = DNThemeColor.CGColor;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.collectionView.scrollEnabled = NO;
    if (ScreenWidth == 320) {
        //小屏
        self.tagLabelWidthCons.constant = 180;
    }else{
        self.tagLabelWidthCons.constant = 220;
    }
        
}


- (void)setDianniuQ_AViewModel:(DNDianniuQ_AViewModel *)dianniuQ_AViewModel{
    _dianniuQ_AViewModel = dianniuQ_AViewModel;
    [self configurCell];
    [self calculaCellHeight];
}

- (void)configurCell{
    self.nameLb.text = self.dianniuQ_AViewModel.name;
    self.tagLabel.text = self.dianniuQ_AViewModel.tagText;
    self.timeLabel.text = self.dianniuQ_AViewModel.time;
    [self configurCollectionView];
    if (_dianniuQ_AViewModel.isFriend) {
        self.addFriendBut.hidden = YES;
    }else{
        self.addFriendBut.hidden = NO;
    }
    self.praiseButn.selected = _dianniuQ_AViewModel.isPraise;
    [self.praiseButn setTitle:[NSString stringWithFormat:@"%ld",(long)self.dianniuQ_AViewModel.allPraiseCount] forState:UIControlStateSelected];
    [self.praiseButn setTitle:[NSString stringWithFormat:@"%ld",(long)self.dianniuQ_AViewModel.praiseCount] forState:UIControlStateNormal];
    [self.commentButn setTitle:[NSString stringWithFormat:@"%ld",(long)self.dianniuQ_AViewModel.answerCount] forState:UIControlStateNormal];
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:self.dianniuQ_AViewModel.hedaerImageStr]
                            placeholderImage:[UIImage imageNamed:@"default_head_icon"]];
}

- (void)configurCollectionView{
    CGSize size = [self calculaImages:self.dianniuQ_AViewModel.contentImageStrs];
    if (size.height == 0) {
        self.collectionView.hidden = YES;
        self.picCollectionViewBottomCons.constant = 0;
        self.collectionView.imageStrs = nil;
    }else{
        self.collectionView.imageStrs = self.dianniuQ_AViewModel.contentImageStrs;
        self.collectionView.hidden = NO;
        self.picCollectionViewBottomCons.constant = 8;
    }
    self.picCollectionViewWidthCons.constant  = size.width;
    self.picCollectionViewHeightCons.constant = size.height;
}

#pragma mark private calcula
- (void)calculaCellHeight{
    self.contentTextLb.text = _dianniuQ_AViewModel.text;
    if (_dianniuQ_AViewModel.cellHeight == 0) {
        _dianniuQ_AViewModel.cellHeight = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingExpandedSize].height + 1;
    }
}

- (CGSize)calculaImages:(NSArray <NSString *> *)imageStrs{
    CGSize collectionViewSize;
    if (imageStrs.count < 1) return CGSizeZero;
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout*)self.collectionView.collectionViewLayout;
    CGFloat imageWH = (ScreenWidth - 2 *DNDianniuQ_ACellEdgemargin - 2 *DNContentImageMargin)/3 -5;
    layout.itemSize = CGSizeMake(imageWH, imageWH);
    NSUInteger rows = (imageStrs.count - 1)/3 + 1;
    collectionViewSize.height = rows *imageWH + (rows -1) *DNContentImageMargin;
    collectionViewSize.width  = ScreenWidth - 2 *DNDianniuQ_ACellEdgemargin;
    
    return collectionViewSize;
}

#pragma mark - Event
- (IBAction)buttonAction:(UIButton *)sender {
    switch (sender.tag) {
        case DNCellToolBarButton_Forwarded:
            
            break;
            
        case DNCellToolBarButton_Praise:
            [self praiseRequest];
            break;
            
        case DNCellToolBarButton_Comment:
            
            break;
    }
}

- (IBAction)clickHederDetailView:(UITapGestureRecognizer *)sender {
    if (self.didClickDetailView) {
        self.didClickDetailView(self.dianniuQ_AViewModel);
    }
}


#pragma mark netWork
- (void)praiseRequest{
    DNQuestingPraiseRequestModel *model = [[DNQuestingPraiseRequestModel alloc] init];
    model.accountId  = [DNUser sheared].userId;
    model.questingId = self.dianniuQ_AViewModel.q_aModel.q_aId;
    [model httpRequest:15 success:^(NSURLSessionDataTask *sessionTask, id respondObj) {
        self.praiseButn.selected = !self.praiseButn.isSelected;
    } failed:^(NSURLSessionDataTask *sessionTask, NSError *error) {
       ///基类已经做了处理
    }];
}



@end
