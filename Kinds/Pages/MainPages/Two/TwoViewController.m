//
//  TwoViewController.m
//  Kinds
//
//  Created by hibor on 2018/6/20.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import "TwoViewController.h"

#import "IDCPageViewController.h"
#import "ZHStockViewController.h"
#import "ZHMarketViewController.h"

#import "VRefreshBtn.h"
#import "VRefreshPopView.h"


@interface TwoViewController ()<IDCPageViewControllerDelegate>

@property(nonatomic,strong)UISegmentedControl *segmentControl;
@property(nonatomic,strong)IDCPageViewController *pageControll;

@property(nonatomic,strong)UIButton *cancelButton;
@property(nonatomic,strong)UIButton *deterButton;
@property(nonatomic,strong)VRefreshBtn *RButton;
@property(nonatomic,strong)UIButton *moreButton;
@property(nonatomic,strong)ZWPullMenuView *menuView;

@property(nonatomic,assign)BOOL fix;

@end

@implementation TwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.titleView = self.segmentControl;
                                     
    [self createRightButtonsWithDisplay:YES];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self createMainConfig];
}

-(UIButton *)cancelButton{
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(managerTheStockCancel) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}
-(UIButton *)deterButton{
    if (!_deterButton) {
        _deterButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deterButton setTitle:@"确定" forState:UIControlStateNormal];
        [_deterButton addTarget:self action:@selector(managerTheStockDeter) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deterButton;
}
-(VRefreshBtn *)RButton{
    if (!_RButton) {
        _RButton = [VRefreshBtn refreshButton];
        [_RButton setButtonImage:[UIImage imageNamed:@"refresh"]];
        __weak typeof (self) weakSelf = self;
        _RButton.clickHandler = ^{
            [weakSelf managerTheStockRefresh];
        };
    }
    return _RButton;
}
-(UIButton *)moreButton{
    if (!_moreButton) {
        _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreButton setImage:[UIImage imageNamed:@"topmore"] forState:UIControlStateNormal];
        [_moreButton addTarget:self action:@selector(managerTheStockMore) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreButton;
}
-(void)createLeftAndRightButtonWithDisplay:(BOOL)display{
    if (display) {
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.cancelButton];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.deterButton];
      
    }else{
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.rightBarButtonItem = nil;
    }
}

-(void)createRightButtonsWithDisplay:(BOOL)display{
    if (display) {
        UIBarButtonItem *refresh = [[UIBarButtonItem alloc] initWithCustomView:self.RButton];
        UIBarButtonItem *more = [[UIBarButtonItem alloc] initWithCustomView:self.moreButton];
        self.navigationItem.rightBarButtonItems = @[more,refresh];
    }else{
        self.navigationItem.rightBarButtonItems = nil;
    }
}
#pragma mark - 刷新方法
-(void)managerTheStockRefresh{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.RButton refreshStatusEnd];
    });
}
-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    [self.menuView animateRemoveView];
}
#pragma mark - 点击更多
-(void)managerTheStockMore{
    self.menuView = [ZWPullMenuView pullMenuAnchorView:self.moreButton titleArray:@[@"组管理",@"添加自选股",@"管理自选股",@"刷新设置"] imageArray:@[@"moreSet",@"moreAdd",@"optionalEdit",@"stock_menu_refresh"]];
    self.menuView.zwPullMenuStyle = PullMenuLightStyle;
    __weak typeof (self) weakSelf = self;
    self.menuView.blockSelectedMenu = ^(NSInteger menuRow) {
        NSLog(@"index = %ld",(long)menuRow);
        if (menuRow == 0) {
            weakSelf.navigationItem.rightBarButtonItems = nil;
            weakSelf.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:weakSelf.cancelButton];
            weakSelf.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:weakSelf.deterButton];
        }else if (menuRow == 3){
            VRefreshPopView *popView = [VRefreshPopView showWithView:weakSelf.view];
            popView.selectedIndex = [[NSUserDefaults standardUserDefaults] integerForKey:@"SELECTEDINDEX"];
            popView.clickHandler = ^(NSUInteger selectedIndex) {
                NSLog(@"index = %ld",selectedIndex);
                [[NSUserDefaults standardUserDefaults] setInteger:selectedIndex forKey:@"SELECTEDINDEX"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            };
            
        }
    };
    
}
#pragma mark - 点击取消
-(void)managerTheStockCancel{
    self.navigationItem.leftBarButtonItem = nil;
    UIBarButtonItem *refresh = [[UIBarButtonItem alloc] initWithCustomView:self.RButton];
    UIBarButtonItem *more = [[UIBarButtonItem alloc] initWithCustomView:self.moreButton];
    self.navigationItem.rightBarButtonItems = @[more,refresh];
}
#pragma mark - 点击确定
-(void)managerTheStockDeter{
    self.navigationItem.leftBarButtonItem = nil;
    UIBarButtonItem *refresh = [[UIBarButtonItem alloc] initWithCustomView:self.RButton];
    UIBarButtonItem *more = [[UIBarButtonItem alloc] initWithCustomView:self.moreButton];
    self.navigationItem.rightBarButtonItems = @[more,refresh];
}
-(void)managerTheStock{
    self.fix = YES;
    [self createRightButtonsWithDisplay:NO];
    [self createLeftAndRightButtonWithDisplay:self.fix];
    
}
-(void)createMainConfig{
    self.pageControll = [[IDCPageViewController alloc] init];
    self.pageControll.pageViewControllerDelegate = self;
    [self addChildViewController:self.pageControll];
    
    ZHStockViewController *stockVC = [[UIStoryboard storyboardWithName:@"Market" bundle:nil] instantiateViewControllerWithIdentifier:@"ZHStockViewController"];
    [self.pageControll addChildViewController:stockVC];
    
    ZHMarketViewController *marketVC = [[ZHMarketViewController alloc] init];
    [self.pageControll addChildViewController:marketVC];
    
    self.pageControll.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self.view addSubview:self.pageControll.view];
    [self.pageControll.view mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}


-(UISegmentedControl *)segmentControl{
    if (!_segmentControl) {
        
        _segmentControl = [[UISegmentedControl alloc] initWithItems:@[@"自选股",@"行情"]];
        _segmentControl.frame = CGRectMake(0, 0, 146, 28);
        _segmentControl.selectedSegmentIndex = 0;
        _segmentControl.tintColor = [UIColor whiteColor];
        [_segmentControl setTitleTextAttributes:@{NSFontAttributeName:FONT_9_MEDIUM(16)} forState:UIControlStateNormal];
        [_segmentControl addTarget:self action:@selector(segmentedControlAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _segmentControl;
}

-(void)idcPageViewController:(IDCPageViewController*)vc didScrollToViewControllerAtIndex:(NSInteger)index{
    self.segmentControl.selectedSegmentIndex = index;
    NSLog(@"IDCPageViewController didScrollToViewControllerAtIndex %d",(int)index);
    
    if (index == 1) {
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.rightBarButtonItems = nil;
    }else{
        UIBarButtonItem *refresh = [[UIBarButtonItem alloc] initWithCustomView:self.RButton];
        UIBarButtonItem *more = [[UIBarButtonItem alloc] initWithCustomView:self.moreButton];
        self.navigationItem.rightBarButtonItems = @[more,refresh];
    }
}

-(void)segmentedControlAction:(UISegmentedControl *)sender {
    NSLog(@"%zd",sender.selectedSegmentIndex);
    [self.pageControll scrollToIndexViewController:sender.selectedSegmentIndex animated:NO];
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
