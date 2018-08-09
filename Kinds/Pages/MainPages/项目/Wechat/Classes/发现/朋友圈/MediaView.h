//
//  MediaView.h
//  Kinds
//
//  Created by hibor on 2018/8/1.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CircleModel.h"

typedef NS_ENUM (NSInteger,MediaViewType){
    MediaViewTypePhoto = 0,
    MediaViewTypeVideo,
};

@interface MediaView : UIView

@property(nonatomic,strong)CircleModel *model;


@end


@interface MediaImageView : UIImageView

@property(nonatomic,copy)void (^tapMediaPhoto)(MediaImageView *imageView);

@end
