//
//  DNAliSDKManager.h
//  Dianniu
//
//  Created by RIMI on 2016/12/2.
//  Copyright © 2016年 Dianniu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ALBBMediaService/ALBBMediaService.h>
// 阿里百川SDK实例相关
@class DNAliTokenGenerator;



typedef void(^DNAliSDKImageLoadProgress)(TFELoadSession *taskSession,NSUInteger progress);
typedef void(^DNAliSDKImageLoadSuccess)(TFELoadSession *taskSession,UIImage *image);
typedef void(^DNAliSDKImageLoadFailed)(TFELoadSession *taskSession,NSError *error);

@interface DNAliSDKManager : NSObject
+ (id<ALBBMediaServiceProtocol>)sharedALMediaSDK;



+ (NSString *)aliMediaSDKLoadImage:(NSString *)filePath Progress:(DNAliSDKImageLoadProgress)progressb Success:(DNAliSDKImageLoadSuccess)success failed:(DNAliSDKImageLoadFailed)failed;

//根据图片名字获取阿里云的图片url
+ (NSString *)aliMediaSDKImagePath:(NSString *)fileName;
@end

@interface DNAliTokenGenerator : NSObject<TFETokenGenerator>

@end
