//
//  DNQuestionsSearchRequest.m
//  Dianniu
//
//  Created by RIMI on 2017/1/20.
//  Copyright © 2017年 Dianniu. All rights reserved.
//

#import "DNQuestionsSearchRequest.h"

@implementation DNQuestionsSearchRequest
- (NSString *)requestAddressUrl{
    return @"";
}

- (NSString *)requestActionString{
    return @"account.quest.search";
}

- (NSDictionary *)requestArguement{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:self.accountId forKey:@"accountId"];
    [param setObject:@(self.page) forKey:@"page"];
    [param setObject:@(20) forKey:@"rows"];
    [param setObject:@(self.type) forKey:@"type"];
    [param setObject:self.content forKey:@"content"];
    return param;
}

- (void)requestSuccess:(NSURLSessionDataTask *)sessionTask respond:(id)respObjc{
}
@end
