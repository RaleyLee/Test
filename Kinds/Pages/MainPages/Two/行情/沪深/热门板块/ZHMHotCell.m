//
//  ZHMHotCell.m
//  Kinds
//
//  Created by hibor on 2018/6/22.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import "ZHMHotCell.h"

@implementation ZHMHotCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.nameLabel = [[UILabel alloc] init];
        self.nameLabel.textColor = STOCK_CONTENT_NAME_COLOR;
        self.nameLabel.font = FONT_9_MEDIUM(STOCK_CONTENT_NAME_FONT);
        self.nameLabel.textAlignment = NSTextAlignmentLeft;
        self.nameLabel.adjustsFontSizeToFitWidth = YES;
        self.nameLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        self.nameLabel.minimumScaleFactor = STOCK_CONTENT_NAME_MINPERCENT;
        //        self.nameLabel.minimumFontSize = STOCK_CONTENT_NAME_MINFONT;
        [self.contentView addSubview:self.nameLabel];
        
        
        
        self.zdfLabel = [[UILabel alloc] init];
        self.zdfLabel.textColor = [UIColor whiteColor];
        self.zdfLabel.font = FONT_9_BOLD(STOCK_CONTENT_MIDDLE_FONT);
        self.zdfLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.zdfLabel];
        
        
        self.gnLabel = [[UILabel alloc] init];
        self.gnLabel.textColor = STOCK_CONTENT_NAME_COLOR;
        self.gnLabel.font = FONT_9_MEDIUM(STOCK_CONTENT_NAME_FONT);
        self.gnLabel.textAlignment = NSTextAlignmentRight;
        self.gnLabel.adjustsFontSizeToFitWidth = YES;
        self.gnLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        self.nameLabel.minimumScaleFactor = STOCK_CONTENT_NAME_MINPERCENT;
        //        self.gnLabel.minimumFontSize = STOCK_CONTENT_NAME_MINFONT;
        [self.contentView addSubview:self.gnLabel];
        
    }
    return self;
}


-(void)layoutSubviews{
    [super layoutSubviews];
    [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(MARKET_SPACING);
        make.width.mas_equalTo(HBWIDTH_SIDE-MARKET_SPACING);
        make.bottom.mas_equalTo(0);
    }];
    
    [self.zdfLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(HBWIDTH_SIDE);
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(HBWIDTH_MIDDLE);
        make.bottom.mas_equalTo(0);
    }];
    [self.gnLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-MARKET_SPACING);
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(HBWIDTH_SIDE-MARKET_SPACING);
        make.bottom.mas_equalTo(0);
    }];
    
    self.nameLabel.text = self.model.bd_name;
    self.gnLabel.text = self.model.nzg_name;
    
    if ([self.model.bd_zdf floatValue] > 0.00) {
        self.zdfLabel.text = [NSString stringWithFormat:@"+%@%%",self.model.bd_zdf];
        self.zdfLabel.textColor = STOCK_CONTENT_REDCOLOR;
    }else if ([self.model.bd_zdf floatValue] < 0.00) {
        self.zdfLabel.text = [NSString stringWithFormat:@"%@%%",self.model.bd_zdf];
        self.zdfLabel.textColor = STOCK_CONTENT_GREENCOLOR;
    }else if ([self.model.bd_zdf floatValue] == 0.00) {
        self.zdfLabel.text = self.model.bd_zdf;
        self.zdfLabel.textColor = STOCK_CONTENT_DEFAULTCOLOR;
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
