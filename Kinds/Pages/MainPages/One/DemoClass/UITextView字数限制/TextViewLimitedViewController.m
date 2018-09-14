//
//  TextViewLimitedViewController.m
//  Kinds
//
//  Created by hibor on 2018/8/31.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import "TextViewLimitedViewController.h"

@interface TextViewLimitedViewController ()

@property(nonatomic,strong)UILabel *countLabel;

@end

@implementation TextViewLimitedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    FSTextView *textView = [FSTextView textView];
    textView.placeholder = @"这是一个继承于UITextView的带Placeholder的自定义TextView, 可以设定限制字符长度, 以Block形式回调, 简单直观 !";
    // 限制输入最大字符数.
    textView.maxLength = 100;
    // 添加输入改变Block回调.
    [textView addTextDidChangeHandler:^(FSTextView *textView) {
        // 文本改变后的相应操作.
        if (textView.text.length <= 100) {
            self.countLabel.text = [NSString stringWithFormat:@"%ld/100",textView.text.length];
        }
        
    }];
    // 添加到达最大限制Block回调.
    [textView addTextLengthDidMaxHandler:^(FSTextView *textView) {
        // 达到最大限制数后的相应操作.
    }];
    [self.view addSubview:textView];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(200);
    }];
    
    
    self.countLabel = [UILabel new];
    self.countLabel.font = [UIFont systemFontOfSize:15];
    self.countLabel.text = @"0/100";
    [self.view addSubview:self.countLabel];
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.equalTo(textView.mas_bottom).offset(10);
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
