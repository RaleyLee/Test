//
//  LRCModel.h
//  Kinds
//
//  Created by hibor on 2018/9/11.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LRCModel : NSObject

/** 歌词开始时间 */
@property (nonatomic,copy) NSString *time;

/** 歌词内容 */
@property (nonatomic,copy) NSString *content;

@end
