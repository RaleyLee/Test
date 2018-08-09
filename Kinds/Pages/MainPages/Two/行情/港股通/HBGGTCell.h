//
//  HBGGTCell.h
//  WBAPP
//
//  Created by hibor on 2018/5/4.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HBModel.h"
@class HBGGTModel;

@interface HBGGTCell : UITableViewCell

@property(nonatomic,strong)HBGGTModel *model;

@property(nonatomic,strong)LLabel *nameLabel; //股票名称

@property(nonatomic,strong)LLabel *htLabel; //H股 上面
@property(nonatomic,strong)LLabel *hbLabel; //H股 下面

@property(nonatomic,strong)LLabel *atLabel; //A股 上面
@property(nonatomic,strong)LLabel *abLabel; //A股 下面

@property(nonatomic,strong)LLabel *priceLabel; //溢价

@end
