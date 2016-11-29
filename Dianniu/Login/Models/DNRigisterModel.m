//
//  DNRigisterModel.m
//  Dianniu
//
//  Created by RIMI on 2016/11/24.
//  Copyright © 2016年 Dianniu. All rights reserved.
//

#import "DNRigisterModel.h"

@implementation DNRigisterModel
- (NSString *)requestAddressUrl{
    return @"";
}

- (NSString *)requestActionString{
    return @"account.register";
}

- (NSDictionary *)requestArguement{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:self.mobile forKey:@"mobile"];
    [param setValue:self.code forKey:@"code"];
    [param setValue:self.pwd forKey:@"pwd"];
    [param setValue:@"app" forKey:@"channel"];
    return param;
}

- (void)requestSuccess:(NSURLSessionDataTask *)sessionTask respond:(id)respObjc{
    
}
@end
