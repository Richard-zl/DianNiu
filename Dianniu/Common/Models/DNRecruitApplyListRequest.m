//
//  DNRecruitApplyListRequest.m
//  Dianniu
//
//  Created by RIMI on 2017/2/5.
//  Copyright © 2017年 Dianniu. All rights reserved.
//

#import "DNRecruitApplyListRequest.h"

@implementation DNRecruitApplyListRequest
- (NSString *)requestAddressUrl{
    return @"";
}

- (NSString *)requestActionString{
    return @"account.jobrecruit.list";
}

- (NSDictionary *)requestArguement{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:self.accountId forKey:@"accountId"];
    [param setObject:@(self.type) forKey:@"type"];
    [param setObject:@(self.page) forKey:@"page"];
    [param setObject:@(20) forKey:@"rows"];
    return param;
}

- (void)requestSuccess:(NSURLSessionDataTask *)sessionTask respond:(id)respObjc{
}

@end
