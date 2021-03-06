//
//  LoginViewC.m
//  Dianniu
//
//  Created by RIMI on 2016/11/15.
//  Copyright © 2016年 Dianniu. All rights reserved.
//

#import "LoginViewC.h"
#import "DNLoginModel.h"
#import "RigisterViewC.h"


#define defaultHeaderCenterY -180

@interface LoginViewC ()

@property (weak, nonatomic) IBOutlet UIButton *headerImage;
@property (weak, nonatomic) IBOutlet UITextField *phoneTf;
@property (weak, nonatomic) IBOutlet UITextField *passwordTf;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hedaerCenterYCons;


@end

@implementation LoginViewC


#pragma life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerNotification];
    [self configurSubviews];
}

- (void)dealloc{
    DNForgetEvent(UIKeyboardWillShowNotification, self);
    DNForgetEvent(UIKeyboardWillHideNotification, self);
}

#pragma mark - privite

- (void)configurSubviews{
    self.loginButton.superview.backgroundColor = [DNThemeColor colorWithAlphaComponent:0.5];
}

- (void)registerNotification{
    DNListenEvent(UIKeyboardWillShowNotification, self, @selector(changeContentViewPosition:));
    DNListenEvent(UIKeyboardWillHideNotification, self, @selector(changeContentViewPosition:));
}

- (void)changeContentViewPosition:(NSNotification *)notification{
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value         = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGFloat keyBoardEndY   = value.CGRectValue.origin.y;
    CGFloat contentY       = [self getContentMaxY];
    NSNumber *duration     = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    CGFloat scrollY        = 0;
    if (contentY - keyBoardEndY > 0) {
        scrollY = defaultHeaderCenterY - (contentY - keyBoardEndY);
    }else{
        scrollY = defaultHeaderCenterY;
    }
    [UIView animateWithDuration:duration.doubleValue animations:^{
        self.hedaerCenterYCons.constant = scrollY;
    } completion:^(BOOL finished) {
        [self.view setNeedsDisplay];
    }];
}

- (CGFloat)getContentMaxY{
    CGRect frame = [self.loginButton.superview convertRect:self.loginButton.frame toView:self.view];
    return frame.origin.y + frame.size.height;
}


- (void)doLogin{
    DNLoginModel *loginModel = [[DNLoginModel alloc] init];
    loginModel.mobileNum = self.phoneTf.text;
    loginModel.pwd       = self.passwordTf.text;
    [SVProgressHUD show];
    [loginModel httpRequest:20 success:^(NSURLSessionDataTask *sessionTask, id respondObj) {        
        [SVProgressHUD dismiss];
        [DNSharedDelegate showHomeViewC];
    } failed:^(NSURLSessionDataTask *sessionTask, NSError *error) {
        //网络请求的基类已经对该类失败做了处理
    }];
}

- (BOOL)verifyLoginParam{
    BOOL isPass = YES;
    if (!verifyPhoneNumber(self.phoneTf.text)) {
        isPass = NO;
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号码"];
    }else if (self.passwordTf.text.length < 4){
        isPass = NO;
        [SVProgressHUD showErrorWithStatus:@"密码位数错误"];
    }
    return isPass;
}


#pragma mark - event
- (IBAction)loginButtonAction:(UIButton *)sender {
    if (![self verifyLoginParam]) {
        return;
    }
    [self doLogin];
}

- (IBAction)rigisterButtonAction:(id)sender {
    
    [self presentViewController:[[RigisterViewC alloc] initWithNibName:@"RigisterViewC" bundle:nil]  animated:YES completion:nil];
}

- (IBAction)forgetPasswordButtonAction:(id)sender {
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if ([self.phoneTf isFirstResponder]) {
        [self.phoneTf resignFirstResponder];
    }else{
        [self.passwordTf resignFirstResponder];
    }
}

#pragma UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([self.phoneTf isEqual:textField]) {
        if (textField.text.length + string.length > 11) {
            if (!verifyPhoneNumber(self.phoneTf.text)) {
                [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号码"];
            }else{
                [self.passwordTf becomeFirstResponder];
            }
            return NO;
        }
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([self.passwordTf isEqual:textField]) {
        if (self.passwordTf.text.length < 4) {
            [SVProgressHUD showErrorWithStatus:@"密码位数不正确"];
            return NO;
        }else{
            [self loginButtonAction:self.loginButton];
        }
    }
    
    return YES;
}


@end
