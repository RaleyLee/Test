//
//  UIView+Helper.h
//  WBAPP
//
//  Created by hibor on 2018/5/3.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Helper)


 
/**
 给单个UIView视图添加边线

 @param view 要设置边线的View视图
 @param top 添加上边线
 @param left 添加左边线
 @param bottom 添加底边线
 @param right 添加右边线
 @param color 边线颜色
 @param width 边线的宽度
 @param height 边线高度
 @return 返回绘制好的View视图
 */

+ (UIView *)setBorderWithView:(UIView *)view top:(BOOL)top left:(BOOL)left bottom:(BOOL)bottom right:(BOOL)right borderColor:(UIColor *)color borderWidth:(CGFloat)width borderHeight:(CGFloat)height;


/**
 给多个UIView视图添加边线 九宫格样式

 @param views 要设置边线的View视图Array
 @param column 列数
 @param color 边线颜色
 */

+(void)setBorderWithViews:(NSArray *)views columuns:(NSInteger)column borderColor:(UIColor *)color;


-(UIView *)circleWithBezierCorner:(CGFloat)corner;

@end
