//
//  CYPageViewHeader.h
//  16_0531再窥约束
//
//  Created by yinxukun on 2016/10/17.
//  Copyright © 2016年 pinAn.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#define CYScreenWidth [[UIScreen mainScreen] bounds].size.width

@protocol CYPageViewHeaderDelegate <NSObject>

- (void)CYPageViewHeaderTapTitle:(NSInteger)toIndex;

@end

@interface CYPageViewHeader : UIView

//滚动条
@property (nonatomic, strong) UIView *moveLine;

//标题
@property (nonatomic, strong, readwrite) NSArray <NSString *>*titles;

@property (nonatomic, weak) id<CYPageViewHeaderDelegate> delegate;

@property (nonatomic, strong, readonly) UIPageViewController *pageViewController;

@property (nonatomic, strong) NSArray <UIViewController *>*pageViewControllers;

- (instancetype)initWithFrame:(CGRect)frame
                       titles:(NSArray <NSString *>*)titles
          pageViewControllers:(NSArray <UIViewController *>*)pageViewControllers;

@end
