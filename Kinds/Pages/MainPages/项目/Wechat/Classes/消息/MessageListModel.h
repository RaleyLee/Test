//
//  MessageListModel.h
//  Kinds
//
//  Created by hibor on 2018/8/7.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageListModel : NSObject

@property(nonatomic,copy)NSString *headImage;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *content;
@property(nonatomic,copy)NSString *time;
@property(nonatomic,assign)BOOL isDis;

@end
