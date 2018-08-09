//
//  BaseViewController.h
//  Kinds
//
//  Created by hibor on 2018/6/20.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VRefreshBtn.h"

@interface BaseViewController : UIViewController


@property(nonatomic,strong)VRefreshBtn *VRefreshButton;  //带动画效果
@property(nonatomic,strong)UIButton *refreshButton;   //普通button 没有动画效果

@property(nonatomic,assign)BOOL firstAppear;

@property(nonatomic,assign)BOOL isPullToRefresh;


typedef void (^RefreshButtonBlock)(void);
@property(nonatomic,copy)RefreshButtonBlock refreshBlock;

/**
 刷新回调
 点击之后没有加载的效果
 @param refreshBlock 回调
 */
-(void)setRefreshButtonWithBlock:(RefreshButtonBlock)refreshBlock;

/**
 刷新回调
 点击之后有加载的效果 UIActivityIndicatorView
 @param refreshBlock 回调
 */
-(void)setRefreshButtonAnimationWithBlock:(RefreshButtonBlock)refreshBlock;

//旋转屏幕
-(void)rotateChange;

//点击状态条 回到顶部
-(void)goTop;

/**
 返回当前视图的父ViewController

 @param currentController 当前ViewController
 @return 父ViewController
 */
-(UIViewController *)superViewController:(UIViewController *)currentController;

@end
