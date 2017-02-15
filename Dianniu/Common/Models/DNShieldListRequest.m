//
//  DNShieldListRequest.m
//  Dianniu
//
//  Created by RIMI on 2017/1/19.
//  Copyright © 2017年 Dianniu. All rights reserved.
//

#import "DNShieldListRequest.h"

@implementation DNShieldListRequest
- (NSString *)requestAddressUrl{
    return @"";
}

- (NSString *)requestActionString{
    if (self.listType == DNRequestListType_Shield) {
        return @"account.shield.list";
    }else{
        return @"account.black.list";
    }
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
