//
//  DNAliSDKManager.m
//  Dianniu
//
//  Created by RIMI on 2016/12/2.
//  Copyright © 2016年 Dianniu. All rights reserved.
//

#import "DNAliSDKManager.h"

@implementation DNAliSDKManager
static id<ALBBMediaServiceProtocol>alMediaSDKInstance = nil;
#pragma mark - 阿里百川SDK实例相关
+ (id<ALBBMediaServiceProtocol>)sharedALMediaSDK{
    if (!alMediaSDKInstance) {
        alMediaSDKInstance = [ALBBMediaServiceFactory getService:[DNAliTokenGenerator new]];
    }
    return alMediaSDKInstance;
}

+ (NSString *)aliMediaSDKLoadImage:(NSString *)filePath Progress:(DNAliSDKImageLoadProgress)progressb Success:(DNAliSDKImageLoadSuccess)success failed:(DNAliSDKImageLoadFailed)failed{
    
    if (!filePath) return @"";
    
    TFELoadNotification *notice = [TFELoadNotification notificationWithProgress:^(TFELoadSession *session, NSUInteger progress) {
        if (progressb)progressb(session,progress);
    } success:^(TFELoadSession *session, NSData *responseData) {
        if (success)success(session,[UIImage imageWithData:responseData]);
    } failed:^(TFELoadSession *session, NSError *error) {
        if (failed)failed(session,error);
    }];
    return [[DNAliSDKManager sharedALMediaSDK] asynLoad:filePath notifications:notice];
}

+ (NSString *)aliMediaSDKImagePath:(NSString *)fileName{
    return [NSString stringWithFormat:@"http://%@/%@/%@",kDNKeyAliMediaSDKImageDomain,kDNKeyAliMediaSDKImageDir,fileName];
}
@end


@implementation DNAliTokenGenerator

- (NSString *)generateToken:(TFEUploadPolicy *)policy{
    return [DNUser sheared].token;
}

@end
