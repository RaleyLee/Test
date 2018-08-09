//
//  StockFormViewController.h
//  HangQingNew
//
//  Created by hibor on 2018/5/23.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import "BaseViewController.h"
#import "AroundCell.h"

@interface StockFormViewController : BaseViewController

@property(nonatomic,copy)NSString *type; //类型
@property(nonatomic,copy)NSString *order; //排序 升降

@property(nonatomic,copy)NSString *tableTitle;

@end
