//
//  CYPageViewHeader.m
//  16_0531再窥约束
//
//  Created by yinxukun on 2016/10/17.
//  Copyright © 2016年 pinAn.com. All rights reserved.
//

#import "CYPageViewHeader.h"
#import <Masonry.h>

const CGFloat fastPercent = 0.5;

#define SPACING_LEFT 15
#define SPACING_RIGHT 15
//获取按钮宽度的前提下 增加额外的值 使点击区域放大
#define SPACING_ADD 30

@interface CYPageViewHeader ()<UIScrollViewDelegate, UIPageViewControllerDelegate, UIPageViewControllerDataSource,UIGestureRecognizerDelegate>{
    
    CGFloat Twidth_total; //所有按钮的总宽度
    
}
@property(nonatomic,assign)NSInteger selectedIndex;
@property(nonatomic,assign)CGFloat Tbuttonx; //当前按钮的X坐标
@property(nonatomic,strong)UIButton *currentButton;
@property(nonatomic,strong)NSMutableArray *widthArray; //存放按钮宽度数组

@property (nonatomic, strong) UIPageViewController *pageViewController;


@end

@implementation CYPageViewHeader


- (instancetype)initWithFrame:(CGRect)frame
                       titles:(NSArray <NSString *>*)titles
          pageViewControllers:(NSArray <UIViewController *>*)pageViewControllers{
    if (self = [super initWithFrame:frame]) {

        Twidth_total = 0.0;
        self.widthArray = [NSMutableArray array];
        
        self.titles = titles;
        self.pageViewControllers = pageViewControllers;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self cy_initUI];
        });
    }
    return self;
}


#pragma mark - UIPageViewControllerDelegate

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    NSInteger index = [self.pageViewControllers indexOfObject:viewController];
    if (index==0) {
        return nil;
    }
    else{
        return self.pageViewControllers[index-1];
    }
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    NSInteger index = [self.pageViewControllers indexOfObject:viewController];
    if (index==self.pageViewControllers.count-1) {
        return nil;
    }
    else{
        return self.pageViewControllers[index+1];
    }
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed{
    self.selectedIndex = [self.pageViewControllers indexOfObject:self.pageViewController.viewControllers[0]];
    //手势滑动页面后调整标题
    self.currentButton = (UIButton *)[self viewWithTag:9000+self.selectedIndex];
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.currentButton.frame;
        frame.size.height = STOCK_MUTIMENU_LINE_HEIGHT;
        frame.origin.y = self.moveLine.frame.origin.y;
        self.moveLine.frame = frame;
    }];
}


- (void)cyChangeRotate:(NSNotification*)noti {
    
//    CGFloat space = (SCREEN_WIDTH-Twidth_total-SPACING_LEFT-SPACING_RIGHT)/(_titles.count-1);
    CGFloat moreFloat = (IS_IPHONEX && SCREEN_WIDTH > SCREEN_HEIGHT) ? 88 : 0;
    CGFloat space = (SCREEN_WIDTH-Twidth_total-SPACING_LEFT-SPACING_RIGHT - moreFloat)/(_titles.count-1);
    self.Tbuttonx = SPACING_LEFT + moreFloat/2;
    
    [self.titles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *button = (UIButton *)[self viewWithTag:9000+idx];
        [button setFrame:CGRectMake(self.Tbuttonx, 0, [self.widthArray[idx] floatValue], STOCK_MUTIMENU_BUTTON_HEIGHT)];
        if (idx == self.selectedIndex) {
            self.currentButton = button;
            [UIView animateWithDuration:0.3 animations:^{
                CGRect frame = self.currentButton.frame;
                frame.size.height = STOCK_MUTIMENU_LINE_HEIGHT;
                frame.origin.y = self.moveLine.frame.origin.y;
                self.moveLine.frame = frame;
            }];
        }
//        [button mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_offset(Tbuttonx);
//            make.width.mas_equalTo([self.widthArray[idx] floatValue]);
//        }];
        self.Tbuttonx += (space+[self.widthArray[idx] floatValue]);
        
    }];
}

#pragma mark - private

- (void)cy_initUI{

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(cyChangeRotate:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
    
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.backgroundColor = STOCK_MUTIMENU_BG_COLOR;
    self.selectedIndex = 0;
    
    [self.titles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitleColor:STOCK_MUTIMENU_TEXTCOLOR forState:UIControlStateNormal];
        [button setTitle:self.titles[idx] forState:UIControlStateNormal];
        button.titleLabel.font = FONT_9_MEDIUM(STOCK_MUTIMEMU_FONT);
        button.tag = 9000+idx;
        [button addTarget:self action:@selector(menuButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
        CGFloat buttonWidth = [self.titles[idx] sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:STOCK_MUTIMEMU_FONT]}].width + SPACING_ADD;
        [self.widthArray addObject:@(buttonWidth)];
        [self addSubview:button];
    }];
    for (int i = 0; i < self.widthArray.count; i++) {
        Twidth_total += [self.widthArray[i] floatValue];
    }
    CGFloat moreFloat = (IS_IPHONEX && SCREEN_WIDTH > SCREEN_HEIGHT) ? 88 : 0;
    CGFloat space = (SCREEN_WIDTH-Twidth_total-SPACING_LEFT-SPACING_RIGHT - moreFloat)/(_titles.count-1);
    self.Tbuttonx = SPACING_LEFT + moreFloat/2;
//    CGFloat space = (SCREEN_WIDTH-Twidth_total-SPACING_LEFT-SPACING_RIGHT)/(_titles.count-1);
//    Tbuttonx = SPACING_LEFT;
    
    [self.titles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *button = (UIButton *)[self viewWithTag:9000+idx];
        [button setFrame:CGRectMake(self.Tbuttonx, 0, [self.widthArray[idx] floatValue], STOCK_MUTIMENU_BUTTON_HEIGHT)];
        if (idx == self.selectedIndex) {
            self.currentButton = button;
            self.moveLine = [[UIView alloc] initWithFrame:CGRectMake(self.Tbuttonx, STOCK_MUTIMENU_BUTTON_HEIGHT, [self.widthArray[idx] floatValue], STOCK_MUTIMENU_LINE_HEIGHT)];
            self.moveLine.backgroundColor = STOCK_CONTENT_REDCOLOR;
            [self addSubview:self.moveLine];
        }
        self.Tbuttonx += (space+[self.widthArray[idx] floatValue]);
    }];
    
}

-(void)menuButtonClickAction:(UIButton *)sender{
    if (sender != self.currentButton) {
        self.currentButton = sender;
        self.selectedIndex = sender.tag - 9000;
        
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = self.currentButton.frame;
            frame.size.height = STOCK_MUTIMENU_LINE_HEIGHT;
            frame.origin.y = self.moveLine.frame.origin.y;
            self.moveLine.frame = frame;
        }];
        [self.pageViewController setViewControllers:@[self.pageViewControllers[self.selectedIndex]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:^(BOOL finished) {
        }];
    }
}


- (UIPageViewController *)pageViewController{
    if (!_pageViewController) {
        _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        [self.pageViewController setViewControllers:@[self.pageViewControllers[0]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL finished) {
        }];
        _pageViewController.delegate = self;
        _pageViewController.dataSource = self;
        for (UIView *view in _pageViewController.view.subviews) {
            if ([view isKindOfClass:[UIScrollView class]]) {
                UIScrollView *scroll = (UIScrollView *)view;
                scroll.delegate = self;
            }
        }
    }
    return _pageViewController;
}

@end
