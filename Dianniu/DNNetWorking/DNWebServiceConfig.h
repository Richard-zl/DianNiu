//
//  DNWebServiceConfig.h
//  Dianniu
//
//  Created by RIMI on 2016/11/21.
//  Copyright © 2016年 Dianniu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef enum : NSUInteger {
    DNWebServiceENV_product,
    DNWebServiceENV_Release,
} DNWebServiceENV;

@interface DNWebServiceConfig : NSObject
@property (nonatomic, copy ,readonly)   NSString *addressDomain;
@property (nonatomic, strong ,readonly) AFHTTPSessionManager *normalHttpManager;

+ (instancetype)shared;

- (void)confirmENV:(DNWebServiceENV)env;
@end
