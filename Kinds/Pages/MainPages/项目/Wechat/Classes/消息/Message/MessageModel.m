//
//  MessageModel.m
//  Kinds
//
//  Created by hibor on 2018/8/8.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import "MessageModel.h"

@implementation MessageModel

-(instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}


+(instancetype)messageWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}


@end
