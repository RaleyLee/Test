//
//  PlayViewController.m
//  Kinds
//
//  Created by hibor on 2018/9/10.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import "PlayViewController.h"
#import "LRCCell.h"
#import "LRCManager.h"
#import "LRCModel.h"
#import "QQPlayManager.h"
#import "SongDiskView.h"
#import "QQPlayMoreView.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

typedef NS_ENUM(NSInteger,QQMusicPlayMode){
    QQMusicPlayModeOneByOne = 0,
    QQMusicPlayModeSingleOne,
    QQMusicPlayModeRandom,
};


@interface PlayViewController ()<TXScrollLabelViewDelegate,UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,AVAudioPlayerDelegate,UIGestureRecognizerDelegate>

@property(nonatomic,strong)AVAudioPlayer *player;
@property(nonatomic,strong)NSTimer *proTimer;
@property(nonatomic,assign)CGFloat currentTime;

@property(nonatomic,strong)TXScrollLabelView *titleLabel;

@property(nonatomic,strong)UITableView *lrcTableView; //显示歌词
@property(nonatomic,strong)NSMutableArray *lrcArray; //解析歌词

@property(nonatomic,strong)UISlider *proSlider; //进度条
@property(nonatomic,strong)UILabel *currentTimeLabel; //当前时间
@property(nonatomic,strong)UILabel *totalTimeLabel; //歌曲总时长

@property(nonatomic,strong)UIButton *lastButton; //上一首
@property(nonatomic,strong)UIButton *nextButton; //下一首
@property(nonatomic,strong)UIButton *playButton; //播放 暂停
@property(nonatomic,strong)UIButton *playStateButton; //顺序播放  随机播放  单曲循环
@property(nonatomic,strong)UIButton *songListButton; //歌曲列表

@property(nonatomic,assign)NSInteger rowIndex; //歌词第几行
@property(nonatomic,assign)NSInteger lastRowIndex;

@property(nonatomic,assign)QQMusicPlayMode playMode;
@property(nonatomic,strong)NSArray *playModeArray;

@property(nonatomic,strong)SongDiskView *diskView; //歌手专辑

@end

@implementation PlayViewController

-(NSMutableArray *)lrcArray{
    if (!_lrcArray) {
        _lrcArray = [NSMutableArray array];
        NSString *fileName = [NSString stringWithFormat:@"%@ - %@.%@",self.currentModel.singer,self.currentModel.song,self.currentModel.lrcType];
        _lrcArray = [[LRCManager sharedManager] getCurrentSongLrcList:fileName];
        [self.lrcTableView tableViewDisplayWithMessage:@"未找到指定歌词" ifNecessaryForRowCount:_lrcArray.count];

    }
    return _lrcArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.currentTime = 0.0;
    self.rowIndex = 0;
    self.lastRowIndex = 0;
    self.playModeArray = @[@"loop_all_icon",@"loop_single_icon",@"shuffle_icon"];
    
    self.playMode = [[NSUserDefaults standardUserDefaults] integerForKey:@"playMode"];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disMissGrantureADD)];
    [tap setNumberOfTapsRequired:1];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
    
    UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [moreButton setImage:[UIImage imageNamed:@"more_icon"] forState:UIControlStateNormal];
    moreButton.frame = CGRectMake(0, 0, 40, 40);
    [moreButton setImageEdgeInsets: UIEdgeInsetsMake(10, 10, 10, 10)];
    [moreButton addTarget:self action:@selector(moreAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:moreButton];
    
    self.titleLabel = [[TXScrollLabelView alloc] initWithTitle:[NSString stringWithFormat:@"%@ - %@",self.currentModel.song,self.currentModel.singer] type:TXScrollLabelViewTypeLeftRight velocity:1 options:UIViewAnimationOptionCurveEaseInOut inset:UIEdgeInsetsZero];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.font = FONT_9_MEDIUM(18);
    self.titleLabel.delegate = self;
    self.titleLabel.scrollSpace = 50;
    self.titleLabel.frame = CGRectMake(0, 0, 150, 44);
    self.navigationItem.titleView = self.titleLabel;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.titleLabel beginScrolling];
    });
    
    
    UIImageView *bgImageView = [UIImageView new];
    bgImageView.image = [UIImage imageNamed:@"playBG"];
    [self.view addSubview:bgImageView];
    [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    toolbar.barStyle   = UIBarStyleBlackTranslucent;
    [bgImageView addSubview:toolbar];
    [toolbar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(bgImageView);
    }];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@ - %@.%@",self.currentModel.singer,self.currentModel.song,self.currentModel.type] ofType:nil];

    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:filePath] error:nil];
    self.player.delegate = self;
    [self.player prepareToPlay];
    
    [self createControls];
    [self getAudioPlayerInfo];
    
    //设置锁屏仍能继续播放
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
 
    //添加通知 拔出耳机后暂停播放
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(routeChange:) name:AVAudioSessionRouteChangeNotification object:nil];
}

