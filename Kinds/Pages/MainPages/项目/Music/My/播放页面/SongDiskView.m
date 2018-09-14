//
//  SongDiskView.m
//  Kinds
//
//  Created by hibor on 2018/9/13.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import "SongDiskView.h"

@interface SongDiskView()

@property(nonatomic,strong)UIImageView *diskImageView;
@property(nonatomic,strong)NSTimer *diskTimer;
@property(nonatomic,assign)BOOL flag;

@end

@implementation SongDiskView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.image = [UIImage imageNamed:@"music_disk"];
        
        self.diskImageView = [UIImageView new];
        self.diskImageView.image = [UIImage imageNamed:@"singer_placeholder.jpg"];
        self.diskImageView.layer.cornerRadius = 100;
        self.diskImageView.layer.masksToBounds = YES;
        [self addSubview:self.diskImageView];
        [self.diskImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.width.height.mas_equalTo(200);
        }];
    }
    return self;
}

-(void)setSingerImage:(UIImage *)singerImage{
    _singerImage = singerImage;
    _diskImageView.image = singerImage;
}

-(void)startSongDiskAnimation{

    if (!_flag) {
        CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0];
        rotationAnimation.duration = 20;
        rotationAnimation.cumulative = YES;
        rotationAnimation.repeatCount = MAXFLOAT;
        [self.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
        
        _flag = YES;
    }else{
        CFTimeInterval pauseTime = [self.layer timeOffset];
        self.layer.speed = 1.0;
        self.layer.timeOffset = 0.0;
        self.layer.beginTime = 0.0;
        CFTimeInterval timeSincePause = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil] - pauseTime;
        self.layer.beginTime = timeSincePause;
    }
    
}

-(void)stopSongDiskAnimation{
    [self.layer removeAnimationForKey:@"rotationAnimation"];
    _flag = NO;
}

-(void)pauseSongDiskAnimation{
    CFTimeInterval pauseTime = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil];
    self.layer.speed = 0.0;
    self.layer.timeOffset = pauseTime;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
