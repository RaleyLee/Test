//
//  UIImage+Helper.h
//  WBAPP
//
//  Created by hibor on 2018/3/22.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface UIImage (Helper)

+(UIImage *)navBGImageWithColor:(UIColor *)color;

+ (UIImage *)scaleToSize:(UIImage*)img size:(CGSize)size;

//生成指定size 颜色的UIImage
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

+ (UIImage *)buttonImageFromColor:(UIColor *)color;

//重新绘制图片
//@param color 填充色
//@return UIImage
- (UIImage *)imageWithColor:(UIColor *)color;

//获取长图
+ (UIImage *)captureScrollView:(UIScrollView *)scrollView;
//拼接图片
+ (UIImage *)composeTopImage:(UIImage *)topImage bottomImage:(UIImage *)bottomImage;


+ (BOOL)imageHasAlpha:(UIImage *)image;

//iOS 除去图片的白色背景(接近白色)，或者其它颜色的替换
//去除图片的白色背景
+ (UIImage *)imageToTransparent:(UIImage *)image;

/**
 获取视频某帧

 @param videoURL 传入视频的链接
 @param time 截取指定时间的帧
 @return 返回指定帧图片
 */
+ (UIImage*) thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time;


/**
 分割图片

 @param row 行数
 @param column 列数
 @param originImage 需要分割的图片
 @return 分割后的图片数组
 */
+(NSMutableArray *)splitPictureWithRow:(NSInteger)row withColumn:(NSInteger)column withImage:(UIImage *)originImage;


+ (UIImage *)createNewImageWithContent:(NSString *)content;

+ (UIImage *)createShareImage:(UIImage *)tImage Context:(NSString *)text;


/**
 将图片修改成指定颜色

 @param color 要修改的颜色
 @return 修改后的的图片
 */
-(UIImage*)imageChangeColor:(UIColor*)color;
@end
