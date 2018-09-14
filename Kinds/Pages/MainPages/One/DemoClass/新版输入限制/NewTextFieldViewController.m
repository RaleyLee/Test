//
//  NewTextFieldViewController.m
//  Kinds
//
//  Created by hibor on 2018/9/10.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import "NewTextFieldViewController.h"

@interface NewTextFieldViewController ()

@property(nonatomic,strong)UITextField *inputTF;

@end

@implementation NewTextFieldViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    self.inputTF = [[UITextField alloc] init];
    self.inputTF.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:self.inputTF];
    [self.inputTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(40);
    }];
    
    
    UIButton *checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [checkButton setBackgroundColor:[UIColor orangeColor]];
    [checkButton setTitle:@"检查" forState:UIControlStateNormal];
    [checkButton addTarget:self action:@selector(checkTheTextField) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:checkButton];
    [checkButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.inputTF);
        make.top.equalTo(self.inputTF.mas_bottom).offset(20);
        make.height.mas_equalTo(40);
    }];
}

-(void)checkTheTextField{
    NSString *regex = @"[a-zA-Z0-9\u4e00-\u9fa5_]+";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if(![pred evaluateWithObject: self.inputTF.text])
    {
        NSLog(@"昵称只能由中文、字母或数字组成");
    }
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