-(void)getAudioPlayerInfo{
    NSString *fileName = [NSString stringWithFormat:@"%@ - %@.%@",self.currentModel.singer,self.currentModel.song,self.currentModel.lrcType];
    _lrcArray = [[LRCManager sharedManager] getCurrentSongLrcList:fileName];
    [self.lrcTableView tableViewDisplayWithMessage:@"未找到指定歌词" ifNecessaryForRowCount:_lrcArray.count];
    self.diskView.singerImage = [[QQPlayManager sharedPlayManager] getCurrentSingerImage:self.currentModel.singer];
    self.totalTimeLabel.text = [self stringWithTime:self.player.duration];
    
    [self.lrcTableView reloadData];
    
}

#pragma mark - 格式化时间

-(NSString *)stringWithTime:(NSTimeInterval)time{
    int minute = time / 60;
    int second = (int)time % 60;
    return [NSString stringWithFormat:@"%02d:%02d",minute,second];
}

#pragma mark - 耳机拔出监测

-(void)routeChange:(NSNotification *)notification{
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
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

    //接受远程控制
    [self becomeFirstResponder];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];

}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    //取消远程控制
    [self resignFirstResponder];
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
}

-(void)createControls{
    
    __weak typeof (self) weakSelf = self;
    
    self.diskView = [[SongDiskView alloc] init];
    self.diskView.userInteractionEnabled = YES;
    self.diskView.singerImage = [[QQPlayManager sharedPlayManager] getCurrentSingerImage:self.currentModel.singer];
    UITapGestureRecognizer *tapSingerView = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        [UIView animateWithDuration:0.5 animations:^{
            weakSelf.lrcTableView.alpha = 1;
            weakSelf.diskView.alpha = 0;
        }];
    }];
    [self.diskView addGestureRecognizer:tapSingerView];
    [self.view addSubview:self.diskView];
    
    
    self.lrcTableView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] bounds] style:UITableViewStylePlain];
    self.lrcTableView.dataSource = self;
    self.lrcTableView.delegate = self;
    self.lrcTableView.alpha = 0;
    self.lrcTableView.showsVerticalScrollIndicator = NO;
    self.lrcTableView.backgroundColor = [UIColor clearColor];
    [self.lrcTableView setSeparatorColor:[UIColor clearColor]];
    [self.lrcTableView setContentInset:UIEdgeInsetsMake(CGRectGetHeight(self.lrcTableView.frame)/4, 0, CGRectGetHeight(self.lrcTableView.frame)/4, 0)];
    [self.lrcTableView setTableFooterView:[UIView new]];
    [self.view addSubview:self.lrcTableView];
    [self.lrcTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(40, 40, 180, 40));
    }];
    [self.diskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf.lrcTableView);
        make.size.mas_equalTo(CGSizeMake(270, 270));
    }];
    

    self.playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    BOOL play = [[NSUserDefaults standardUserDefaults] boolForKey:@"playState"];
    if (!play) {
        [self.playButton setImage:[UIImage imageNamed:@"player_btn_pause_normal"] forState:UIControlStateNormal];
        [self.playButton setImage:[UIImage imageNamed:@"player_btn_pause_highlight"] forState:UIControlStateHighlighted];
        
        [self musicPlay];
    }else{
        [self.playButton setImage:[UIImage imageNamed:@"player_btn_play_normal"] forState:UIControlStateNormal];
        [self.playButton setImage:[UIImage imageNamed:@"player_btn_play_highlight"] forState:UIControlStateHighlighted];
    }
    [self.playButton addTarget:self action:@selector(playOrPauseSongAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.playButton];
    [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.bottom.mas_equalTo(-50);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    
    self.lastButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.lastButton setImage:[UIImage imageNamed:@"player_btn_pre_normal"] forState:UIControlStateNormal];
    [self.lastButton setImage:[UIImage imageNamed:@"player_btn_pre_highlight"] forState:UIControlStateHighlighted];
    [self.lastButton addTarget:self action:@selector(changePreviousSong) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.lastButton];
    [self.lastButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.playButton);
        make.right.equalTo(weakSelf.playButton.mas_left).offset(-30);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    
    self.nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.nextButton setImage:[UIImage imageNamed:@"player_btn_next_normal"] forState:UIControlStateNormal];
    [self.nextButton setImage:[UIImage imageNamed:@"player_btn_next_highlight"] forState:UIControlStateHighlighted];
    [self.nextButton addTarget:self action:@selector(changeNextSong) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.nextButton];
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.playButton);
        make.left.equalTo(weakSelf.playButton.mas_right).offset(30);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    
    
    self.playStateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.playStateButton setImage:[[UIImage imageNamed:self.playModeArray[self.playMode]] imageWithColor:QQMUSIC_THEMECOLOR] forState:UIControlStateNormal];
    [self.playStateButton setImageEdgeInsets:UIEdgeInsetsMake(8, 8, 8, 8)];
    [self.playStateButton addTarget:self action:@selector(changePlayStateAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.playStateButton];
    [self.playStateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.playButton);
        make.size.mas_equalTo(CGSizeMake(40, 33));
        make.right.equalTo(weakSelf.lastButton.mas_left).offset(-20);
    }];
    
    
    self.songListButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.songListButton setImage:[[UIImage imageNamed:@"music_list_menu"] imageWithColor:QQMUSIC_THEMECOLOR]forState:UIControlStateNormal];
    [self.songListButton setImageEdgeInsets:UIEdgeInsetsMake(8, 8, 8, 8)];
    [self.songListButton addTarget:self action:@selector(openSongListAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.songListButton];
    [self.songListButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.playButton);
        make.left.equalTo(weakSelf.nextButton.mas_right).offset(20);
        make.size.mas_equalTo(CGSizeMake(40, 33));
    }];
    
    
    self.currentTimeLabel = [UILabel new];
    self.currentTimeLabel.font = FONT_9_REGULAR(12);
    self.currentTimeLabel.textColor = [UIColor whiteColor];
    self.currentTimeLabel.text = @"00:00";
    self.currentTimeLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.currentTimeLabel];
    [self.currentTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.bottom.equalTo(weakSelf.playButton.mas_top).offset(-20);
        make.width.mas_equalTo(40);
    }];
    
    self.totalTimeLabel = [UILabel new];
    self.totalTimeLabel.font = FONT_9_REGULAR(12);
    self.totalTimeLabel.textColor = [UIColor whiteColor];
    self.totalTimeLabel.text = @"01:42";
    self.totalTimeLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.totalTimeLabel];
    [self.totalTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.bottom.equalTo(weakSelf.playButton.mas_top).offset(-20);
        make.width.mas_equalTo(40);
    }];
    
    self.proSlider = [[UISlider alloc] init];
    self.proSlider.value = 0.0;
    self.proSlider.minimumValue = 0.0;
    self.proSlider.maximumValue = 1.0;
    self.proSlider.minimumTrackTintColor = QQMUSIC_THEMECOLOR;
    self.proSlider.maximumTrackTintColor = [UIColor lightGrayColor];
    [self.proSlider setThumbImage:[UIImage imageNamed:@"slider_thumb"] forState:UIControlStateNormal];
    [self.proSlider addTarget:self action:@selector(proSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.proSlider];
    [self.proSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.totalTimeLabel);
        make.left.equalTo(weakSelf.currentTimeLabel.mas_right).offset(10);
        make.right.equalTo(weakSelf.totalTimeLabel.mas_left).offset(-10);
        
    }];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.lrcArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LRCCell *cell = [LRCCell createLRCCell:tableView];
    LRCModel *model = self.lrcArray[indexPath.row];
    cell.content = model.content;
    cell.indexPath = indexPath;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    LRCModel *model = self.lrcArray[indexPath.row];
    CGSize size = [model.content boundingRectWithSize:CGSizeMake(CGRectGetWidth(tableView.frame), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:FONT_9_REGULAR(15)} context:nil].size;
    return size.height + 10;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self disMissGrantureADD];
}

