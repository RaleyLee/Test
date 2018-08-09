//
//  HBMarketItemView.h
//  StockMarket
//
//  Created by hibor on 2018/5/18.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HBModel.h"

enum {
    MarketItemTypeTop = 0,  //顶部的Item
    MarketItemTypeMiddle,   //中间的Item
};
typedef NSUInteger MarketItemType;

@interface HBMarketItemView : UIView


/**
 初始化 Item

 @param frame Item 的frame
 @param type Item 的类型
 @return 返回
 */
-(instancetype)initWithFrame:(CGRect)frame withItemType:(MarketItemType)type;


@property(nonatomic,strong)HBItemModel *itemModel;
@property(nonatomic,strong)HBListModel *listModel;
@property(nonatomic,strong)GangTModel *gTModel;


/**
 点击Item的block回调
 */
@property(nonatomic,strong)void (^clickItemBlock)(id model);

@end
