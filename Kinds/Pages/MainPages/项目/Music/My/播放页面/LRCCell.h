//
//  LRCCell.h
//  Kinds
//
//  Created by hibor on 2018/9/10.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LRCCell : UITableViewCell

@property(nonatomic,assign)CGFloat rowHeight;

@property(nonatomic,copy)NSString *content;

@property(nonatomic,strong)UILabel *contentLabel;

@property(nonatomic,strong)NSIndexPath *indexPath;

+(instancetype)createLRCCell:(UITableView *)tableView;


@end
