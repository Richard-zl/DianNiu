//
//  DNActivityJoinRequest.m
//  Dianniu
//
//  Created by RIMI on 2017/2/14.
//  Copyright © 2017年 Dianniu. All rights reserved.
//

#import "DNActivityJoinRequest.h"

@implementation DNActivityJoinRequest
- (NSString *)requestAddressUrl{
    return @"";
}

- (NSString *)requestActionString{
    return @"account.activity.join";
}

- (NSDictionary *)requestArguement{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[DNUser sheared].userId forKey:@"accountId"];
    [param setObject:self.activityId forKey:@"activityId"];
    [param setObject:@"" forKey:@"content"];
    return param;
}

- (void)requestSuccess:(NSURLSessionDataTask *)sessionTask respond:(id)respObjc{
}

@end
