//
//  IDCPageViewController.m
//  爱豆
//
//  Created by idol_ios on 2017/6/19.
//  Copyright © 2017年 idol_ios. All rights reserved.
//

#import "IDCPageViewController.h"

#define IDCPageViewController_Item_Space (1.0f)//为了在判断边界不要纠结>= 还是 > ( <=还是< ) ,索性每个childViewController的view之间都有这个间隔，判断起来就不用 >=， <=了

typedef NS_ENUM (NSUInteger, IDCPageViewControllerItemAppearState) {
    IDCPageViewControllerItemAppearStateIsHidden = 0,
    IDCPageViewControllerItemAppearStateIsShow = 1,
};

@class IDCPageView;
@protocol IDCPageViewDelegate <NSObject>

-(void)layoutSubviewsByIDCPageView:(IDCPageView*)view;

@end


@interface IDCPageView : UIView
@property (nonatomic, assign) NSUInteger viewControllerCount;
@property (nonatomic, weak) id<IDCPageViewDelegate> pageViewDelegate;
@end

@implementation IDCPageView

-(void)layoutSubviews{
    [super layoutSubviews];
    
    if ([_pageViewDelegate respondsToSelector:@selector(layoutSubviewsByIDCPageView:)]) {
        [_pageViewDelegate layoutSubviewsByIDCPageView:self];
    }
}

@end




@interface IDCPageViewController ()<UIScrollViewDelegate,IDCPageViewDelegate>
@property (nonatomic, strong) UIScrollView* scrollView;
@property (nonatomic, strong) NSMutableArray* arrayAppearState;
@property (nonatomic, strong) NSMutableArray* selfChildViewControllers;
@property (nonatomic, assign) NSInteger nowIndex;//这次显示的index
@property (nonatomic, assign) NSUInteger viewControllerCount;
@property (nonatomic, assign) BOOL bInitView;
@property (nonatomic, assign) BOOL bFirstMakeChildViewControllerAppear;
@end

@implementation IDCPageViewController

-(instancetype)init{
    
    if (self = [super init]) {
        self.selfChildViewControllers = [NSMutableArray array];
        self.bFirstMakeChildViewControllerAppear = YES;
        self.isStop = YES;
    }
    return self;
}

-(void)loadView{
    IDCPageView* pageView = [[IDCPageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    pageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    pageView.pageViewDelegate = self;
    self.view = pageView;
}


-(void)addChildViewController:(UIViewController *)childController{
    //这里，自己管理childViewController,
    if (self.bInitView) {
        [super addChildViewController:childController];
    }else{
        [self.selfChildViewControllers addObject:childController];
    }
}

-(NSArray<__kindof UIViewController *> *)childViewControllers{
    if (self.bInitView) {
        return [super childViewControllers];
    }else{
        return [self.selfChildViewControllers copy];
    }
}

-(NSArray<__kindof UIViewController *> *)getRealAllChildViewControllers{
    
    return [self.selfChildViewControllers copy];
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.arrayAppearState = [NSMutableArray array];
    
    self.viewControllerCount = [self.selfChildViewControllers count];
    
    for (int i = (int)self.viewControllerCount - 1; i >= 0; i --) {
        [self.arrayAppearState addObject:@(IDCPageViewControllerItemAppearStateIsHidden)];
    }
    
    
    self.scrollView = ({
        UIScrollView* s = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width + IDCPageViewController_Item_Space, self.view.bounds.size.height)];
        s.backgroundColor = [UIColor clearColor];
        s.showsHorizontalScrollIndicator = NO;
        s.bounces = NO;
        s.minimumZoomScale = s.maximumZoomScale = 1.0f;
        s.delaysContentTouches = NO;
        s.pagingEnabled = YES;
        [self.view addSubview:s];
        s;
    });
    
}

