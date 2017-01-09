//
//  DNMoreLabelViewC.h
//  Dianniu
//
//  Created by RIMI on 2017/1/9.
//  Copyright © 2017年 Dianniu. All rights reserved.
//

#import <UIKit/UIKit.h>


//更多标签

@protocol DNMoerLabelDelegate <NSObject>

@optional
- (void)didSelectedLabel:(UIButton *)target;

@end
@interface DNMoreLabelViewC : UIViewController
@property (nonatomic, weak) id<DNMoerLabelDelegate>delegate;
@end
