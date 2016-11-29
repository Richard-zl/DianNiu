//
//  DNVerifyCodeModel.m
//  Dianniu
//
//  Created by RIMI on 2016/11/23.
//  Copyright © 2016年 Dianniu. All rights reserved.
//

#import "DNVerifyCodeModel.h"

@implementation DNVerifyCodeModel
- (NSString *)requestAddressUrl{
    return @"";
}

- (NSString *)requestActionString{
    return @"register.code.get";
}

- (NSDictionary *)requestArguement{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:self.mobileNum forKey:@"mobile"];
    return param;
}

- (void)requestSuccess:(NSURLSessionDataTask *)sessionTask respond:(id)respObjc{
    
}
@end
