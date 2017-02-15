//
//  DNAddJobRecruitRequest.m
//  Dianniu
//
//  Created by RIMI on 2017/2/9.
//  Copyright © 2017年 Dianniu. All rights reserved.
//

#import "DNAddJobRecruitRequest.h"

@implementation DNAddJobRecruitRequest

- (NSString *)requestAddressUrl{
    return @"";
}

- (NSString *)requestActionString{
    if (self.type == DNRecruitDetailType_JOB) {
        return @"account.job.add";
    }else{
        return @"account.recruit.add";
    }
}

- (NSDictionary *)requestArguement{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:self.accountId forKey:@"accountId"];
    [param setObject:self.post forKey:@"post"];
    [param setObject:self.salary forKey:@"salary"];
    [param setObject:self.tryout forKey:@"tryout"];
    [param setObject:self.area forKey:@"address"];
    if (self.experience) {
        [param setObject:self.experience forKey:@"experience"];
    }else{
        [param setObject:self.recruitNumber forKey:@"recruitCount"];
    }
    [param setObject:self.education forKey:@"education"];
    [param setObject:self.describe forKey:@"describe"];
    [param setObject:self.contact forKey:@"contactWay"];
    return param;
}

- (void)requestSuccess:(NSURLSessionDataTask *)sessionTask respond:(id)respObjc{
}

@end
