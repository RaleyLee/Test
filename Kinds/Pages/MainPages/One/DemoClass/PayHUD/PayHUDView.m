//
//  PayHUDView.m
//  Kinds
//
//  Created by hibor on 2018/8/16.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import "PayHUDView.h"

static CGFloat lineWidth = 4.0f;
static CGFloat circleDuration = 0.5f;
static CGFloat checkDuration = 0.2f;

#define PayBlueColor [UIColor colorWithRed:16/255.0 green:142/255.0 blue:233/255.0 alpha:1]

@interface PayHUDView()

@property(nonatomic,strong) CADisplayLink *link;
@property(nonatomic,strong) CAShapeLayer *animationLayer;
@property(nonatomic,assign) CGFloat startAngle;
@property(nonatomic,assign) CGFloat endAngle;
@property(nonatomic,assign) CGFloat progress;

@property(nonatomic,assign) PayHUDStyle tempStyle;

@end

@implementation PayHUDView

+(PayHUDView *)showIn:(UIView *)view withAnimation:(PayHUDStyle)style{
    [self hideIn:view];
    PayHUDView *payView = [[PayHUDView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    if (style == PayHUDStyleLoading){
        [payView startPayAnimation];
    }else{
        [payView startFinishAnimation:style];
    }
    
    [view addSubview:payView];
    return payView;
}


+(PayHUDView *)hideIn:(UIView *)view{
    PayHUDView *payView = nil;
    for (PayHUDView *subView in view.subviews) {
        if ([subView isKindOfClass:[PayHUDView class]]) {
            [subView endPayAnimation];
            [subView removeFromSuperview];
            payView = subView;
        }
    }
    return payView;
}

-(void)startPayAnimation{
    _link.paused = false;
}

-(void)endPayAnimation{
    _link.paused = true;
    _progress = 0;

    for (CALayer *subLayer in _animationLayer.sublayers) {
        [subLayer removeAllSublayers];
    }
}


-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _animationLayer = [CAShapeLayer layer];
        _animationLayer.bounds = CGRectMake(0, 0, 60, 60);
        _animationLayer.position = CGPointMake(self.bounds.size.width/2.0f, self.bounds.size.height/2.0);
        _animationLayer.fillColor = [UIColor clearColor].CGColor;
        _animationLayer.strokeColor = PayBlueColor.CGColor;
        _animationLayer.lineWidth = lineWidth;
        _animationLayer.lineCap = kCALineCapRound;
        [self.layer addSublayer:_animationLayer];
        
        
        _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkAction)];
        [_link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
        _link.paused = true;
    }
    return self;
}


-(void)displayLinkAction{
    _progress += [self speed];
    if (_progress >= 1) {
        _progress = 0;
    }
    [self updateAnimationLayer];
}

-(void)updateAnimationLayer{
    _startAngle = -M_PI_2;
    _endAngle = -M_PI_2 +_progress * M_PI * 2;
    if (_endAngle > M_PI) {
        CGFloat progress1 = 1 - (1 - _progress)/0.25;
        _startAngle = -M_PI_2 + progress1 * M_PI * 2;
    }
    CGFloat radius = _animationLayer.bounds.size.width/2.0f - lineWidth/2.0f;
    CGFloat centerX = _animationLayer.bounds.size.width/2.0f;
    CGFloat centerY = _animationLayer.bounds.size.height/2.0f;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(centerX, centerY) radius:radius startAngle:_startAngle endAngle:_endAngle clockwise:true];
    path.lineCapStyle = kCGLineCapRound;
    
    _animationLayer.path = path.CGPath;
}


-(CGFloat)speed{
    if (_endAngle > M_PI) {
        return 0.3/60.0f;
    }
    return 2/60.0f;
}


-(void)startFinishAnimation:(PayHUDStyle)style{
    [self circleAnimation];

    __weak typeof (self) weakSelf = self;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * circleDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CGFloat a = weakSelf.animationLayer.bounds.size.width;
        UIBezierPath *path = [UIBezierPath bezierPath];
        if (style == PayHUDStyleSuccess) {
            [path moveToPoint:CGPointMake(a*2.7/10,a*5.4/10)];
            [path addLineToPoint:CGPointMake(a*4.5/10,a*7/10)];
            [path addLineToPoint:CGPointMake(a*7.8/10,a*3.8/10)];
        }else if (style == PayHUDStyleFailure) {
            [path moveToPoint:CGPointMake(20, 20)];
            [path addLineToPoint:CGPointMake(40, 40)];
            
            [path moveToPoint:CGPointMake(40, 20)];
            [path addLineToPoint:CGPointMake(20, 40)];
        }else if (style == PayHUDStyleWarning) {
            [path moveToPoint:CGPointMake(30, 15)];
            [path addLineToPoint:CGPointMake(30, 35)];
            
            [path moveToPoint:CGPointMake(30, 42)];
            [path addLineToPoint:CGPointMake(30, 45)];
        }
        CAShapeLayer *checkLayer = [CAShapeLayer layer];
        checkLayer.path = path.CGPath;
        checkLayer.fillColor = [UIColor clearColor].CGColor;
        checkLayer.strokeColor = (style == PayHUDStyleFailure) ? [UIColor redColor].CGColor : PayBlueColor.CGColor;
        checkLayer.lineWidth = lineWidth;
        checkLayer.lineCap = kCALineCapRound;
        checkLayer.lineJoin = kCALineJoinRound;
        [weakSelf.animationLayer addSublayer:checkLayer];
        
        CABasicAnimation *checkAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        checkAnimation.duration = checkDuration;
        checkAnimation.fromValue = @(0.0f);
        checkAnimation.toValue = @(1.0f);
        checkAnimation.delegate = self;
        [checkAnimation setValue:@"checkAnimation" forKey:@"animationName"];
        [checkLayer addAnimation:checkAnimation forKey:nil];
    });
}

//画圆
- (void)circleAnimation {
    
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    circleLayer.frame = _animationLayer.bounds;
    [_animationLayer addSublayer:circleLayer];
    circleLayer.fillColor =  [[UIColor clearColor] CGColor];
    circleLayer.strokeColor  = PayBlueColor.CGColor;
    circleLayer.lineWidth = lineWidth;
    circleLayer.lineCap = kCALineCapRound;
    
    
    CGFloat lineWidth = 5.0f;
    CGFloat radius = _animationLayer.bounds.size.width/2.0f - lineWidth/2.0f;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:circleLayer.position radius:radius startAngle:-M_PI/2 endAngle:M_PI*3/2 clockwise:true];
    circleLayer.path = path.CGPath;
    
    CABasicAnimation *circleAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    circleAnimation.duration = circleDuration;
    circleAnimation.fromValue = @(0.0f);
    circleAnimation.toValue = @(1.0f);
    circleAnimation.delegate = self;
    [circleAnimation setValue:@"circleAnimation" forKey:@"animationName"];
    [circleLayer addAnimation:circleAnimation forKey:nil];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
