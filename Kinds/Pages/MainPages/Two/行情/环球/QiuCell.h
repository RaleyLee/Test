//
//  QiuCell.h
//  WBAPP
//
//  Created by hibor on 2018/4/24.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QiuModel;

@interface QiuCell : UITableViewCell

@property(nonatomic,strong)QiuModel *model;

@property(nonatomic,strong)UIImageView *flagImageView;
@property(nonatomic,assign)BOOL showFlagIcon;

@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *oneLabel;
@property(nonatomic,strong)UILabel *twoLabel;

@property(nonatomic,strong)NSIndexPath *indexPath;

@end
