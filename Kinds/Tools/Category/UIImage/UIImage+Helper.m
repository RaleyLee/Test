//
//  UIImage+Helper.m
//  WBAPP
//
//  Created by hibor on 2018/3/22.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import "UIImage+Helper.h"
#import <SDWebImage/SDImageCache.h>

@implementation UIImage (Helper)

+(UIImage *)navBGImageWithColor:(UIColor *)color{
    UIImage *backgroundImage = [self imageWithColor:color size:CGSizeMake(1, 1)];
    backgroundImage = [backgroundImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, backgroundImage.size.height, backgroundImage.size.width)];
    return backgroundImage;
}

//改变图片大小
+ (UIImage *)scaleToSize:(UIImage*)img size:(CGSize)size
{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    // 返回新的改变大小后的图片
    return scaledImage;
}
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    //Create a context of the appropriate size
    UIGraphicsBeginImageContext(size);
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    //Build a rect of appropriate size at origin 0,0
    CGRect fillRect = CGRectMake(0, 0, size.width, size.height);
    
    //Set the fill color
    CGContextSetFillColorWithColor(currentContext, color.CGColor);
    
    //Fill the color
    CGContextFillRect(currentContext, fillRect);
    
    //Snap the picture and close the context
    UIImage *colorImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return colorImage;
}
+ (UIImage *)buttonImageFromColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, SCREEN_WIDTH, 50);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (UIImage *)imageWithColor:(UIColor *)color
{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, self.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextClipToMask(context, rect, self.CGImage);
    [color setFill];
    CGContextFillRect(context, rect);
    UIImage*newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - 保存长图
+ (UIImage *)captureScrollView:(UIScrollView *)scrollView {
    UIImage *image = nil;
    UIGraphicsBeginImageContextWithOptions(scrollView.contentSize, NO, 0.0);
    {
        CGPoint savedContentOffset = scrollView.contentOffset;
        CGRect savedFrame = scrollView.frame;
        scrollView.frame = CGRectMake(0 , 0, scrollView.contentSize.width, scrollView.contentSize.height);
        
        [scrollView.layer renderInContext:UIGraphicsGetCurrentContext()];
        image = UIGraphicsGetImageFromCurrentImageContext();
        
        scrollView.contentOffset = savedContentOffset;
        scrollView.frame = savedFrame;
    }
    UIGraphicsEndImageContext();
    
    if (image != nil) {
        return image;
    }
    return nil;
}
// 拼接两张图片
+ (UIImage *)composeTopImage:(UIImage *)topImage bottomImage:(UIImage *)bottomImage
{
    //1.创建上下文尺寸
    CGSize size = CGSizeMake(topImage.size.width, topImage.size.height +bottomImage.size.height);
    UIGraphicsBeginImageContextWithOptions(size, YES, 0.0);
    
    //2.先把topImage 画到上下文中
    [topImage drawInRect:CGRectMake(0, 0, topImage.size.width, topImage.size.height)];
    //3.再把小图放在上下文中
    [bottomImage drawInRect:CGRectMake(0, topImage.size.height, topImage.size.width, 140)];
    
    UIImage *resultImg = UIGraphicsGetImageFromCurrentImageContext();//从当前上下文中获得最终图片
    UIGraphicsEndImageContext();//关闭上下文
    
    return resultImg;
}


+ (BOOL)imageHasAlpha:(UIImage *)image{
    
    CGImageAlphaInfo alpha = CGImageGetAlphaInfo(image.CGImage);
    return (alpha == kCGImageAlphaFirst ||
            alpha == kCGImageAlphaLast ||
            alpha == kCGImageAlphaPremultipliedFirst ||
            alpha == kCGImageAlphaPremultipliedLast);
}

+ (UIImage *)imageToTransparent:(UIImage *)image
{
    // 分配内存
    const int imageWidth = image.size.width;
    const int imageHeight = image.size.height;
    size_t bytesPerRow = imageWidth * 4;
    uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
    // 创建context
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);
    // 遍历像素
    int pixelNum = imageWidth * imageHeight;
    uint32_t* pCurPtr = rgbImageBuf;
    for (int i = 0; i < pixelNum; i++, pCurPtr++)
    {
        //去除白色...将0xFFFFFF00换成其它颜色也可以替换其他颜色。
        if ((*pCurPtr & 0xFFFFFF00) >= 0xffffff00) {
            
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[0] = 0;
        }
        //接近白色
        //将像素点转成子节数组来表示---第一个表示透明度即ARGB这种表示方式。ptr[0]:透明度,ptr[1]:R,ptr[2]:G,ptr[3]:B
        //分别取出RGB值后。进行判断需不需要设成透明。
        uint8_t* ptr = (uint8_t*)pCurPtr;
        if (ptr[1] > 240 && ptr[2] > 240 && ptr[3] > 240) {
            //当RGB值都大于240则比较接近白色的都将透明度设为0.-----即接近白色的都设置为透明。某些白色背景具有杂质就会去不干净，用这个方法可以去干净
            ptr[0] = 0;
        }
    }
    // 将内存转成image
    CGDataProviderRef dataProvider =CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight, nil);
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight,8, 32, bytesPerRow, colorSpace,kCGImageAlphaLast |kCGBitmapByteOrder32Little, dataProvider,NULL, true,kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProvider);
    UIImage* resultUIImage = [UIImage imageWithCGImage:imageRef];
    // 释放
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return resultUIImage;
}

