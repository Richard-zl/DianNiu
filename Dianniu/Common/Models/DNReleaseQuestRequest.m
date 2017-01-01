//
//  DNReleaseQuestRequest.m
//  Dianniu
//
//  Created by RIMI on 2016/12/27.
//  Copyright © 2016年 Dianniu. All rights reserved.
//

#import "DNReleaseQuestRequest.h"

@implementation DNReleaseQuestRequest
- (NSString *)requestAddressUrl{
    return @"";
}

- (NSString *)requestActionString{
    return @"account.quest.add";
}

- (NSDictionary *)requestArguement{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (self.accountId) {
        [param setObject:self.accountId forKey:@"accountId"];
    }
    if (self.questImgs) {
        [param setObject:self.questImgs forKey:@"questImgs"];
    }
    [param setObject:@(self.type) forKey:@"type"];
    [param setObject:self.content forKey:@"content"];
    return param;
}

- (void)requestSuccess:(NSURLSessionDataTask *)sessionTask respond:(id)respObjc{
}
@end
