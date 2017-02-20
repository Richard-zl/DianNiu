//
//  DNPhone.h
//  Dianniu
//
//  Created by RIMI on 2016/11/21.
//  Copyright © 2016年 Dianniu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface DNPhone : NSObject
@property (nonatomic, copy) NSString *os;         //系统
@property (nonatomic, copy) NSString *osver;      //系统版本
@property (nonatomic, copy) NSString *phoneModel; //设备模式
@property (nonatomic, copy) NSString *newworkType;//网络类型
@property (nonatomic, copy) NSString *udid;       //手机唯一标示但其实是获取adid,因为2013年苹果宣布获取udid会被拒
@property (nonatomic, copy) NSString *lon; //精度
@property (nonatomic, copy) NSString *lat; //纬度
@property (nonatomic, copy) NSString *city; //定位城市
@property (nonatomic, copy) NSString *selectCity;
@property (nonatomic, assign) CLLocationCoordinate2D coord; //坐标
+ (instancetype)shared;


- (void)refreshCurrentLocation;
@end
