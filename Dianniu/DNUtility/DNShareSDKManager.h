//
//  DNShareSDKManager.h
//  Dianniu
//
//  Created by RIMI on 2016/12/21.
//  Copyright © 2016年 Dianniu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ShareSDK/ShareSDK.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"
#import "WeiboSDK.h"

typedef NS_ENUM(NSUInteger, DNShareType) {
    DNShareType_QA,//问答分享
    DNShareType_profile,//名片分享
    DNShareType_app, //app分享
    DNShareType_Job, //职位分享
    DNShareType_Recruit, //招聘分享
    DNShareType_Activity   //活动分享
};

@interface DNShareSDKManager : NSObject

+ (instancetype)shared;
- (void)configurSDK;

///分享类型  分享的内容(如问答则输入传问答content)  目标id(用来拼接网址的id)  成功回调
- (void)shareContentWithType:(DNShareType)type content:(NSString *)kContent shareId:(NSNumber *)kId imagePath:(NSString *)path success:(void(^)(NSInteger platform))successCB;
@end
