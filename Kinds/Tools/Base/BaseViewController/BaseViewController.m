//
//  BaseViewController.m
//  Kinds
//
//  Created by hibor on 2018/6/20.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()<UIGestureRecognizerDelegate>


@end

@implementation BaseViewController

-(void)rotateChange{
    
}

-(void)refresh{
    if (self.refreshBlock) {
        self.refreshBlock();
    }
}
-(void)setRefreshButtonWithBlock:(RefreshButtonBlock)refreshBlock{
    self.refreshBlock = refreshBlock;
    self.refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.refreshButton setImage:[UIImage imageNamed:@"refresh"] forState:UIControlStateNormal];
    [self.refreshButton addTarget:self action:@selector(refresh) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.refreshButton];

}

-(void)setRefreshButtonAnimationWithBlock:(RefreshButtonBlock)refreshBlock{
    self.refreshBlock = refreshBlock;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.VRefreshButton];
}

-(VRefreshBtn *)VRefreshButton{
    if (!_VRefreshButton) {
        _VRefreshButton = [VRefreshBtn refreshButton];
        [_VRefreshButton setButtonImage:[UIImage imageNamed:@"refresh"]];
        __weak typeof (self) weakSelf = self;
        _VRefreshButton.clickHandler = ^{
            if (weakSelf.refreshBlock) {
                weakSelf.refreshBlock();
            }
        };
    }
    return _VRefreshButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //避免忘记添加背景色导致push页面的时候黑屏 卡屏
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rotateChange) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goTop) name:kStatusBarTappedNotification object:nil];
}

-(void)goTop{
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
}
#pragma mark - UIGestureRecognizer Delegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    //判断是否是一级视图，若是则关闭滑动返回手势
    if (self.navigationController.viewControllers.count == 1)    {
        return NO;
    }else{
        //        if (self.isSettingPage) {
        //            [self popAlertAction];
        //            return NO;
        //        }
        return YES;
    }
}


-(UIViewController *)superViewController:(UIViewController *)currentController{
    UIResponder *responder = currentController.parentViewController;
    while ((responder = [responder nextResponder])) {
        if ([responder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)responder;
        }
    }
    return nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
