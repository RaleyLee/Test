//
//  QQPlayMoreView.m
//  Kinds
//
//  Created by hibor on 2018/9/13.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import "QQPlayMoreView.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface QQPlayMoreView()

@property(nonatomic,strong)MPVolumeView *volumeView;

@end

@implementation QQPlayMoreView

+(QQPlayMoreView *)sharedManager{
    QQPlayMoreView *moreView = [[NSBundle mainBundle] loadNibNamed:@"QQPlayMoreView" owner:nil options:nil].firstObject;
    return moreView;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        self.frame = [UIScreen mainScreen].bounds;
    }
    return self;
}

-(void)changeSongName:(NSNotification *)noti{
    self.songNameLabel.text = noti.object;
}
-(void)awakeFromNib{
    [super awakeFromNib];
    
    
    [self addSubview:self.volumeView];
    [self.volumeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSongName:) name:@"CHANGECURRENTSONGNAME" object:nil];
    
    [self.voiceSlider setThumbImage:[UIImage imageNamed:@"slider_thumb"] forState:UIControlStateNormal];

    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [self.voiceSlider setValue:audioSession.outputVolume animated:NO];
    
    //监听系统声音
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryAmbient error:nil];//重点方法
    [session setActive:YES error:nil];
    NSError *error;
    [[AVAudioSession sharedInstance] setActive:YES error:&error];
    //注，ios9上不加这一句会无效
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(volumeChanged:) name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];
}

-(void)volumeChanged:(NSNotification *)notification{
    float volume = [[[notification userInfo] objectForKey:@"AVSystemController_AudioVolumeNotificationParameter"] floatValue];
    [self.voiceSlider setValue:volume animated:NO];
}

-(UISlider *)getSystemVolumeSlider{
    UISlider *s;
    for (UIView *view in [_volumeView subviews]){
        if ([[view.class description] isEqualToString:@"MPVolumeSlider"]){
            s = (UISlider*)view;
            break;
        }
    }
    return s;
}

- (IBAction)playChangeVoice:(UISlider *)sender {
    
    UISlider *s = [self getSystemVolumeSlider];
 
    [s setValue:sender.value];

}

-(MPVolumeView *)volumeView{
    if (!_volumeView) {
        _volumeView = [[MPVolumeView alloc] init];
        [_volumeView sizeToFit];
        _volumeView.alpha = 0;
    }
    return _volumeView;
}

- (IBAction)cancelMoreViewAction:(UIButton *)sender {
    [self playDismiss];
}

-(void)playShow{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    [keyWindow addSubview:self];
    
    __block CGRect frame = self.popView.frame;
    frame.origin.y = SCREEN_HEIGHT;
    self.alpha = 0.0;
    [UIView animateWithDuration:0.38 animations:^{
        frame.origin.y = SCREEN_HEIGHT - 300;
        self.popView.frame = frame;
        self.alpha = 1.0;
    }];
}

-(void)playDismiss{
    [UIView animateWithDuration:0.38 animations:^{
        CGRect frame = self.popView.frame;
        frame.origin.y = SCREEN_HEIGHT;
        self.popView.frame = frame;
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
