//
//  DNQuestingPraiseRequestModel.m
//  Dianniu
//
//  Created by RIMI on 2016/12/13.
//  Copyright © 2016年 Dianniu. All rights reserved.
//

#import "DNQuestingPraiseRequestModel.h"

@implementation DNQuestingPraiseRequestModel
- (NSString *)requestAddressUrl{
    return @"";
}

- (NSString *)requestActionString{
    return @"account.quest.good.add";
}

- (NSDictionary *)requestArguement{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (self.accountId) {
        [param setValue:self.accountId forKey:@"accountId"];
    }
    [param setObject:self.accountId forKey:@"accountId"];
    [param setObject:self.questingId forKey:@"questId"];
    
    return param;
}

- (void)requestSuccess:(NSURLSessionDataTask *)sessionTask respond:(id)respObjc{
}
@end
