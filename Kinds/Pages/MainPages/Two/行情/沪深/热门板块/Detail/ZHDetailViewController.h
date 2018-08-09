//
//  ZHDetailViewController.h
//  Kinds
//
//  Created by hibor on 2018/6/22.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import "BaseViewController.h"
#import "ZHDetailCell.h"

@interface ZHDetailViewController : BaseViewController

typedef enum : NSUInteger {
    StockItemTypeGG,    //港股
    StockItemTypeHS    //沪深
    
} StockItemType;


@property(nonatomic,copy)NSString *code;
@property(nonatomic,copy)NSString *titleName;

@property(nonatomic,assign)StockItemType itemType;

@end
