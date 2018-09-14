//
//  PayHUDViewController.m
//  Kinds
//
//  Created by hibor on 2018/8/16.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import "PayHUDViewController.h"
#import "PayHUDView.h"

@interface PayHUDViewController ()

@end

@implementation PayHUDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"PayHUD";
    self.view.backgroundColor = [UIColor whiteColor];
    
    
//    [PayHUDView showIn:self.view];
    
    NSArray *titleArray = @[@"开始支付",@"付款成功",@"付款失败",@"付款异常"];
    NSMutableArray *viewArray = [NSMutableArray array];
    for (int i = 0 ; i < titleArray.count ; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [button setTitleColor:RGB_random forState:UIControlStateNormal];
        button.layer.borderColor = [UIColor lightGrayColor].CGColor;
        button.layer.borderWidth = 0.5f;
        button.layer.cornerRadius = 5;
        button.layer.masksToBounds = YES;
        button.tag = 100 + i;
        [button addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        [viewArray addObject:button];
    }
    
    [viewArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:10 leadSpacing:10 tailSpacing:10];
    [viewArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.height.mas_equalTo(45);
    }];
}

-(void)buttonClickAction:(UIButton *)sender{
    self.navigationItem.title = sender.titleLabel.text;
    PayHUDView *payView = nil;
    payView = [PayHUDView hideIn:self.view];
    if (sender.tag == 100) {
        payView = [PayHUDView showIn:self.view withAnimation:PayHUDStyleLoading];
    }else if (sender.tag == 101) {
        payView = [PayHUDView showIn:self.view withAnimation:PayHUDStyleSuccess];
    }else if (sender.tag == 102) {
        payView = [PayHUDView showIn:self.view withAnimation:PayHUDStyleFailure];
    }else if (sender.tag == 103) {
        payView = [PayHUDView showIn:self.view withAnimation:PayHUDStyleWarning];
    }
    [payView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];
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
