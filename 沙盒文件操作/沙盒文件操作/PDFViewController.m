//
//  PDFViewController.m
//  沙盒文件操作
//
//  Created by YXT on 16/8/26.
//  Copyright © 2016年 YXT. All rights reserved.
//

#import "PDFViewController.h"

@interface PDFViewController ()

@end

@implementation PDFViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    
    
    UIWebView *webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:webView];
    
    
    NSURL *url = [NSURL fileURLWithPath:self.pdfURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    webView.scalesPageToFit = YES;
    [webView loadRequest:request];
    
    
    
}



@end
