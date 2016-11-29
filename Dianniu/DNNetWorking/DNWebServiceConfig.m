//
//  DNWebServiceConfig.m
//  Dianniu
//
//  Created by RIMI on 2016/11/21.
//  Copyright © 2016年 Dianniu. All rights reserved.
//

#import "DNWebServiceConfig.h"

#define Domain_Release @"http://api.dianniuapp.com"
#define DOmain_Product @"http://118.178.189.156:8080/dianniu/batch/json"

DNWebServiceConfig *instance;
@implementation DNWebServiceConfig
+ (instancetype)shared{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[DNWebServiceConfig alloc] init];
    });
    
    return instance;
}

- (void)confirmENV:(DNWebServiceENV)env{
    if (env == DNWebServiceENV_Release) {
        _addressDomain = Domain_Release;
    }else{
        _addressDomain = DOmain_Product;
    }
}

- (instancetype)init{
    self = [super init];
    if (self) {
        _normalHttpManager = [AFHTTPSessionManager manager];
        _normalHttpManager.requestSerializer  = [AFJSONRequestSerializer serializer];
        _normalHttpManager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        //使用https的时候再设置安全策略 先预留
        //_normalHttpManager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        
    }
    return self;
}

@end
