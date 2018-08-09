//
//  CircleCell.h
//  Kinds
//
//  Created by hibor on 2018/8/1.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CircleModel.h"
#import "MediaView.h"
#import "WeMenuView.h"


@protocol CellOCButtonDelegate<NSObject>

-(void)ocButtonClickWithIndexPath:(NSIndexPath *)indexPath;

@end

@interface CircleCell : UITableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;

@property(nonatomic,strong)NSIndexPath *indexPath;

@property(nonatomic,strong)MediaView *mediaView;
@property(nonatomic,strong)CircleModel *model;

@property(nonatomic,strong)WeMenuView *menuView;

@property(nonatomic,assign)id <CellOCButtonDelegate> delegate;
@end
