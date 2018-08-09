//
//  UIWebViewController.m
//  Kinds
//
//  Created by hibor on 2018/7/12.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import "UIWebViewController.h"

@interface UIWebViewController ()<UIWebViewDelegate>

@property(nonatomic,strong)UIWebView *musicWebView;

@end

@implementation UIWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.musicWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.musicWebView.delegate = self;
    self.musicWebView.scalesPageToFit = YES;
    [self.view addSubview:self.musicWebView];
    [self.musicWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://c.y.qq.com/node/musicmac/v4/index.html"]];;
    [self.musicWebView loadRequest:request];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *content = [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.innerHTML"];
    NSLog(@"content = %@",content);
    return YES;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    NSString *content = [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.innerHTML"];
    NSLog(@"content1 = %@",content);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
