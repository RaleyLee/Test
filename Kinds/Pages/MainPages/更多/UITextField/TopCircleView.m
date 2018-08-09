//
//  TopCircleView.m
//  Kinds
//
//  Created by hibor on 2018/7/13.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import "TopCircleView.h"

@implementation TopCircleView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {

    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //线宽
    CGFloat lineWidth = 2.0f;
    
    CGContextSetRGBStrokeColor(context,1,0,0,1.0);//画笔线的颜色
    CGContextSetLineWidth(context, lineWidth);//线的宽度
    // x,y为圆点坐标，radius半径，startAngle为开始的弧度，endAngle为 结束的弧度，clockwise 0为顺时针，1为逆时针。
    CGContextAddArc(context, rect.size.width/2, rect.size.height/2, rect.size.width/2-1, 0, 2*M_PI, 0); //添加一个圆
    CGContextDrawPath(context, kCGPathStroke); //绘制路径

    //内圆与外圆的间隔
    CGFloat space = 5.0f;
    
    //内圈圆半径
    CGFloat circle_R = rect.size.width/2-space;
    
    //填充圆，无边框
    UIColor*aColor = [UIColor colorWithRed:1.0 green:0.0 blue:0 alpha:1];
    CGContextSetFillColorWithColor(context, aColor.CGColor);//填充颜色
    CGContextAddArc(context, rect.size.width/2, rect.size.height/2, circle_R, 0, 2*M_PI, 0); //添加一个圆
    CGContextDrawPath(context, kCGPathFill);//绘制填充

    
    
    //内容正方形的边长
    int LWidth = (int)sqrt(((circle_R *2) * (circle_R * 2)) / 2);
    int topX = (int)(rect.size.width - LWidth)/2;
    
    
    CGRect labelRect = CGRectMake(topX, topX, LWidth, LWidth);
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor purpleColor];
    label.textColor = [UIColor whiteColor];
    label.text = _contentNumber;
    label.textAlignment = NSTextAlignmentCenter;
//    label.font = [UIFont systemFontOfSize:LWidth];
    label.adjustsFontSizeToFitWidth = YES;
    [label drawTextInRect:labelRect];
    

}

-(void)setContentNumber:(NSString *)contentNumber{
    _contentNumber = contentNumber;
}

@end
