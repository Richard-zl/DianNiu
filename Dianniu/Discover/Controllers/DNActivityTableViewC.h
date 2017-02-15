//
//  DNNearByTableViewC.h
//  Dianniu
//
//  Created by RIMI on 2017/2/9.
//  Copyright © 2017年 Dianniu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    DNActivityType_Nearby = 1,
    DNActivityType_join,
    DNActivityType_My,
} DNActivityType;
#define DNTableViewTipLabelTag 0x1234
@interface DNActivityTableViewC : UIViewController
@property (nonatomic, assign)DNActivityType activityType;
@end