+ (UIImage*) thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time {
    if (!videoURL) {
        return nil;
    }
    //先从缓存中找是否有图片
    static UIImage *backImage = nil;
    SDImageCache *cache = [SDImageCache sharedImageCache];
    UIImage *memoryImage = [cache imageFromMemoryCacheForKey:videoURL.absoluteString];
    if (memoryImage) {
        backImage = memoryImage;
        return backImage;
    }else{
        UIImage *diskImage = [cache imageFromDiskCacheForKey:videoURL.absoluteString];
        if (diskImage) {
            backImage = diskImage;
            return backImage;
        }
    }
    if (!time) {
        time = 1;
    }
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetImageGenerator =[[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = time;
    NSError *thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60)actualTime:NULL error:&thumbnailImageGenerationError];
    
    if(!thumbnailImageRef)
        NSLog(@"thumbnailImageGenerationError %@",thumbnailImageGenerationError);
    
    UIImage*thumbnailImage = thumbnailImageRef ? [[UIImage alloc]initWithCGImage: thumbnailImageRef] : nil;
    dispatch_async(dispatch_get_main_queue(), ^{
        SDImageCache *cache = [SDImageCache sharedImageCache];
        [cache storeImage:thumbnailImage forKey:videoURL.absoluteString toDisk:YES completion:^{
 
        }];
        backImage = thumbnailImage;
    });
    return backImage;
    
}

+(NSMutableArray *)splitPictureWithRow:(NSInteger)row withColumn:(NSInteger)column withImage:(UIImage *)originImage{
    if (row < 1 || column < 1 || !originImage) {
        return nil;
    }
    NSMutableArray *backImageArray = [NSMutableArray array];
    
    float itemWidth = originImage.size.width / column;  // 单个图片的宽度
    float itemHeight = originImage.size.height / row;   // 单个图片的高度
    int number = 0;
    for (int i = 0; i < row; i++) {
        for (int j = 0; j < column; j++) {
            number ++;
            CGRect rect = CGRectMake(itemWidth * j, itemHeight * i, itemWidth, itemHeight);
//            NSLog(@"rect = %@",NSStringFromCGRect(rect));
            CGImageRef sourceImageRef = [originImage CGImage];
            CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, rect);
            UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
//            NSData *data = UIImagePNGRepresentation(newImage);
//            [data writeToFile:[NSString stringWithFormat:@"/Users/hibor/Desktop/splite-%d.png",number] atomically:YES];
            
            [backImageArray addObject:newImage];
        }
    }
    
    return backImageArray;
}

+ (UIImage *)createNewImageWithContent:(NSString *)content{
    //获取要加工的图片
    UIImage *image = [UIImage new];
    CGSize size= CGSizeMake (40 , 40); // 画布大小
    UIGraphicsBeginImageContextWithOptions (size, NO , 0.0 );
    [image drawAtPoint : CGPointMake ( 0 , 0 )];
    // 获得一个位图图形上下文
    CGContextRef context= UIGraphicsGetCurrentContext ();
    CGContextDrawPath (context, kCGPathStroke );
    //画自己想画的内容。。。。。
    [content drawAtPoint : CGPointMake ( size.width/2-4.5  , size.height/2-4.5 ) withAttributes : @{ NSFontAttributeName:FONT_9_MEDIUM(15), NSForegroundColorAttributeName : [UIColor whiteColor] } ];

    // 返回绘制的新图形
    UIImage *newImage= UIGraphicsGetImageFromCurrentImageContext ();
    UIGraphicsEndImageContext ();
    
    return newImage;
    
}


+ (UIImage *)createShareImage:(UIImage *)tImage Context:(NSString *)text
{
    UIImage *sourceImage = tImage;
    CGSize imageSize; //画的背景 大小
    imageSize = [sourceImage size];
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
    [sourceImage drawAtPoint:CGPointMake(0, 0)];
    //获得 图形上下文
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextDrawPath(context, kCGPathStroke);
    CGFloat nameFont = 18.f;
    //画 自己想要画的内容
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:nameFont]};
    CGRect sizeToFit = [text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, nameFont) options:NSStringDrawingUsesDeviceMetrics attributes:attributes context:nil];
//    NSLog(@"图片: %f %f",imageSize.width,imageSize.height);
//    NSLog(@"sizeToFit: %f %f",sizeToFit.size.width,sizeToFit.size.height);
    CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
    [text drawAtPoint:CGPointMake((imageSize.width-sizeToFit.size.width)/2,(imageSize.height-sizeToFit.size.height)/2) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:nameFont]}];
    //返回绘制的新图形
    
    UIImage *newImage=UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return newImage;
}


//绘图
-(UIImage*)imageChangeColor:(UIColor*)color
{
    //获取画布
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    //画笔沾取颜色
    [color setFill];
    
    CGRect bounds = CGRectMake(0, 0, self.size.width, self.size.height);
    UIRectFill(bounds);
    //绘制一次
    [self drawInRect:bounds blendMode:kCGBlendModeOverlay alpha:1.0f];
    //再绘制一次
    [self drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0f];
    //获取图片
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

@end
