//
//  DNSexModifyViewC.m
//  Dianniu
//
//  Created by RIMI on 2017/1/6.
//  Copyright © 2017年 Dianniu. All rights reserved.
//

#import "DNSexModifyViewC.h"
#import "DNProfileModifyRequest.h"

@interface DNSexModifyViewC ()
@property (weak, nonatomic) IBOutlet UIButton *manBut;
@property (weak, nonatomic) IBOutlet UIButton *womanBut;
@property (nonatomic ,strong) UIButton *lastSelectedBut;

@end

@implementation DNSexModifyViewC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"性别";
    [self configurSubViews];
}

- (void)configurSubViews{
    [self configurRightButton];
    if ([DNUser sheared].sex < 2) {
        //选择过性别了
        self.lastSelectedBut = [DNUser sheared].sex == 0 ? _womanBut : _manBut;
        self.lastSelectedBut.selected = YES;
    }
}

- (void)configurRightButton{
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"确认" style:UIBarButtonItemStylePlain target:self action:@selector(commitButtonAction:)];
    rightItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

#pragma mark - Event
- (void)commitButtonAction:(UIBarButtonItem *)item{
    DNProfileModifyRequest *request = [[DNProfileModifyRequest alloc] init];
    request.accountId = [DNUser sheared].userId;
    request.type      = DNProfileModifyType_Sex;
    request.value     = @(self.lastSelectedBut.tag);
    [SVProgressHUD showWithStatus:@"正在设置..."];
    [request httpRequest:15 success:^(NSURLSessionDataTask *sessionTask, id respondObj) {
        [SVProgressHUD dismiss];
        [DNUser sheared].sex = self.lastSelectedBut.tag;
        [[DNUser sheared] dump];
        [self.navigationController popViewControllerAnimated:YES];
    } failed:^(NSURLSessionDataTask *sessionTask, NSError *error) {
        
    }];
}

#pragma mark - Event
- (IBAction)buttonAction:(UIButton *)sender {
    if (!sender.isSelected) {
        sender.selected = YES;
    }
    if (!self.navigationItem.rightBarButtonItem.isEnabled) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
    if (![_lastSelectedBut isEqual:sender] && sender.isSelected && _lastSelectedBut.isSelected) {
        _lastSelectedBut.selected = NO;
        _lastSelectedBut.enabled = YES;
    }
    _lastSelectedBut = sender;
}


@end
