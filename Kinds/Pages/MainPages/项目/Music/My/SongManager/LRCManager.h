//
//  LRCManager.h
//  Kinds
//
//  Created by hibor on 2018/9/11.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LRCManager : NSObject


+(LRCManager *)sharedManager;


/**
 获取指定歌曲的歌词

 @param fileName 传入歌曲文件
 @return 解析后的歌词
 */
-(NSMutableArray *)getCurrentSongLrcList:(NSString *)fileName;


@end
