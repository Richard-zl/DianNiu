//
//  DNActivityListRequest.m
//  Dianniu
//
//  Created by RIMI on 2017/2/11.
//  Copyright © 2017年 Dianniu. All rights reserved.
//

#import "DNActivityListRequest.h"

@implementation DNActivityListRequest
- (NSString *)requestAddressUrl{
    return @"";
}

- (NSString *)requestActionString{
    return @"account.activity.list";
}

- (NSDictionary *)requestArguement{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:self.accountId forKey:@"accountId"];
    if (self.loaction) {
        if (![self.loaction hasSuffix:@"市"]) {
            self.loaction = [self.loaction stringByAppendingString:@"市"];
        }
        [param setObject:self.loaction forKey:@"address"];
    }
//#warning 测试用 需要删除
//    [param setObject:@"台州市" forKey:@"address"];
    [param setObject:@(self.activityType) forKey:@"type"];
    [param setObject:@(self.page) forKey:@"page"];
    [param setObject:@(20) forKey:@"rows"];
    return param;
}

- (void)requestSuccess:(NSURLSessionDataTask *)sessionTask respond:(id)respObjc{
}
@end
