//
//  MusicViewController.m
//  Kinds
//
//  Created by hibor on 2018/7/10.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import "MusicViewController.h"

#import "IDCPageViewController.h"

#import "MyMusicViewController.h"
#import "MusicHostViewController.h"
#import "MusicDisCoverViewController.h"

@interface MusicViewController ()<IDCPageViewControllerDelegate>

@property(nonatomic,strong)IDCPageViewController *pageVC;

@property(nonatomic,strong)UIView *navTitleView; //
@property(nonatomic,strong)NSArray *navTitleArray;
@property(nonatomic,assign)NSInteger currentIndex;

@end

@implementation MusicViewController

-(NSArray *)navTitleArray{
    if (!_navTitleArray) {
        _navTitleArray = @[@"我的",@"音乐馆",@"发现"];
    }
    return _navTitleArray;
}
-(UIView *)navTitleView{
    if (!_navTitleView) {
        _navTitleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 180, 30)];
        for (int i = 0; i < self.navTitleArray.count; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(60*i, 0, 60, 30);
            [button setTag: 100+i];
            [button setTitle:self.navTitleArray[i] forState:UIControlStateNormal];
            if (i == _currentIndex) {
                button.titleLabel.font = FONT_9_BOLD(18);
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }else{
                button.titleLabel.font = FONT_9_MEDIUM(16);
                [button setTitleColor:RGB(232, 233, 236) forState:UIControlStateNormal];
            }
            [button addTarget:self action:@selector(changePageAction:) forControlEvents:UIControlEventTouchUpInside];
            [_navTitleView addSubview:button];
        }
    }
    return _navTitleView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.titleView = self.navTitleView;
    
    IDCPageViewController *pagesVC = [[IDCPageViewController alloc] init];
    pagesVC.pageViewControllerDelegate = self;
    [self addChildViewController:pagesVC];
    
    MyMusicViewController *myVC = [[UIStoryboard storyboardWithName:@"Music" bundle:nil] instantiateViewControllerWithIdentifier:@"MyMusicViewController"];
    [pagesVC addChildViewController:myVC];
    
//    MusicHostViewController *hostVC = [[MusicHostViewController alloc] init];
    MusicHostViewController *hostVC = [[UIStoryboard storyboardWithName:@"Music" bundle:nil] instantiateViewControllerWithIdentifier:@"MusicHostViewController"];
    [pagesVC addChildViewController:hostVC];
    
    MusicDisCoverViewController *disCoverVC = [[MusicDisCoverViewController alloc] init];
    [pagesVC addChildViewController:disCoverVC];
    
    pagesVC.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:pagesVC.view];
    self.pageVC = pagesVC;
    [pagesVC.view mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
#pragma mark - 滑动页面
-(void)idcPageViewController:(IDCPageViewController *)vc didScrollToViewControllerAtIndex:(NSInteger)index{
    [self changeTitleEffectWithIndex:index];
}

#pragma mark - 点击导航栏头部按钮
-(void)changePageAction:(UIButton *)sender{
    [self.pageVC scrollToIndexViewController:sender.tag-100 animated:NO];
    [self changeTitleEffectWithIndex:sender.tag-100];
}
#pragma mark - 改变头部切换效果
-(void)changeTitleEffectWithIndex:(NSInteger)index{
    NSArray *array = [_navTitleView subviews];
    for (int i = 0; i < array.count; i++) {
        UIButton *button = (UIButton *)array[i];
        if (i == index) {
            button.titleLabel.font = FONT_9_BOLD(18);
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }else{
            button.titleLabel.font = FONT_9_MEDIUM(16);
            [button setTitleColor:RGB(232, 233, 236) forState:UIControlStateNormal];
        }
    }
    
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"REMOVEBOTTOMVIEW" object:nil];
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
