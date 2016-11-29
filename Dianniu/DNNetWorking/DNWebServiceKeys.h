//
//  DNWebServiceKeys.h
//  Dianniu
//
//  Created by RIMI on 2016/11/21.
//  Copyright © 2016年 Dianniu. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const kDNRespCode;//返回码
extern NSString *const kDNRespData;//返回数据
extern NSString *const kDNRespMsg; //返回数据说明

extern NSString *const kDNReqCommand; //请求:command参数(所有参数父节点)
extern NSString *const kDNRReqAction; //请求:action参数(用于路由具体接口)
extern NSString *const kDNReqArgs;    //请求:args参数(具体接口需要的参数)
extern NSString *const kDNReqToken;

//Json字符串,如
//{"command":{"action":"test.get","args":{"resultStr":"123"}}}

