//
//  AppDelegate.m
//  Dianniu
//
//  Created by RIMI on 2016/11/15.
//  Copyright © 2016年 Dianniu. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewC.h"
#import "DNWebServiceConfig.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[LoginViewC alloc] initWithNibName:@"LoginViewC" bundle:nil];
    [self.window makeKeyAndVisible];
    
    [self configurGlobal];
    

    return YES;
}

- (void)configurGlobal{
    [[DNWebServiceConfig shared] confirmENV:DNWebServiceENV_Release];
    [SVProgressHUD setBackgroundColor:[DNThemeColor colorWithAlphaComponent:0.9]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
}


@end
