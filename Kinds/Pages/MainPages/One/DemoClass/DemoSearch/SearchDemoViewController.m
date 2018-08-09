//
//  SearchDemoViewController.m
//  Kinds
//
//  Created by hibor on 2018/8/8.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import "SearchDemoViewController.h"
#import "SearchView.h"

@interface SearchDemoViewController ()

@end

@implementation SearchDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    SearchView *searchView = [[SearchView alloc] initWithFrame:CGRectZero withBlock:^(CGFloat height) {
        NSLog(@"height = %lf",height);
    }];
    searchView.dataArray = [NSMutableArray arrayWithObjects:@"钢化膜",@"剃须刀",@"苹果手机钢化膜",@"保温杯",@"苹果手机",@"钢化膜",@"剃须刀",@"苹果手机钢化膜帝国时代",@"保温杯",@"苹果手机",@"钢化膜",@"剃须刀",@"苹果手机钢化膜",@"保温杯",@"苹果手机",@"钢化膜",@"剃须刀",@"苹果手机钢化膜",@"保温分公司电饭锅杯",@"苹果手机",@"钢化膜",@"剃须刀",@"苹果手机钢化膜",@"保温杯",@"苹果手机", nil];
    searchView.itemBlock = ^(NSString *title) {
        NSLog(@"click = %@",title);
        self.title = title;
    };
    [self.view addSubview:searchView];
    NSLog(@"%@",NSStringFromCGRect(searchView.frame));
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
