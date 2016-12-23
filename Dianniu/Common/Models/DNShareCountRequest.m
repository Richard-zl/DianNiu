//
//  DNShareCountRequest.m
//  Dianniu
//
//  Created by RIMI on 2016/12/22.
//  Copyright © 2016年 Dianniu. All rights reserved.
//

#import "DNShareCountRequest.h"

@implementation DNShareCountRequest
- (NSString *)requestAddressUrl{
    return @"";
}

- (NSString *)requestActionString{
    return @"account.quest.share.add";
}

- (NSDictionary *)requestArguement{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:self.accountId forKey:@"accountId"];
    [param setObject:self.questId forKey:@"questId"];
    [param setObject:@(self.platform) forKey:@"platform"];
    return param;
}

- (void)requestSuccess:(NSURLSessionDataTask *)sessionTask respond:(id)respObjc{
}
@end
