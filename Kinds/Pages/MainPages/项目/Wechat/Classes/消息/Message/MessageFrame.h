//
//  MessageFrame.h
//  Kinds
//
//  Created by hibor on 2018/8/8.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MessageModel.h"

@interface MessageFrame : NSObject

@property(nonatomic,strong)MessageModel *message;//引用数据模型
@property(nonatomic,assign,readonly)CGRect timeFrame; //时间label Frame
@property(nonatomic,assign,readonly)CGRect iconFrame; //头像 Frame
@property(nonatomic,assign,readonly)CGRect textFrame; //正文 Frame
@property(nonatomic,assign,readonly)CGFloat rowHeight; //行高

@end
