//
//  DNAliSDKManager.h
//  Dianniu
//
//  Created by RIMI on 2016/12/2.
//  Copyright © 2016年 Dianniu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ALBBMediaService/ALBBMediaService.h>
#import <ALBBMediaService/ALBBWantu.h>
// 阿里百川SDK实例相关
typedef void(^DNAliSDKUploadProgress)(CGFloat progress);
typedef void(^DNAliSDKUploadSuccess)(NSString *url, NSString *fileName);
typedef void(^DNAliSDKUploadFailed)(NSError *error);

@interface DNAliSDKManager : NSObject
+ (ALBBWantu *)sharedALMediaSDK;
+ (void)uploadWithData:(NSData *)data progress:(DNAliSDKUploadProgress)progress success:(DNAliSDKUploadSuccess)success failed:(DNAliSDKUploadFailed)failed;
+ (void)cancelAll;
//根据图片名字获取阿里云的图片url
+ (NSString *)aliMediaSDKImagePath:(NSString *)fileName;

@end

