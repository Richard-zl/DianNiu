//
//  DNActivityDetailRequest.m
//  Dianniu
//
//  Created by RIMI on 2017/2/13.
//  Copyright © 2017年 Dianniu. All rights reserved.
//

#import "DNActivityDetailRequest.h"

@implementation DNActivityDetailRequest
- (NSString *)requestAddressUrl{
    return @"";
}

- (NSString *)requestActionString{
    return @"account.activity.detail";
}

- (NSDictionary *)requestArguement{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[DNUser sheared].userId forKey:@"accountId"];
    [param setObject:self.activityId forKey:@"activityId"];

    return param;
}

- (void)requestSuccess:(NSURLSessionDataTask *)sessionTask respond:(id)respObjc{
}
@end
