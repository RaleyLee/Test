//
//  MusicCell.h
//  Kinds
//
//  Created by hibor on 2018/7/20.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MusicHostContentModel.h"

@interface MusicCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;


-(void)setTuiJianCollectionCellWithModel:(MusicHostContentModel *)contentModel;

@end
