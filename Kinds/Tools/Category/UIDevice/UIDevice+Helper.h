//
//  UIDevice+Helper.h
//  Kinds
//
//  Created by hibor on 2018/9/7.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (Helper)

// 获取磁盘总空间
- (int64_t)getTotalDiskSpace;

// 获取未使用的磁盘空间
- (int64_t)getFreeDiskSpace;

// 获取已使用的磁盘空间
- (int64_t)getUsedDiskSpace;

@end
