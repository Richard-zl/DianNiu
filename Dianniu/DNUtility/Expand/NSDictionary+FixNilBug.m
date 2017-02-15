//
//  NSDictionary+FixNilBug.m
//  NetworkDemo
//
//  Created by mac on 16/1/22.
//  Copyright © 2016年 qfpay. All rights reserved.
//

#import "NSDictionary+FixNilBug.h"

@implementation NSDictionary(FixNilBug)

+ (instancetype)dictionaryWithObjects:(const id  _Nonnull __unsafe_unretained *)objects forKeys:(const id<NSCopying>  _Nonnull __unsafe_unretained *)keys count:(NSUInteger)cnt
{
    NSUInteger keyCnt = 0, valueCnt = 0;
    const id  _Nonnull __unsafe_unretained *objPtr = objects; // 指向objects初始位置
    const id  _Nonnull __unsafe_unretained *keyPtr = keys;    // 指向keys初始位置
    // 遍历找到为key nil的位置
    for (   ; keyCnt < cnt; keyCnt ++, objPtr++) {
        if (*objPtr == 0)
        {
            break;
        }
    }
    // 遍历找到为key nil的位置
    for (   ; valueCnt < cnt; valueCnt ++, keyPtr++) {
        if (*keyPtr == 0) // 遍历找到为key nil的位置
        {
            break;
        }
    }
    // 找到最小值
    NSUInteger minCnt = MIN(keyCnt, valueCnt);
    // 构造合适的key,object array
    NSArray *vs = [NSArray arrayWithObjects:objects count:minCnt];
    NSArray *ks = [NSArray arrayWithObjects:keys count:minCnt];
    // 用下面的方法构造
    return [self dictionaryWithObjects:vs forKeys:ks];
}



+(instancetype)dictionaryWithObjectsAndKeys:(id)firstObject, ...
{
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    id eachObject;
    va_list argumentList;
    if (firstObject)
    {
        [objects addObject: firstObject];
        va_start(argumentList, firstObject);
        NSUInteger index = 1;
        while ((eachObject = va_arg(argumentList, id)))
        {
            (index++ & 0x01) ? [keys addObject: eachObject] : [objects addObject: eachObject];
        }
        va_end(argumentList);
    }
    
    
    if (objects.count == keys.count)
    {
        // 直接写空 跳到最后返回
    }
    else
    {
        (objects.count < keys.count)?[keys removeLastObject]:[objects removeLastObject];
    }
    
    return [self dictionaryWithObjects:objects forKeys:keys];
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

- (instancetype)initWithObjects:(const id  _Nonnull __unsafe_unretained *)objects forKeys:(const id<NSCopying>  _Nonnull __unsafe_unretained *)keys count:(NSUInteger)cnt
{
    const id  _Nonnull __unsafe_unretained *objsPtr = objects; //指向objects的初始位置
    const id  _Nonnull __unsafe_unretained *keysPtr = keys;   //纸箱keys的初始位置
    
    NSMutableArray *vArray = [[NSMutableArray alloc] initWithCapacity:1];
    NSMutableArray *kArray = [[NSMutableArray alloc] initWithCapacity:1];
    
    for (int i = 0; i < cnt; i++, objsPtr++, keysPtr++) {
        if (*objsPtr == 0 || *keysPtr == 0) {
            NSLog(@"Insert failed because value or key is null");
            continue;
        }
        [vArray addObject:*objsPtr];
        [kArray addObject:*keysPtr];
    }
    return [[NSDictionary alloc] initWithObjects:vArray forKeys:kArray];
}
#pragma clang diagnostic pop

#pragma clang diagnostic push

#pragma clang diagnostic ignored "-Wobjc-designated-initializers"
- (instancetype)initWithObjectsAndKeys:(id)firstObject, ...
{
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    id eachObject;
    va_list argumentList;
    if (firstObject)
    {
        [objects addObject: firstObject];
        va_start(argumentList, firstObject);
        NSUInteger index = 1;
        while ((eachObject = va_arg(argumentList, id)))
        {
            (index++ & 0x01) ? [keys addObject: eachObject] : [objects addObject: eachObject];
        }
        va_end(argumentList);
    }
    
    
    if (objects.count == keys.count)
    {
        // 直接写空 跳到最后返回
    }
    else
    {
        (objects.count < keys.count)?[keys removeLastObject]:[objects removeLastObject];
    }
    return [self initWithObjects:objects forKeys:keys];

}

- (id)DNObjectForKey:(id)aKey{
    id value = [self valueForKey:aKey];
    if ([value isKindOfClass:[NSNull class]]) {
        return nil;
    }
    return value;
}


- (NSString *)jsonString
{
    NSError *error = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:0
                                                         error:&error];
    
    if (jsonData == nil) {
        NSLog(@"Fail to get JSON from dictionary: %@, error: %@", self, error);
        return nil;
    }
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    return jsonString;
}

@end
