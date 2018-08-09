//
//  MyMusicHeaderView.m
//  Kinds
//
//  Created by hibor on 2018/7/11.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import "MyMusicHeaderView.h"

@interface MyMusicHeaderView()

@property(nonatomic,strong)UIImageView *headImageView;
@property(nonatomic,strong)UILabel *nickNameLabel;
@property(nonatomic,strong)UIImageView *vipImageView;

@property(nonatomic,strong)UIImageView *leftIconImageView;
@property(nonatomic,strong)UILabel *leftNameLabel;
@property(nonatomic,strong)UILabel *leftContentLabel;

@property(nonatomic,strong)UIView *sepatorView;

@property(nonatomic,strong)UIImageView *rightIconImageView;
@property(nonatomic,strong)UILabel *rightNameLabel;
@property(nonatomic,strong)UILabel *rightContentLabel;

@end

@implementation MyMusicHeaderView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = RGB(43, 63, 83);
        
        [self addSubview:self.nickNameLabel];
        [self.nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(20);
            make.centerX.equalTo(self);
        }];
        
        [self addSubview:self.headImageView];
        [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.nickNameLabel.mas_left).offset(-5);
            make.centerY.equalTo(self.nickNameLabel);
            make.size.mas_equalTo(CGSizeMake(35, 35));
        }];
        
        [self addSubview:self.vipImageView];
        [self.vipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nickNameLabel.mas_right).offset(5);
            make.centerY.equalTo(self.nickNameLabel);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
        
        [self addSubview:self.sepatorView];
        [self.sepatorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self.headImageView.mas_bottom).offset(30);
            make.size.mas_equalTo(CGSizeMake(1, 20));
        }];
        
        
        [self addSubview:self.leftNameLabel];
        [self.leftNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo((frame.size.width/2-(5+20))/2);
            make.top.equalTo(self.headImageView.mas_bottom).offset(20);
        }];
        
        [self addSubview:self.leftIconImageView];
        [self.leftIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.leftNameLabel.mas_left).offset(-5);
            make.centerY.equalTo(self.leftNameLabel);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
        
        [self addSubview:self.leftContentLabel];
        [self.leftContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.leftIconImageView.mas_bottom).offset(5);
            make.left.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH/2, 20));
        }];
        
        [self addSubview:self.rightNameLabel];
        [self.rightNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-(frame.size.width/2-(48+20+5))/2);
            make.top.equalTo(self.headImageView.mas_bottom).offset(20);
        }];
        
        [self addSubview:self.rightIconImageView];
        [self.rightIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.rightNameLabel.mas_left).offset(-5);
            make.centerY.equalTo(self.rightNameLabel);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
        
        [self addSubview:self.rightContentLabel];
        [self.rightContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.rightIconImageView.mas_bottom).offset(5);
            make.right.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH/2, 20));
        }];
        
    }
    return self;
}

-(UIImageView *)headImageView{
    if (!_headImageView) {
        _headImageView = [UIImageView new];
        _headImageView.backgroundColor = [UIColor redColor];
        _headImageView.layer.cornerRadius = 17.5;
        _headImageView.layer.masksToBounds = YES;
    }
    return _headImageView;
}
-(UILabel *)nickNameLabel{
    if (!_nickNameLabel) {
        _nickNameLabel = [UILabel new];
        _nickNameLabel.text = @"泛滥的小青春";
        _nickNameLabel.textColor = [UIColor whiteColor];
        _nickNameLabel.font = FONT_9_REGULAR(15);
        [_nickNameLabel sizeToFit];
    }
    return _nickNameLabel;
}
-(UIImageView *)vipImageView{
    if (!_vipImageView) {
        _vipImageView = [UIImageView new];
        _vipImageView.backgroundColor = [UIColor redColor];
    }
    return _vipImageView;
}
-(UIImageView *)leftIconImageView{
    if (!_leftIconImageView) {
        _leftIconImageView = [UIImageView new];
        _leftIconImageView.backgroundColor = [UIColor redColor];
    }
    return _leftIconImageView;
}
-(UILabel *)leftNameLabel{
    if (!_leftNameLabel) {
        _leftNameLabel = [UILabel new];
        _leftNameLabel.textColor = [UIColor whiteColor];
        _leftNameLabel.font = FONT_9_REGULAR(12);
        _leftNameLabel.text = @"活动中心";
        [_leftNameLabel sizeToFit];
    }
    return _leftNameLabel;
}
-(UILabel *)leftContentLabel{
    if (!_leftContentLabel) {
        _leftContentLabel = [UILabel new];
        _leftContentLabel.textColor = [UIColor whiteColor];
        _leftContentLabel.font = FONT_9_REGULAR(10);
        _leftContentLabel.text = @"今日听歌0分钟";
        _leftContentLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _leftContentLabel;
}
-(UIView *)sepatorView{
    if (!_sepatorView) {
        _sepatorView = [UIView new];
        _sepatorView.backgroundColor = [UIColor whiteColor];
    }
    return _sepatorView;
}
-(UIImageView *)rightIconImageView{
    if (!_rightIconImageView) {
        _rightIconImageView = [UIImageView new];
        _rightIconImageView.backgroundColor = [UIColor redColor];
    }
    return _rightIconImageView;
}
-(UILabel *)rightNameLabel{
    if (!_rightNameLabel) {
        _rightNameLabel = [UILabel new];
        _rightNameLabel.textColor = [UIColor whiteColor];
        _rightNameLabel.font = FONT_9_REGULAR(12);
        _rightNameLabel.text = @"会员中心";
        [_rightNameLabel sizeToFit];
    }
    return _rightNameLabel;
}
-(UILabel *)rightContentLabel{
    if (!_rightContentLabel) {
        _rightContentLabel = [UILabel new];
        _rightContentLabel.textColor = [UIColor whiteColor];
        _rightContentLabel.font = FONT_9_REGULAR(10);
        _rightContentLabel.text = @"豪华绿钻独享DTS音效";
        _rightContentLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _rightContentLabel;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
