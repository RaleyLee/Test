//
//  CCSlider.m
//  Kinds
//
//  Created by hibor on 2018/8/6.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import "CCSlider.h"

@implementation CCSlider

-(UIImage*) OriginImage:(UIImage*)image scaleToSize:(CGSize)size

{
    
    UIGraphicsBeginImageContext(size);//size为CGSize类型，即你所需要的图片尺寸
    
    [image drawInRect:CGRectMake(0,0, size.width, size.height)];
    
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;
    
}

#pragma mark - 修改滑块的触摸范围
//-(CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value {
//
//    rect.origin.x=rect.origin.x-10;
//
//    rect.size.width=rect.size.width-10;
//    return CGRectInset([super thumbRectForBounds:bounds trackRect:rect value:value],2,2);
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
