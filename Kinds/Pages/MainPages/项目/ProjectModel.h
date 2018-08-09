//
//  ProjectModel.h
//  Kinds
//
//  Created by hibor on 2018/7/10.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProjectModel : NSObject

@property(nonatomic,copy)NSString *proName;
@property(nonatomic,copy)NSString *proIcon;
@property(nonatomic,copy)NSString *proUrl;
@property(nonatomic,copy)NSString *iconCorner;
@property(nonatomic,copy)NSString *iconSimName;
@property(nonatomic,copy)NSString *state;
@property(nonatomic,assign)BOOL canPush;

@end
