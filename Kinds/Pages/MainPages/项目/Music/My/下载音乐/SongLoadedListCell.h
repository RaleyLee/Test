//
//  SongLoadedListCell.h
//  Kinds
//
//  Created by hibor on 2018/9/10.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SongModel.h"

@interface SongLoadedListCell : UITableViewCell

@property(nonatomic,strong)SongModel *sModel;
@property(nonatomic,strong)NSIndexPath *indexPath;

+(instancetype)createSongListCell:(UITableView *)tableView;

@end
