
//
//  HBMarketItemView.m
//  StockMarket
//
//  Created by hibor on 2018/5/18.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import "HBMarketItemView.h"

@interface HBMarketItemView (){
    
}
@property(nonatomic,strong)LLabel *nameLabel;
@property(nonatomic,strong)LLabel *middleLabel;
@property(nonatomic,strong)LLabel *detailLabel;
@property(nonatomic,strong)LLabel *leftLabel,*rightLabel;

@property(nonatomic,assign)MarketItemType itemType;

@property(nonatomic,strong)HBItemModel *tempItemModel;
@property(nonatomic,strong)HBListModel *tempListModel;
@property(nonatomic,strong)GangTModel *tempGTModel;

@end

@implementation HBMarketItemView

-(instancetype)initWithFrame:(CGRect)frame withItemType:(MarketItemType)type{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.itemType = type;
        
        [self addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(0);
            if (type == MarketItemTypeTop) {
                make.height.mas_equalTo(35);
            }else{
                make.height.mas_equalTo(24);
            }
        }];
        
        [self addSubview:self.middleLabel];
        [self.middleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.equalTo(self.nameLabel.mas_bottom);
            if (type == MarketItemTypeTop) {
                make.height.mas_equalTo(25);
            }else{
                make.height.mas_equalTo(20);
            }
        }];
        
        if (type == MarketItemTypeMiddle) {
            [self addSubview:self.detailLabel];
            [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(0);
                make.top.equalTo(self.middleLabel.mas_bottom);
                make.height.mas_equalTo(16);
            }];
        }
        
        
        CGFloat padding = (type == MarketItemTypeTop) ? 7.0f : 10.0f;
        [self addSubview:self.leftLabel];
        [self addSubview:self.rightLabel];
        [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(padding);
            make.height.mas_equalTo(25);
            if (type == MarketItemTypeMiddle) {
                make.right.equalTo(self.rightLabel.mas_left).offset(-7);
                make.top.equalTo(self.detailLabel.mas_bottom);
            }else{
                make.right.equalTo(self.rightLabel.mas_left).offset(-8);
                make.top.equalTo(self.middleLabel.mas_bottom);
            }
            make.width.equalTo(self.rightLabel.mas_width);
        }];
        
        [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-padding);
            make.height.equalTo(self.leftLabel.mas_height);
            if (type == MarketItemTypeMiddle) {
                make.top.equalTo(self.detailLabel.mas_bottom);
            }else{
                make.top.equalTo(self.middleLabel.mas_bottom);
            }
        }];
        
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

#pragma mark - 点击 Item 的手势回调
-(void)click:(UIGestureRecognizer *)gesture{
    if (self.clickItemBlock) {
        if (self.tempGTModel) {
            self.clickItemBlock(self.tempGTModel);
        }else if (self.tempItemModel){
            self.clickItemBlock(self.tempItemModel);
        }else if (self.tempListModel){
            self.clickItemBlock(self.tempListModel);
        }
    }
}


-(void)layoutSubviews{
    [super layoutSubviews];
}

#pragma mark 赋值操作
-(void)setItemModel:(HBItemModel *)itemModel{
    
    self.tempItemModel = itemModel;
    
    self.nameLabel.text = itemModel.bd_name;
    if ([itemModel.bd_zdf floatValue] > 0) {
        self.middleLabel.textColor = STOCK_CONTENT_REDCOLOR;
        self.middleLabel.text = [NSString stringWithFormat:@"+%@%%",itemModel.bd_zdf];
    }else if ([itemModel.bd_zdf floatValue] == 0){
        self.middleLabel.textColor = STOCK_CONTENT_DEFAULTCOLOR;
        self.middleLabel.text = itemModel.bd_zdf;
    }else if ([itemModel.bd_zdf floatValue] < 0){
        self.middleLabel.textColor = STOCK_CONTENT_GREENCOLOR;
        self.middleLabel.text = [NSString stringWithFormat:@"%@%%",itemModel.bd_zdf];
    }
    self.detailLabel.text = itemModel.nzg_name;
    self.leftLabel.text = itemModel.nzg_zxj;
    self.rightLabel.text = [NSString stringWithFormat:@"+%@%%",itemModel.nzg_zdf];
}

