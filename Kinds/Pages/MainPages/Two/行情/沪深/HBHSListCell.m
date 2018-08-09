//
//  HBHSListCell.m
//  WBAPP
//
//  Created by hibor on 2018/5/2.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import "HBHSListCell.h"


@implementation HBHSListCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = RGB(255, 255, 255);
        
    }
    return self;
}

-(void)setPrice_textAlignment:(NSTextAlignment)price_textAlignment{
    self.priceLabel.textAlignment = price_textAlignment;
}

#pragma mark - LazyLoad

#pragma mark - LazyLoad HK Logo
-(UIImageView *)stockIcon{
    if (!_stockIcon) {
        _stockIcon = [UIImageView new];
        _stockIcon.image = [UIImage imageNamed:@"HK1"];
        [self.contentView addSubview:_stockIcon];
    }
    return _stockIcon;
}
#pragma mark - LazyLoad 股票
-(LLabel *)stockNameLabel{
    if (!_stockNameLabel) {
        _stockNameLabel = [[LLabel alloc] init];
        _stockNameLabel.textColor = STOCK_CONTENT_NAME_COLOR;
        _stockNameLabel.font = FONT_9_MEDIUM(STOCK_CONTENT_NAME_FONT);
        _stockNameLabel.textAlignment = NSTextAlignmentLeft;
        _stockNameLabel.edgInsets = UIEdgeInsetsMake(10, 0, 0, 0);
        _stockNameLabel.adjustsFontSizeToFitWidth = YES;
        _stockNameLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        _stockNameLabel.minimumScaleFactor = STOCK_CONTENT_NAME_MINPERCENT;
        [self.contentView addSubview:_stockNameLabel];
    }
    return _stockNameLabel;
}
#pragma mark - LazyLoad 股票代码
-(LLabel *)StockCodeLabel{
    if (!_StockCodeLabel) {
        _StockCodeLabel = [[LLabel alloc] init];
        _StockCodeLabel.textColor = STOCK_CONTENT_CODE_COLOR;
        _StockCodeLabel.font = FONT_9_REGULAR(STOCK_CONTENT_CODE_FONT);
        _StockCodeLabel.textAlignment = NSTextAlignmentLeft;
        _StockCodeLabel.edgInsets = UIEdgeInsetsMake(6, 0, 10, 0);
        [self.contentView addSubview:_StockCodeLabel];
        
    }
    return _StockCodeLabel;
}
#pragma mark - LazyLoad 最新价
-(LLabel *)priceLabel{
    if (!_priceLabel) {
        _priceLabel = [[LLabel alloc] init];
        _priceLabel.textColor = STOCK_CONTENT_MIDDLE_COLOR;
        _priceLabel.font = FONT_9_BOLD(STOCK_CONTENT_MIDDLE_FONT);
        _priceLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_priceLabel];
    }
    return _priceLabel;
}
#pragma mark - LazyLoad unknownLabel
-(LLabel *)unknownLabel{
    if (!_unknownLabel) {
        _unknownLabel = [[LLabel alloc] init];
        _unknownLabel.textColor = STOCK_CONTENT_DEFAULTCOLOR;
        _unknownLabel.font = FONT_9_BOLD(STOCK_CONTENT_MIDDLE_FONT);
        _unknownLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_unknownLabel];
    }
    return _unknownLabel;
}



