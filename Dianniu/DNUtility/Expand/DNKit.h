//
//  DNKit.h
//  Dianniu
//
//  Created by RIMI on 2016/11/23.
//  Copyright © 2016年 Dianniu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DNKit : NSObject

/** 快速弹出提醒窗口 */
id DNAlert(NSString *title, NSString *msg, NSString *buttonText, void (^cancelBlock) ());

/** 快速发送一个事件 */
void DNEvent(NSString *eventName, id data);

/** 快速注册事件侦听 */
void DNListenEvent(NSString *eventName, id target, SEL method);

/** 快速注销事件侦听 */
void DNForgetEvent(NSString *eventName, id target);

/** 验证手机号是否有效 */
BOOL verifyPhoneNumber(NSString *num);


#pragma mark 数据处理相关
/** 得到字符串的MD5值
 * @param str 需要计算MD5的字符串
 */
+ (NSString *)MD5:(NSString *)str;

+ (NSString *)docmentsFilePath:(NSString *)fileNameOrRelPath;

@end
