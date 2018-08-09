//
//  CircleModel.h
//  Kinds
//
//  Created by hibor on 2018/8/1.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CircleModel : NSObject

@property(nonatomic,copy)NSString *headImage;
@property(nonatomic,copy)NSString *nickName;
@property(nonatomic,copy)NSString *content;
@property(nonatomic,copy)NSString *mediaType;
@property(nonatomic,strong)NSArray *mediaContent;
@property(nonatomic,copy)NSString *time;
@property(nonatomic,copy)NSString *address;
@property(nonatomic,assign)BOOL open;
@property(nonatomic,assign)CGFloat rowHeight;

@end
