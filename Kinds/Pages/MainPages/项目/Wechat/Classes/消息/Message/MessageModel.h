//
//  MessageModel.h
//  Kinds
//
//  Created by hibor on 2018/8/8.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    CZMessageTypeMe = 0,
    CZMessageTypeOther = 1
} CZMessageType;

@interface MessageModel : NSObject


@property(nonatomic,copy)NSString *text;

@property(nonatomic,copy)NSString *time;

@property(nonatomic,assign)CZMessageType type;

@property(nonatomic,assign)BOOL hideTime;//是否显示时间label

-(instancetype)initWithDict:(NSDictionary *)dict;
+(instancetype)messageWithDict:(NSDictionary *)dict;

@end
