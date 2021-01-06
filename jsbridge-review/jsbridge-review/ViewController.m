//
//  ViewController.m
//  jsbridge-review
//
//  Created by Yang Chen on 1/6/21.
//  Copyright © 2021 Yang Chen. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIWebViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // Create a webview
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;
    UIWebView *webview = [[UIWebView alloc] initWithFrame:CGRectMake(0, 20, width, height - 20)];
    
    // [important]:
    // set webview delegate to self
    webview.delegate = self;
    
    [self.view addSubview:webview];
    
    // Add html page located in www/index.html to current webview
    NSString *path = [[NSBundle mainBundle] pathForResource:@"www/index.html" ofType:nil];
    NSURL *url = [NSURL URLWithString:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webview loadRequest:request];
}

// Self-defined webview delegate
// This method used to intercept request url
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    // print url in console
    NSLog(@"url: %@", request.URL.absoluteString);
    
    NSString *path = request.URL.absoluteString;
    if ([path hasPrefix:@"jsbridge://"]) { // this is dummy request
        NSLog(@"Intercepted request: %@", path);
        
        // invoke webpage global js method, and handleNativeValue method is defined in html page
        [webView stringByEvaluatingJavaScriptFromString:@"handleNativeValue('message from native code')"];
        
        return NO;
    } else {
        NSLog(@"This is a normal request: %@", path);
        
        return YES;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
