//
//  DNCollectRequest.m
//  Dianniu
//
//  Created by RIMI on 2016/12/26.
//  Copyright © 2016年 Dianniu. All rights reserved.
//

#import "DNCollectRequest.h"

@implementation DNCollectRequest
- (NSString *)requestAddressUrl{
    return @"";
}

- (NSString *)requestActionString{
    return @"account.collect.addOrDel";
}

- (NSDictionary *)requestArguement{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:self.accountId forKey:@"accountId"];
    [param setObject:self.questId forKey:@"questId"];
    return param;
}

- (void)requestSuccess:(NSURLSessionDataTask *)sessionTask respond:(id)respObjc{
}
@end
