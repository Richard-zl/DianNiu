//
//  DNPhone.m
//  Dianniu
//
//  Created by RIMI on 2016/11/21.
//  Copyright © 2016年 Dianniu. All rights reserved.
//

#import "DNPhone.h"
#import <AdSupport/AdSupport.h>
static DNPhone *inst = nil;
@interface DNPhone ()<CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLGeocoder *geoCoder;
@end

@implementation DNPhone

+ (instancetype)shared{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        inst = [[DNPhone alloc] init];
    });
    
    return inst;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        self.os = @"i";
        self.osver = [[UIDevice currentDevice] systemVersion];
        self.phoneModel = [[UIDevice currentDevice] model];
        self.udid = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
        self.newworkType = @"nuConnect";
        self.locationManager = [[CLLocationManager alloc] init];
        self.city = @"未知";
        //设置代理
        self.locationManager.delegate = self;
        //设置定位精度
        self.locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        //定位频率,每隔多少米定位一次
        CLLocationDistance distance = 1000.0;//100米定位一次
        self.locationManager.distanceFilter=distance;
        self.geoCoder = [[CLGeocoder alloc] init];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self refreshCurrentLocation];
        });

    }
    
    return self;
}

- (void)refreshCurrentLocation
{
    if (![CLLocationManager locationServicesEnabled]) {
        
        if ([[DNPhone shared].osver doubleValue] >= 8.0) {
            
            NSLog(@"请在手机设置里面允许电钮访问您的位置信息");
        }else{
            NSLog(@"请在手机设置里面允许电钮访问您的位置信息");
        }
        
        return;
    }
    
    //如果没有授权则请求用户授权
    if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined){
        
        if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            [self.locationManager requestAlwaysAuthorization];
        }
        
        if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [self.locationManager requestWhenInUseAuthorization];
        }
        
    }else {
        if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied) {
            //用户拒绝使用定位
            dispatch_async(dispatch_get_main_queue(), ^{
                DNTextAlert(@"提示", @"电纽没有权限获取您的位置，请到设置里允许电纽访问", @[@"取消",@"确定"], ^(NSInteger index) {
                    if (index != 0) {
                        if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                        }else{
                            NSURL *url = [NSURL URLWithString:@"prefs:root=General"];
                            if ([[UIApplication sharedApplication] canOpenURL:url])
                            {
                                [[UIApplication sharedApplication] openURL:url];
                            }else{
                                NSLog(@"can not open");
                            }
                        }
                    }
                });
            });
        }else{
            //设置代理
            self.locationManager.delegate=self;
            //设置定位精度
            self.locationManager.desiredAccuracy=kCLLocationAccuracyBest;
            //定位频率,每隔多少米定位一次
            CLLocationDistance distance = 100.0;//100米定位一次
            
            self.locationManager.distanceFilter=distance;
            //启动跟踪定位
            [self.locationManager startUpdatingLocation];
        }
    }
    
}


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    CLLocationCoordinate2D coor = newLocation.coordinate;
    self.coord = coor;
    [DNPhone shared].lon = [NSString stringWithFormat:@"%@", @(coor.longitude)];
    [DNPhone shared].lat = [NSString stringWithFormat:@"%@", @(coor.latitude)];
    //将更新过的GPS信息写入到NSUserDefaults中
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@", @(coor.longitude)] forKey:@"gpslon"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@", @(coor.latitude)] forKey:@"gpslat"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.geoCoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (!error && placemarks.count > 0) {
            CLPlacemark *place = [placemarks firstObject];
            NSString *city = place.locality;
            if (!city) {
                city = city;
            }
            [DNPhone shared].city = place.locality;
        }
    }];
    [[DNPhone shared].locationManager stopUpdatingLocation];
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    [self.locationManager stopUpdatingLocation];
    
    if ([[error domain] isEqualToString:kCLErrorDomain] && [error code] == kCLErrorDenied) {
    }
}

#pragma mark getter
- (NSString *)selectCity{
    if (!_selectCity || _selectCity.length < 1) {
        _selectCity = self.city;
    }
    return _selectCity;
}


@end
