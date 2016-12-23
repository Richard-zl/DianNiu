//
//  DNAddFirendRequest.m
//  Dianniu
//
//  Created by RIMI on 2016/12/21.
//  Copyright © 2016年 Dianniu. All rights reserved.
//

#import "DNAddFirendRequest.h"
//添加好友
@implementation DNAddFirendRequest
- (NSString *)requestAddressUrl{
    return @"";
}

- (NSString *)requestActionString{
    return @"account.friend.add";
}

- (NSDictionary *)requestArguement{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:self.accountId forKey:@"accountId"];
    [param setObject:self.friendAccountId forKey:@"friendAccountId"];
    return param;
}

- (void)requestSuccess:(NSURLSessionDataTask *)sessionTask respond:(id)respObjc{
}
@end