-(void)disMissGrantureADD{
    [UIView animateWithDuration:0.5 animations:^{
        self.lrcTableView.alpha = 0;
        self.diskView.alpha = 1;
    }];
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([touch.view isKindOfClass:[UIScrollView class]]) {
        return YES;
    }
    return NO;
}

#pragma mark - 更多功能

-(void)moreAction{
    NSLog(@"打开更多功能");
    QQPlayMoreView *moreView = [QQPlayMoreView sharedManager];
    moreView.songNameLabel.text = [NSString stringWithFormat:@"%@ - %@",self.currentModel.song,self.currentModel.singer];
    [moreView playShow];
}

#pragma mark - 打开歌曲列表

-(void)openSongListAction{
    NSLog(@"打开歌曲列表");
}


#pragma mark - 改变播放模式

-(void)changePlayStateAction{
    if (self.playMode == 2) {
        self.playMode = 0;
    }else{
        self.playMode ++;
    }
    [[NSUserDefaults standardUserDefaults] setInteger:self.playMode forKey:@"playMode"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.playStateButton setImage:[[UIImage imageNamed:self.playModeArray[self.playMode]] imageWithColor:QQMUSIC_THEMECOLOR] forState:UIControlStateNormal];
}

#pragma mark - 播放 暂停
-(void)playOrPauseSongAction{
    BOOL play = [[NSUserDefaults standardUserDefaults] boolForKey:@"playState"];
    if (!play) {
        [self musicPlay];
    }else{
        [self musicPause];
    }

}

