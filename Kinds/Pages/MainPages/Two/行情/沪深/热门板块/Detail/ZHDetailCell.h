//
//  ZHDetailCell.h
//  Kinds
//
//  Created by hibor on 2018/6/22.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZHDetailCell : UITableViewCell

@property(nonatomic,assign)BOOL isWaiHui;

@property(nonatomic,assign)BOOL showIcon;
@property(nonatomic,strong)UIImageView *flagImageView;
@property(nonatomic,strong)LLabel *nameLabel;
@property(nonatomic,strong)LLabel *codeLabel;
@property(nonatomic,strong)UILabel *priceLabel;
@property(nonatomic,strong)UILabel *unknownLabel;

@property(nonatomic,strong)HBListModel *model;

@end
