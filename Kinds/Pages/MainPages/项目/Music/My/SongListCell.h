//
//  SongListCell.h
//  Kinds
//
//  Created by hibor on 2018/7/11.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import <UIKit/UIKit.h>

enum{
    SongListTypeNormal = 0, //正常有数据是显示
    SongListTypeEnd,  //最后一条数据
};
typedef NSUInteger SongListType;

@interface SongListCell : UITableViewCell

@property(nonatomic,assign)SongListType listType;

@end
