//
//  SongInfo.h
//  Kinds
//
//  Created by hibor on 2018/9/12.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SongInfo : NSObject

@property(nonatomic,copy)NSString *songName; //歌曲
@property(nonatomic,copy)NSString *singer; //歌手
@property(nonatomic,copy)NSString *album; //专辑
@property(nonatomic,copy)NSString *cover; //封面
@property(nonatomic,assign)NSInteger duration; //时长

@end
