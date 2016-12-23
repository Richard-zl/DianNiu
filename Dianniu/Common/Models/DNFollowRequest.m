//
//  DNFollowRequest.m
//  Dianniu
//
//  Created by RIMI on 2016/12/21.
//  Copyright © 2016年 Dianniu. All rights reserved.
//

#import "DNFollowRequest.h"

//关注某人
@implementation DNFollowRequest
- (NSString *)requestAddressUrl{
    return @"";
}

- (NSString *)requestActionString{
    return @"account.follow.addOrDel";
}

- (NSDictionary *)requestArguement{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:self.accountId forKey:@"accountId"];
    [param setObject:self.friendAccountId forKey:@"followAccountId"];
    return param;
}

- (void)requestSuccess:(NSURLSessionDataTask *)sessionTask respond:(id)respObjc{
}
@end
