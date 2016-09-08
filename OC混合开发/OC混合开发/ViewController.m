//
//  ViewController.m
//  OC混合开发
//
//  Created by 沈强 on 16/9/5.
//  Copyright © 2016年 SQ. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>
#import <JavaScriptCore/JavaScript.h>
#import "NSObject+Extension.h"

@interface ViewController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation ViewController

- (IBAction)refresh:(id)sender {
    [self.webView reload];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]]];
    self.webView.delegate = self;
    // 系统可以自动检测电话、链接、地址、日历、邮箱....
    self.webView.dataDetectorTypes = UIDataDetectorTypeAll;
    NSURL *htmlURL = [[NSBundle mainBundle] URLForResource:@"info.html" withExtension:nil];
    [self.webView loadRequest:[NSURLRequest requestWithURL:htmlURL]];
}

/**
 *  每当webView发送请求之前就会调用这个方法
 */
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    // 获取url全路径
    NSString *url = request.URL.absoluteString;
    NSString *protocol = @"jsoc://";  //
    if ([url hasPrefix:protocol]) { // 判断url是否以 jsoc:// 开头
        // 获取协议后面的路径 substringFromIndex:从指定位置开始截取到最后，包含指定位置
        NSString *path = [url substringFromIndex:protocol.length];
        // 利用占位符进行切割
        NSArray *subpaths = [path componentsSeparatedByString:@"?"];
        // 获取方法名 call_  -> call:
        NSString *methodName = [[subpaths firstObject] stringByReplacingOccurrencesOfString:@"_" withString:@":"];
        NSArray *params = nil;
        if (subpaths.count == 2) {
            params = [[subpaths lastObject] componentsSeparatedByString:@"&"];
        }
//        selector  SEL
        // 调用方法
        SEL sel = sel_registerName([methodName UTF8String]);
//        self performSelector:<#(SEL)#> withObject:<#(id)#>
//        self performSelector:<#(SEL)#> withObject:<#(id)#> withObject:<#(id)#>
        [self sq_performSelector:sel withObjects:params];
        return NO;
    }
    return YES;
}

- (void)call:(NSString *)number {
    NSLog(@"参数:%@", number);
    NSLog(@"调用了OC的%s方法", __func__);
}

// OC调用JS
- (void)webViewDidFinishLoad:(UIWebView *)webView {
//    NSString *js = [webView stringByEvaluatingJavaScriptFromString:@"onCallJSNoParamsFunction()"];
//    NSLog(@"%@", js);
//    NSString *js = [NSString stringWithFormat:@"onCallJSHasParamsFunction('%@', '%@')", @"哈哈", @"电视剧"];
//    [webView stringByEvaluatingJavaScriptFromString:js];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
