//
//  DNUserDetailModel.m
//  Dianniu
//
//  Created by RIMI on 2016/12/19.
//  Copyright © 2016年 Dianniu. All rights reserved.
//

#import "DNUserDetailModel.h"

@implementation DNUserDetailModel

- (instancetype)initWhitDictionary:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
        self.unableBeFriend = [dict[@"beFriend"] boolValue];
        self.userId = dict[@"id"];
        [self dealHederImage];
    }
    return self;
}

- (void)dealHederImage{
    if (self.headPic.length > 0) {
        self.headPic = [DNAliSDKManager aliMediaSDKImagePath:self.headPic];
    }
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{};

- (void)setValue:(id)value forKey:(NSString *)key{
    if (value &&
        key &&
        ![value isKindOfClass:[NSNull class]] &&
        ![key isKindOfClass:[NSNull class]]) {
        [super setValue:value forKey:key];
    }
}

@end