-(void)proSliderValueChanged:(UISlider *)slider{
    self.player.currentTime = slider.value * self.player.duration;
    [self.player playAtTime:slider.value * self.player.duration];
    self.currentTime = slider.value*self.player.duration;
    self.currentTimeLabel.text = [self stringWithTime:self.currentTime];
}

#pragma mark - 开始播放
-(void)musicPlay{
    [self.playButton setImage:[UIImage imageNamed:@"player_btn_pause_normal"] forState:UIControlStateNormal];
    [self.playButton setImage:[UIImage imageNamed:@"player_btn_pause_highlight"] forState:UIControlStateHighlighted];
    
    if (self.currentModel) {

        [self.player play];
        if (self.proTimer) {
            [self.proTimer setFireDate:[NSDate date]];
        }
        
        [self setPlayingInfo];
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"playState"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    if (!self.proTimer) {
        __weak typeof (self) weakSelf = self;
        self.proTimer = [NSTimer eocScheduledTimerWithTimeInterval:0.01 block:^{
            weakSelf.currentTime += 0.01;
            weakSelf.currentTimeLabel.text = [self stringWithTime:weakSelf.currentTime];
            [weakSelf changeProgressValue];
        } repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.proTimer forMode:NSRunLoopCommonModes];
    }
    
    [self.diskView startSongDiskAnimation];
}

-(void)changeProgressValue{
    [self.proSlider setValue:self.currentTime / self.player.duration animated:YES];
    
//    NSLog(@"%lf",self.currentTime);
    int minute = self.currentTime / 60;
    int second = (int)self.currentTime % 60;
    NSString *temp = [NSString stringWithFormat:@"%lf",self.currentTime];
    if ([temp rangeOfString:@"."].length) {
        NSString *time = [temp substringWithRange:NSMakeRange([temp rangeOfString:@"."].location+1, 2)];
        NSString *timeComplete = [NSString stringWithFormat:@"[%02d:%02d.%@]",minute,second,time];
//        NSLog(@"timeComplete = %@",timeComplete);
        
        
        for (NSInteger i = self.rowIndex; i < _lrcArray.count; i++) {
            LRCModel *model = _lrcArray[i];
            if ([model.time isEqualToString:timeComplete]) {
                self.rowIndex = i;
                NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:self.lastRowIndex inSection:0];
                LRCCell *lastCell = [_lrcTableView cellForRowAtIndexPath:lastIndexPath];
                lastCell.contentLabel.textColor = [UIColor whiteColor];
                self.lastRowIndex = i;
                NSLog(@"timeComplete = %@,time = %@,index = %ld",timeComplete,model.time,self.rowIndex);

                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.rowIndex inSection:0];
                LRCCell *cell = [_lrcTableView cellForRowAtIndexPath:indexPath];
                cell.contentLabel.textColor = QQMUSIC_THEMECOLOR;
                
                [self.lrcTableView scrollToRow:self.rowIndex inSection:0 atScrollPosition:UITableViewScrollPositionMiddle animated:YES];

                break;
            }
            
        }
        
        
    }
    
}

