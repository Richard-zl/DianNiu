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
@interface DNAppDelegate ()

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
    [SVProgressHUD setBackgroundColor:[DNThemeColor colorWithAlphaComponent:0.9]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];

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
    DNAlert(@"提示", @"登陆已过期，请重新登陆", @"确定", nil);
}


@end
