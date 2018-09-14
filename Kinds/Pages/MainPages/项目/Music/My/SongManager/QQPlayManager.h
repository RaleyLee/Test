//
//  QQPlayManager.h
//  Kinds
//
//  Created by hibor on 2018/9/11.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SongInfo.h"

@interface QQPlayManager : NSObject

@property(nonatomic,assign) NSTimeInterval currentTime;
@property(nonatomic,assign) NSTimeInterval duration;


/**
 单例
 */
+(instancetype)sharedPlayManager;


/**
 获取当前歌曲信息
 @param fileName 歌曲名字
 */
-(SongInfo *)getCurrentSongInfo:(NSString *)fileName;


/**
 获取当前歌手的照片

 @param singerName 歌手名字
 @return 歌手照片
 */
-(UIImage *)getCurrentSingerImage:(NSString *)singerName;

/**
 播放音乐的方法

 @param fileName 音乐文件的名称
 @param complete 播放完毕后block回调
 */
-(void)playMusicWithFileName:(NSString *)fileName didComplete:(void(^)(void))complete;


/**
 音乐暂停
 */
-(void)musicPause;


/**
 音乐停止
 */
-(void)musicStop;
@end
