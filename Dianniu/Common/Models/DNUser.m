//
//  DNUser.m
//  Dianniu
//
//  Created by RIMI on 2016/11/24.
//  Copyright © 2016年 Dianniu. All rights reserved.
//

#import "DNUser.h"
#import <objc/runtime.h>
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
        self.sex = 3;
        if (userid) {
            [self load:userid];
        }
    }
    return self;
}

- (DNUser *)load:(NSNumber *)userId{
    if (userId.intValue < 1) {
        return  self;
    }
    NSString *fileName = [NSString stringWithFormat:@"%@/dn.temp",[DNKit MD5:[NSString stringWithFormat:@"%@",userId]]];
    NSString *filePath = [DNKit docmentsFilePath:fileName];
    DNUser *user;
    user = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    if (user) {
        u_int count;
        objc_property_t *properties  =class_copyPropertyList([DNUser class], &count);
        for (int i = 0; i<count; i++){
            const char* chars =property_getName(properties[i]);
            NSString *property = [NSString stringWithUTF8String:chars];
            if ([user valueForKey:property]) {
                [self setValue:[user valueForKey:property] forKey:property];
            }
        }
        free(properties);
    }
    
    return self;
}

- (BOOL)dump{
    if (!_userId) {
        return NO;
    }
    
    NSString *dirPath  = [DNKit docmentsFilePath:[DNKit MD5:[NSString stringWithFormat:@"%@",self.userId]]];
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
    self.tag    = userModel.label;
    self.allowviewpro = !userModel.dataPrivacy;
    self.canAddfriend = !userModel.beFriend;
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
        self.tag          = [aDecoder decodeObjectForKey:@"tag"];
        self.sex          = [aDecoder decodeIntegerForKey:@"sex"];
        self.canAddfriend = [aDecoder decodeBoolForKey:@"canAddfriend"];
        self.allowviewpro = [aDecoder decodeBoolForKey:@"allowviewpro"];
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
    [aCoder encodeObject:self.tag forKey:@"tag"];
    [aCoder encodeInteger:self.sex forKey:@"sex"];
    [aCoder encodeBool:self.allowviewpro forKey:@"allowviewpro"];
    [aCoder encodeBool:self.canAddfriend forKey:@"canAddfriend"];
}

#pragma mark - getter
- (NSString *)sexString{
    if (self.sex == 0) {
        return @"女";
    }else if(self.sex == 1){
        return @"男";
    }
    return @"";
}

@end
