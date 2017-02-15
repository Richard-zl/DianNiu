//
//  DNQ_ADetailHederView.m
//  Dianniu
//
//  Created by RIMI on 2016/12/14.
//  Copyright © 2016年 Dianniu. All rights reserved.
//

#import "DNQ_ADetailHederView.h"
#import <UIImageView+WebCache.h>
#import "DNContentImageCollectionView.h"

#define DNDianniuQ_ACellEdgemargin 25
#define DNContentImageMargin   5

@interface DNQ_ADetailHederView ()
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UILabel *tagLb;
@property (weak, nonatomic) IBOutlet UIButton *addFriendBut;

///匿名问答详情属性
@property (weak, nonatomic) IBOutlet UILabel *nickNameLb;

///共有属性
@property (weak, nonatomic) IBOutlet UILabel *contentLb;
@property (weak, nonatomic) IBOutlet UILabel *forwardKeyLb;
@property (weak, nonatomic) IBOutlet UILabel *forwardValueLb;
@property (weak, nonatomic) IBOutlet UILabel *praiseValueLb;
@property (weak, nonatomic) IBOutlet UILabel *answerValueLb;
@property (weak, nonatomic) IBOutlet DNContentImageCollectionView *collectionView;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLbWidthCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeightCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewWidthCons;


@end

@implementation DNQ_ADetailHederView
- (void)awakeFromNib{
    [super awakeFromNib];
    self.addFriendBut.layer.borderWidth = 1.0;
    self.addFriendBut.layer.borderColor = DNThemeColor.CGColor;
    self.contentLbWidthCons.constant = ScreenWidth - 50;
    self.width = ScreenWidth;
}

- (void)setType:(DNHomeListType)type{
    _type = type;
    if (_type == DNHomeListType_anonymity) {
        [self hiddenDianniuQ_AProperty];
    }
}

- (void)setModel:(DNDianniuQ_AViewModel *)model{
    _model = model;
    [self configurSubViewsWithModel:model];
    CGFloat height = [self calculateViewHeight];
    self.height = height;
    _model.cellHeight = height;
}


#pragma mark UI Private func
- (void)hiddenDianniuQ_AProperty{
    if (self.nameLb.isHidden) return;
    for (UIView *subView in self.nameLb.superview.subviews) {
        if (subView.isHidden) {
            subView.hidden = NO;
        }else{
            subView.hidden = YES;
        }
    }
}

- (void)configurSubViewsWithModel:(DNDianniuQ_AViewModel *)model{
    if (self.type == DNHomeListType_anonymity) {
        //匿名问答详情
        [self configurAnonymityQ_ASubViews:model];
    }else{
        //电钮问答详情
        [self configurDianniuQ_ASubViews:model];
    }
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:model.hedaerImageStr]
                            placeholderImage:[UIImage imageNamed:@"default_head_icon"]];
    self.contentLb.text     = model.text;
    self.praiseValueLb.text = [NSString stringWithFormat:@"%ld",(long)model.praiseCount];
    self.answerValueLb.text = [NSString stringWithFormat:@"%ld",(long)model.answerCount];
    [self configCollectionView];
    if (model.isHot) {
        self.contentLb.textColor = UIColorFromRGB(0x7D72FA);
    }
}

- (void)configurDianniuQ_ASubViews:(DNDianniuQ_AViewModel *)model{
    self.nameLb.text = model.name;
    self.tagLb.text  = model.tagText;
    self.forwardKeyLb.text = @"谁看过";
    self.forwardValueLb.text = [NSString stringWithFormat:@"%ld",(long)model.q_aModel.visitorCount];
}

- (void)configurAnonymityQ_ASubViews:(DNDianniuQ_AViewModel *)model{
    self.nickNameLb.text = model.q_aModel.aliasName;
    self.forwardKeyLb.text = @"转发";
    self.forwardValueLb.text = [NSString stringWithFormat:@"%ld",(long)model.q_aModel.forwardCount];
}

- (void)configCollectionView{
    CGSize size = [self calculaImages:_model.contentImageStrs];
    if (size.width == 0 && size.height == 0) {
        self.collectionView.hidden = YES;
    }else{
        self.collectionView.hidden = NO;
        self.collectionView.imageStrs = _model.contentImageStrs;
    }
    self.collectionViewWidthCons.constant  = size.width;
    self.collectionViewHeightCons.constant = size.height;
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

- (CGFloat)calculateViewHeight{
    //计算出来比实际要高五十 这个问题待解决
    /*(已解决) 因为XIB创建出来时宽度是按照iphone6的尺寸，显示在6plus上高度就会多，显示在iphone5上宽度就不够*/
    return [self systemLayoutSizeFittingSize:UILayoutFittingExpandedSize].height + 1;
}

#pragma mark - Event
- (IBAction)cilickHederView:(id)sender {
    if (self.didClickDetailView) {
        self.didClickDetailView();
    }
}

@end
