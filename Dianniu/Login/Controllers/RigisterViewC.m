//
//  RigisterViewC.m
//  Dianniu
//
//  Created by RIMI on 2016/11/22.
//  Copyright © 2016年 Dianniu. All rights reserved.
//

#import "RigisterViewC.h"
#import "DNVerifyCodeModel.h"
#import "DNRigisterModel.h"

#define defaultVerticalCenterY 0

@interface RigisterViewC ()
@property (weak, nonatomic) IBOutlet UITextField *phoneTf;
@property (weak, nonatomic) IBOutlet UITextField *verifyCodeTf;
@property (weak, nonatomic) IBOutlet UITextField *passwordTf;
@property (weak, nonatomic) IBOutlet UITextField *confimPwdTf;
@property (weak, nonatomic) IBOutlet UIButton *verifyCodeBut;

@property (weak, nonatomic) IBOutlet UIButton *rigisterBut;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewVerticalCenterYcons;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation RigisterViewC

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerNotification];
    [self configurSubviews];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.timer invalidate];
    self.timer = nil;
}

-(void)dealloc{
    DNForgetEvent(UIKeyboardWillShowNotification, self);
    DNForgetEvent(UIKeyboardWillHideNotification, self);
}

#pragma mark private
- (void)configurSubviews{
    self.passwordTf.superview.backgroundColor = [DNThemeColor colorWithAlphaComponent:0.5];
}

- (void)registerNotification{
    DNListenEvent(UIKeyboardWillShowNotification, self, @selector(changeContentViewPosition:));
    DNListenEvent(UIKeyboardWillHideNotification, self, @selector(changeContentViewPosition:));
}

- (void)changeContentViewPosition:(NSNotification *)notification{
    if ([self.confimPwdTf isFirstResponder]) {
        NSDictionary *userInfo = [notification userInfo];
        NSValue *value         = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
        CGFloat keyBoardEndY   = value.CGRectValue.origin.y;
        CGFloat contentY       = [self getRigisterButMaxY];
        NSNumber *duration     = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
        CGFloat scrollY        = 0;
        if (contentY - keyBoardEndY > 0) {
            scrollY = defaultVerticalCenterY - (contentY - keyBoardEndY);
        }else{
            scrollY = defaultVerticalCenterY;
        }
        [UIView animateWithDuration:duration.doubleValue animations:^{
            self.contentViewVerticalCenterYcons.constant = scrollY;
        } completion:^(BOOL finished) {
            [self.view setNeedsDisplay];
        }];
    }else{
        [UIView animateWithDuration:0.25 animations:^{
            self.contentViewVerticalCenterYcons.constant = defaultVerticalCenterY;
        } completion:^(BOOL finished) {
            [self.view setNeedsDisplay];
        }];
    }
}

- (CGFloat)getRigisterButMaxY{
    CGRect frame = [self.rigisterBut.superview convertRect:self.rigisterBut.frame toView:self.view];
    return frame.origin.y + frame.size.height;
}

- (void)countDown{
    __block NSInteger seconds = 60;
    [self.verifyCodeBut setTitle:[NSString stringWithFormat:@"(%lds)",(long)seconds] forState:UIControlStateDisabled];
    DNWeakself;
    self.timer = [NSTimer bk_scheduledTimerWithTimeInterval:1 block:^(NSTimer *timer) {
        if (seconds == 0) {
            [timer invalidate];
            self.timer = nil;
            weakSelf.verifyCodeBut.enabled = YES;
            return ;
        }else{
            [weakSelf.verifyCodeBut setTitle:[NSString stringWithFormat:@"(%lds)",(long)seconds] forState:UIControlStateDisabled];
        }
        seconds--;
    } repeats:YES];
}

- (void)requestVerifyCode{
    DNVerifyCodeModel *model = [[DNVerifyCodeModel alloc] init];
    model.mobileNum = self.phoneTf.text;
    [SVProgressHUD show];
    [model httpRequest:20 success:^(NSURLSessionDataTask *sessionTask, id respondObj) {
        [self countDown];
        [SVProgressHUD dismiss];
    } failed:^(NSURLSessionDataTask *sessionTask, NSError *error) {
        //基类已经统一做了处理
        self.verifyCodeBut.enabled = YES;
    }];
}

- (BOOL)checkRigisterParam{
    BOOL isPass = YES;
    if (!verifyPhoneNumber(self.phoneTf.text)) {
        isPass = NO;
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号"];
    }else if (self.verifyCodeTf.text.length < 3){
        isPass = NO;
        [SVProgressHUD showErrorWithStatus:@"请输入正确的验证码"];
    }else if (self.passwordTf.text.length < 4){
        isPass = NO;
        [SVProgressHUD showErrorWithStatus:@"您设置的密码长度太短"];
    }else if (![self.passwordTf.text isEqualToString:self.confimPwdTf.text]){
        isPass = NO;
        [SVProgressHUD showErrorWithStatus:@"两次密码输入不一致"];
    }

    return isPass;
}

- (void)clearTextFiledText{
    for (UIView *subview in self.phoneTf.superview.subviews) {
        if ([subview isKindOfClass:[UITextField class]]) {
            if ([subview isFirstResponder]) {
                [subview resignFirstResponder];
            }
            ((UITextField *)subview).text = @"";
        }
    }
}

- (void)doRegister{
    DNRigisterModel *model = [[DNRigisterModel alloc] init];
    model.mobile = self.phoneTf.text;
    model.code   = self.verifyCodeTf.text;
    model.pwd    = self.passwordTf.text;
    [SVProgressHUD show];
    [model httpRequest:20 success:^(NSURLSessionDataTask *sessionTask, id respondObj) {
        [SVProgressHUD dismiss];
        DNAlert(@"提示", @"注册成功！", @"返回", ^{
            [self backButtonAction:nil];
        });
    } failed:^(NSURLSessionDataTask *sessionTask, NSError *error) {
        [self clearTextFiledText];
    }];
}

#pragma mark - event
- (IBAction)rigisterButtonAction:(UIButton *)sender {
    if (![self checkRigisterParam]) {
        return;
    }
    [self doRegister];
}

- (IBAction)verifyCodeButtonAction:(UIButton *)sender {
    if (verifyPhoneNumber(self.phoneTf.text)) {
        //获取验证码请求
        sender.enabled = NO;
        [self requestVerifyCode];
    }else{
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号码"];
    }
}

- (IBAction)backButtonAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    for (UIView *subview in self.phoneTf.superview.subviews) {
        if ([subview isFirstResponder]) {
            [subview resignFirstResponder];
            return;
        }
    }
}

@end
