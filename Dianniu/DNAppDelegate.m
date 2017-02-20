//
//  AppDelegate.m
//  Dianniu
//
//  Created by RIMI on 2016/11/15.
//  Copyright © 2016年 Dianniu. All rights reserved.
//

#import "DNAppDelegate.h"
#import "LoginViewC.h"
#import "DNWebServiceConfig.h"
#import <ALBBMediaService/ALBBMediaService.h>
#import "DNShareSDKManager.h"
#import "DNPhone.h"
#import <AFNetworking.h>
@interface DNAppDelegate ()<BMKGeneralDelegate>

@end

@implementation DNAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    if ([self isLogin]) {
        [self showHomeViewC];
    }else{
        [self showLoginViewC];
    }
    
    [self configurGlobal];
    [self listenNotifications];
    [self.window makeKeyAndVisible];
    
    return YES;
}

//分享
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return [ShareSDK handleOpenURL:url
                        wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
}

#pragma mark - public
- (void)showHomeViewC{
    if (!self.tableBarC) {
        self.tableBarC = [[DNTabBarController alloc] init];
    }
    self.window.rootViewController = self.tableBarC;
}

- (void)showLoginViewC{
    LoginViewC *loginViewC = [[LoginViewC alloc] initWithNibName:@"LoginViewC" bundle:nil];
    self.window.rootViewController = loginViewC;
}

#pragma mark -private
- (void)configurGlobal{
    [[DNWebServiceConfig shared] confirmENV:DNWebServiceENV_product];
    [[DNShareSDKManager shared] configurSDK];
    [self configurMap];
    [DNPhone shared];
    [SVProgressHUD setBackgroundColor:[RGBColor(33, 33, 33) colorWithAlphaComponent:0.9]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
}

- (void)configurMap{
    _mapManager = [[BMKMapManager alloc] init];
    BOOL ret = [_mapManager start:@"XpNIoSGDuMM25m5II3XG8TrBneZ30kiW" generalDelegate:self];
    if (!ret) {
        NSLog(@"baiduMap start failed!");
    }
}

- (void)listenNotifications{
    DNListenEvent(kDNKeyNoticeLogout, self, @selector(logout));
}

- (BOOL)isLogin{
    return [DNUser sheared].token;
}

- (void)logout{
    [[DNUser sheared] clearDNUser];
    [self showLoginViewC];
}


#pragma mark - 百度地图代理
- (void)onGetNetworkState:(int)iError{
    if (iError != 0) {
        [SVProgressHUD showErrorWithStatus:@"网络不好，请稍后再试"];
    }
}

@end
