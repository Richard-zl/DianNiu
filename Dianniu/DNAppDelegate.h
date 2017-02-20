//
//  AppDelegate.h
//  Dianniu
//
//  Created by RIMI on 2016/11/15.
//  Copyright © 2016年 Dianniu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DNTabBarController.h"
#import "BaiduMap_IOSSDK_v3.2.1_Lib/BaiduMapAPI_Base.framework/Headers/BMKMapManager.h"

@interface DNAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic ,strong) DNTabBarController *tableBarC;
@property (nonatomic, strong) BMKMapManager *mapManager;
- (void)showHomeViewC;
- (void)showLoginViewC;
@end