-(void)scrollToIndexViewController:(NSInteger)index animated:(BOOL)animated{
    
    if (index >= 0 && index < self.viewControllerCount) {
        [self.scrollView setContentOffset:CGPointMake(index*self.scrollView.bounds.size.width, 0) animated:animated];
        self.nowIndex = index;//要事先记录一下当前设置的index,因为一开始时scrollView的delegate为空，上面的函数执行后，scrollViewDidScroll:不会执行，在layoutSubViews后才会赋值scrollView的delegate，且显示调用scrollViewDidScroll:一次，这时，根据nowIndex，会正确显示nowIndex的childViewController
    }
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat currentOffsetX = self.scrollView.contentOffset.x;
    
    CGFloat offsetMiddleX = currentOffsetX + (self.scrollView.bounds.size.width/2);
    
    NSInteger index = (NSInteger)floor( offsetMiddleX/self.scrollView.bounds.size.width );
    
    
    if (index < self.viewControllerCount && index >= 0) {
        if (index != self.nowIndex) {
            self.nowIndex = index;
            if ([_pageViewControllerDelegate respondsToSelector:@selector(idcPageViewController: didScrollToViewControllerAtIndex:)]) {
                [_pageViewControllerDelegate idcPageViewController:self didScrollToViewControllerAtIndex:index];
            }
        }
    }
    
    
    if (index < self.viewControllerCount && index >= 0) {
        
        if ([[self.arrayAppearState objectAtIndex:index] intValue] == 0) {
//            NSLog(@"scrollViewDidScroll make appear contentOffsetX:%lf index:%d", currentOffsetX,(int)index);
            [self makeIndexViewAppear:index];
        }
        
        
        if (index + 1 < self.viewControllerCount && [[self.arrayAppearState objectAtIndex:index + 1] intValue] == 0 && [self checkIfIndexCellAppear:index + 1 offsetX:currentOffsetX]) {
//            NSLog(@"scrollViewDidScroll make appear contentOffsetX:%lf index:%d", currentOffsetX, (int)index + 1);
            [self makeIndexViewAppear:index + 1];
        }
        
        if (index - 1 >= 0 && [[self.arrayAppearState objectAtIndex:index - 1] intValue] == 1 && [self checkIfIndexCellDisAppear:index - 1 offsetX:currentOffsetX]) {
//            NSLog(@"scrollViewDidScroll make appear contentOffsetX:%lf index:%d", currentOffsetX, (int)index - 1);
            [self makeIndexViewDisAppear:index - 1];
        }
        
        
        
        if (index - 1 >= 0 && [[self.arrayAppearState objectAtIndex:index - 1] intValue] == 0 && [self checkIfIndexCellAppear:index - 1 offsetX:currentOffsetX]) {
            [self makeIndexViewAppear:index - 1];
            
        }
        
        if (index + 1 < self.viewControllerCount && [[self.arrayAppearState objectAtIndex:index + 1] intValue] == 1 && [self checkIfIndexCellDisAppear:index + 1 offsetX:currentOffsetX]) {
            [self makeIndexViewDisAppear:index + 1];
        }
        
        
        
        
        
        for (int i = 0; i < self.viewControllerCount; i ++) {
            if (i == index - 1 || i == index || i == index + 1) {
                continue;
            }
            
            
            if ( [[self.arrayAppearState objectAtIndex:i] intValue] == 1 && [self checkIfIndexCellDisAppear:i offsetX:currentOffsetX]) {
                [self makeIndexViewDisAppear:i];
            }
            
        }
        
        
    }
    
    self.nowIndex = index;
}

-(BOOL)checkIfIndexCellDisAppear:(NSInteger)index offsetX:(CGFloat)offsetX{
    
    CGFloat width = self.scrollView.bounds.size.width, left = index*width, right = left + width - IDCPageViewController_Item_Space;
    
    if (left >= offsetX + width || right < offsetX) {
        return YES;
    }else{
        return NO;
    }
}


