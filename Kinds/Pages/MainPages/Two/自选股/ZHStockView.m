//
//  ZHStockView.m
//  Kinds
//
//  Created by hibor on 2018/6/25.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import "ZHStockView.h"

@interface ZHStockView()

@property(nonatomic,strong)LLabel *nameLabel;
@property(nonatomic,strong)LLabel *middleLabel;
@property(nonatomic,strong)LLabel *leftLabel,*rightLabel;

@end

@implementation ZHStockView


-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(0);
            make.height.mas_equalTo(35);
        }];
        
        [self addSubview:self.middleLabel];
        [self.middleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.equalTo(self.nameLabel.mas_bottom);
            make.height.mas_equalTo(25);
        }];
        

        CGFloat padding =  7.0f ;
        [self addSubview:self.leftLabel];
        [self addSubview:self.rightLabel];
        [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(padding);
            make.height.mas_equalTo(25);
            make.right.equalTo(self.rightLabel.mas_left).offset(-7);
            make.top.equalTo(self.middleLabel.mas_bottom);
            make.width.equalTo(self.rightLabel.mas_width);
        }];
        
        [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-padding);
            make.height.equalTo(self.leftLabel.mas_height);
            make.top.equalTo(self.middleLabel.mas_bottom);
        }];
        
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

#pragma mark - 点击 Item 的手势回调
-(void)click:(UIGestureRecognizer *)gesture{
    if (self.clickItemBlock) {
        self.clickItemBlock(self.model);
    }
}


-(void)layoutSubviews{
    [super layoutSubviews];
}

-(void)setModel:(ZHStockModel *)model{
    _model = model;
    self.nameLabel.text = @"123";
    if ([model.JiaGe floatValue] > 0) {
        self.middleLabel.textColor = STOCK_CONTENT_REDCOLOR;
        self.middleLabel.text = [NSString stringWithFormat:@"+%@%%",model.JiaGe];
    }else if ([model.JiaGe floatValue] == 0){
        self.middleLabel.textColor = STOCK_CONTENT_DEFAULTCOLOR;
        self.middleLabel.text = model.JiaGe;
    }else if ([model.JiaGe floatValue] < 0){
        self.middleLabel.textColor = STOCK_CONTENT_GREENCOLOR;
        self.middleLabel.text = [NSString stringWithFormat:@"%@%%",model.JiaGe];
    }
    self.leftLabel.text = model.ZangBv;
    self.rightLabel.text = [NSString stringWithFormat:@"+%@%%",model.ZangZhi];
}

#pragma mark - 初始化控件操作
-(LLabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [LLabel new];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.textColor = RGB_color(51);
        _nameLabel.font = FONT_9_MEDIUM(16);
        _nameLabel.edgInsets = UIEdgeInsetsMake(20, 0, 0, 0);
    }
    return _nameLabel;
}

-(LLabel *)middleLabel{
    if (!_middleLabel) {
        _middleLabel = [[LLabel alloc] init];
        _middleLabel.textAlignment = NSTextAlignmentCenter;
        _middleLabel.font = FONT_9_BOLD(17);
        _middleLabel.textColor = STOCK_CONTENT_GREENCOLOR;
        _middleLabel.edgInsets = UIEdgeInsetsMake(11, 0, 0, 0);
    }
    return _middleLabel;
}


-(LLabel *)leftLabel{
    if (!_leftLabel) {
        _leftLabel = [[LLabel alloc] init];
        _leftLabel.textAlignment = NSTextAlignmentRight;
        _leftLabel.backgroundColor = [UIColor clearColor];
        _leftLabel.font = FONT_9_REGULAR(11);
        _leftLabel.edgInsets = UIEdgeInsetsMake(10, 0, 10, 0);
        _leftLabel.textColor = RGB_color(153);
    }
    return _leftLabel;
}

-(LLabel *)rightLabel{
    if (!_rightLabel) {
        _rightLabel = [[LLabel alloc] init];
        _rightLabel.textAlignment = NSTextAlignmentLeft;
        _rightLabel.backgroundColor = [UIColor clearColor];
        _rightLabel.font = FONT_9_REGULAR(11);
        _rightLabel.edgInsets = UIEdgeInsetsMake(10, 0, 10, 0);
        _rightLabel.textColor = RGB_color(153);
    }
    return _rightLabel;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
