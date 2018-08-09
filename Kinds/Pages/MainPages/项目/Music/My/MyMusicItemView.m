//
//  MyMusicItemView.m
//  Kinds
//
//  Created by hibor on 2018/7/11.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import "MyMusicItemView.h"

@interface MyMusicItemView()

@property(nonatomic,strong)UIImageView *iconImageView;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *numberLabel;

@end

@implementation MyMusicItemView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = RGB(49, 65, 80);
        
        [self addSubview:self.iconImageView];
        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.mas_equalTo(10);
            make.size.mas_equalTo(CGSizeMake(30, 30));
        }];
        
        [self addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.equalTo(self.iconImageView.mas_bottom).offset(10);
            make.height.mas_equalTo(20);
        }];
        
        [self addSubview:self.numberLabel];
        [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
            make.height.mas_equalTo(10);
        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickItemAction:)];
        [self addGestureRecognizer:tap];
        
    }
    return self;
}

-(void)setItemTag:(NSInteger)itemTag{
    self.tag = itemTag;
}

-(void)clickItemAction:(UIGestureRecognizer *)gesture{
    if (self.clickItemBlock) {
        self.clickItemBlock(gesture.view.tag);
    }
}

-(UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [UIImageView new];
        _iconImageView.backgroundColor = [UIColor cyanColor];
    }
    return _iconImageView;
}
-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.font = FONT_9_REGULAR(16);
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.textColor = [UIColor whiteColor];
    }
    return _nameLabel;
}
-(UILabel *)numberLabel{
    if (!_numberLabel) {
        _numberLabel = [UILabel new];
        _numberLabel.font = FONT_9_REGULAR(13);
        _numberLabel.textAlignment = NSTextAlignmentCenter;
        _numberLabel.textColor = RGB(166, 172, 177);
    }
    return _numberLabel;
}

-(void)setDiction:(NSDictionary *)diction{
    if ([diction[@"iconName"] length]) {
        _iconImageView.image = [UIImage imageNamed:diction[@"iconName"]];
    }
    
    _nameLabel.text = diction[@"iconTitle"];
    _numberLabel.text = diction[@"iconNumber"];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
