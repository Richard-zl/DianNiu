//
//  DNCitysViewModel.h
//  Dianniu
//
//  Created by RIMI on 2017/1/22.
//  Copyright © 2017年 Dianniu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DNCityModel : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *pinyin;
@end

@interface DNCitysViewModel : NSObject

- (instancetype)initWithDataPath:(NSString *)path didLoadBlock:(void(^)())didloadBlock;

- (NSArray *)allinitials;
- (NSInteger)sections;
- (NSInteger)numberOfRowsInSection:(NSInteger)section;
- (DNCityModel *)cityModelWithSection:(NSInteger )section Row:(NSInteger)row;
- (NSString *)initialStringWithSection:(NSInteger)section;
- (NSArray <DNCityModel *> *)searchCityWithString:(NSString *)key didSearch:(void(^)(NSArray<DNCityModel *> *citys))didSearch;
@end
