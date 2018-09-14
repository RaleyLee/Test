//
//  AllSongsViewController.m
//  Kinds
//
//  Created by hibor on 2018/9/12.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import "AllSongsViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface AllSongsViewController ()

@property(nonatomic,assign)CGFloat currentTime;
@property(nonatomic,strong)NSMutableArray *timeArray;
@property(nonatomic,strong)NSTimer *timer;
@property(nonatomic,assign)BOOL isStop;

@end

@implementation AllSongsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"全部音乐";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.currentTime = 0.0;
    self.timeArray = [NSMutableArray array];
    self.isStop = NO;
    
    UIButton *insetTime = [UIButton buttonWithType:UIButtonTypeCustom];
    [insetTime setTitle:@"插入时间" forState:UIControlStateNormal];
    [insetTime setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [insetTime setBackgroundColor:[UIColor greenColor]];
    [insetTime addTarget:self action:@selector(insertTime) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:insetTime];
    [insetTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.mas_equalTo(40);
        make.size.mas_equalTo(CGSizeMake(100, 50));
    }];
    
    
    UIButton *stopTime = [UIButton buttonWithType:UIButtonTypeCustom];
    [stopTime setTitle:@"停止时间" forState:UIControlStateNormal];
    [stopTime setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [stopTime setBackgroundColor:[UIColor greenColor]];
    [stopTime addTarget:self action:@selector(stopInsertTime) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:stopTime];
    [stopTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(insetTime.mas_bottom).offset(50);
        make.size.mas_equalTo(CGSizeMake(100, 50));
    }];
    
//    __weak typeof (self) weakSelf = self;
//    self.timer = [NSTimer eocScheduledTimerWithTimeInterval:0.01 block:^{
//        weakSelf.currentTime += 0.01;
//    } repeats:YES];
    
//    [self getSongInfo];
    
    [self writeSongInfo];
}

-(void)writeSongInfo{
    NSError *error;
    NSString *path = [[NSBundle mainBundle]pathForResource:@"Infinite - Can You Smile.mp3"ofType:nil];
    AVAssetWriter *assetWrtr = [[AVAssetWriter alloc] initWithURL:[NSURL fileURLWithPath:path] fileType:AVFileTypeAppleM4A error:&error];
    NSLog(@"%@",error);
    
    NSArray *existingMetadataArray = assetWrtr.metadata;
    NSMutableArray *newMetadataArray = nil;
    if (existingMetadataArray)
    {
        newMetadataArray = [existingMetadataArray mutableCopy]; // To prevent overriding of existing metadata
    }
    else
    {
        newMetadataArray = [[NSMutableArray alloc] init];
    }
    
    
    AVMutableMetadataItem *item = [[AVMutableMetadataItem alloc] init];
    item.keySpace = AVMetadataKeySpaceCommon;
    item.key = AVMetadataCommonKeyArtwork;
    item.value = UIImageJPEGRepresentation([UIImage imageNamed:@"Infinite.jpg"], 1.0);
    
    [newMetadataArray addObject:item];
    assetWrtr.metadata = newMetadataArray;
    
    
    
    [assetWrtr startWriting];
    [assetWrtr startSessionAtSourceTime:kCMTimeZero];
}

-(void)getSongInfo{
    //用来获取多媒体文件的信息的工具
    //1.创建一个AVURLAsset对象
    //参数1:需要获取的多媒体的路径
    NSString *path = [[NSBundle mainBundle]pathForResource:@"王贰浪 - 往后余生.mp3"ofType:nil];
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:path] options:nil];
    
    //2.获取媒体文件的格式
    NSArray * formatArray = [asset availableMetadataFormats];
    NSString *format = formatArray.firstObject;
    
    //3.根据格式做文件解析(解析音乐文件的信息)
    NSArray *metaDataArray = [asset metadataForFormat:format];
    
    //4.遍历数组拿到所有信息
    for (AVMutableMetadataItem *item in metaDataArray) {
        //歌手
        if ([item.commonKey isEqualToString:@"artist"]) {
            NSLog(@"1:%@",item.value);
        }
        
        //专辑
        if ([item.commonKey isEqualToString:@"albumName"]) {
            NSLog(@"%@",item.value);
        }
        
        //歌名
        if ([item.commonKey isEqualToString:@"title"]) {
            NSLog(@"%@",item.value);
        }
       
        //专辑
        if ([item.commonKey isEqualToString:@"artwork"]) {
            
            NSData *data = (NSData *)item.value;
            self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithData:data]];
        }
        
    }
    

}

-(NSString *)formatterTime{
    int minute = self.currentTime / 60;
    int second = (int)self.currentTime % 60;
    NSString *temp = [NSString stringWithFormat:@"%lf",self.currentTime];
    if ([temp rangeOfString:@"."].length) {
        NSString *time = [temp substringWithRange:NSMakeRange([temp rangeOfString:@"."].location+1, 2)];
        NSString *timeComplete = [NSString stringWithFormat:@"[%02d:%02d.%@]",minute,second,time];
        return timeComplete;
    }
    return @"[00:00.00]";
}

-(void)insertTime{
    if (self.isStop) {
        self.isStop = NO;
        self.currentTime = 0.0;
        [self.timer setFireDate:[NSDate date]];
        self.timeArray = [NSMutableArray array];
    }
    
    
    [self.timeArray addObject:[self formatterTime]];
    
}

-(void)stopInsertTime{
    NSLog(@"timeArray = %@",self.timeArray);
    self.isStop = YES;
    [self.timer setFireDate:[NSDate distantFuture]];
    
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
