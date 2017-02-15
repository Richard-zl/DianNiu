//
//  DNCitysViewModel.m
//  Dianniu
//
//  Created by RIMI on 2017/1/22.
//  Copyright © 2017年 Dianniu. All rights reserved.
//

#import "DNCitysViewModel.h"

@implementation DNCityModel

@end

@interface DNCitysViewModel()
@property (nonatomic, strong)NSMutableArray *initials;
@property (nonatomic, strong)NSMutableDictionary *dataSource;
@property (nonatomic, copy) void(^didload)();
@end

@implementation DNCitysViewModel
- (instancetype)initWithDataPath:(NSString *)path didLoadBlock:(void(^)())didloadBlock{
    if (self = [super init]) {
        self.didload = [didloadBlock copy];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self configurDataSourceWithDataArr:[NSArray arrayWithContentsOfFile:path]];
        });
    }
    return self;
}

#pragma mark - public
- (NSInteger)sections{
    return self.initials.count;
}
- (NSInteger)numberOfRowsInSection:(NSInteger)section{
    if (section < self.initials.count) {
        return [self.dataSource[self.initials[section]] count];
    }
    return 0;
}
- (DNCityModel *)cityModelWithSection:(NSInteger )section Row:(NSInteger)row{
    if (section < self.initials.count &&
        row < [self.dataSource[self.initials[section]] count]) {
        return self.dataSource[self.initials[section]][row];
    }
    return nil;
}
- (NSString *)initialStringWithSection:(NSInteger)section{
    if (section < self.initials.count) {
        return [NSString stringWithFormat:@"     %@",self.initials[section]];
    }
    return @"";
}

- (NSArray *)allinitials{
    return [self.initials copy];
}

- (NSArray <DNCityModel *> *)searchCityWithString:(NSString *)key didSearch:(void (^)(NSArray<DNCityModel *> *citys))didSearch{
    NSMutableArray *searchCitys = [NSMutableArray array];
    for (NSString *dictKey in self.dataSource.allKeys) {
        for (DNCityModel *city in self.dataSource[dictKey]) {
            if ([city.name rangeOfString:key].location != NSNotFound ||
                [city.pinyin rangeOfString:key].location != NSNotFound) {
                [searchCitys addObject:city];
            }
        }
    }
    if (didSearch) {
        didSearch([searchCitys copy]);
    }
    return [searchCitys copy];
}

#pragma mark - private
- (void)configurDataSourceWithDataArr:(NSArray *)arr{
    for (NSDictionary *cityDict in arr) {
        DNCityModel *city = [[DNCityModel alloc] init];
        city.name = cityDict[@"name"];
        city.pinyin = cityDict[@"pinyin"];
        //排序
        NSString *initial = [city.pinyin substringToIndex:1];
        NSMutableArray *dataArr;
        if ([self.initials containsObject:initial]) {
            //之前已经有这个key了
            dataArr = self.dataSource[initial];
        }else{
            //需要添加key
            dataArr = [NSMutableArray array];
            [self.initials addObject:initial];
            self.dataSource[initial] = dataArr;
        }
        //排序内容
        if (dataArr.count > 0) {
            DNCityModel *lastCity = [dataArr lastObject];
            if ([lastCity.pinyin compare:city.pinyin options:NSCaseInsensitiveSearch] == NSOrderedDescending) {
                [dataArr addObject:city];
            }else{
                [dataArr insertObject:city atIndex:[dataArr indexOfObject:lastCity]];
            }
        }else{
            [dataArr addObject:city];
        }
    }
    //排序key
    [self.initials sortWithOptions:NSSortConcurrent usingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2 options:NSCaseInsensitiveSearch];
    }];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.didload) {
            self.didload();
        }
    });
}

- (NSString *)firstCharactor:(NSString *)aString
{
    //转拼音属于非常耗时的操作,现已将所有城市的全拼固化到plist里了
    if (aString.length > 1) {
        aString = [aString substringWithRange:NSMakeRange(0, 1)];
    }
    //转成了可变字符串
    NSMutableString *str = [NSMutableString stringWithString:aString];
    //先转换为带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
    //再转换为不带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformStripDiacritics,NO);
    //转化为大写拼音
    NSString *pinYin = [str capitalizedString];
    //获取并返回首字母
    return [pinYin substringToIndex:1];
}

#pragma mark - getter
- (NSMutableArray *)initials{
    if (!_initials) {
        _initials = [NSMutableArray array];
    }
    return _initials;
}

- (NSMutableDictionary *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableDictionary dictionary];
    }
    return _dataSource;
}

@end
