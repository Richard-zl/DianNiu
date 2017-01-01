//
//  DNAliSDKManager.m
//  Dianniu
//
//  Created by RIMI on 2016/12/2.
//  Copyright © 2016年 Dianniu. All rights reserved.
//

#import "DNAliSDKManager.h"
#import "DNPhone.h"

@implementation DNAliSDKManager
static ALBBWantu *alMediaSDKInstance = nil;
#pragma mark - 阿里百川SDK实例相关
+ (ALBBWantu *)sharedALMediaSDK{
    if (!alMediaSDKInstance) {
        alMediaSDKInstance = [ALBBWantu defaultWantu];
        
    }
    return alMediaSDKInstance;
}
+ (void)uploadWithData:(NSData *)data progress:(DNAliSDKUploadProgress)progress success:(DNAliSDKUploadSuccess)success failed:(DNAliSDKUploadFailed)failed{
    CFUUIDRef uuidRef = CFUUIDCreate(NULL);
    CFStringRef uuidStrRef= CFUUIDCreateString(NULL, uuidRef);
    CFRelease(uuidRef);
    NSString *retStr = (__bridge NSString *)uuidStrRef;
    retStr = [NSString stringWithFormat:@"image_%@",[retStr lowercaseString]];
    retStr = [retStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
    CFRelease(uuidStrRef);
    ALBBWTUploadDataRequest  *request = [ALBBWTUploadDataRequest new];
    request.content = data;
    request.fileName = @"";
    request.dir = kDNKeyAliMediaSDKImageDir;
    request.fileName = retStr;
    request.token = @"UPLOAD_AK_TOP MjM0MTA3NjI6ZXlKa1pYUmxZM1JOYVcxbElqb3hMQ0psZUhCcGNtRjBhVzl1SWpveE5EZzBOalF5TlRrMU9EUTRMQ0pwYm5ObGNuUlBibXg1SWpvd0xDSnVZVzFsYzNCaFkyVWlPaUprYVdGdWJtbDFJaXdpYzJsNlpVeHBiV2wwSWpvd2ZROmFkNjU4ZmE1OTM1YTYwNTIxYjk2OGNlNDMzOGE2NGY2OWI4MDg2ZTM";
    request.uploadProgress = ^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend){
        if (progress) {
            dispatch_async(dispatch_get_main_queue(), ^{
                progress(totalBytesSent/totalBytesExpectedToSend);
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD showProgress:totalBytesSent/totalBytesExpectedToSend status:@"正在上传"];
            });
        }
    };
    [[DNAliSDKManager sharedALMediaSDK] upload:request
                               completeHandler:^(ALBBWTUploadResponse *response, NSError *error) {
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       if (!progress) {
                                           [SVProgressHUD dismiss];
                                       }
                                       if (error) {
                                           //上传失败
                                           if (failed || response.url.length < 1) {
                                               failed(error);
                                           }
                                       }else{
                                           //上传成功
                                           if (success) {
                                               success(response.url,response.name);
                                           }
                                       }
                                   });
                               }];

}


+ (void)cancelAll{
}

+ (NSString *)aliMediaSDKImagePath:(NSString *)fileName{
    return [NSString stringWithFormat:@"http://%@/%@/%@",kDNKeyAliMediaSDKImageDomain,kDNKeyAliMediaSDKImageDir,fileName];
}
@end