-(void)setGTModel:(GangTModel *)gTModel{
    
    self.tempGTModel = gTModel;
    
    self.nameLabel.text = gTModel.bd_name;
    if ([gTModel.bd_zdf floatValue] > 0) {
        self.middleLabel.textColor = STOCK_CONTENT_REDCOLOR;
        self.middleLabel.text = [NSString stringWithFormat:@"+%@%%",gTModel.bd_zdf];
    }else if ([gTModel.bd_zdf floatValue] == 0){
        self.middleLabel.textColor = STOCK_CONTENT_DEFAULTCOLOR;
        self.middleLabel.text = gTModel.bd_zdf;
    }else if ([gTModel.bd_zdf floatValue] < 0){
        self.middleLabel.textColor = STOCK_CONTENT_GREENCOLOR;
        self.middleLabel.text = [NSString stringWithFormat:@"%@%%",gTModel.bd_zdf];
    }
    self.detailLabel.text = gTModel.nzg_name;
    self.leftLabel.text = gTModel.nzg_zxj;
    self.rightLabel.text = [NSString stringWithFormat:@"+%@%%",gTModel.nzg_zdf];
}

-(void)setListModel:(HBListModel *)listModel{
    
    self.tempListModel = listModel;
    
    self.nameLabel.text = listModel.name;
    self.middleLabel.text = listModel.zxj;
    if ([listModel.zd floatValue] < 0.0 || [listModel.zdf floatValue] < 0.0) {
        self.middleLabel.textColor = STOCK_CONTENT_GREENCOLOR;
    }else if ([self.listModel.zd floatValue] > 0.0 || [listModel.zdf floatValue] > 0.0){
        self.middleLabel.textColor = STOCK_CONTENT_REDCOLOR;
    }
    self.leftLabel.text = [NSString stringWithFormat:@"%@",listModel.zd];
    self.rightLabel.text = [NSString stringWithFormat:@"%@%%",listModel.zdf];
    
}

#pragma mark - 初始化控件操作
-(LLabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [LLabel new];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.textColor = RGB_color(51);
        if (self.itemType == MarketItemTypeTop) {
            _nameLabel.font = FONT_9_MEDIUM(16);
            _nameLabel.edgInsets = UIEdgeInsetsMake(20, 0, 0, 0);
        }else{
            _nameLabel.font = FONT_9_MEDIUM(14);
            _nameLabel.edgInsets = UIEdgeInsetsMake(10, 0, 0, 0);
        }
    }
    return _nameLabel;
}

-(LLabel *)middleLabel{
    if (!_middleLabel) {
        _middleLabel = [[LLabel alloc] init];
        _middleLabel.textAlignment = NSTextAlignmentCenter;
        _middleLabel.font = FONT_9_BOLD(17);
        if (self.itemType == MarketItemTypeTop) {
            _middleLabel.textColor = STOCK_CONTENT_GREENCOLOR;
            _middleLabel.edgInsets = UIEdgeInsetsMake(11, 0, 0, 0);
        }else{
            _middleLabel.textColor = STOCK_CONTENT_REDCOLOR;
            _middleLabel.edgInsets = UIEdgeInsetsMake(7, 0, 0, 0);
        }
    }
    return _middleLabel;
}

-(LLabel *)detailLabel{
    if (!_detailLabel) {
        _detailLabel = [[LLabel alloc] init];
        _detailLabel.textAlignment = NSTextAlignmentCenter;
        _detailLabel.font = FONT_9_REGULAR(10);
        _detailLabel.textColor = RGB_color(0);
        _detailLabel.edgInsets = UIEdgeInsetsMake(7, 0, 0, 0);
    }
    return _detailLabel;
}

-(LLabel *)leftLabel{
    if (!_leftLabel) {
        _leftLabel = [[LLabel alloc] init];
        _leftLabel.textAlignment = NSTextAlignmentRight;
        _leftLabel.backgroundColor = [UIColor clearColor];
        if (self.itemType == MarketItemTypeTop) {
            _leftLabel.font = FONT_9_REGULAR(11);
            _leftLabel.edgInsets = UIEdgeInsetsMake(10, 0, 10, 0);
        }else{
            _leftLabel.font = FONT_9_REGULAR(10);
            _leftLabel.edgInsets = UIEdgeInsetsMake(7, 0, 10, 0);
        }
        _leftLabel.textColor = RGB_color(153);
    }
    return _leftLabel;
}

-(LLabel *)rightLabel{
    if (!_rightLabel) {
        _rightLabel = [[LLabel alloc] init];
        _rightLabel.textAlignment = NSTextAlignmentLeft;
        _rightLabel.backgroundColor = [UIColor clearColor];
        if (self.itemType == MarketItemTypeTop) {
            _rightLabel.font = FONT_9_REGULAR(11);
            _rightLabel.edgInsets = UIEdgeInsetsMake(10, 0, 10, 0);
        }else{
            _rightLabel.font = FONT_9_REGULAR(10);
            _rightLabel.edgInsets = UIEdgeInsetsMake(7, 0, 10, 0);
        }
        _rightLabel.textColor = RGB_color(153);
    }
    return _rightLabel;
}

@end
