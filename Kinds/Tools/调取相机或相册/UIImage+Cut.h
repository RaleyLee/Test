//
//  UIImage+Cut.h
//  CalendarLib
//
//  Created by wang yepin on 13-4-18.
//
//

#import <UIKit/UIKit.h>

@interface UIImage (Cut)

- (UIImage *)subImageInRect:(CGRect)rect;
- (UIImage *)scaleToSize:(CGSize)size;
- (UIImage *)imageScaleAspectFillFromTop:(CGSize)frameSize;
- (UIImage *)imageFillSize:(CGSize)viewsize;
- (UIImage *)scaleAndRotateImage;

- (UIImage *)resizeCanvas:(CGSize)sz alignment:(int)alignment;
+ (UIImage *)imageWithColor:(UIColor *)color;   // 生成纯色的图片

- (UIImage*)makeRoundCornersWithRadius:(const CGFloat)RADIUS;

@end
