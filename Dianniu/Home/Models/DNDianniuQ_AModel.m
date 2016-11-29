//
//  DNDianniuQ_AModel.m
//  Dianniu
//
//  Created by RIMI on 2016/11/29.
//  Copyright © 2016年 Dianniu. All rights reserved.
//

#import "DNDianniuQ_AModel.h"

@implementation DNDianniuQ_AModel

+ (instancetype)modelWithQ_ADictionary:(NSDictionary *)dataDic{
    DNDianniuQ_AModel *model = [[DNDianniuQ_AModel alloc] init];
    if (dataDic.allKeys > 0) {
        model.q_aId = dataDic[@"id"];
        [model setValuesForKeysWithDictionary:dataDic];
    }
    
    return model;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{};

@end
