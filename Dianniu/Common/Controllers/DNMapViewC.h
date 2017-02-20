//
//  DNMapViewC.h
//  Dianniu
//
//  Created by RIMI on 2017/2/16.
//  Copyright © 2017年 Dianniu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>

@interface DNMapViewC : UIViewController
@property (nonatomic, assign)CLLocationCoordinate2D currentCoord;
@property (nonatomic, copy) void(^mapViewResult)(NSString *address,CLLocationCoordinate2D coord);
@end
