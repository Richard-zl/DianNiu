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
        self.name        = model.realName.length > 0? model.realName:model.aliasName;
        self.time = [self convertDateString:model.createDate];
        self.tagText     = model.label;
        self.text        = model.content;
        self.isFriend    = model.isFriend;
        self.praiseCount = model.goodCount;
        self.answerCount = model.answerCount;
        self.cellHeight  = 0;
        self.isPraise    = model.isGood;
        self.contentImageStrs  = [self parserImageUrlstring:model.questImgs];
        self.hedaerImageStr = [self createURLString:model.headPic];
        self.q_aModel    = model;
        [self dealPraiseCount];
    }
    
    return self;
}

- (void)dealPraiseCount{
    self.allPraiseCount = self.praiseCount;
    if (self.isPraise) {
        self.praiseCount-=1;
    }else{
        self.allPraiseCount+=1;
    }
}

//根据服务器返回的阿里云图片名生成完整的url
- (NSString *)createURLString:(NSString *)nameStr{
    
    if (!nameStr && nameStr.length < 1)return nil;
    return [DNAliSDKManager aliMediaSDKImagePath:nameStr];
}

- (NSArray *)parserImageUrlstring:(NSString *)picStr{
    NSMutableArray *resultArr = [NSMutableArray array];
    if (picStr && picStr.length > 0) {
        NSArray *strArr = [picStr componentsSeparatedByString:@","];
        for (NSString *nameStr in strArr) {
            [resultArr addObject:[self createURLString:nameStr]];
        }
    }
    return [resultArr copy];
}

//时间转换
- (NSString *)convertDateString:(NSString *)dateString{
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    formater.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    formater.locale     = [NSLocale localeWithLocaleIdentifier:@"en"];
    NSDate *date        = [formater dateFromString:dateString];
    NSDate *nowDate     = [NSDate date];
 
    NSTimeInterval interval = [nowDate timeIntervalSinceDate:date];
    if (interval < 60) {
        return @"刚刚";
    }
    
    if (interval < 60 * 60) {
        return [NSString stringWithFormat:@"%ld分钟前",(NSInteger)interval/60];
    }
    
    if (interval < 60 * 60 * 24) {
        return [NSString stringWithFormat:@"%ld小时前",(NSInteger)interval/60/60];
    }
    
    NSCalendar *calender = [NSCalendar currentCalendar];
    if ([calender isDateInYesterday:date]) {
        formater.dateFormat = @"昨天 HH:mm";
        return [formater stringFromDate:date];
    }
    
    NSDateComponents* comp = [calender components:NSCalendarUnitYear fromDate:date toDate:nowDate options:NSCalendarWrapComponents];
    if (comp.year < 1) {
        formater.dateFormat = @"MM-dd HH:mm";
        return [formater stringFromDate:date];
    }
    
    formater.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return [formater stringFromDate:date];
}
@end
