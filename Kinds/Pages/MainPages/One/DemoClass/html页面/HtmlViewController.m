//
//  HtmlViewController.m
//  Kinds
//
//  Created by hibor on 2018/7/27.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import "HtmlViewController.h"

@interface HtmlViewController ()<UIWebViewDelegate>

@property(nonatomic,strong)UIWebView *webView;

@end

@implementation HtmlViewController

-(UIWebView *)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc] init];
        _webView.dataDetectorTypes = UIDataDetectorTypeAll;
        _webView.delegate = self;
    }
    return _webView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"HTML测试";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    //本地HTML
//    NSURL *filePath = [[NSBundle mainBundle] URLForResource:@"resource.html" withExtension:nil];
//    NSURLRequest *request = [NSURLRequest requestWithURL:filePath];
//    [self.webView loadRequest:request];
    
//    NSURL *url = [NSURL URLWithString:@"http://www.yizhaobiao.net/plus/view.php?act=app&aid=74490"];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    [self.webView loadRequest:request];
    
    
    [self load];
}

-(void)load{
    __weak typeof (self) weakSelf = self;
    NSString *url = @"http://www.yizhaobiao.net/plus/view.php?act=app&aid=74490";
    [[RequestTool sharedRequestTool] HBGETRequestDataWithPath:url isHaveNetWork:^{
        
    } failuare:^(NSError *error) {
        
    } success:^(id jsonData) {
        NSLog(@"jsonData = %@",jsonData);
        weakSelf.title = jsonData[@"content"][@"title"];
        NSString *str = [jsonData[@"content"][@"body"] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        [weakSelf.webView loadHTMLString:str baseURL:nil];
    }];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *content = request.URL.absoluteString;
    NSRange range = [content rangeOfString:@"tel:"];
    if (range.length) {
        NSString *phone = [content substringFromIndex:range.location+range.length];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"是否要拨打:%@",phone] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
        return NO;
    }
    NSRange range1 = [content rangeOfString:@"http"];
    if (range1.length) {
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:content]]) {
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:content]];
        }
        return NO;
    }
    return YES;
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
