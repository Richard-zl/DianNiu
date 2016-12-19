//
//  NSDictionary+FixNilBug.h
//  NetworkDemo
//
//  Created by mac on 16/1/22.
//  Copyright © 2016年 qfpay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (FixNilBug)

/***
 *** 字典转jsonString
 ***/
- (NSString *)jsonString;

@end
