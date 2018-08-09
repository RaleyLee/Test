//
//  MusicCell.m
//  Kinds
//
//  Created by hibor on 2018/7/20.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import "MusicCell.h"

@implementation MusicCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"MusicCell" owner:self options:nil].lastObject;
    }
    
    return self;
}

-(void)setTuiJianCollectionCellWithModel:(MusicHostContentModel *)contentModel{
    self.desLabel.text = contentModel.descript;
    self.iconImageView.image = [UIImage imageNamed:contentModel.iconImage];
}

@end
