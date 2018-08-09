//
//  OCTableModel.h
//  TT
//
//  Created by hibor on 2018/4/3.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OCTableModel : NSObject


/**
 Section的文字标题
 */
@property(nonatomic,strong)NSString *headTitle;


/**
 存放当前Section的数据
 */
@property(nonatomic,strong)NSArray *listArray;


/**
 是否处于打开状态
 */
@property(nonatomic,assign)BOOL opened;

@end