-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.stockIcon mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(11);
        make.left.mas_equalTo(MARKET_SPACING);
        make.size.mas_equalTo(CGSizeMake(16, 12));
    }];
    self.stockIcon.hidden = !self.showIcon;
    
    [self.stockNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        if (self.showIcon) {
            make.left.mas_equalTo(32);
            make.width.mas_equalTo(HBWIDTH_SIDE-32);
        }else{
            make.left.mas_equalTo(MARKET_SPACING);
            make.width.mas_equalTo(HBWIDTH_SIDE-MARKET_SPACING);
        }
        make.height.mas_equalTo(25);
    }];
    [self.StockCodeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.stockNameLabel.mas_left);
        make.top.mas_equalTo(self.stockNameLabel.mas_bottom);
        make.width.mas_equalTo(HBWIDTH_SIDE-MARKET_SPACING);
        make.bottom.mas_equalTo(0);
    }];
    [self.priceLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(HBWIDTH_SIDE);
        make.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(HBWIDTH_MIDDLE);
    }];
    [self.unknownLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-MARKET_SPACING);
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(HBWIDTH_SIDE-MARKET_SPACING);
        make.bottom.mas_equalTo(0);
    }];
    
    if (self.model) {
        self.stockNameLabel.text = self.model.name;
        self.StockCodeLabel.text = [self.model.code substringFromIndex:2];
        self.priceLabel.text = self.model.zxj;
        
        
        NSString *unknownValue = @"";
        if ([self.keyString isEqualToString:@"zdf"] || [self.keyString isEqualToString:@"df"]) {
            unknownValue = self.model.zdf;
        }else if ([self.keyString isEqualToString:@"hsl"]) {
            unknownValue = self.model.hsl;
        }else if ([self.keyString isEqualToString:@"zs"]) {
            unknownValue = self.model.zs;
        }else if ([self.keyString isEqualToString:@"zf"]) {
            unknownValue = self.model.zf;
        }else if ([self.keyString isEqualToString:@"lb"]) {
            unknownValue = self.model.lb;
        }
        
        
        if (self.zxj_colorful) {
            //更改zxj的颜色
            if ([self.priceLabel.text floatValue] > 0) {
                self.priceLabel.textColor = STOCK_CONTENT_REDCOLOR;
            }else if ([self.priceLabel.text floatValue] == 0) {
                self.priceLabel.textColor = STOCK_CONTENT_DEFAULTCOLOR;
            }else if ([self.priceLabel.text floatValue] < 0) {
                self.priceLabel.textColor = STOCK_CONTENT_GREENCOLOR;
            }
            self.unknownLabel.textColor = STOCK_CONTENT_DEFAULTCOLOR;
            self.unknownLabel.text = [NSString stringWithFormat:@"%@%%",unknownValue];
            
        }else{
            self.priceLabel.textColor = STOCK_CONTENT_DEFAULTCOLOR;
            
            if ([unknownValue floatValue] > 0) {
                self.unknownLabel.text = [NSString stringWithFormat:@"+%@%%",unknownValue];
                self.unknownLabel.textColor = STOCK_CONTENT_REDCOLOR;
            }else if ([unknownValue floatValue] == 0) {
                self.unknownLabel.text = unknownValue;
                self.unknownLabel.textColor = STOCK_CONTENT_DEFAULTCOLOR;
            }else if ([unknownValue floatValue] < 0) {
                self.unknownLabel.text = [NSString stringWithFormat:@"%@%%",unknownValue];
                self.unknownLabel.textColor = STOCK_CONTENT_GREENCOLOR;
            }
            
        }
    }else if (self.gModel){
        self.stockNameLabel.text = self.gModel.name;
        self.StockCodeLabel.text = [self.gModel.code substringFromIndex:2];
        self.priceLabel.text = self.gModel.zxj;
        if (self.zxj_colorful) {
            
        }else{
            if ([self.gModel.zdf floatValue] > 0) {
                self.unknownLabel.text = [NSString stringWithFormat:@"+%@%%",self.gModel.zdf];
                self.unknownLabel.textColor = STOCK_CONTENT_REDCOLOR;
            }else if ([self.gModel.zdf floatValue] == 0) {
                self.unknownLabel.text = self.gModel.zdf;
                self.unknownLabel.textColor = STOCK_CONTENT_DEFAULTCOLOR;
            }else if ([self.gModel.zdf floatValue] < 0) {
                self.unknownLabel.text = [NSString stringWithFormat:@"%@%%",self.gModel.zdf];
                self.unknownLabel.textColor = STOCK_CONTENT_GREENCOLOR;
            }
        }
    }else if (self.hqModel){
        self.stockNameLabel.text = self.hqModel.name;
        self.StockCodeLabel.text = [self.hqModel.code substringFromIndex:2];
        self.priceLabel.text = self.hqModel.zxj;
        if ([self.hqModel.zdf floatValue] > 0) {
            self.unknownLabel.text = [NSString stringWithFormat:@"+%@%%",self.hqModel.zdf];
            self.unknownLabel.textColor = STOCK_CONTENT_REDCOLOR;
        }else if ([self.hqModel.zdf floatValue] == 0) {
            self.unknownLabel.text = self.hqModel.zdf;
            self.unknownLabel.textColor = STOCK_CONTENT_DEFAULTCOLOR;
        }else if ([self.hqModel.zdf floatValue] < 0) {
            self.unknownLabel.text = [NSString stringWithFormat:@"%@%%",self.hqModel.zdf];
            self.unknownLabel.textColor = STOCK_CONTENT_GREENCOLOR;
        }
    }else if (self.bangModel){
        self.stockNameLabel.text = self.bangModel.name;
        self.priceLabel.text = self.bangModel.zxj;
        self.StockCodeLabel.text = [self.bangModel.code substringFromIndex:2];
        if (self.showCJE) {
            self.unknownLabel.text = [self formatCJEWithString:self.bangModel.cje];
        }else{
            if ([self.bangModel.zdf floatValue] > 0.00) {
                self.unknownLabel.text = [NSString stringWithFormat:@"+%@%%",self.bangModel.zdf];
                self.unknownLabel.textColor = STOCK_CONTENT_REDCOLOR;
            }else if ([self.bangModel.zdf floatValue] < 0.00) {
                self.unknownLabel.text = [NSString stringWithFormat:@"%@%%",self.bangModel.zdf];
                self.unknownLabel.textColor = STOCK_CONTENT_GREENCOLOR;
            }else if ([self.bangModel.zdf floatValue] == 0.00) {
                self.unknownLabel.text = self.bangModel.zdf;
                self.unknownLabel.textColor = STOCK_CONTENT_DEFAULTCOLOR;
            }
        }
    }
    
}




-(NSString *)formatCJEWithString:(NSString *)string{
    float value = [string floatValue];
    if (value > 100000000) {
        NSMutableString *string = [NSMutableString stringWithString:[NSString stringWithFormat:@"%.2f亿",value/100000000]];
        return [string stringByReplacingOccurrencesOfString:@".00" withString:@""];
    }else if (value > 10000) {
        NSMutableString *string = [NSMutableString stringWithString:[NSString stringWithFormat:@"%.2f万",value/10000]];
        return [string stringByReplacingOccurrencesOfString:@".00" withString:@""];
    }
    return [NSString stringWithFormat:@"%.0f",value];
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
