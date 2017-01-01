//
//  DNShieldRequest.m
//  Dianniu
//
//  Created by RIMI on 2016/12/26.
//  Copyright © 2016年 Dianniu. All rights reserved.
//

#import "DNShieldRequest.h"

@implementation DNShieldRequest
- (NSString *)requestAddressUrl{
    return @"";
}

- (NSString *)requestActionString{
    return @"account.shield.addOrDel";
}

- (NSDictionary *)requestArguement{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:self.accountId forKey:@"accountId"];
    [param setObject:self.shieldAccountId forKey:@"shieldAccountId"];
    return param;
}

- (void)requestSuccess:(NSURLSessionDataTask *)sessionTask respond:(id)respObjc{
}
@end
