//
//  ZHMHotCell.h
//  Kinds
//
//  Created by hibor on 2018/6/22.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZHMHotCell : UITableViewCell

@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *zdfLabel;
@property(nonatomic,strong)UILabel *gnLabel;

@property(nonatomic,strong)HBItemModel *model;

@end
