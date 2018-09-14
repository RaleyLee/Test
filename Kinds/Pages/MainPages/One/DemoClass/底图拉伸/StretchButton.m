//
//  StretchButton.m
//  Kinds
//
//  Created by hibor on 2018/8/10.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import "StretchButton.h"

@interface StretchButton()

@property(nonatomic,assign)BOOL isShow;

@end

@implementation StretchButton


-(void)setTitle:(NSString *)title forState:(UIControlState)state{
    [super setTitle:title forState:state];
    

}

-(void)layoutSubviews{
    [super layoutSubviews];

}

#pragma mark - 上下拉伸
- (UIImage *)hcl_stretchTopAndDownWithContainerSize:(CGSize)imageViewSize
{
    CGSize imageSize           = self.size;
    CGSize bgSize              = CGSizeMake((int)(imageViewSize.width), (int)(imageViewSize.height));
    UIImage *image             = [[UIImage imageNamed:@"TestBgImage"] stretchableImageWithLeftCapWidth:(int)(imageSize.width * 0.8) topCapHeight:(int)(imageSize.height * 0.8)];
    CGFloat tempHeight         = (bgSize.height) / 2 + (imageSize.height) / 2;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(bgSize.width, tempHeight), NO, [UIScreen mainScreen].scale);
    [image drawInRect:CGRectMake(0, 0,bgSize.width, tempHeight)];
    UIImage *firstStrechImage  = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImage *finalStretchImage = [firstStrechImage stretchableImageWithLeftCapWidth:(int)(imageSize.width * 0.8) topCapHeight:(int)(imageSize.height * 0.2)];
    
    return finalStretchImage;
}

#pragma mark - 左右拉伸

- (UIImage *)hcl_stretchLeftAndRightWithContainerSize:(CGSize)imageViewSize
{
    CGSize imageSize           = self.size;
    CGSize bgSize              = CGSizeMake((int)(imageViewSize.width), (int)(imageViewSize.height));
    UIImage *image             = [[UIImage imageNamed:@"TestBgImage"] stretchableImageWithLeftCapWidth:(int)(imageSize.width * 0.8) topCapHeight:(int)(imageSize.height * 0.8)];
    CGFloat tempWidth          = (bgSize.width) / 2 + (imageSize.width) / 2;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(tempWidth, bgSize.height), NO, [UIScreen mainScreen].scale);
    [image drawInRect:CGRectMake(0, 0, tempWidth, bgSize.height)];
    UIImage *firstStrechImage  = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImage *finalStretchImage = [firstStrechImage stretchableImageWithLeftCapWidth:(int)(imageSize.width * 0.2) topCapHeight:(int)(imageSize.height * 0.8)];
    
    return finalStretchImage;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
