//
//  MessageListCell.h
//  Kinds
//
//  Created by hibor on 2018/8/7.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageListModel.h"

@interface MessageListCell : UITableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;

@property(nonatomic,strong)MessageListModel *model;

@end
