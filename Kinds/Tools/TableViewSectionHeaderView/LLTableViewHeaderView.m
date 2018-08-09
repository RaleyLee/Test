//
//  LLTableViewHeaderView.m
//  Kinds
//
//  Created by hibor on 2018/6/20.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import "LLTableViewHeaderView.h"

@implementation LLTableViewHeaderView

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = RGB_color(244);
        
        [self.contentView addSubview:self.kindLabel];
        
        [self.contentView addSubview:self.countLabel];
        
    }
    return self;
}

-(void)setBgColor:(UIColor *)bgColor{
    self.contentView.backgroundColor = bgColor;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self.kindLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(200, CGRectGetHeight(self.contentView.frame)));
    }];
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(50, CGRectGetHeight(self.contentView.frame)));
    }];
}
-(UILabel *)kindLabel{
    if (!_kindLabel) {
        _kindLabel = [UILabel new];
        _kindLabel.backgroundColor = [UIColor clearColor];
        _kindLabel.font = [UIFont systemFontOfSize:15];
    }
    return _kindLabel;
}

-(UILabel *)countLabel{
    if (!_countLabel) {
        _countLabel = [UILabel new];
        _countLabel.backgroundColor = [UIColor clearColor];
        _countLabel.font = [UIFont systemFontOfSize:13];
        _countLabel.textAlignment = NSTextAlignmentRight;
    }
    return _countLabel;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
