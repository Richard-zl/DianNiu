//
//  NSArray+FixNilBug.m
//  NetworkDemo
//
//  Created by mac on 16/1/22.
//  Copyright © 2016年 qfpay. All rights reserved.
//

#import "NSArray+FixNilBug.h"

@implementation NSArray(FixNilBug)

+ (instancetype)arrayWithObjects:(const id  _Nonnull __unsafe_unretained *)objects count:(NSUInteger)cnt
{
    const id  _Nonnull __unsafe_unretained *objsPtr = objects;
    
    NSMutableArray *modifyArray = [NSMutableArray array];
    for (int i = 0; i < cnt; i++, objsPtr++) {
        if (*objsPtr == 0) {
            continue;
        }
        [modifyArray addObject:*objsPtr];
    }
    return modifyArray;
}

+ (instancetype)arrayWithObjects:(id)firstObj, ...
{
    NSMutableArray *array = [NSMutableArray array];
    
    if (!firstObj ) {
        return nil;
    }
    id tempObject = nil;
    
    va_list argumentList;
    
    va_start(argumentList, firstObj);
    
    tempObject = firstObj;

    if (firstObj != nil) {
        [array addObject:tempObject];
        
        while ((tempObject = va_arg(argumentList, id))) {
            if (tempObject != nil) {
                [array addObject:tempObject];
            }else{
                break;
            }
        }
    }

    va_end(argumentList);
    
    return array;

}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
- (instancetype)initWithObjects:(const id  _Nonnull __unsafe_unretained *)objects count:(NSUInteger)cnt
{
    const id  _Nonnull __unsafe_unretained *objsPtr = objects;
    
    NSMutableArray *modifyArray = [NSMutableArray array];
    for (int i = 0; i < cnt; i++, objsPtr++) {
        if (*objsPtr == 0) {
            continue;
        }
        [modifyArray addObject:*objsPtr];
    }
    return modifyArray;
}

#pragma clang diagnostic pop

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-designated-initializers"
- (instancetype)initWithObjects:(id)firstObj, ...
{
    NSMutableArray *array = [NSMutableArray array];
    
    id tempObject = nil;
    
    va_list argumentList;
    
    va_start(argumentList, firstObj);
    
    tempObject = firstObj;
    
    if (firstObj != nil) {
        [array addObject:tempObject];
        
        while ((tempObject = va_arg(argumentList, id))) {
            if (tempObject != nil) {
                [array addObject:tempObject];
            }else{
                break;
            }
        }
    }
    
    va_end(argumentList);
    
    return array;
}

#pragma clang diagnostic pop
@end
