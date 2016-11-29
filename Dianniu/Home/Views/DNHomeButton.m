//
//  DNHomeButton.m
//  Dianniu
//
//  Created by RIMI on 2016/11/25.
//  Copyright © 2016年 Dianniu. All rights reserved.
//

#import "DNHomeButton.h"

@implementation DNHomeButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (void)setEnabled:(BOOL)enabled{
    if (!enabled) {
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[self titleForState:UIControlStateDisabled]];
        __block BOOL isSet = NO;
        [str enumerateAttribute:NSUnderlineStyleAttributeName inRange:NSMakeRange(0, str.length) options:NSAttributedStringEnumerationReverse usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
            if (value) {
                isSet = YES;
            }
        }];
        if (!isSet) {
             [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, str.length)];
            [self setAttributedTitle:str forState:UIControlStateDisabled];
        }
    }else{
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[self titleForState:UIControlStateNormal]];
        [self setAttributedTitle:str forState:UIControlStateNormal];
    }
    [super setEnabled:enabled];
}

@end
