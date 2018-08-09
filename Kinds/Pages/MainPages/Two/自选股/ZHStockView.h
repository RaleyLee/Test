//
//  ZHStockView.h
//  Kinds
//
//  Created by hibor on 2018/6/25.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHStockModel.h"

@interface ZHStockView : UIView

@property(nonatomic,strong)ZHStockModel *model;

/**
 初始化 Item
 
 @param frame Item 的frame
 @return 返回
 */
-(instancetype)initWithFrame:(CGRect)frame;


/**
 点击Item的block回调
 */
@property(nonatomic,strong)void (^clickItemBlock)(id model);

@end
