//
//  ZHDetailCell.m
//  Kinds
//
//  Created by hibor on 2018/6/22.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import "ZHDetailCell.h"

#define WIDTH (SCREEN_WIDTH/3)

@implementation ZHDetailCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.flagImageView = [[UIImageView alloc] init];
        self.flagImageView.image = [UIImage imageNamed:@"HK"];
        [self.contentView addSubview:self.flagImageView];
        
        self.nameLabel = [[LLabel alloc] init];
        self.nameLabel.textColor = STOCK_CONTENT_NAME_COLOR;
        self.nameLabel.font = FONT_9_MEDIUM(STOCK_CONTENT_NAME_FONT);
        self.nameLabel.textAlignment = NSTextAlignmentLeft;
        self.nameLabel.edgInsets = UIEdgeInsetsMake(10, 0, 0, 0);
        self.nameLabel.adjustsFontSizeToFitWidth = YES;
        self.nameLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        self.nameLabel.minimumScaleFactor = STOCK_CONTENT_NAME_MINPERCENT;
        //        self.nameLabel.minimumFontSize = STOCK_CONTENT_NAME_MINFONT;
        [self.contentView addSubview:self.nameLabel];
        
        self.codeLabel = [[LLabel alloc] init];
        self.codeLabel.textColor = STOCK_CONTENT_CODE_COLOR;
        self.codeLabel.font = FONT_9_REGULAR(STOCK_CONTENT_CODE_FONT);
        self.codeLabel.textAlignment = NSTextAlignmentLeft;
        self.codeLabel.edgInsets = UIEdgeInsetsMake(6, 0, 10, 0);
        [self.contentView addSubview:self.codeLabel];
        
        
        self.priceLabel = [[UILabel alloc] init];
        self.priceLabel.textColor = STOCK_CONTENT_MIDDLE_COLOR;
        self.priceLabel.font = FONT_9_BOLD(STOCK_CONTENT_MIDDLE_FONT);
        self.priceLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.priceLabel];
        
        self.unknownLabel = [[UILabel alloc] init];
        self.unknownLabel.textColor = [UIColor whiteColor];
        self.unknownLabel.font = FONT_9_BOLD(STOCK_CONTENT_MIDDLE_FONT);
        self.unknownLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.unknownLabel];
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.flagImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(11);
        make.left.mas_equalTo(MARKET_SPACING);
        make.size.mas_equalTo(CGSizeMake(15, 11));
    }];
    self.flagImageView.hidden = !self.showIcon;
    
    [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
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
    [self.codeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left);
        make.top.mas_equalTo(self.nameLabel.mas_bottom);
        make.width.equalTo(self.nameLabel.mas_width);
        make.bottom.mas_equalTo(0);
    }];
    [self.priceLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(HBWIDTH_SIDE);
        make.width.mas_equalTo(HBWIDTH_MIDDLE);
        make.centerY.mas_equalTo(self.contentView);
    }];
    [self.unknownLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-MARKET_SPACING);
        make.width.mas_equalTo(HBWIDTH_SIDE-MARKET_SPACING);
        make.centerY.mas_equalTo(self.contentView);
    }];
    self.nameLabel.text = self.model.name;
    self.codeLabel.text = self.model.code.length ? [self.model.code substringFromIndex:2] : @"";
    self.priceLabel.text = self.model.zxj;
    if ([self.model.state isEqualToString:@"S"]) {
        self.unknownLabel.text = @"停牌";
        self.unknownLabel.textColor = STOCK_CONTENT_DEFAULTCOLOR;
    }else{
        if (self.isWaiHui) {
            if ([self.model.zd floatValue] > 0) {
                self.unknownLabel.text = [NSString stringWithFormat:@"+%@",self.model.zd];
                self.unknownLabel.textColor = STOCK_CONTENT_REDCOLOR;
            }else if ([self.model.zdf floatValue] < 0){
                self.unknownLabel.text = [NSString stringWithFormat:@"%@",self.model.zd];
                self.unknownLabel.textColor = STOCK_CONTENT_GREENCOLOR;
            }else{
                self.unknownLabel.text = self.model.zd;
                self.unknownLabel.textColor = STOCK_CONTENT_DEFAULTCOLOR;
            }
        }else{
            if ([self.model.zdf floatValue] > 0) {
                self.unknownLabel.text = [NSString stringWithFormat:@"+%@%%",self.model.zdf];
                self.unknownLabel.textColor = STOCK_CONTENT_REDCOLOR;
            }else if ([self.model.zdf floatValue] < 0){
                self.unknownLabel.text = [NSString stringWithFormat:@"%@%%",self.model.zdf];
                self.unknownLabel.textColor = STOCK_CONTENT_GREENCOLOR;
            }else{
                self.unknownLabel.text = self.model.zdf;
                self.unknownLabel.textColor = STOCK_CONTENT_DEFAULTCOLOR;
            }
        }
        
    }
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
