//
//  DNPhone.h
//  Dianniu
//
//  Created by RIMI on 2016/11/21.
//  Copyright © 2016年 Dianniu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DNPhone : NSObject
@property (nonatomic, copy) NSString *os;         //系统
@property (nonatomic, copy) NSString *osver;      //系统版本
@property (nonatomic, copy) NSString *phoneModel; //设备模式
@property (nonatomic, copy) NSString *newworkType;//网络类型
@property (nonatomic, copy) NSString *udid;       //手机唯一标示但其实是获取adid,因为2013年苹果宣布获取udid会被拒


+ (instancetype)shared;

@end
