//
//  DNRecruitAddRequest.m
//  Dianniu
//
//  Created by RIMI on 2017/1/25.
//  Copyright © 2017年 Dianniu. All rights reserved.
//

#import "DNRecruitAddRequest.h"

@implementation DNRecruitAddRequest
- (NSString *)requestAddressUrl{
    return @"";
}

- (NSString *)requestActionString{
    return @"account.jobrecruit.add";
}

- (NSDictionary *)requestArguement{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:self.accountId forKey:@"accountId"];
    [param setObject:self.requestId forKey:@"businessId"];
    [param setObject:@(self.type) forKey:@"type"];
    if (self.content) {
        [param setObject:self.content forKey:@"content"];
    }
    return param;
}

- (void)requestSuccess:(NSURLSessionDataTask *)sessionTask respond:(id)respObjc{
}

@end
