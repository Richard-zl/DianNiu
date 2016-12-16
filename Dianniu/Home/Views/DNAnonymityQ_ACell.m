//
//  DNAnonymityQ_ACell.m
//  Dianniu
//
//  Created by RIMI on 2016/12/13.
//  Copyright © 2016年 Dianniu. All rights reserved.
//

#import "DNAnonymityQ_ACell.h"
#import "DNContentImageCollectionView.h"

@interface DNAnonymityQ_ACell ()
#define DNDianniuQ_ACellEdgemargin 25
#define DNContentImageMargin   5

@property (weak, nonatomic) IBOutlet UILabel *contentLb;
@property (weak, nonatomic) IBOutlet UIButton *transpondBut;
@property (weak, nonatomic) IBOutlet UIButton *praiseBut;
@property (weak, nonatomic) IBOutlet UIButton *commentBut;
@property (weak, nonatomic) IBOutlet DNContentImageCollectionView *collectionView;

///约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewBottomCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeightCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewWidthCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLbWidthCons;

@end

@implementation DNAnonymityQ_ACell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.collectionView.scrollEnabled = NO;
    self.contentLbWidthCons.constant = ScreenWidth - 2 * DNDianniuQ_ACellEdgemargin;
}

- (void)setDianniuQ_AViewModel:(DNDianniuQ_AViewModel *)dianniuQ_AViewModel{
    _dianniuQ_AViewModel = dianniuQ_AViewModel;
    [self configurCell];
    [self calculaCellHeight];
}

- (void)configurCell{
    if (self.dianniuQ_AViewModel.isPraise) {
        [self.praiseBut setSelected:YES];
        [self.transpondBut setTitle:[NSString stringWithFormat:@"%ld",(long)self.dianniuQ_AViewModel.q_aModel.forwardCount] forState:UIControlStateSelected];
    }else{
        [self.praiseBut setSelected:NO];
    }
    [self.transpondBut setTitle:[NSString stringWithFormat:@"%ld",(long)self.dianniuQ_AViewModel.q_aModel.forwardCount] forState:UIControlStateNormal];
    [self.praiseBut setTitle:[NSString stringWithFormat:@"%ld",(long)self.dianniuQ_AViewModel.praiseCount] forState:UIControlStateNormal];
    [self.commentBut setTitle:[NSString stringWithFormat:@"%ld",(long)self.dianniuQ_AViewModel.answerCount] forState:UIControlStateNormal];
    [self configurCollectionView];
}

- (void)configurCollectionView{
    CGSize size = [self calculaImages:self.dianniuQ_AViewModel.contentImageStrs];
    if (size.height == 0) {
        self.collectionView.hidden = YES;
        self.collectionViewBottomCons.constant = 0;
        self.collectionView.imageStrs = nil;
    }else{
        self.collectionView.imageStrs = self.dianniuQ_AViewModel.contentImageStrs;
        self.collectionView.hidden = NO;
        self.collectionViewBottomCons.constant = 8;
    }
    self.collectionViewWidthCons.constant  = size.width;
    self.collectionViewHeightCons.constant = size.height;
}

#pragma mark private calcula
- (void)calculaCellHeight{
    self.contentLb.text = _dianniuQ_AViewModel.text;
    if (_dianniuQ_AViewModel.cellHeight == 0) {
        CGFloat cellHeight = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingExpandedSize].height + 1;
        _dianniuQ_AViewModel.cellHeight = cellHeight;
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


#pragma mark netWork
- (void)praiseRequest{
    DNQuestingPraiseRequestModel *model = [[DNQuestingPraiseRequestModel alloc] init];
    model.accountId  = [DNUser sheared].userId;
    model.questingId = self.dianniuQ_AViewModel.q_aModel.q_aId;
    [model httpRequest:15 success:^(NSURLSessionDataTask *sessionTask, id respondObj) {
        self.praiseBut.selected = !self.praiseBut.isSelected;
        if (self.praiseBut.isSelected) {
            [self.praiseBut setTitle:[NSString stringWithFormat:@"%ld",(long)self.dianniuQ_AViewModel.praiseCount + 1] forState:UIControlStateSelected];
        }
    } failed:^(NSURLSessionDataTask *sessionTask, NSError *error) {
        ///基类已经做了处理
    }];
}

@end
