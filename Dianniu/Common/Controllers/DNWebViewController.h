//
//  DNWebViewController.h
//  Dianniu
//
//  Created by RIMI on 2017/1/12.
//  Copyright © 2017年 Dianniu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DNWebViewController : UIViewController

- (instancetype)initWithUrl:(NSString *)url;
- (instancetype)initWithFilePath:(NSString *)filePath script:(NSString *)script;

- (void)executeScript:(NSString *)script delay:(NSInteger)second;
@end
