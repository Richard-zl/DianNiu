//
//  DNLoginModel.m
//  Dianniu
//
//  Created by RIMI on 2016/11/22.
//  Copyright © 2016年 Dianniu. All rights reserved.
//

#import "DNLoginModel.h"
#import "DNUserModel.h"

@implementation DNLoginModel

- (NSString *)requestAddressUrl{
   return @"";
}

- (NSString *)requestActionString{
   return @"account.login";
}

- (NSDictionary *)requestArguement{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:self.mobileNum forKey:@"mobile"];
    [param setValue:self.pwd forKey:@"pwd"];
    [param setValue:[DNPhone shared].udid forKey:@"deviceId"];
    [param setValue:[DNPhone shared].os forKey:@"deviceType"];
//    [param setValue:@"成都" forKey:@"lastLoginCity"];
    
    return param;
}

- (void)requestSuccess:(NSURLSessionDataTask *)sessionTask respond:(id)respObjc{
    DNUserModel *userModel = [DNUserModel modelWithUserDictionary:respObjc];
    [[DNUser sheared] configurDNUser:userModel];
    [DNKeychain save:kDNKeychainLastUserId data:[DNUser sheared].userId];
}



@end
