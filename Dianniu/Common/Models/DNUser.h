//
//  DNUser.h
//  Dianniu
//
//  Created by RIMI on 2016/11/24.
//  Copyright © 2016年 Dianniu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DNUserModel.h"

typedef enum : NSUInteger {
    DNUSerAuthLevel_NULL = 0,
    DNUSerAuthLevel_ONE,
    DNUSerAuthLevel_TWO,
    DNUSerAuthLevel_THIRD
} DNUSerAuthLevel;

@interface DNUser : NSObject<NSCoding>

@property (nonatomic, copy)   NSString *token;
@property (nonatomic, copy)   NSNumber *userId;
@property (nonatomic, copy)   NSString *joinDate;
@property (nonatomic, strong) NSURL    *headerImgURL;
@property (nonatomic, copy)   NSString *realName;
@property (nonatomic, assign) DNUSerAuthLevel authLevel;
@property (nonatomic, copy)   NSString *userDesription;
@property (nonatomic, copy)   NSNumber *mobile;


+ (instancetype)sheared;
- (void)clearDNUser;
- (void)configurDNUser:(DNUserModel *)userModel;
- (DNUser *)load:(NSString *)userId;
- (BOOL)dump;
@end
