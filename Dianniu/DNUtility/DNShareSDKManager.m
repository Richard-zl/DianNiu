//
//  DNShareSDKManager.m
//  Dianniu
//
//  Created by RIMI on 2016/12/21.
//  Copyright © 2016年 Dianniu. All rights reserved.
//

#import "DNShareSDKManager.h"
#import "DNDianniuQ_AViewModel.h"

#define KDNKeyShareSDKredirectUri @"www.sharesdk.cn"

static DNShareSDKManager *shareSDKmanager;

@implementation DNShareSDKManager

+ (instancetype)shared{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareSDKmanager = [[DNShareSDKManager alloc] init];
    });
    return shareSDKmanager;
}

- (void)configurSDK{
    [ShareSDK registerApp:KDNKeyShareSDKappId];
    //添加新浪微博应用 注册网址 http://open.weibo.com
    [ShareSDK connectTencentWeiboWithAppKey:@"1362455525" appSecret:@"c399f8d74e1c36ea776f1df1c0747488" redirectUri:KDNKeyShareSDKredirectUri wbApiCls:[WeiboSDK class]];
    [ShareSDK connectSinaWeiboWithAppKey:@"1362455525"
                               appSecret:@"c399f8d74e1c36ea776f1df1c0747488"
                             redirectUri:KDNKeyShareSDKredirectUri];
    //qq
    [ShareSDK connectQZoneWithAppKey:@"1105437435"
                           appSecret:@"qmGGjfEJLmoYaoax"
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
    //QQ空间
    [ShareSDK connectQQWithQZoneAppKey:@"1105437435"
                     qqApiInterfaceCls:[QQApiInterface class]
                       tencentOAuthCls:[TencentOAuth class]];
    //微信
    [ShareSDK connectWeChatWithAppId:@"wx58df1958cb4b572f"   //微信APPID
                           appSecret:@"56408a827ef7da45caa51a3df1e357ed"  //微信APPSecret
                           wechatCls:[WXApi class]];
}

//问答分享
- (void)shareContentWithType:(DNShareType)type content:(NSString *)kContent shareId:(NSNumber *)kId imagePath:(NSString *)path success:(void(^)(NSInteger platform))successCB{
    
    NSString *title,*url;
    switch (type) {
        case DNShareType_QA:
            title = @"问答";
            url = [NSString stringWithFormat:@"quest.html?id=%@",kId];
            break;
        case DNShareType_profile:
            title = @"名片";
            url = [NSString stringWithFormat:@"card.html?id=%@",kId];
            break;
        case DNShareType_app:
            title = @"应用";
            url = @"index.html";
            break;
    }
    url = [NSString stringWithFormat:@"http://share.dianniuapp.com/%@",url];
    title = [NSString stringWithFormat:@"来自电钮的%@分享",title];
    
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:kContent
                                       defaultContent:@""
                                                image:[ShareSDK imageWithUrl:path]
                                                title:title
                                                  url:url
                                          description:@""
                                            mediaType:SSPublishContentMediaTypeNews];

    //弹出分享菜单
    [ShareSDK showShareActionSheet:nil
                         shareList:[ShareSDK getShareListWithType:ShareTypeSinaWeibo,ShareTypeQQSpace,ShareTypeQQ,ShareTypeWeixiSession,ShareTypeWeixiTimeline]
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                if (state == SSResponseStateSuccess)
                                {
                                    if (successCB) {
                                        successCB(type);
                                    }
                                }
                                else if (state == SSResponseStateFail || [error errorDescription].length > 0)
                                {
                                    [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"分享失败:%@",[error errorDescription]]];
                                }
                            }];
}

@end
