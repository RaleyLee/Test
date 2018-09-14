//
//  DownListCell.h
//  Kinds
//
//  Created by hibor on 2018/8/18.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "VideoModel.h"

@interface DownListCell : UITableViewCell

+(instancetype)createTableView:(UITableView *)tableView;

@property(nonatomic,strong)NSIndexPath *indexPath;

@property(nonatomic,strong)VideoModel *model;

@property(nonatomic,copy) void (^downLoadCallBackBlock)();

@end
