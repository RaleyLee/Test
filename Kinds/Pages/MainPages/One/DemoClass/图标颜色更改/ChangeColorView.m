//
//  ChangeColorView.m
//  Kinds
//
//  Created by hibor on 2018/8/6.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import "ChangeColorView.h"

@interface ChangeColorView()

@property (weak, nonatomic) IBOutlet UIButton *closeButton;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UISlider *RSlider;
@property (weak, nonatomic) IBOutlet UISlider *GSlider;
@property (weak, nonatomic) IBOutlet UISlider *BSlider;
@property (weak, nonatomic) IBOutlet UILabel *HexLabel;

@property (weak, nonatomic) IBOutlet UITextField *RTextField;
@property (weak, nonatomic) IBOutlet UITextField *GTextField;
@property (weak, nonatomic) IBOutlet UITextField *BTextField;

@end
@implementation ChangeColorView

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        self.frame = [UIScreen mainScreen].bounds;
        _imageView.image = [_imageView.image imageChangeColor:RGB(0, 0, 0)];

    }
    return self;
}

+(ChangeColorView *)popChangeView{
    ChangeColorView *changeView = [[NSBundle mainBundle] loadNibNamed:@"ChangeColorView" owner:nil options:nil].firstObject;
    return changeView;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    UIImage *rImage = [UIImage imageWithColor:RGB(255, 0, 0) size:CGSizeMake(10, 15)];
    [_RSlider setThumbImage:rImage forState:UIControlStateNormal];
    [_RSlider setMaximumTrackTintColor:RGB(200, 200, 200)];
    [_RSlider setMinimumTrackTintColor:[UIColor redColor]];
//    UIImage *img1 = [self getGradientImageWithColors:@[RGB(0, 0, 0),RGB(255, 0, 0)] imgSize:_RSlider.bounds.size];
//    [_RSlider setMinimumTrackImage:img1 forState:UIControlStateNormal];

    
    UIImage *gImage = [UIImage imageWithColor:RGB(0, 255, 0) size:CGSizeMake(10, 15)];
    [_GSlider setThumbImage:gImage forState:UIControlStateNormal];
    [_GSlider setMaximumTrackTintColor:RGB(200, 200, 200)];
    [_GSlider setMinimumTrackTintColor:[UIColor greenColor]];
//    UIImage *img2 = [self getGradientImageWithColors:@[RGB(0, 0, 0),RGB(0, 255, 0)] imgSize:_GSlider.bounds.size];
//    [_GSlider setMinimumTrackImage:img2 forState:UIControlStateNormal];
    
    UIImage *bImage = [UIImage imageWithColor:RGB(0, 0, 255) size:CGSizeMake(10, 15)];
    [_BSlider setThumbImage:bImage forState:UIControlStateNormal];
    [_BSlider setMaximumTrackTintColor:RGB(200, 200, 200)];
    [_BSlider setMinimumTrackTintColor:[UIColor blueColor]];
//    UIImage *img3 = [self getGradientImageWithColors:@[RGB(0, 0, 0),RGB(0, 0, 255)] imgSize:_BSlider.bounds.size];
//    [_BSlider setMinimumTrackImage:img3 forState:UIControlStateNormal];
    
}


- (IBAction)changeRGBValueAction:(UISlider *)sender {
    NSInteger tag = sender.tag;
    if (tag == 101) {
        // R
        _RTextField.text = [NSString stringWithFormat:@"%d",(int)sender.value];
    }else if (tag == 102) {
        // G
        _GTextField.text = [NSString stringWithFormat:@"%d",(int)sender.value];
    }else if (tag == 103) {
        // B
        _BTextField.text = [NSString stringWithFormat:@"%d",(int)sender.value];
    }
    _imageView.image = [_imageView.image imageChangeColor:RGB([_RTextField.text intValue], [_GTextField.text intValue], [_BTextField.text intValue])];
    
    NSString *colorHex = [self hexStringFromColor:RGB([_RTextField.text intValue], [_GTextField.text intValue], [_BTextField.text intValue])];
    _HexLabel.text = colorHex;
}

- (NSString *)hexStringFromColor:(UIColor *)color {
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    
    CGFloat r = components[0];
    CGFloat g = components[1];
    CGFloat b = components[2];
    
    return [NSString stringWithFormat:@"#%02lX%02lX%02lX",
            lroundf(r * 255),
            lroundf(g * 255),
            lroundf(b * 255)];
}

-(UIImage *)getGradientImageWithColors:(NSArray*)colors imgSize:(CGSize)imgSize
{
    NSMutableArray *arRef = [NSMutableArray array];
    for(UIColor *ref in colors) {
        [arRef addObject:(id)ref.CGColor];
        
    }
    UIGraphicsBeginImageContextWithOptions(imgSize, YES, 1);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGColorSpaceRef colorSpace = CGColorGetColorSpace([[colors lastObject] CGColor]);
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)arRef, NULL);
    CGPoint start = CGPointMake(0.0, 0.0);
    CGPoint end = CGPointMake(imgSize.width, imgSize.height);
    CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGGradientRelease(gradient);
    CGContextRestoreGState(context);
    CGColorSpaceRelease(colorSpace);
    UIGraphicsEndImageContext();
    return image;
}

- (IBAction)closePopViewAction:(UIButton *)sender {
    [self dismiss];
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


@end
