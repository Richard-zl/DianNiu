//
//  DNJobListRequest.m
//  Dianniu
//
//  Created by RIMI on 2017/1/24.
//  Copyright © 2017年 Dianniu. All rights reserved.
//

#import "DNJobListRequest.h"

@implementation DNJobListRequest
- (NSString *)requestAddressUrl{
    return @"";
}

- (NSString *)requestActionString{
    return @"account.job.list";
}

- (NSDictionary *)requestArguement{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:self.accountId forKey:@"accountId"];
    [param setObject:@(self.page) forKey:@"page"];
    [param setObject:@(20) forKey:@"rows"];
    [param setObject:@(self.type) forKey:@"type"];
    if (self.post) {
        [param setObject:self.post forKey:@"post"];
    }
    return param;
}

- (void)requestSuccess:(NSURLSessionDataTask *)sessionTask respond:(id)respObjc{
}
@end
