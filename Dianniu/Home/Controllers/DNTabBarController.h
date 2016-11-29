//
//  DNTabBarController.h
//  Dianniu
//
//  Created by RIMI on 2016/11/25.
//  Copyright © 2016年 Dianniu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DNTabSelectItem){
    DNTabSelectItem_HOME = 0,     //电钮
    DNTabSelectItem_DISCOVER,     //发现
    DNTabSelectItem_MESSAGE,      //消息
    DNTabSelectItem_PROFILE,      //个人中心
};

@interface DNTabBarController : UITabBarController

- (void)selectItemIndex:(DNTabSelectItem)itemIndex;

- (void)setBadege:(BOOL)IsDisplay andSender:(UIViewController *)sender;

@end
