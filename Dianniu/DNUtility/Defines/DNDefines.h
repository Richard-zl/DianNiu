//
//  DNDefines.h
//  Dianniu
//
//  Created by RIMI on 2016/11/22.
//  Copyright © 2016年 Dianniu. All rights reserved.
//

#import "DNAppDelegate.h"

#ifndef DNDefines_h
#define DNDefines_h

#define DNSharedDelegate ((DNAppDelegate *)[[UIApplication sharedApplication] delegate])

/***
 ***rgb颜色转换（16进制->10进制）
 ***/
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define UIColorFromRGBWithAlpha(rgbValue,alpha) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(alpha)]
#define RGBColor(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
//定制好的颜色
#define DNThemeColor RGBColor(72,201,169)

//设备的⾼高度
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height //设备的宽度
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width

#define DNWeakself typeof(self) __weak weakSelf = self;
#define DNWeakObject(o) typeof(o) __weak weakObject = o;
#endif /* DNDefines_h */
typedef enum : NSUInteger {
    DNCellToolBarButton_Forwarded = 0,///转发
    DNCellToolBarButton_Praise,       ///点赞
    DNCellToolBarButton_Comment,      ///评论
} DNCellToolBarButton;
