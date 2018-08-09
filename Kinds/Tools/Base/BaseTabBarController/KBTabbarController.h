//
//  KBTabbarController.h
//  KBTabbarController
//
//  Created by kangbing on 16/5/31.
//  Copyright © 2016年 kangbing. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^centerButtonBlock)(UIButton *centerButton);

@interface KBTabbarController : UITabBarController

@property(nonatomic,copy)centerButtonBlock centerBlock;


-(instancetype)initWithControllers:(NSArray *)controlls titles:(NSArray *)titles normalImages:(NSArray *)normals selectedImages:(NSArray *)selecteds withNavigation:(NSArray <UINavigationController *> *)navControlls withTintColor:(UIColor *)tintColor withCenterButtonBlock:(centerButtonBlock)block;


/**
 使用属性创建中间凸起的按钮
 当controlls的个数为单数时不生效
 */
@property(nonatomic,assign)BOOL createCenterButton; //Default is NO,if set to YES,a center button will add to the current tabBarController


/**
 使用方法创建中间凸起的按钮
 当controlls的个数为单数时不生效
 */
-(void)setCustomtabbar;


/**
 调用此方法 使centerButton旋转到初始角度 0°
 */
-(void)centerButtonResetStateNormal;


/**
 调用此方法 使centerButton顺时针旋转45°

 @param centerButton 中间的button
 */
-(void)centerButtonRotationDegress45:(UIButton *)centerButton;

@end
