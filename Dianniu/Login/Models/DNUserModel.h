//
//  QFUserModel.h
//  Dianniu
//
//  Created by RIMI on 2016/11/24.
//  Copyright © 2016年 Dianniu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DNUserModel : NSObject
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *headPc;
@property (nonatomic, copy) NSString *realName;
@property (nonatomic, copy) NSString *createDate;
@property (nonatomic, copy) NSString *describe;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, assign) NSInteger authLevel;

+ (instancetype)modelWithUserDictionary:(NSDictionary *)dict;

@end
