//
//  DNUserDetailRequest.m
//  Dianniu
//
//  Created by RIMI on 2016/12/19.
//  Copyright © 2016年 Dianniu. All rights reserved.
//

#import "DNUserDetailRequest.h"

@implementation DNUserDetailRequest
- (NSString *)requestAddressUrl{
    return @"";
}

- (NSString *)requestActionString{
    return @"account.detail";
}

- (NSDictionary *)requestArguement{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:self.accountId forKey:@"accountId"];
    [param setObject:self.friendAccountId forKey:@"friendAccountId"];
    return param;
}

- (void)requestSuccess:(NSURLSessionDataTask *)sessionTask respond:(id)respObjc{
}
@end
