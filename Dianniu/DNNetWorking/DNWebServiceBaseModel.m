//
//  DNWebServiceBaseModel.m
//  Dianniu
//
//  Created by RIMI on 2016/11/21.
//  Copyright © 2016年 Dianniu. All rights reserved.
//

#import "DNWebServiceBaseModel.h"
#import "DNWebServiceKeys.h"

@interface DNWebServiceBaseModel ()

@property (nonatomic ,strong) NSURLSessionTask *sessionTask;

@end

@implementation DNWebServiceBaseModel

#pragma mark - public
- (void)httpRequest:(NSInteger)timeout success:(DNNetWorkSuccess)successBlock failed:(DNNetWorkFailed)failedBlock{
    
    AFHTTPSessionManager *manager       = [DNWebServiceConfig shared].normalHttpManager;
    NSError  *serializationError        = nil;
    
    NSMutableURLRequest *mutableRequest = [manager.requestSerializer requestWithMethod:[self requestMethod] URLString:[self packageRequestURL] parameters:[self packgeRequestParam] error:&serializationError];
    
    if (serializationError) {
        dispatch_async(dispatch_get_main_queue(), ^{
            failedBlock(nil,serializationError);
            [self requestFailed:nil error:serializationError];
        });
        return;
    }
    [mutableRequest setTimeoutInterval:timeout];
    
    __block NSURLSessionDataTask *sessionTask = [manager dataTaskWithRequest:mutableRequest completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
    
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                [self requestFailed:sessionTask error:error];
                if (failedBlock) {
                    failedBlock(sessionTask,error);
                }
            }else{
                [self preprocessRespond:responseObject session:sessionTask success:successBlock failed:failedBlock];
            }
        });

    }];
    _sessionTask = sessionTask;
    [sessionTask resume];
}

- (void)cancelCurrentRequest{
    if (_sessionTask && _sessionTask.currentRequest) {
        [_sessionTask cancel];
    }
}
- (void)suspend{
    if (_sessionTask && _sessionTask.currentRequest) {
        [_sessionTask suspend];
    }
}
- (void)resume{
    if (_sessionTask && _sessionTask.currentRequest) {
        [_sessionTask resume];
    }
}

#pragma mark - privite
- (NSDictionary *)packgeRequestParam{
    NSMutableDictionary *requestDict = [NSMutableDictionary dictionary];
    NSMutableDictionary *paramDict   = [NSMutableDictionary dictionary];
    [paramDict setValue:[self requestActionString] forKey:kDNRReqAction];
    [paramDict setValue:[self requestArguement] forKey:kDNReqArgs];
    [requestDict setValue:paramDict forKey:kDNReqCommand];
    [requestDict setValue:[DNUser sheared].token forKey:kDNReqToken];
    
    return requestDict;
}
- (NSString *)packageRequestURL{
    NSString *reqUrl = [self requestAddressUrl];
    if (![reqUrl hasPrefix:@"http"]) {
        reqUrl = [DNWebServiceConfig shared].addressDomain;
    }
    
    return reqUrl;
}
- (NSString *)requestMethod{
    NSString *requestMethod;
    if ([self requestType] == DNRequestType_POST) {
        requestMethod = @"POST";
    }else{
        requestMethod = @"GET";
    }
    return requestMethod;
}

- (void)preprocessRespond:(id _Nullable)respondObjc session:(NSURLSessionDataTask *)sessionTask success:(DNNetWorkSuccess) successB failed:(DNNetWorkFailed)faildB{
    if (respondObjc) {
        if ([respondObjc[kDNRespCode] integerValue] == 0 ) {
            //返回码是0代表成功
            [self requestSuccess:sessionTask respond:respondObjc[kDNRespData]];
            if (successB) {
                successB(sessionTask,respondObjc[kDNRespData]);
            }
        }else{
            //返回码不为0为失败
            if (faildB) {
                faildB(sessionTask,nil);
            }
            [self handleFailByRespondCode:respondObjc[kDNRespCode] respond:respondObjc];
            [self requestFailed:sessionTask error:nil];
        }
    }else{
        [self requestFailed:sessionTask error:nil];
    }
    
}
- (void)handleFailByRespondCode:(id)redpCode respond:(id)respondObjc{
    //这个方法里应该判断具体的返回码 804为未登录或session过期
    NSString *respMsg = respondObjc[kDNRespMsg];
    switch ([redpCode integerValue]) {
        case 804:
        case 800:
        //这儿做退出登录 并且回到登录页的逻辑
        DNEvent(kDNKeyNoticeLogout, nil);
        DNAlert(@"提示", @"登陆已过期，请重新登陆", @"确定", nil);
        break;
        
        default:
        break;
    }
    [SVProgressHUD showErrorWithStatus:respMsg];
}

#pragma mark - override metheds
- (NSString *)requestAddressUrl{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (NSString *)requestActionString{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (NSDictionary *)requestArguement{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}
    
- (DNRequestType)requestType{
    return DNRequestType_POST;
}

- (void)requestSuccess:(NSURLSessionDataTask *)sessionTask respond:(id)respObjc{
    
}

- (void)requestFailed:(NSURLSessionDataTask *)sessionTask error:(NSError *)err{
    if (err) {
        [SVProgressHUD showErrorWithStatus:@"网络不好,请稍后再试"];
    }
}

@end
