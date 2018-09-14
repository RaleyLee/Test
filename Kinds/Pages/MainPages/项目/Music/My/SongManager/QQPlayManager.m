//
//  QQPlayManager.m
//  Kinds
//
//  Created by hibor on 2018/9/11.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import "QQPlayManager.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface QQPlayManager()<AVAudioPlayerDelegate>

@property(nonatomic,strong)AVAudioPlayer *player;
@property(nonatomic,copy)NSString *fileName;
@property(nonatomic,copy)void(^complete)(void);

@end

@implementation QQPlayManager

+(instancetype)sharedPlayManager{
    static QQPlayManager *_playManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _playManager = [[self alloc] init];
    });
    return _playManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioSessionInterruptionNotification:) name:AVAudioSessionRouteChangeNotification object:nil];
    }
    return self;
}

-(void)audioSessionInterruptionNotification:(NSNotification *)notification{
    NSDictionary *dict = notification.userInfo;
    int changeReason = [dict[AVAudioSessionRouteChangeReasonKey] intValue];
    if (changeReason == AVAudioSessionRouteChangeReasonOldDeviceUnavailable) {
        AVAudioSessionRouteDescription *routeDescript = dict[AVAudioSessionRouteChangePreviousRouteKey];
        AVAudioSessionPortDescription *portDescript = [routeDescript.outputs firstObject];
        //原设备为耳机则暂停
        if ([portDescript.portType isEqualToString:@"Headphones"]) {
            [self.player pause];
        }
    }
    /*
    AVAudioSessionInterruptionType type = [notification.userInfo[AVAudioSessionInterruptionTypeKey] integerValue];
    if (type == AVAudioSessionInterruptionTypeBegan) {
        [self.player pause];
    }else if(type == AVAudioSessionInterruptionTypeEnded){
        [self.player play];
    }
     */
}

-(void)playMusicWithFileName:(NSString *)fileName didComplete:(void (^)(void))complete{
    if (_fileName != fileName) {
        //播放音乐
        NSURL *url = [[NSBundle mainBundle] URLForResource:fileName withExtension:nil];
        AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        self.player = player;
        [player prepareToPlay];
        player.delegate = self;
        self.fileName = fileName;
        self.complete = complete;
    }
    [self.player play];
}

-(void)musicPause{
    [self.player pause];
}

-(void)musicStop{
    [self.player stop];
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    self.complete();
}

-(SongInfo *)getCurrentSongInfo:(NSString *)fileName{
    if (fileName == nil || fileName.length == 0) {
        return nil;
    }
    SongInfo *info = [[SongInfo alloc] init];
    info.songName = fileName;
    return info;
}


-(UIImage *)getCurrentSingerImage:(NSString *)singerName{
    if (!singerName || [singerName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0) {
        return [UIImage imageNamed:@"singer_placeholder.jpg"];
    }
    NSString *filePath = [[NSBundle mainBundle] pathForResource:singerName ofType:@".png"];
    UIImage *singerImage = nil;
    if (filePath) {
        singerImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",singerName]];
    }else{
        singerImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",singerName]];
    }
    return singerImage;
}

-(NSTimeInterval)currentTime{
    return self.player.currentTime;
}

-(NSTimeInterval)duration{
    return self.player.duration;
}

-(void)setCurrentTime:(NSTimeInterval)currentTime{
    self.player.currentTime = currentTime;
}

@end
