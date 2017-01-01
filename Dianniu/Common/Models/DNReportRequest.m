//
//  DNReportRequest.m
//  Dianniu
//
//  Created by RIMI on 2016/12/26.
//  Copyright © 2016年 Dianniu. All rights reserved.
//

#import "DNReportRequest.h"

@implementation DNReportRequest
- (NSString *)requestAddressUrl{
    return @"";
}

- (NSString *)requestActionString{
    return @"account.report.add";
}

- (NSDictionary *)requestArguement{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@(self.type) forKey:@"type"];
    [param setObject:self.reasonModel forKey:@"reasonModel"];
    [param setObject:self.targetId forKey:@"objId"];
    [param setObject:self.accountId forKey:@"accountId"];
    return param;
}

- (void)requestSuccess:(NSURLSessionDataTask *)sessionTask respond:(id)respObjc{
}
@end
