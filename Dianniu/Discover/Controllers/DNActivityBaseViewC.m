//
//  DNActivityBaseViewC.m
//  Dianniu
//
//  Created by RIMI on 2017/2/7.
//  Copyright © 2017年 Dianniu. All rights reserved.
//

#import "DNActivityBaseViewC.h"
#import "DNInformationViewC.h"
#import "DNActivityTableViewC.h"
#import "DNReleaseActivityViewC.h"

#define DNRecruitCategoryButtonTag 500
@interface DNActivityBaseViewC ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *controllers;

@end

@implementation DNActivityBaseViewC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"线下活动";
    [self configurSubViews];
}

- (void)configurSubViews{
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self configurScrollView];
    [self configurRightButton];
    DNActivityTableViewC *first = [[DNActivityTableViewC alloc] init];
    first.activityType   = DNActivityType_Nearby;
    DNActivityTableViewC *secound = [[DNActivityTableViewC alloc] init];
    secound.activityType = DNActivityType_join;
    DNActivityTableViewC *third = [[DNActivityTableViewC alloc] init];
    third.activityType   = DNActivityType_My;
    //因为必须强持有两个控制器  才不会刚创建就被销毁
    self.controllers = [NSMutableArray arrayWithArray:@[first,secound,third]];
    [self.scrollView addSubview:first.view];
    secound.view.left = first.view.right;
    [self.scrollView addSubview:secound.view];
    third.view.left = secound.view.right;
    [self.scrollView addSubview:third.view];
}
- (void)configurRightButton{
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"创建" style:UIBarButtonItemStylePlain target:self action:@selector(postButtonAction)];
    rightItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)configurScrollView{
    self.scrollView.contentSize = CGSizeMake(ScreenWidth*3, ScreenHeight - self.topView.bottom);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.bounces = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
}

#pragma mark - private func
- (void)deselectCategoryButtn{
    for (UIView *subView in self.topView.subviews) {
        if ([subView isKindOfClass:[UIButton class]]) {
            UIButton *categoryBut = (UIButton *)subView;
            if (categoryBut.isSelected) {
                categoryBut.selected = NO;
                categoryBut.userInteractionEnabled = YES;
                return;
            }
        }
    }
}

#pragma mark - Event
///发布按钮点击事件
- (void)postButtonAction{
    if ([DNUser sheared].authLevel < DNUSerAuthLevel_TWO) {
        //没有权限发招聘
        DNTextAlert(nil, @"您还未完成二级认证，请先验证！", @[@"确认",@"取消"], ^(NSInteger index) {
            if (index == 0) {
#warning 跳转到权限认证页面
                DNInformationViewC *viewC = [[DNInformationViewC alloc] initWithNibName:@"DNInformationViewC" bundle:[NSBundle mainBundle]];
                [self.navigationController pushViewController:viewC animated:YES];
            }
        });
        return ;
    }
    DNReleaseActivityViewC *releaseViewC = [[DNReleaseActivityViewC alloc] initWithNibName:@"DNReleaseActivityViewC" bundle:nil];
    [self.navigationController pushViewController:releaseViewC animated:YES];
}

- (IBAction)categoryButtonAction:(UIButton *)sender {
    if (!sender.isSelected) {
        [self deselectCategoryButtn];
             [self.scrollView setContentOffset:CGPointMake((sender.tag - DNRecruitCategoryButtonTag)*self.scrollView.width , 0) animated:YES];
        sender.selected = YES;
        sender.userInteractionEnabled = NO;
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger offSetX = self.scrollView.contentOffset.x;
    NSInteger width   = ScreenWidth;
    NSInteger tag = offSetX/width + DNRecruitCategoryButtonTag;
    UIButton *selectBut = (UIButton *)[self.topView viewWithTag:tag];
    [self categoryButtonAction:selectBut];
}


@end
