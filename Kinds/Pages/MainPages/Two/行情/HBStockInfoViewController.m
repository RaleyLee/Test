//
//  HBStockInfoViewController.m
//  HangQingNew
//
//  Created by hibor on 2018/5/23.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import "HBStockInfoViewController.h"

@interface HBStockInfoViewController ()<UIWebViewDelegate>


@property (weak, nonatomic) IBOutlet UIWebView *infoWebView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webView_LeftLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webView_RightLayout;

@end

@implementation HBStockInfoViewController


-(void)viewSafeAreaInsetsDidChange{
    [super viewSafeAreaInsetsDidChange];
    
    if (@available(iOS 11.0, *)) {
        if (IS_IPHONEX) {
            UIEdgeInsets  safeArea  =  self.view.safeAreaInsets;
            NSLog(@"safeArea:%@",NSStringFromUIEdgeInsets(safeArea));
            self.webView_LeftLayout.constant = safeArea.left;
            self.webView_RightLayout.constant =safeArea.right;
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    __weak typeof(self) weakSelf = self;
    self.title = [NSString stringWithFormat:@"%@(%@)",self.stockName,self.code];//@"股票详情页面";
    
    _infoWebView.backgroundColor = [UIColor clearColor];
    _infoWebView.opaque = NO;
    [self loadData];
}

-(void)loadData{
    //http://proxy.finance.qq.com/ifzqgtimg/appstock/app/minute/query?code=sz002607&_rndtime=1527152889
    NSString *url = [NSString stringWithFormat:@"http://proxy.finance.qq.com/ifzqgtimg/appstock/app/minute/query?code=%@&_rndtime=%@",self.code,[NSString getNowTimeTimeStamp]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];//@"http://www.yizhaobiao.net/m/appview.php?aid=49275"
    [self.infoWebView loadRequest:request];
    
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    [[HUDHelper sharedHUDHelper] showLoadingHudWithMessage:nil withView:nil];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    //页面背景色
//    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.background='#2E2E2E'"];
    
    [[HUDHelper sharedHUDHelper] stopLoadingHud];
    [[HUDHelper sharedHUDHelper] showHudWithMessage:@"ok" withView:nil];
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
