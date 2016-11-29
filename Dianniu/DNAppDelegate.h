//
//  AppDelegate.h
//  Dianniu
//
//  Created by RIMI on 2016/11/15.
//  Copyright © 2016年 Dianniu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DNTabBarController.h"

@interface DNAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic ,strong) DNTabBarController *tableBarC;

- (void)showHomeViewC;
- (void)showLoginViewC;
@end

