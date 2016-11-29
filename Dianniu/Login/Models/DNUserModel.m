//
//  QFUserModel.m
//  Dianniu
//
//  Created by RIMI on 2016/11/24.
//  Copyright © 2016年 Dianniu. All rights reserved.
//

#import "DNUserModel.h"
#import "DNWebServiceKeys.h"

@implementation DNUserModel

+ (instancetype)modelWithUserDictionary:(NSDictionary *)dict{
    DNUserModel *model = [[DNUserModel alloc] init];
    NSDictionary *userDic = dict[@"accountInfo"];
    if (userDic.allKeys > 0) {
        [model setValuesForKeysWithDictionary:userDic];
    }
    model.token = dict[kDNReqToken];
    model.userId = [userDic[@"id"] stringValue];
    return model;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{};

@end
