//
//  LoadedCell.h
//  Kinds
//
//  Created by hibor on 2018/8/21.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DownFileModel.h"
#import "DownLoadHelper.h"

@interface LoadedCell : UITableViewCell

+(instancetype)createCellWithTableView:(UITableView *)tableView;

/** 下载信息模型 */
@property (nonatomic, strong) DownFileModel      *fileInfo;

@end
