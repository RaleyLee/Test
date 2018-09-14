//
//  DownCell.h
//  Kinds
//
//  Created by hibor on 2018/8/20.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DownLoadManager.h"

typedef NS_ENUM(NSInteger,DownCellType){
    DownCellTypeLoading = 0,
    DownCellTypeLoaded
};

@interface DownCell : UITableViewCell

+(instancetype)createCellWithTableView:(UITableView *)tableView;

//单元格类型
@property(nonatomic,assign) DownCellType cellType;

/** 下载信息模型 */
@property (nonatomic, strong) DownFileModel      *fileInfo;
/** 该文件发起的请求 */
@property (nonatomic,retain ) DownHttpRequest    *request;

@end
