//
//  DNRecruitDetailRequest.m
//  Dianniu
//
//  Created by RIMI on 2017/1/24.
//  Copyright © 2017年 Dianniu. All rights reserved.
//

#import "DNRecruitDetailRequest.h"

@implementation DNRecruitDetailRequest
- (NSString *)requestAddressUrl{
    return @"";
}

- (NSString *)requestActionString{
    if (self.type == DNRecruitDetailType_RECRUIT) {
        return @"account.recruit.detail";
    }else{
        return @"account.job.detail";
    }
}

- (NSDictionary *)requestArguement{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:self.accountId forKey:@"accountId"];
    if (self.type == DNRecruitDetailType_RECRUIT) {
        [param setObject:self.requestId forKey:@"recruitId"];
    }else{
        [param setObject:self.requestId forKey:@"jobId"];
    }
    return param;
}

- (void)requestSuccess:(NSURLSessionDataTask *)sessionTask respond:(id)respObjc{
}
@end
