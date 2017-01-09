//
//  DNNicknameModifyViewC.m
//  Dianniu
//
//  Created by RIMI on 2017/1/6.
//  Copyright © 2017年 Dianniu. All rights reserved.
//

#import "DNNicknameModifyViewC.h"
#import "DNProfileModifyRequest.h"

@interface DNNicknameModifyViewC ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nickNameTf;

@end

@implementation DNNicknameModifyViewC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"编辑昵称";
    [self configurRightButton];
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
    request.type      = DNProfileModifyType_Realname;
    request.value     = self.nickNameTf.text;
    [SVProgressHUD showWithStatus:@"正在设置昵称..."];
    [request httpRequest:15 success:^(NSURLSessionDataTask *sessionTask, id respondObj) {
        [SVProgressHUD dismiss];
        [DNUser sheared].realName = self.nickNameTf.text;
        [[DNUser sheared] dump];
        [self.navigationController popViewControllerAnimated:YES];
    } failed:^(NSURLSessionDataTask *sessionTask, NSError *error) {
        
    }];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField.text.length + string.length > 0) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
        if (textField.text.length >= 10) {
            return NO;
        }
    }else{
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
    return YES;
}


@end
