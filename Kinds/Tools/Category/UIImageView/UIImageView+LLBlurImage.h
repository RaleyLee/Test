//
//  UIImageView+LLBlurImage.h
//  Kinds
//
//  Created by hibor on 2018/9/10.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef void(^LBBlurredImageCompletionBlock)(NSError *error);

extern NSString *const kLBBlurredImageErrorDomain;

extern CGFloat   const kLBBlurredImageDefaultBlurRadius;

enum LBBlurredImageError {
    LBBlurredImageErrorFilterNotAvailable = 0,
};


@interface UIImageView (LLBlurImage)

- (void)setImageToBlur: (UIImage *)image
            blurRadius: (CGFloat)blurRadius
       completionBlock: (LBBlurredImageCompletionBlock) completion;



@end
