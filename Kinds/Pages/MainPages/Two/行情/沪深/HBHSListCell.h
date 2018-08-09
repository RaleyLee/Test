//
//  HBHSListCell.h
//  WBAPP
//
//  Created by hibor on 2018/5/2.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HBHSListCell : UITableViewCell

@property(nonatomic,strong)HBListModel *model;
@property(nonatomic,strong)GangModel *gModel;
@property(nonatomic,strong)HBHQModel *hqModel;
@property(nonatomic,strong)BangModel *bangModel;


@property(nonatomic,assign)BOOL zxj_colorful;//最新价变色
@property(nonatomic,copy)NSString *keyString; //显示变色的key

@property(nonatomic,assign)BOOL showCJE;//展示成交额

@property(nonatomic,strong)UIImageView *stockIcon; //HK 标识
@property(nonatomic,assign)BOOL showIcon;


@property(nonatomic,strong)LLabel *stockNameLabel; //股票名称
@property(nonatomic,strong)LLabel *StockCodeLabel; //股票代码
@property(nonatomic,strong)LLabel *priceLabel; //最新价
@property(nonatomic,strong)LLabel *unknownLabel; //其他


@property(nonatomic,assign)NSTextAlignment price_textAlignment;


@end
