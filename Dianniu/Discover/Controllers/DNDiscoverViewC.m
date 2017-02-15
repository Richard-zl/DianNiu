//
//  DNDiscoverViewC.m
//  Dianniu
//
//  Created by RIMI on 2016/11/25.
//  Copyright © 2016年 Dianniu. All rights reserved.
//

#import "DNDiscoverViewC.h"
#import "DNPhone.h"
#import "DNCitySelectViewC.h"
#import "DNRecruitBaseViewC.h"
#import "DNActivityBaseViewC.h"

@interface DNDiscoverViewC ()

@end

@implementation DNDiscoverViewC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发现";
    [self creatRightNaviBar];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)dealloc{
    [[DNPhone shared] bk_removeAllBlockObservers];
}

- (void)creatRightNaviBar{
    UIButton *rightBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightBut.titleLabel.font = [UIFont systemFontOfSize:16];
    [rightBut setImage:[UIImage imageNamed:@"down_icon"] forState:UIControlStateNormal];
    [rightBut setTitle:[DNPhone shared].selectCity forState:UIControlStateNormal];
    [rightBut sizeToFit];
    [rightBut setTitleEdgeInsets:UIEdgeInsetsMake(0, -rightBut.width + rightBut.imageView.width + 5, 0, 0)];
    [rightBut setImageEdgeInsets:UIEdgeInsetsMake(0, rightBut.titleLabel.width, 0, 0)];
    [rightBut addTarget:self action:@selector(cityButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [[DNPhone shared] bk_addObserverForKeyPath:@"selectCity" task:^(id target) {
        [rightBut setTitle:((DNPhone *)target).selectCity forState:UIControlStateNormal];
        [rightBut sizeToFit];
        [rightBut setTitleEdgeInsets:UIEdgeInsetsMake(0, -rightBut.width + rightBut.imageView.width + 5, 0, 0)];
        [rightBut setImageEdgeInsets:UIEdgeInsetsMake(0, rightBut.titleLabel.width, 0, 0)];
    }];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBut];
}

#pragma mark - Event
- (void)cityButtonAction{
    DNCitySelectViewC *viewC = [[DNCitySelectViewC alloc] init];
    [self.navigationController pushViewController:viewC animated:YES];
}

- (IBAction)homeButtonAction:(UIButton *)sender {
    UIViewController *viewC;
    if (sender.tag == 0) {
        //求职招聘
        viewC = [[DNRecruitBaseViewC alloc] initWithNibName:@"DNRecruitBaseViewC" bundle:nil];
    }else{
        //线下活动
        viewC = [[DNActivityBaseViewC alloc] init];
    }
    [self.navigationController pushViewController:viewC animated:YES];
}


@end
