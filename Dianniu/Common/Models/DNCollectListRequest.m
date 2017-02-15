//
//  DNCollectListRequest.m
//  Dianniu
//
//  Created by RIMI on 2017/1/12.
//  Copyright © 2017年 Dianniu. All rights reserved.
//

#import "DNCollectListRequest.h"

@implementation DNCollectListRequest
- (NSString *)requestAddressUrl{
    return @"";
}

- (NSString *)requestActionString{
    return @"account.collect.list";
}

- (NSDictionary *)requestArguement{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:self.accountId forKey:@"accountId"];
    [param setObject:@(self.page) forKey:@"page"];
    [param setObject:@(20) forKey:@"rows"];
    return param;
}

- (void)requestSuccess:(NSURLSessionDataTask *)sessionTask respond:(id)respObjc{
}
@end
