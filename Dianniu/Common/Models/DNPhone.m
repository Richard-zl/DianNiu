//
//  DNPhone.m
//  Dianniu
//
//  Created by RIMI on 2016/11/21.
//  Copyright © 2016年 Dianniu. All rights reserved.
//

#import "DNPhone.h"
#import <AdSupport/AdSupport.h>

static DNPhone *inst = nil;

@implementation DNPhone

+ (instancetype)shared{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        inst = [[DNPhone alloc] init];
    });
    
    return inst;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        self.os = @"i";
        self.osver = [[UIDevice currentDevice] systemVersion];
        self.phoneModel = [[UIDevice currentDevice] model];
        self.udid = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
        self.newworkType = @"nuConnect";
    }
    
    return self;
}


@end
