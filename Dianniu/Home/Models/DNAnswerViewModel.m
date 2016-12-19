//
//  DNAnswerViewModel.m
//  Dianniu
//
//  Created by RIMI on 2016/12/16.
//  Copyright © 2016年 Dianniu. All rights reserved.
//

#import "DNAnswerViewModel.h"

@implementation DNAnswerViewModel

- (instancetype)initWhitDictionary:(NSDictionary *)dict{
     self =  [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
        self.answerId = dict[@"id"];
        [self dealPraiseCount];
        self.cellHeight = 0;
    }
    return self;
}

- (void)dealPraiseCount{
    self.allGoodCount = self.goodCount;
    if (self.isGood) {
        //已经点赞
        self.goodCount-=1;
    }else{
        self.allGoodCount+=1;
    }
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{};
@end
