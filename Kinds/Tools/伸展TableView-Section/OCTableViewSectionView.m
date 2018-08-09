//
//  OCTableViewSectionView.m
//  TT
//
//  Created by hibor on 2018/4/3.
//  Copyright © 2018年 hibor. All rights reserved.
//


#import "OCTableViewSectionView.h"

@interface OCTableViewSectionView(){
    
}

@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic,strong)UIButton *moreButton;


@end
@implementation OCTableViewSectionView


-(void)setHiddenMoreButton:(BOOL)hiddenMoreButton{
    self.moreButton.hidden = hiddenMoreButton;
}

/**
 *  重写MGHeaderView的init方法，添加控件
 */
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        self.imageView = [[UIImageView alloc] init];
        self.imageView.contentMode = UIViewContentModeCenter;
        [self.contentView addSubview:self.imageView];
        
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.textColor = STOCK_ZDSECTION_TITLECOLOR;
        self.titleLabel.font = FONT_9_MEDIUM(STOCK_ZDSECTION_TITLEFONTSIZE);
        [self.contentView addSubview:self.titleLabel];
        
        
        
        self.moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.moreButton setImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal];
        self.moreButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 15);
        self.moreButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [self.moreButton addTarget:self action:@selector(moreButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.moreButton];
        
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerViewTap)];
        [self addGestureRecognizer:tap];
    }
    
    return self;
}


-(void)setContentBGColor:(UIColor *)contentBGColor{
    self.contentView.backgroundColor = contentBGColor;
}
-(void)moreButtonAction:(UIButton *)sender{
    if (self.headerMoreClick) {
        self.headerMoreClick(sender.tag);
    }
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.backgroundView.backgroundColor = [UIColor whiteColor];
    

    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(33);
        make.width.mas_equalTo(200);
        make.centerY.equalTo(self.contentView);
    }];
    
    if (!self.hiddenMoreButton) {
        [self.moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(0);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(30);
            make.centerY.equalTo(self.contentView);
        }];
    }
    
}
-(void)setSectionTag:(NSInteger)sectionTag{
    _sectionTag = sectionTag;
    self.moreButton.tag = sectionTag;
}
-(void)setModel:(OCTableModel *)model{
    _model = model;
    self.titleLabel.text = model.headTitle;
    self.imageView.image = !self.model.opened ? [UIImage imageNamed:@"UpAccessory-1"] : [UIImage imageNamed:@"DownAccessory-1"];
    if (self.hiddenMoreButton) {
        self.moreButton.hidden = YES;
    }else{
        self.moreButton.hidden = !self.model.opened;
    }
    
}

/**
 *  点击了组的头部
 */
- (void)headerViewTap
{
    self.model.opened = !self.model.opened;
    // 刷新表格
    !self.headerSectionClick ? : self.headerSectionClick();
}

@end

