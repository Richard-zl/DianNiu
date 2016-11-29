//
//  DNUser.m
//  Dianniu
//
//  Created by RIMI on 2016/11/24.
//  Copyright © 2016年 Dianniu. All rights reserved.
//

#import "DNUser.h"

static DNUser *sharedUser;

@implementation DNUser

+ (instancetype)sheared{
    
    //clearUser时会把instance赋空,如果用gdc实现单例则退出登录后该方法永远返回空值
    @synchronized (self) {
        if (!sharedUser) {
            sharedUser = [[DNUser alloc] init];
        }
    }
    return sharedUser;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        NSString *userid = [DNKeychain load:kDNKeychainLastUserId];
        if (userid) {
            [self load:userid];
        }
    }
    return self;
}

- (DNUser *)load:(NSString *)userId{
    if (userId.length < 1) {
        return  self;
    }
    NSString *fileName = [NSString stringWithFormat:@"%@/dn.temp",[DNKit MD5:userId]];
    NSString *filePath = [DNKit docmentsFilePath:fileName];
    DNUser *user;
    user = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    if (user) {
        self.userId = user.userId;
        self.token  = user.token;
        self.joinDate = user.joinDate;
        self.headerImgURL = user.headerImgURL;
        self.realName = user.realName;
        self.authLevel = user.authLevel;
        self.userDesription = user.userDesription;
        self.mobile = user.mobile;
    }
    
    return self;
}

- (BOOL)dump{
    if (!_userId) {
        return NO;
    }
    
    NSString *dirPath  = [DNKit docmentsFilePath:[DNKit MD5:self.userId]];
    NSString *filePath = [NSString stringWithFormat:@"%@/dn.temp",dirPath];
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSError *err;
    [fileManager createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:&err];
    
    BOOL b = [NSKeyedArchiver archiveRootObject:[DNUser sheared] toFile:filePath];
    return b;
}

- (void)configurDNUser:(DNUserModel *)userModel{
    self.userId = userModel.userId;
    self.token  = userModel.token;
    self.joinDate = userModel.createDate;
    self.headerImgURL = [NSURL URLWithString:userModel.headPc];
    self.authLevel = userModel.authLevel;
    self.userDesription = userModel.describe == nil? @"这家伙很懒,什么都没留下":userModel.describe;
    self.realName = userModel.realName;
    self.mobile = userModel.mobile;
    [self dump];
}

- (void)clearDNUser{
    if (sharedUser) {
        sharedUser.token  = nil;
        [sharedUser dump];
        sharedUser.userId = nil;
        sharedUser = nil;
    }
}

// ****** 归/解档  *******
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        self.token        = [aDecoder decodeObjectForKey:@"token"];
        self.userId       = [aDecoder decodeObjectForKey:@"userId"];
        self.joinDate     = [aDecoder decodeObjectForKey:@"joinDate"];
        self.headerImgURL = [aDecoder decodeObjectForKey:@"image"];
        self.realName     = [aDecoder decodeObjectForKey:@"name"];
        self.authLevel    = [aDecoder decodeIntegerForKey:@"level"];
        self.userDesription = [aDecoder decodeObjectForKey:@"userD"];
        self.mobile       = [aDecoder decodeObjectForKey:@"mobile"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.token forKey:@"token"];
    [aCoder encodeObject:self.userId forKey:@"userId"];
    [aCoder encodeObject:self.joinDate forKey:@"joinDate"];
    [aCoder encodeObject:self.headerImgURL forKey:@"image"];
    [aCoder encodeObject:self.realName forKey:@"name"];
    [aCoder encodeInteger:self.authLevel forKey:@"level"];
    [aCoder encodeObject:self.userDesription forKey:@"userD"];
    [aCoder encodeObject:self.mobile forKey:@"mobile"];
}

@end