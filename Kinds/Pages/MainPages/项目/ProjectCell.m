//
//  ProjectCell.m
//  Kinds
//
//  Created by hibor on 2018/7/10.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import "ProjectCell.h"

@interface ProjectCell()

@property(nonatomic,strong)UIImageView *iconImageView;
@property(nonatomic,strong)UILabel *nameLabel;

@end

@implementation ProjectCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.contentView addSubview:self.iconImageView];
        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_offset(10);
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];
        
        [self.contentView addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconImageView.mas_right).offset(10);
            make.centerY.equalTo(self.contentView);
        }];
    }
    return self;
}

-(UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [UIImageView new];
    }
    return _iconImageView;
}

-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.font = FONT_9_MEDIUM(15);
        [_nameLabel sizeToFit];
    }
    return _nameLabel;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    UIBezierPath *bezier = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 40, 40) cornerRadius:[self.pModel.iconCorner floatValue]];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = bezier.CGPath;
    _iconImageView.layer.mask = shapeLayer;
    
    if (self.pModel.proIcon.length == 0) {
        _iconImageView.image = [UIImage createShareImage:[UIImage imageWithColor:RGB_random size:CGSizeMake(40, 40)] Context:self.pModel.iconSimName];
    }else{
        _iconImageView.image = [UIImage imageNamed:self.pModel.proIcon];
    }
    
    _nameLabel.text = [NSString stringWithFormat:@"%@  -  %@",self.pModel.proName , self.pModel.state];
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
