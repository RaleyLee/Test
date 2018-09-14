//
//  SongDiskView.h
//  Kinds
//
//  Created by hibor on 2018/9/13.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SongDiskView : UIImageView

@property(nonatomic,strong)UIImage *singerImage;

//开始专辑旋转动画
-(void)startSongDiskAnimation;

//停止专辑旋转动画
-(void)stopSongDiskAnimation;

//暂停专辑旋转动画
-(void)pauseSongDiskAnimation;

@end
