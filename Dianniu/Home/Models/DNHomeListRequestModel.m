//
//  DNHomeListRequestModel.m
//  Dianniu
//
//  Created by RIMI on 2016/11/25.
//  Copyright © 2016年 Dianniu. All rights reserved.
//

#import "DNHomeListRequestModel.h"

@implementation DNHomeListRequestModel

- (NSString *)requestAddressUrl{
    return @"";
}

- (NSString *)requestActionString{
    return @"account.quest.list";
}

- (NSDictionary *)requestArguement{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (self.accountId) {
        [param setValue:self.accountId forKey:@"accountId"];
    }
    [param setValue:@(self.type) forKey:@"type"];
    [param setValue:self.page forKey:@"page"];
    [param setValue:self.counts forKey:@"rows"];
    
    return param;
}

- (void)requestSuccess:(NSURLSessionDataTask *)sessionTask respond:(id)respObjc{
}

@end