#pragma mark - 暂停
-(void)musicPause{
    [self.playButton setImage:[UIImage imageNamed:@"player_btn_play_normal"] forState:UIControlStateNormal];
    [self.playButton setImage:[UIImage imageNamed:@"player_btn_play_highlight"] forState:UIControlStateHighlighted];
    
    [self.player pause];
    [self.proTimer setFireDate:[NSDate distantFuture]];
    
    [self.diskView pauseSongDiskAnimation];
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"playState"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - 停止
-(void)musicStop{
    [self.proTimer setFireDate:[NSDate distantFuture]];
    [self.player stop];
    [self.diskView stopSongDiskAnimation];
    self.rowIndex = 0;
    self.lastRowIndex = 0;
    [self.lrcTableView scrollToRow:self.rowIndex inSection:0 atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    self.currentTime = 0.0;
    self.currentTimeLabel.text = [self stringWithTime:self.currentTime];
    [self.proSlider setValue:0.0 animated:NO];
    
    [self.playButton setImage:[UIImage imageNamed:@"player_btn_play_normal"] forState:UIControlStateNormal];
    [self.playButton setImage:[UIImage imageNamed:@"player_btn_play_highlight"] forState:UIControlStateHighlighted];
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"playState"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    NSLog(@"音乐播放完成");
    
    if (self.playMode == 0) {
        [self changeNextSong];
    }else if (self.playMode == 1) {
        [self musicStop];
        [self musicPlay];
    }else{
        self.songIndex = arc4random() % _songListArray.count + 1;
        [self changeRandomSong];
        
    }
//    [self musicStop];
}
-(void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error{
    NSLog(@"音乐解码错误 = %@",[error localizedDescription]);
}
-(void)audioPlayerBeginInterruption:(AVAudioPlayer *)player{
    NSLog(@"播放被中断");
    
    [self musicPause];
}


#pragma mark - 上一首
-(void)changePreviousSong{
    NSLog(@"上一首");
    if (self.songIndex == 0) {
        self.songIndex = self.songListArray.count - 1;
    }else{
        self.songIndex--;
    }
    
    [self changeRandomSong];
}

#pragma mark - 下一首
-(void)changeNextSong{
    NSLog(@"下一首");
    if (self.songIndex == self.songListArray.count - 1) {
        self.songIndex = 0;
    }else{
        self.songIndex++;
    }
    
    [self changeRandomSong];
}

#pragma mark - 随机播放

-(void)changeRandomSong{
    
    [self.diskView stopSongDiskAnimation];
    [self.diskView startSongDiskAnimation];
    
    self.currentModel = self.songListArray[self.songIndex];
    self.titleLabel.scrollTitle = [NSString stringWithFormat:@"%@ - %@",self.currentModel.song,self.currentModel.singer];
    self.currentTime = 0.0;
    self.rowIndex = 0;
    self.lastRowIndex = 0;
    if (self.lrcArray.count) {
        [self.lrcTableView scrollToRow:self.rowIndex inSection:0 atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    }
    self.diskView.singerImage = [[QQPlayManager sharedPlayManager] getCurrentSingerImage:self.currentModel.singer];
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:[NSString stringWithFormat:@"%@ - %@.%@",self.currentModel.singer,self.currentModel.song,self.currentModel.type] withExtension:nil];
    

    [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGECURRENTSONGNAME" object:[NSString stringWithFormat:@"%@ - %@",self.currentModel.song,self.currentModel.singer]];
    
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    self.player.delegate = self;
    [self.player prepareToPlay];
    [self.player play];
    
    [self getAudioPlayerInfo];
}

#pragma mark - 定制锁屏界面

-(void)setPlayingInfo{
    //设置后台播放时显示的界面，例如歌曲名字 图片等
    MPMediaItemArtwork *artWork = [[MPMediaItemArtwork alloc] initWithImage:[UIImage imageWithColor:[UIColor redColor]]];
    NSDictionary *dic = @{
                          MPMediaItemPropertyTitle : self.currentModel.song,
                          MPMediaItemPropertyArtist : self.currentModel.singer,
                          MPMediaItemPropertyArtwork : artWork
                          };
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dic];
}

#pragma mark - 控制锁屏界面的按钮（上一首 播放 下一首）
-(void)remoteControlReceivedWithEvent:(UIEvent *)event{
    //判断是否为远程控制
    if (event.type == UIEventTypeRemoteControl) {
        switch (event.subtype) {
            case UIEventSubtypeRemoteControlPlay:
                if (![self.player isPlaying]) {
                    [self musicPlay];
                }
                break;
            case UIEventSubtypeRemoteControlPause:
                if ([self.player isPlaying]) {
                    [self musicPause];
                }
                break;
            case UIEventSubtypeRemoteControlNextTrack:
                NSLog(@"下一首");
                break;
            case UIEventSubtypeRemoteControlPreviousTrack:
                NSLog(@"上一首");
                break;
            default:
                break;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
