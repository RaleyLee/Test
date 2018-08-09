//
//  ZHMarketViewController.m
//  Kinds
//
//  Created by hibor on 2018/6/22.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import "ZHMarketViewController.h"

#import "CYPageViewHeader.h"

#import "ZHHSViewController.h"
#import "ZHGGViewController.h"
#import "ZHGGTViewController.h"
#import "ZHHQViewController.h"

@interface ZHMarketViewController ()

@property(nonatomic,strong)CYPageViewHeader *pageHeader;
@property(nonatomic,strong)NSMutableArray <UIViewController *>*pageViewControllers;
@property(nonatomic,strong)NSArray <NSString *>*titles;
@property(nonatomic,strong)NSArray <NSString *>*viewControllers;

@end

@implementation ZHMarketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    __weak typeof(self) weakself = self;
    
    [self.view addSubview:self.pageHeader];
    
    [self.view addSubview:self.pageHeader.pageViewController.view];
    
    [self.pageHeader.pageViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(weakself.view);
        make.top.equalTo(weakself.pageHeader.mas_bottom);
    }];
    
}

#pragma mark - get & set

- (CYPageViewHeader *)pageHeader{
    if (!_pageHeader) {
        _pageHeader = [[CYPageViewHeader alloc] initWithFrame:CGRectMake(0, 0, CYScreenWidth, STOCK_MUTIMENU_BG_HEIGHT) titles:self.titles pageViewControllers:self.pageViewControllers];
    }
    return _pageHeader;
}

#pragma get & set

- (NSArray<NSString *> *)titles{
    return @[@"沪深",@"港股",@"港股通",@"环球"];
}

-(NSArray<NSString *> *)viewControllers{
    return @[@"ZHHSViewController",@"ZHGGViewController",@"ZHGGTViewController",@"ZHHQViewController"];
}

- (NSMutableArray<UIViewController *> *)pageViewControllers{
    if (!_pageViewControllers) {
        _pageViewControllers = [[NSMutableArray alloc] init];
        __weak typeof(self) weakself = self;
        [self.titles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIViewController *controller = [[UIStoryboard storyboardWithName:@"Market" bundle:nil] instantiateViewControllerWithIdentifier:self.viewControllers[idx]];
            [weakself.pageViewControllers addObject:controller];
        }];
    }
    return _pageViewControllers;
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
