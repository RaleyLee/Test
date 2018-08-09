//
//  AroundCell.h
//  AroundVC
//
//  Created by apple on 17/2/8.
//  Copyright © 2017年 ZXL. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AroundModel;

typedef void(^TapCellClick)(NSIndexPath *indexPath);
static NSString *tapCellScrollNotification = @"tapCellScrollNotification";

@interface AroundCell : UITableViewCell <UIScrollViewDelegate>

@property (strong, nonatomic) LLabel *nameLabel;
@property(strong,nonatomic)LLabel *codeLabel;
@property (strong, nonatomic) UIScrollView *rightScrollView;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) BOOL isNotification;
@property (nonatomic, copy) TapCellClick tapCellClick;

@property(nonatomic,strong)AroundModel *model;

@end
