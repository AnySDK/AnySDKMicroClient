//
//  ViewController.m
//  WebDemo
//
//  Created by WangChris on 2017/10/25.
//  Copyright © 2017年 AnySDK@Cocos. All rights reserved.
//

#import "ViewController.h"
#import "AnyController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"gameindex.html" withExtension:nil];
    [webView loadRequest:[NSURLRequest requestWithURL:fileURL]];
    [self.view addSubview:webView];
    
    AnyController::getInstance()->setWebView(webView);
    AnyController::getInstance()->initAnySDK();
    
    //注册登录和支付方法
    [webView.configuration.userContentController addScriptMessageHandler:self name:@"login"];
    [webView.configuration.userContentController addScriptMessageHandler:self name:@"pay"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message
{
    NSLog(@"body:%@",message.body);
    if ([message.name isEqualToString:@"login"]) {
        AnyController::getInstance()->login();
    }
    else if ([message.name isEqualToString:@"pay"]) {
        AnyController::getInstance()->pay();
    }
}

@end
