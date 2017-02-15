//
//  DNWebViewController.m
//  Dianniu
//
//  Created by RIMI on 2017/1/12.
//  Copyright © 2017年 Dianniu. All rights reserved.
//

#import "DNWebViewController.h"

@interface DNWebViewController ()<UIWebViewDelegate>
@property (nonatomic, copy) NSString *filePath;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, copy) NSString *script;
@end

@implementation DNWebViewController

- (instancetype)initWithUrl:(NSString *)url{
    self = [super init];
    if (self) {
        self.url = url;
    }
    return self;
}

- (instancetype)initWithFilePath:(NSString *)filePath script:(NSString *)script{
    self = [super init];
    if (self) {
        self.filePath = filePath;
        self.script = script;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self configurWebView];
}

- (void)configurWebView{
    [self.view addSubview:self.webView];
    if (self.filePath) {
        NSString *htmlStr = [[NSString alloc] initWithContentsOfFile:self.filePath encoding:NSUTF8StringEncoding error:nil];
        [self.webView loadHTMLString:htmlStr baseURL:[NSURL fileURLWithPath:self.filePath]];
    }else{
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    }
}

#pragma public
- (void)executeScript:(NSString *)script delay:(NSInteger)second{
    if (self.webView) {
        [self.webView bk_performBlock:^(id obj) {
            [((UIWebView *)obj) stringByEvaluatingJavaScriptFromString:script];
        } afterDelay:second];
    }
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    if (self.script) {
        [webView stringByEvaluatingJavaScriptFromString:self.script];
    }
}

#pragma mark - getter
- (UIWebView *)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
        _webView.delegate = self;
        _webView.scrollView.backgroundColor = RGBColor(241, 241, 241);
    }
    return _webView;
}



@end
