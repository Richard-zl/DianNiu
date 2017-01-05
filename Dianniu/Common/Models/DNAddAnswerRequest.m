//
//  DNAddAnswerRequest.m
//  Dianniu
//
//  Created by RIMI on 2017/1/3.
//  Copyright © 2017年 Dianniu. All rights reserved.
//

#import "DNAddAnswerRequest.h"

@implementation DNAddAnswerRequest
- (NSString *)requestAddressUrl{
    return @"";
}

- (NSString *)requestActionString{
    return @"account.quest.answer.add";
}

- (NSDictionary *)requestArguement{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:self.questId forKey:@"questId"];
    [param setObject:self.content forKey:@"content"];
    [param setObject:self.accountId forKey:@"accountId"];
    return param;
}

- (void)requestSuccess:(NSURLSessionDataTask *)sessionTask respond:(id)respObjc{
}
@end
