//
//  DNLabelSetCell.m
//  Dianniu
//
//  Created by RIMI on 2017/1/6.
//  Copyright © 2017年 Dianniu. All rights reserved.
//

#import "DNLabelSetCell.h"

@implementation DNLabelSetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.titleBut setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] size:self.titleBut.size] forState:UIControlStateNormal];
    [self.titleBut setBackgroundImage:[UIImage imageWithColor:DNThemeColor size:self.titleBut.size] forState:UIControlStateSelected];
    [self.titleBut setBackgroundImage:[UIImage imageWithColor:DNThemeColor size:self.titleBut.size] forState:UIControlStateHighlighted];
}
- (IBAction)buttonAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (self.didSelected) {
        self.didSelected(sender.isSelected,self.indexPath,sender);
    }
}

@end
