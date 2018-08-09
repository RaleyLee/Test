//
//  MediaView.m
//  Kinds
//
//  Created by hibor on 2018/8/1.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import "MediaView.h"

@interface MediaView()

@property(nonatomic,strong)NSMutableArray *imageArray;

@end

@implementation MediaView

-(instancetype)init{
    if (self = [super init]) {
        _imageArray = [NSMutableArray array];
        for (int i = 0; i < 9; i++) {
            MediaImageView *imageView = [[MediaImageView alloc] init];
            imageView.tag = 1000 + i;
            [imageView setTapMediaPhoto:^(MediaImageView *imageView) {
                NSLog(@"%ld",imageView.tag);
            }];
            [_imageArray addObject:imageView];
            [self addSubview:imageView];
        }
    }
    return self;
}

-(void)setModel:(CircleModel *)model{
    _model = model;
    for (UIImageView *imageView in _imageArray) {
        imageView.hidden = YES;
    }
    // 图片区
    NSInteger count = model.mediaContent.count;
    if (count == 0) {
        self.size = CGSizeZero;
        return;
    }
    if ([model.mediaType isEqualToString:@"photo"]) {
        CGFloat ImageW = 100;
        CGFloat ImageH = 160;
        
        MediaImageView *imageView = nil;
        
        if (model.mediaContent.count == 1) {
            imageView = [self viewWithTag:1000];
            imageView.frame = CGRectMake(0, 0, ImageW, ImageH);
            imageView.backgroundColor = RGB_random;
            imageView.hidden = NO;
            [imageView setImageURL:[NSURL URLWithString:model.mediaContent[0]]];
            self.size = CGSizeMake(ImageW, ImageH);
        }else {
            NSInteger tempRow = 2;
            if (count > 4 || count == 3) {
                tempRow = 3;
            }
            ImageW = 80;
            ImageH = 80;
            for (int i = 0; i < count; i++) {
                int row = i / tempRow;
                int col = i % tempRow;
                CGFloat X = (ImageW + 5) * col;
                CGFloat Y = (ImageH + 5) * row;
                imageView = [self viewWithTag:1000 + i];
                imageView.frame = CGRectMake(X, Y, ImageW, ImageH);
                imageView.backgroundColor = RGB_random;
                imageView.hidden = NO;
                [imageView setImageURL:[NSURL URLWithString:model.mediaContent[i]]];
            }
            CGFloat w = (ImageW+5)*tempRow;
            CGFloat h = (ImageH+5)*((count/tempRow)+((count%tempRow)?1:0) );
            self.size = CGSizeMake(w-5, h-5);
        }
        self.frame = CGRectMake(0, 0, self.size.width, self.size.height);
    }
}


@end



@implementation MediaImageView

-(instancetype)init{
    if (self = [super init]) {
        self.clipsToBounds = YES;
        self.userInteractionEnabled = YES;
        self.contentMode = UIViewContentModeCenter;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureClick:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

-(void)singleTapGestureClick:(UITapGestureRecognizer *)gesture{
    if (self.tapMediaPhoto) {
        self.tapMediaPhoto(self);
    }
}

@end
