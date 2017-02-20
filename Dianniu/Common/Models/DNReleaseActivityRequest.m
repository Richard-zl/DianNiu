//
//  DNReleaseActivityRequest.m
//  Dianniu
//
//  Created by RIMI on 2017/2/17.
//  Copyright © 2017年 Dianniu. All rights reserved.
//

#import "DNReleaseActivityRequest.h"

@implementation DNReleaseActivityRequest
- (NSString *)requestAddressUrl{
    return @"";
}

- (NSString *)requestActionString{
    return @"account.activity.add";
}

- (NSDictionary *)requestArguement{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[DNUser sheared].userId forKey:@"accountId"];
    [param setObject:self.title forKey:@"subject"];
    [param setObject:self.startDate forKey:@"startDate"];
    [param setObject:self.address forKey:@"address"];
    [param setObject:self.number forKey:@"persionCountSection"];
    if (self.number.length < 3) {
        [param setObject:[self.number substringWithRange:NSMakeRange(0, 1)] forKey:@"maxPersionCount"];
    }else{
        NSString *str = [[self.number componentsSeparatedByString:@"-"] lastObject];
        str = [[str componentsSeparatedByString:@"人"] firstObject];
        [param setObject:str forKey:@"maxPersionCount"];
    }
    ;
    [param setObject:self.payType forKey:@"costType"];
    if (self.amount) {
        [param setObject:self.amount forKey:@"costTypeContent"];
    }
    [param setObject:self.tags forKey:@"labels"];
    [param setObject:self.content forKey:@"content"];
    [param setObject:@(self.coord.longitude) forKey:@"longitude"];
    [param setObject:@(self.coord.latitude) forKey:@"latitude"];
    return param;
}

- (void)requestSuccess:(NSURLSessionDataTask *)sessionTask respond:(id)respObjc{
}
@end
