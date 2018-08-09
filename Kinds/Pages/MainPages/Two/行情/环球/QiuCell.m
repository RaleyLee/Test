//
//  QiuCell.m
//  WBAPP
//
//  Created by hibor on 2018/4/24.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import "QiuCell.h"

@implementation QiuCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.flagImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.flagImageView];
        
        
        self.nameLabel = [[UILabel alloc] init];
        self.nameLabel.textColor = STOCK_CONTENT_DEFAULTCOLOR;
        self.nameLabel.font = FONT_9_MEDIUM(STOCK_CONTENT_NAME_FONT);
        self.nameLabel.textAlignment = NSTextAlignmentLeft;
        self.nameLabel.adjustsFontSizeToFitWidth = YES;
        self.nameLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        self.nameLabel.minimumScaleFactor = STOCK_CONTENT_NAME_MINPERCENT;
        [self.contentView addSubview:self.nameLabel];
        
        
        self.oneLabel = [[UILabel alloc] init];
        self.oneLabel.textColor = STOCK_CONTENT_DEFAULTCOLOR;
        self.oneLabel.font = FONT_9_BOLD(STOCK_CONTENT_MIDDLE_FONT);
        self.oneLabel.textAlignment = NSTextAlignmentRight;
        self.oneLabel.adjustsFontSizeToFitWidth = YES;
        self.oneLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        [self.contentView addSubview:self.oneLabel];
        
        
        self.twoLabel = [[UILabel alloc] init];
        self.twoLabel.textColor = STOCK_CONTENT_DEFAULTCOLOR;
        self.twoLabel.font = FONT_9_BOLD(STOCK_CONTENT_MIDDLE_FONT);
        self.twoLabel.textAlignment = NSTextAlignmentRight;
        self.twoLabel.adjustsFontSizeToFitWidth = YES;
        self.twoLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        [self.contentView addSubview:self.twoLabel];
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.flagImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(MARKET_SPACING);
        make.size.mas_equalTo(CGSizeMake(26, 15));
        make.centerY.mas_equalTo(self.contentView);
    }];
    
    self.flagImageView.hidden = !self.showFlagIcon;
    
    [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        if (!self.showFlagIcon) {
            make.left.mas_equalTo(MARKET_SPACING);
            make.width.mas_equalTo(HBWIDTH_SIDE-MARKET_SPACING);
        }else{
            make.left.equalTo(self.flagImageView.mas_right).offset(5);
            make.width.mas_equalTo(HBWIDTH_SIDE-46);
        }
        make.top.mas_equalTo(5);
        make.bottom.mas_equalTo(-5);
    }];
    
    [self.oneLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(HBWIDTH_SIDE);
        make.top.mas_equalTo(5);
        make.bottom.mas_equalTo(-5);
        make.width.mas_equalTo(HBWIDTH_MIDDLE);
    }];
    
    [self.twoLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-MARKET_SPACING);
        make.top.mas_equalTo(5);
        make.bottom.mas_equalTo(-5);
        make.width.mas_equalTo(HBWIDTH_SIDE-MARKET_SPACING);
    }];
    
   
    
    self.flagImageView.image = [UIImage imageNamed:[self flageNameWithCode:self.model.code name:self.model.name]];
    self.nameLabel.text = self.model.name;
    
    if (self.model.zxj) {
        self.oneLabel.text = self.model.zxj;
    }else{
        self.oneLabel.text = self.model.hbuy;
    }
    
    
    if (self.model.zdf) {
        self.twoLabel.text = self.model.zdf;
    }else{
        self.twoLabel.text = self.model.cbuy;
    }
    if (self.indexPath.section == 4) {
        self.twoLabel.text = [NSString stringWithFormat:@"%.2f",[self.twoLabel.text floatValue]];
        self.twoLabel.textColor = STOCK_CONTENT_DEFAULTCOLOR;
    }else{
        if (self.indexPath.section == 3) {
            self.twoLabel.text = [NSString stringWithFormat:@"%@",self.model.zd];
            if ([self.twoLabel.text floatValue] > 0) {
                self.twoLabel.text = [NSString stringWithFormat:@"+%@",self.twoLabel.text];
                self.twoLabel.textColor = STOCK_CONTENT_REDCOLOR;
            }else if ([self.twoLabel.text floatValue] < 0){
                self.twoLabel.textColor = STOCK_CONTENT_GREENCOLOR;
            }else{
                self.twoLabel.textColor = STOCK_CONTENT_DEFAULTCOLOR;
            }
        }else {
            if ([self.twoLabel.text floatValue] > 0) {
                self.twoLabel.text = [NSString stringWithFormat:@"+%.2f%%",[self.twoLabel.text floatValue]];
                self.twoLabel.textColor = STOCK_CONTENT_REDCOLOR;
            }else if ([self.twoLabel.text floatValue] < 0){
                self.twoLabel.text = [NSString stringWithFormat:@"%.2f%%",[self.twoLabel.text floatValue]];
                self.twoLabel.textColor = STOCK_CONTENT_GREENCOLOR;
            }else{
                self.twoLabel.text = [NSString stringWithFormat:@"%.2f",[self.twoLabel.text floatValue]];
                self.twoLabel.textColor = STOCK_CONTENT_DEFAULTCOLOR;
            }
        }
    }
}

#pragma mark - 根据Code返回国旗
-(NSString *)flageNameWithCode:(NSString *)getCode name:(NSString *)name{
    NSArray *DJI_Array = @[@"DJI",@"DINIW",@"IXIC",@"INX"];
    if ([DJI_Array containsObject:getCode]) {
        return @"DJI";
    }
    NSArray *CL_Array = @[@"CL",@"OIL"];
    if ([CL_Array containsObject:getCode]) {
        return @"CL";
    }
    NSArray *USD_Array = @[@"USD",@"USDCNY"];
    if ([USD_Array containsObject:getCode]) {
        return @"USDCNY";
    }
    if ([getCode isEqualToString:@"CAD"] && [name isEqualToString:@"加拿大元"]) {
        return @"CAD_1";
    }
    return getCode;
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
