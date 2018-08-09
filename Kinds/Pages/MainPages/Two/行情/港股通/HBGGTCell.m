//
//  HBGGTCell.m
//  WBAPP
//
//  Created by hibor on 2018/5/4.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import "HBGGTCell.h"

#define WIDTH (SCREEN_WIDTH/4)

@implementation HBGGTCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.nameLabel = [[LLabel alloc] init];
        self.nameLabel.textColor = RGB_color(51);
        self.nameLabel.font = FONT_9_MEDIUM(15);
        self.nameLabel.textAlignment = NSTextAlignmentLeft;
        self.nameLabel.adjustsFontSizeToFitWidth = YES;
        self.nameLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        self.nameLabel.minimumScaleFactor = STOCK_CONTENT_NAME_MINPERCENT;
//        self.nameLabel.minimumFontSize = STOCK_CONTENT_NAME_MINFONT;
        [self.contentView addSubview:self.nameLabel];
        
        
        self.htLabel = [[LLabel alloc] init];
        self.htLabel.textColor = STOCK_CONTENT_NAME_COLOR;
        self.htLabel.font = FONT_9_BOLD(15);
        self.htLabel.textAlignment = NSTextAlignmentRight;
        self.htLabel.adjustsFontSizeToFitWidth = YES;
        self.htLabel.edgInsets = UIEdgeInsetsMake(10, 0, 0, 0);
        self.htLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        [self.contentView addSubview:self.htLabel];
        
        self.hbLabel = [[LLabel alloc] init];
        self.hbLabel.textColor = RGB_color(153);
        self.hbLabel.font = FONT_9_REGULAR(10);
        self.hbLabel.textAlignment = NSTextAlignmentRight;
        self.hbLabel.adjustsFontSizeToFitWidth = YES;
        self.hbLabel.edgInsets = UIEdgeInsetsMake(6, 0, 10, 0);
        self.hbLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        [self.contentView addSubview:self.hbLabel];
        
        self.atLabel = [[LLabel alloc] init];
        self.atLabel.textColor = STOCK_CONTENT_NAME_COLOR;
        self.atLabel.font = FONT_9_BOLD(15);
        self.atLabel.textAlignment = NSTextAlignmentRight;
        self.atLabel.adjustsFontSizeToFitWidth = YES;
        self.atLabel.edgInsets = UIEdgeInsetsMake(10, 0, 0, 0);
        self.atLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        [self.contentView addSubview:self.atLabel];
        
        self.abLabel = [[LLabel alloc] init];
        self.abLabel.textColor = RGB_color(153);
        self.abLabel.font = FONT_9_REGULAR(10);
        self.abLabel.textAlignment = NSTextAlignmentRight;
        self.abLabel.adjustsFontSizeToFitWidth = YES;
        self.abLabel.edgInsets = UIEdgeInsetsMake(6, 0, 10, 0);
        self.abLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        [self.contentView addSubview:self.abLabel];
        
        self.priceLabel = [[LLabel alloc] init];
        self.priceLabel.textColor = RGB_color(51);
        self.priceLabel.font = FONT_9_BOLD(15);
        self.priceLabel.textAlignment = NSTextAlignmentRight;
        self.priceLabel.adjustsFontSizeToFitWidth = YES;
        self.priceLabel.edgInsets = UIEdgeInsetsMake(0, 0, 0, 15);
        self.priceLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        [self.contentView addSubview:self.priceLabel];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(MARKET_SPACING);
        make.width.mas_equalTo(WIDTH-MARKET_SPACING);
        make.bottom.mas_equalTo(0);
    }];
    
    [self.htLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(WIDTH);
        make.width.mas_equalTo(WIDTH);
        make.height.mas_equalTo(25);
    }];
    [self.hbLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.htLabel.mas_bottom);
        make.left.mas_equalTo(WIDTH);
        make.width.mas_equalTo(WIDTH);
        make.bottom.mas_equalTo(0);
    }];
    
    [self.atLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(WIDTH*2);
        make.width.mas_equalTo(WIDTH);
        make.height.mas_equalTo(25);
    }];
    [self.abLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.atLabel.mas_bottom);
        make.left.mas_equalTo(WIDTH*2);
        make.width.mas_equalTo(WIDTH);
        make.bottom.mas_equalTo(0);
    }];
    [self.priceLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.width.mas_equalTo(WIDTH);
        make.bottom.mas_equalTo(0);
    }];
    
    self.nameLabel.text = self.model.hname;
    self.htLabel.text = self.model.hzxj;
    if ([self.model.hzdf floatValue] > 0) {
        self.hbLabel.text = [NSString stringWithFormat:@"+%@%%",self.model.hzdf];
        self.htLabel.textColor = STOCK_CONTENT_REDCOLOR;
    }else if ([self.model.hzdf floatValue] < 0){
        self.hbLabel.text = [NSString stringWithFormat:@"%@%%",self.model.hzdf];
        self.htLabel.textColor = STOCK_CONTENT_GREENCOLOR;
    }else{
        self.hbLabel.text = [NSString stringWithFormat:@"%@%%",self.model.hzdf];
        self.htLabel.textColor = STOCK_CONTENT_NAME_COLOR;
    }
    self.atLabel.text = self.model.azxj;
    self.abLabel.text = self.model.azdf;
    if ([self.model.azdf floatValue] > 0) {
        self.abLabel.text = [NSString stringWithFormat:@"+%@%%",self.model.azdf];
        self.atLabel.textColor = STOCK_CONTENT_REDCOLOR;
    }else if ([self.model.azdf floatValue] < 0){
        self.abLabel.text = [NSString stringWithFormat:@"%@%%",self.model.azdf];
        self.atLabel.textColor = STOCK_CONTENT_GREENCOLOR;
    }else{
        self.abLabel.text = [NSString stringWithFormat:@"%@%%",self.model.azdf];
        self.atLabel.textColor = STOCK_CONTENT_NAME_COLOR;
    }
    self.priceLabel.text = [self.model.hayj stringByAppendingString:@"%"];
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
