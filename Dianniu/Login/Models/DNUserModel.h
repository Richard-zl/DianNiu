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
@property (nonatomic, copy) NSNumber *userId;
@property (nonatomic, copy) NSString *headPc;
@property (nonatomic, copy) NSString *realName;
@property (nonatomic, copy) NSString *createDate;
@property (nonatomic, copy) NSString *describe;
@property (nonatomic, copy) NSString *label;
@property (nonatomic, copy) NSNumber *mobile;
@property (nonatomic, assign) NSInteger authLevel;
@property (nonatomic, assign) NSInteger dataPrivacy; //0所有人可见，1好友可见
@property (nonatomic, assign) NSInteger beFriend;    //0所有人可加好友，1不可加好友

+ (instancetype)modelWithUserDictionary:(NSDictionary *)dict;

@end
