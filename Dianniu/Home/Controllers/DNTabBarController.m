//
//  DNTabBarController.m
//  Dianniu
//
//  Created by RIMI on 2016/11/25.
//  Copyright © 2016年 Dianniu. All rights reserved.
//

#import "DNTabBarController.h"
#import "DNMainNavigationC.h"
#import "DNHomeViewC.h"
#import "DNDiscoverViewC.h"
#import "DNMessageViewC.h"
#import "DNProfileViewC.h"

@interface DNTabBarController ()
@property (nonatomic, strong) NSArray *unSelectImageNames;
@property (nonatomic, strong) NSArray *selectedImageNames;
@property (nonatomic, strong) NSArray *itemTitles;
@property (nonatomic, strong) NSArray *dnControllers;

@end

@implementation DNTabBarController
#pragma mark - Getter
- (NSArray *)unSelectImageNames{
    if (_unSelectImageNames == nil) {
        _unSelectImageNames = @[@"home_main_icon_one_n",
                                @"home_main_icon_two_n",
                                @"home_main_icon_third_n",
                                @"home_main_icon_four_n"];
    }
    return _unSelectImageNames;
}
- (NSArray *)selectedImageNames{
    if (_selectedImageNames == nil) {
        _selectedImageNames =  @[@"home_main_icon_one_f",
                                 @"home_main_icon_two_f",
                                 @"home_main_icon_third_f",
                                 @"home_main_icon_four_f"];
    }
    return _selectedImageNames;
}

- (NSArray *)itemTitles{
    if (_itemTitles == nil) {
        _itemTitles = @[@"电钮",
                        @"发现",
                        @"消息户",
                        @"我"];
    }
    return _itemTitles;
}



- (NSArray *)dnControllers
{
    if (_dnControllers == nil) {
        
        _dnControllers = @[[[DNHomeViewC alloc] initWithNibName:@"DNHomeViewC" bundle:nil],
                           [[DNDiscoverViewC alloc] initWithNibName:@"DNDiscoverViewC" bundle:nil],
                           [[DNMessageViewC alloc] initWithNibName:@"DNMessageViewC" bundle:nil],
                           [[DNProfileViewC alloc] initWithNibName:@"DNProfileViewC" bundle:nil]];
        
    }
    return _dnControllers;
}
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self createUITabBarItems];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.selectedViewController beginAppearanceTransition: YES animated: animated];
}

-(void) viewDidAppear:(BOOL)animated
{
    [self.selectedViewController endAppearanceTransition];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [self.selectedViewController beginAppearanceTransition: NO animated: animated];
}

-(void) viewDidDisappear:(BOOL)animated
{
    [self.selectedViewController endAppearanceTransition];
}

#pragma mark - pulick
- (void)setBadege:(BOOL)IsDisplay andSender:(UIViewController *)sender{
    
    if (!sender) return;
    
    __block NSInteger index;
    __weak typeof (UIViewController *)weakSender = sender;
    [self.dnControllers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([weakSender isEqual:obj]) {
            index = idx;
            *stop = YES;
        }
    }];
    if (index >= self.dnControllers.count) return;
    UINavigationController *Navic = self.viewControllers[index];
    UIImage *selectedImage = Navic.tabBarItem.selectedImage;
    UIImage *unSelectedImage = Navic.tabBarItem.image;
    if (IsDisplay) {
        //显示角标
        selectedImage = [self drawBadegeImage:[UIImage imageNamed:self.selectedImageNames[index]]];
        unSelectedImage = [self drawBadegeImage:[UIImage imageNamed:self.unSelectImageNames[index]]];
    }else{
        //不显示角标
        selectedImage = [UIImage imageNamed:self.selectedImageNames[index]];
        unSelectedImage = [UIImage imageNamed:self.unSelectImageNames[index]];
    }
    Navic.tabBarItem.selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    Navic.tabBarItem.image = [unSelectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}


#pragma private methd
- (void)createUITabBarItems{
    
    NSMutableArray *controllerArray = [NSMutableArray array];
    
    for (int i = 0 ; i < self.dnControllers.count; i ++) {
        UIViewController *controller = self.dnControllers[i];
        UITabBarItem     *item       = [[UITabBarItem alloc] init];
        item.title            = self.itemTitles[i];
        item.image            = [[UIImage imageNamed:self.unSelectImageNames[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        item.selectedImage    = [[UIImage imageNamed:self.selectedImageNames[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:DNThemeColor, NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
        
        
        DNMainNavigationC *naviC = [[DNMainNavigationC alloc] initWithRootViewController:controller];
        naviC.tabBarItem = item;
        controller.navigationController.navigationBarHidden = YES;
        controller.edgesForExtendedLayout = UIRectEdgeNone;
        [controllerArray addObject:naviC];
    }
    
    self.viewControllers = controllerArray;
}

- (UIImage *)drawBadegeImage:(UIImage *)originImg{
    
    CGFloat width = originImg.size.width;
    CGFloat height = originImg.size.height;
    
    UIImageView *badgeView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    badgeView.backgroundColor = [UIColor clearColor];
    badgeView.image = originImg;
    UIView   *view = [[UIView alloc] initWithFrame:CGRectMake(width - 10, 0, 10, 10)];
    view.backgroundColor = [UIColor redColor];
    view.layer.cornerRadius = 5.0;
    [badgeView addSubview:view];
    UIGraphicsBeginImageContextWithOptions(badgeView.bounds.size, NO, badgeView.layer.contentsScale);
    [badgeView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}


- (void)selectItemIndex:(DNTabSelectItem)itemIndex
{
    [self setSelectedIndex:itemIndex];
}

#pragma mark - other
/**
 *  屏幕自动旋转
 */
- (BOOL)shouldAutorotate {
    return NO;
}

@end
