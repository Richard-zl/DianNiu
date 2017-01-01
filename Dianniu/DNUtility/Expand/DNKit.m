//
//  DNKit.m
//  Dianniu
//
//  Created by RIMI on 2016/11/23.
//  Copyright © 2016年 Dianniu. All rights reserved.
//

#import "DNKit.h"
#import "DNPhone.h"
#import <CommonCrypto/CommonDigest.h>

@implementation DNKit

id DNAlert(NSString *title, NSString *msg, NSString *buttonText, void (^cancelBlock) ()){
    if ([[DNPhone shared].osver doubleValue] >= 8.0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:msg  preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:buttonText style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            if (cancelBlock) {
                cancelBlock();
            }
        }];
        [cancelAction setValue:DNThemeColor forKey:@"_titleTextColor"];
        [alertController addAction:cancelAction];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
        return alertController;
    }else{
        UIAlertView *alertView = [UIAlertView bk_showAlertViewWithTitle:title message:msg cancelButtonTitle:buttonText otherButtonTitles:nil handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex == [alertView cancelButtonIndex]) {
                if (cancelBlock) {
                    cancelBlock();
                }
            }
        }];
        [alertView bk_setWillShowBlock:^(UIAlertView *alert) {
            
        }];
        return alertView;
    }
}

id DNTextAlert(NSString *title, NSString *msg, NSArray *texts, void(^actionBlock)(NSInteger index)){
    
    if ([[DNPhone shared].osver doubleValue] >= 8.0) {
         UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:msg  preferredStyle:UIAlertControllerStyleAlert];
        for (NSString *text in texts) {
            UIAlertAction *action = [UIAlertAction actionWithTitle:text style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if (actionBlock) {
                    actionBlock([texts indexOfObject:text]);
                }
            }];
            [action setValue:DNThemeColor forKey:@"_titleTextColor"];
            [alertController addAction:action];
        }
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
        return alertController;
    }else{
        UIAlertView *alertView = [UIAlertView bk_showAlertViewWithTitle:title message:msg cancelButtonTitle:nil otherButtonTitles:texts handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
            if (actionBlock) {
                actionBlock(buttonIndex);
            }
        }];
        return alertView;
    }
}

void DNEvent(NSString *eventName, id data) {
    [[NSNotificationCenter defaultCenter] postNotificationName:eventName object:data];
}

void DNListenEvent(NSString *eventName, id target, SEL method) {
    [[NSNotificationCenter defaultCenter] addObserver:target selector:method name:eventName object:nil];
}

void DNForgetEvent(NSString *eventName, id target) {
    [[NSNotificationCenter defaultCenter] removeObserver:target name:eventName object:nil];
}

BOOL verifyPhoneNumber(NSString *num){
    BOOL isPass = NO;
    NSString *pattern = @"^1[34578]\\d{9}$";
    NSError  *error;
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray *results = [regex matchesInString:num options:NSMatchingReportProgress range:NSMakeRange(0, num.length)];
    
    for (NSInteger i = 0 ; i < results.count; i ++) {
        isPass =YES;
    }
    return isPass;
}



#pragma mark 数据处理相关
+ (NSString *)MD5:(NSString *)s {
    if (!s) {
        return @"1";
    }
    
    const char *cStr = [s UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    return [[NSString stringWithFormat:
             @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
}

+ (NSString *)docmentsFilePath:(NSString *)fileNameOrRelPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = paths[0];
    return [path stringByAppendingPathComponent:fileNameOrRelPath];
}

//        unsigned int count = 0;
//        Ivar *ivars = class_copyIvarList([UIAlertView class], &count);
//        for (int i = 0; i<count; i++) {
//            // 取出成员变量
//            // Ivar ivar = (ivars + i);
//            Ivar ivar = ivars[i];
//            // 打印成员变量名字
//            NSLog(@"%s------%s", ivar_getName(ivar),ivar_getTypeEncoding(ivar));
//        }

@end
