//
//  DNDianniuQ_AViewModel.m
//  Dianniu
//
//  Created by RIMI on 2016/11/29.
//  Copyright © 2016年 Dianniu. All rights reserved.
//

#import "DNDianniuQ_AViewModel.h"

@implementation DNDianniuQ_AViewModel

- (instancetype)initWithQ_AModel:(DNDianniuQ_AModel *)model{
    self = [super init];
    if (self) {
        self.name        = model.aliasName;
//        self.time =
        self.tagText     = model.label;
        self.text        = model.content;
        self.isFriend    = model.isFriend;
        self.praiseCount = model.goodCount;
        self.answerCount = model.answerCount;
    }
    
    return self;
}
//时间转换

@end
