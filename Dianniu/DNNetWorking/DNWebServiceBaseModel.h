//
//  DNWebServiceBaseModel.h
//  Dianniu
//
//  Created by RIMI on 2016/11/21.
//  Copyright © 2016年 Dianniu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DNWebServiceConfig.h"

typedef enum : NSUInteger {
    DNRequestType_GET,
    DNRequestType_POST,
} DNRequestType;

typedef void(^DNNetWorkSuccess)(NSURLSessionDataTask *sessionTask, id respondObj);
typedef void(^DNNetWorkFailed)(NSURLSessionDataTask *sessionTask, NSError *error);

@interface DNWebServiceBaseModel : NSObject

- (void)handleFailByRespondCode:(id)redpCode respond:(id)respondObjc;//服务器返回不为0的失败,如果不想基类做处理可重写该方法
- (NSString *)requestAddressUrl;
- (NSString *)requestActionString;
- (NSDictionary *)requestArguement;
- (DNRequestType)requestType;
    

- (void)httpRequest:(NSInteger)timeout success:(DNNetWorkSuccess)successBlock failed:(DNNetWorkFailed)failedBlock;
- (void)cancelCurrentRequest;
- (void)suspend;
- (void)resume;

- (void)requestSuccess:(NSURLSessionDataTask *)sessionTask respond:(id)respObjc;
- (void)requestFailed:(NSURLSessionDataTask *)sessionTask error:(NSError *)err;
@end
