//
//  OneCollectionViewCell.m
//  Kinds
//
//  Created by hibor on 2018/6/20.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import "OneCollectionViewCell.h"

@implementation OneCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self.contentView addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        
        [self.contentView addSubview:self.canPushImageView];
        [self.canPushImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(15, 15));
        }];
    }
    return self;
}

-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.numberOfLines = 0;
        _nameLabel.lineBreakMode = NSLineBreakByCharWrapping | NSLineBreakByWordWrapping;
        [_nameLabel adjustsFontSizeToFitWidth];
    }
    return _nameLabel;
}

-(UIImageView *)canPushImageView{
    if (!_canPushImageView) {
        _canPushImageView = [UIImageView new];
        _canPushImageView.image = [UIImage imageNamed:@"canpush-RB"];
    }
    return _canPushImageView;
}
@end