-(BOOL)checkIfIndexCellAppear:(NSInteger)index offsetX:(CGFloat)offsetX{
    
    CGFloat width = self.scrollView.bounds.size.width, left = index*width, right = left + width - IDCPageViewController_Item_Space;
    
    if (left < offsetX + width && right >= offsetX) {
        return YES;
    }else{
        return NO;
    }
    
    
}


-(void)makeIndexViewAppear:(NSInteger)index{
    
    UIViewController* vc = self.selfChildViewControllers[index];
    
    if (self.bFirstMakeChildViewControllerAppear) {
        self.bFirstMakeChildViewControllerAppear = NO;
        dispatch_async(dispatch_get_main_queue(), ^{//不知为什么ios7中第一次加入view时，第一个childViewController的view会执行两次viewDidAppear,这里异步进行childViewController操作后就不会
            [self addChildViewController:vc];
        });
    }else{
        [self addChildViewController:vc];
    }
    
    
    UIView* view = vc.view;
    view.frame = (CGRect){ {self.scrollView.bounds.size.width*index, 0}, {self.scrollView.bounds.size.width - IDCPageViewController_Item_Space, self.scrollView.bounds.size.height} };
    [self.scrollView addSubview: view];
    
    [self.arrayAppearState replaceObjectAtIndex:index withObject:@(IDCPageViewControllerItemAppearStateIsShow)];
    
}

-(void)makeIndexViewDisAppear:(NSInteger)index{
    
    UIViewController* vc = self.selfChildViewControllers[index];
    
    UIView* view = vc.view;
    [view removeFromSuperview];
    
    [vc removeFromParentViewController];
    
    [self.arrayAppearState replaceObjectAtIndex:index withObject:@(IDCPageViewControllerItemAppearStateIsHidden)];
}

#pragma mark - IDCPageViewDelegate
-(void)layoutSubviewsByIDCPageView:(IDCPageView *)view{
    
    self.bInitView = YES;//在调用过layoutSubViews后才是自己的逻辑 正确的开始，
    
    self.scrollView.delegate = nil; //发现在不同系统中，设置scrollView的contentOffset, frame，contentSize等都有可能会各自的可能调用到scrollViewDidScroll：（且调用的时间都可能略有不同），索性delegate设为空，待自己的逻辑处理完成后，再来设置delegate,自己来调用scrollViewDidScroll：
    
    
//    NSLog(@"IDCPageView layoutSubviews, size:%f %f",self.view.bounds.size.width, self.view.bounds.size.height);
    
    
    self.scrollView.frame = CGRectMake(0, 0, self.view.bounds.size.width + IDCPageViewController_Item_Space, self.view.bounds.size.height);
    
    
    if (self.nowIndex >= 0 && self.nowIndex < self.viewControllerCount) {
        
        NSInteger nowIndex = self.nowIndex;
        
        if (nowIndex < [self.arrayAppearState count]) {
            [self.arrayAppearState replaceObjectAtIndex:nowIndex withObject:@(IDCPageViewControllerItemAppearStateIsHidden)];//layoutSubViews,可能是scrollView的大小变化了，把这个标记设置为隐藏，这段函数后面调用scrollViewDidScroll:里，会把childViewController的view大小重新设置
        }
        
        
//        NSLog(@"IDCPageView layoutSubviews, setContentOffsetX:%f forIndex:%d", lastIndex*self.scrollView.bounds.size.width, (int)lastIndex);
        
        [self.scrollView setContentOffset:CGPointMake(nowIndex*self.scrollView.bounds.size.width, 0) animated:NO];
        self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width*self.viewControllerCount, 1);
        
//        NSLog(@"IDCPageView layoutSubviews, getContentOffsetX:%f ", self.scrollView.contentOffset.x);
    }
    
    [self scrollViewDidScroll:self.scrollView];
    self.scrollView.delegate = self;
    
}


@end
