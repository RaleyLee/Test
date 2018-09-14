//
//  DownViewController.m
//  Kinds
//
//  Created by hibor on 2018/8/18.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import "DownViewController.h"

#import "IDCPageViewController.h"
#import "LoadingViewController.h"
#import "LoadedViewController.h"

@interface DownViewController ()<IDCPageViewControllerDelegate>

@property (nonatomic,strong) UISegmentedControl *segmentControl;
@property (nonatomic,strong) IDCPageViewController *pageControl;

@end

@implementation DownViewController

-(UISegmentedControl *)segmentControl{
    if (!_segmentControl) {
        _segmentControl = [[UISegmentedControl alloc] initWithItems:@[@"下载中",@"已下载"]];
        _segmentControl.frame = CGRectMake(0, 0, 146, 28);
        _segmentControl.selectedSegmentIndex = 0;
        _segmentControl.tintColor = [UIColor whiteColor];
        [_segmentControl setTitleTextAttributes:@{NSFontAttributeName:FONT_9_MEDIUM(16)} forState:UIControlStateNormal];
        [_segmentControl addTarget:self action:@selector(segmentedControlAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _segmentControl;
}

-(void)segmentedControlAction:(UISegmentedControl *)segment{
    [self.pageControl scrollToIndexViewController:segment.selectedSegmentIndex animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.titleView = self.segmentControl;
    
    self.pageControl = [[IDCPageViewController alloc] init];
    self.pageControl.pageViewControllerDelegate = self;
    [self addChildViewController:self.pageControl];
    
    
    LoadingViewController *loadVC = [[LoadingViewController alloc] init];
    [self.pageControl addChildViewController:loadVC];
    
    LoadedViewController *loadedVC = [[LoadedViewController alloc] init];
    [self.pageControl addChildViewController:loadedVC];
    
    self.pageControl.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self.view addSubview:self.pageControl.view];
    [self.pageControl.view mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
}

-(void)idcPageViewController:(IDCPageViewController *)vc didScrollToViewControllerAtIndex:(NSInteger)index{
    self.segmentControl.selectedSegmentIndex = index;
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
