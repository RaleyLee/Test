//
//  BDLayerView.h
//  Kinds
//
//  Created by hibor on 2018/8/14.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^mapKindClickBlock)(NSInteger index);

@interface BDLayerView : UIView


+(BDLayerView *)popLayerView;

@property(nonatomic,strong)mapKindClickBlock mapkindBlock;

-(void)show;

-(void)dismiss;

@end




@interface BDLayerCell : UITableViewCell

@property(nonatomic,strong)UIImageView *iconImageView;
@property(nonatomic,strong)UILabel *titleLabel;


+(instancetype)cellWithTableView:(UITableView *)tableView;

@end
