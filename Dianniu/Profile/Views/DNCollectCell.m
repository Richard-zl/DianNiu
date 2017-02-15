//
//  DNCollectCell.m
//  Dianniu
//
//  Created by RIMI on 2017/1/12.
//  Copyright © 2017年 Dianniu. All rights reserved.
//

#import "DNCollectCell.h"
@interface DNCollectCell ()
@property (weak, nonatomic) IBOutlet UILabel *contentLb;
@property (weak, nonatomic) IBOutlet UILabel *timeLb;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLbCons;

@end
@implementation DNCollectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentLbCons.constant = ScreenWidth - 16;
}

- (void)setViewModel:(DNDianniuQ_AViewModel *)viewModel{
    _viewModel = viewModel;
    [self updateSubViews];
    if (_viewModel.cellHeight == 0) {
        _viewModel.cellHeight= [self.contentView systemLayoutSizeFittingSize:UILayoutFittingExpandedSize].height + 1;
    }
}

- (void)updateSubViews{
    self.contentLb.text = _viewModel.text;
    self.timeLb.text    = _viewModel.time;
    if (_viewModel.isHot) {
        self.contentLb.textColor = UIColorFromRGB(0x7D72FA);
    }
}

@end
