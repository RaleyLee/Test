//
//  StretchView.m
//  Kinds
//
//  Created by hibor on 2018/8/9.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import "StretchView.h"

@implementation StretchView

+(StretchView *)popStretchView{
    StretchView *chooseView = [[NSBundle mainBundle] loadNibNamed:@"StretchView" owner:nil options:nil].firstObject;
    return chooseView;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        self.frame = [UIScreen mainScreen].bounds;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    
}

-(void)show{
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview:self];
    [self animatedIn];
}

-(void)dismiss{
    [self animatedOut];
}

#pragma mark - Animated Mthod
- (void)animatedIn{
    self.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.alpha = 0;
    [UIView animateWithDuration:.35 animations:^{
        self.alpha = 1;
        self.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

- (void)animatedOut{
    [UIView animateWithDuration:.35 animations:^{
        self.transform = CGAffineTransformMakeScale(0.2, 0.2);
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
