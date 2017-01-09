//
//  DNDescriptionModifyViewC.m
//  Dianniu
//
//  Created by RIMI on 2017/1/6.
//  Copyright © 2017年 Dianniu. All rights reserved.
//

#import "DNDescriptionModifyViewC.h"
#import "DNProfileModifyRequest.h"

@interface DNDescriptionModifyViewC ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *placeholderLb;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *numberLb;

@end

@implementation DNDescriptionModifyViewC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个性签名";
    self.automaticallyAdjustsScrollViewInsets = NO;
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
    request.type      = DNProfileModifyType_Describe;
    request.value     = self.textView.text;
    [SVProgressHUD showWithStatus:@"正在设置签名..."];
    [request httpRequest:15 success:^(NSURLSessionDataTask *sessionTask, id respondObj) {
        [SVProgressHUD dismiss];
        [DNUser sheared].userDesription = self.textView.text;
        [[DNUser sheared] dump];
        [self.navigationController popViewControllerAnimated:YES];
    } failed:^(NSURLSessionDataTask *sessionTask, NSError *error) {
        
    }];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView{
    BOOL isInput = textView.text.length > 0;
    self.placeholderLb.hidden = isInput;
    self.navigationItem.rightBarButtonItem.enabled = isInput;
    self.numberLb.text = [NSString stringWithFormat:@"可输入%ld个字",30 - textView.text.length];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (textView.text.length + text.length >= 31) {
        return NO;
    }
    return YES;
}

@end
