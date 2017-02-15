//
//  DNMyAnswerCell.m
//  Dianniu
//
//  Created by RIMI on 2017/1/19.
//  Copyright © 2017年 Dianniu. All rights reserved.
//

#import "DNMyAnswerCell.h"
@interface DNMyAnswerCell ()
@property (weak, nonatomic) IBOutlet UILabel *contentLb;
@property (weak, nonatomic) IBOutlet UILabel *timeLb;
@property (weak, nonatomic) IBOutlet UILabel *answerLb;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLbWidthCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *answerLbWidthCons;


@end
@implementation DNMyAnswerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentLbWidthCons.constant = ScreenWidth - 16;
    self.answerLbWidthCons.constant  = ScreenWidth - 16;
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
    self.timeLb.text = _viewModel.time;
    self.answerLb.text = _viewModel.q_aModel.answerContent;
}


@end
