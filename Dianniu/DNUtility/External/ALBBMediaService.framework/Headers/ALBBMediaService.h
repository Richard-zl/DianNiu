//
//  ALBBMediaService.h
//  ALBBMediaService
//
//  Created by XuPeng on 16/9/8.
//  Copyright © 2016年 Alipay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MediaLoadProtocol.h"

@interface ALBBMediaService : NSObject<MediaLoadProtocol>

/**
 * 配置是否使用spdy来加载图片
 */
@property(nonatomic) BOOL useSpdy;

/**
 * ALBBMediaService初始化，同步执行
 */
+ (void)syncInit;

/**
 *  返回单例
 */
+ (instancetype)sharedInstance;

/**
 *  设置是否开启Debug，显示Debug日志
 */
+ (void)setDebug:(BOOL)debug;
@end