//
//  KindModel.h
//  Kinds
//
//  Created by hibor on 2018/6/20.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KindModel : NSObject

@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *openPage;
@property(nonatomic,copy)NSString *descript;
@property(nonatomic,assign)BOOL canPush;

@end
