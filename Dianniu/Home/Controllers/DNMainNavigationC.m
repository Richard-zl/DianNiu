//
//  DNMainNavigationC.m
//  Dianniu
//
//  Created by RIMI on 2016/11/25.
//  Copyright © 2016年 Dianniu. All rights reserved.
//

#import "DNMainNavigationC.h"

@interface DNMainNavigationC ()

@end

@implementation DNMainNavigationC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configurBarColor];
    [self configurBackButton];
}

- (void)configurBarColor{
    self.navigationBar.barTintColor = DNThemeColor;
    self.navigationBar.translucent = YES;
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],
                                                          NSFontAttributeName:[UIFont boldSystemFontOfSize:18]};
}

- (void)configurBackButton{
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:[[UIImage imageNamed:@"back_icon"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 15, 0, 0)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
}

- (void)backAction{
    [self popViewControllerAnimated:YES];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
  
    if (animated) viewController.hidesBottomBarWhenPushed = YES;
    self.navigationBarHidden = NO;
    [super pushViewController:viewController animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated{
   
    UIViewController *controller = [super popViewControllerAnimated:animated];
    if ([self.delegate respondsToSelector:@selector(navigationController:willShowViewController:animated:)]) {
        [self.delegate navigationController:self willShowViewController:controller animated:animated];
    }
    if (self.viewControllers.count == 1) {
        [self setNavigationBarHidden:YES animated:YES];
    }
    return controller;
}



@end
