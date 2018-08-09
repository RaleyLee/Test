//
//  OCTableViewHeaderView.m
//  HangQingNew
//
//  Created by hibor on 2018/5/24.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import "OCTableViewHeaderView.h"

@interface OCTableViewHeaderView()<UIScrollViewDelegate,UIGestureRecognizerDelegate>

@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic,strong)UIButton *moreButton;

@property(nonatomic,strong)UIScrollView *detailScrollView;
@property(nonatomic,strong)NSArray *scrollTitleArray;

@end

@implementation OCTableViewHeaderView


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
        
        
        self.detailScrollView = [[UIScrollView alloc] init];
        self.detailScrollView.delegate = self;
        self.detailScrollView.showsVerticalScrollIndicator = NO;
        self.detailScrollView.showsHorizontalScrollIndicator = NO;
        self.detailScrollView.tag = 10000;
        self.detailScrollView.backgroundColor = RGB_color(244);
        self.scrollTitleArray = @[
                                  @{@"title":@"涨幅榜",@"detailTitle":@"涨幅",@"requestURL":HS_HOME_ZDF_URL},
                                  @{@"title":@"跌幅榜",@"detailTitle":@"跌幅",@"requestURL":HS_HOME_DF_URL},
                                  @{@"title":@"换手榜",@"detailTitle":@"换手率",@"requestURL":HS_HOME_HSL_URL},
                                  @{@"title":@"涨速榜",@"detailTitle":@"5分钟涨速",@"requestURL":HS_HOME_ZS_URL},
                                  @{@"title":@"振幅榜",@"detailTitle":@"振幅",@"requestURL":HS_HOME_ZF_URL},
                                  @{@"title":@"量比榜",@"detailTitle":@"量比",@"requestURL":HS_HOME_LB_URL}
                                  ];
        for (int i = 0; i < self.scrollTitleArray.count; i++) {
            NSDictionary *dict = self.scrollTitleArray[i];
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:dict[@"title"] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:15];
            [button setTitleColor:RGB_color(51) forState:UIControlStateNormal];
            if (i == self.selectedIndex) {
                [button setTitleColor:STOCK_CONTENT_REDCOLOR forState:UIControlStateNormal];
            }
            [button setFrame:CGRectMake(90*i, 0, 90, 40)];
            if (i == 0) {
                button.titleEdgeInsets = UIEdgeInsetsMake(0, MARKET_SPACING, 0, 0);
                button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            }
            if (i == self.scrollTitleArray.count-1) {
                button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, MARKET_SPACING);
                button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            }
            button.tag = 500+i;
            [button addTarget:self action:@selector(changeBangAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.detailScrollView addSubview:button];
        }
        self.detailScrollView.contentSize = CGSizeMake(90*self.scrollTitleArray.count, 40);
        [self addSubview:self.detailScrollView];
        
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerViewTap)];
        [self addGestureRecognizer:tap];
        
    }
    
    return self;
}

-(void)setShowDetailView:(BOOL)showDetailView{
    self.detailScrollView.hidden = !showDetailView;
}

-(void)setSelectedIndex:(NSInteger)selectedIndex{
    for (int i = 0; i < self.scrollTitleArray.count; i++) {
        UIButton *button = (UIButton *)[self viewWithTag:500+i];
        [button setTitleColor:RGB_color(51) forState:UIControlStateNormal];
        if (i == selectedIndex) {
            [button setTitleColor:STOCK_CONTENT_REDCOLOR forState:UIControlStateNormal];
        }
    }
}
-(void)changeBangAction:(UIButton *)sender{
    NSInteger index = sender.tag - 500;
    NSDictionary *diction = self.scrollTitleArray[index];
    if (self.headerClickDetailBangButton) {
        self.headerClickDetailBangButton(diction,index);
    }
//    [sender setTitleColor:STOCK_CONTENT_REDCOLOR forState:UIControlStateNormal];
}
-(void)setHqDetail:(BOOL)hqDetail{
    _hqDetail = hqDetail;
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
        if (self.hqDetail) {
            make.centerY.mas_equalTo(self.contentView);
        }else{
            make.top.mas_equalTo(12);
        }
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(33);
        if (self.hqDetail) {
            make.size.mas_equalTo(CGSizeMake(200, 35));
        }else{
            make.size.mas_equalTo(CGSizeMake(200, 45));
        }
        make.top.mas_equalTo(0);
    }];
    
    if (!self.hiddenMoreButton) {
        [self.moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(0);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(30);
            make.top.mas_equalTo(7);
        }];
    }
    
    [self.detailScrollView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(45);
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 40));
    }];
//    [UIView setBorderWithView:self.detailScrollView top:NO left:NO bottom:YES right:NO borderColor:SECTION_UNDERLINE_COLOR borderWidth:self.detailScrollView.frame.size.width borderHeight:0.5];

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
