//
//  DNProfileModifyRequest.m
//  Dianniu
//
//  Created by RIMI on 2017/1/5.
//  Copyright © 2017年 Dianniu. All rights reserved.
//

#import "DNProfileModifyRequest.h"
//修改资料
@implementation DNProfileModifyRequest
- (NSString *)requestAddressUrl{
    return @"";
}

- (NSString *)requestActionString{
    return @"account.info.modify";
}

- (NSDictionary *)requestArguement{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:self.value forKey:@"value"];
    NSString *key = [self requestStringWithType:self.type];
    [param setObject:key forKey:@"name"];
    [param setObject:self.accountId forKey:@"accountId"];
    return param;
}

- (void)requestSuccess:(NSURLSessionDataTask *)sessionTask respond:(id)respObjc{
}

- (NSString *)requestStringWithType:(DNProfileModifyType)type{
    NSString *key;
    switch (type) {
        case DNProfileModifyType_Sex:
        key = @"sex";
        break;
        case DNProfileModifyType_Label:
        key = @"label";
        break;
        case DNProfileModifyType_Header:
        key = @"headPic";
        break;
        case DNProfileModifyType_BeFirend:
        key = @"beFriend";
        break;
        case DNProfileModifyType_Describe:
        key = @"describe";
        break;
        case DNProfileModifyType_DataPrivacy:
        key = @"dataPrivacy";
        break;
    }
    return key;
}
@end
