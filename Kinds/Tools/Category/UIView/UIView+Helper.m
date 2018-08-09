//
//  UIView+Helper.m
//  WBAPP
//
//  Created by hibor on 2018/5/3.
//  Copyright © 2018年 hibor. All rights reserved.
//

#define VIEW_WIDTH  view.frame.size.width
#define VIEW_HEIGHT  view.frame.size.height

#import "UIView+Helper.h"

@implementation UIView (Helper)

+ (UIView *)setBorderWithView:(UIView *)view top:(BOOL)top left:(BOOL)left bottom:(BOOL)bottom right:(BOOL)right borderColor:(UIColor *)color borderWidth:(CGFloat)width borderHeight:(CGFloat)height;
{
    
    if (top) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake((VIEW_WIDTH-width)/2, 0, width, height);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
    if (left) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, (VIEW_HEIGHT-height)/2, width, height);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
    if (bottom) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake((VIEW_WIDTH-width)/2, VIEW_HEIGHT - height, VIEW_WIDTH, height);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
    if (right) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(VIEW_WIDTH - width, (VIEW_HEIGHT-height)/2, width, height);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
    return  view;
}

+(void)setBorderWithViews:(NSArray *)views columuns:(NSInteger)column borderColor:(UIColor *)color{
    
//    NSInteger totalRows = views.count / column + (views.count % column > 0 ? 1 : 0);     //总共有多少行
    float lineWidth = 0.5;     //边线的粗细
    
    for (int i = 0; i < views.count; i++) {
        
        NSInteger row = i / column;     //当前是第几行
        
        UIView *view = views[i];        //获取当前view
        CGFloat view_width = view.frame.size.width;
        CGFloat view_height = view.frame.size.height;
        
        if (row == 0) {
            //添加上边线
            CALayer *topLayer = [CALayer layer];
            topLayer.frame = CGRectMake(0, 0, view_width, lineWidth);
            topLayer.backgroundColor = color.CGColor;
            [view.layer addSublayer:topLayer];
        }
        //添加下边线
        CALayer *bottomLayer = [CALayer layer];
        bottomLayer.frame = CGRectMake(0, view_height-lineWidth, view_width, lineWidth);
        bottomLayer.backgroundColor = color.CGColor;
        [view.layer addSublayer:bottomLayer];
        //添加左边线
        CALayer *leftLayer = [CALayer layer];
        leftLayer.frame = CGRectMake(0, 0, lineWidth, view_height);
        leftLayer.backgroundColor = color.CGColor;
        [view.layer addSublayer:leftLayer];
        //添加右边线
        if (i == (row+1)*column-1 || i == views.count -1) {
            CALayer *rightLayer = [CALayer layer];
            rightLayer.frame = CGRectMake(view_width-lineWidth, 0, lineWidth, view_height);
            rightLayer.backgroundColor = color.CGColor;
            [view.layer addSublayer:rightLayer];
        }
    }
}

-(UIView *)circleWithBezierCorner:(CGFloat)corner{
    UIBezierPath *bezier = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:corner];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = bezier.CGPath;
    self.layer.mask = shapeLayer;
    return self;
}
@end
