//
//  HBGGTCell2.m
//  WBAPP
//
//  Created by hibor on 2018/5/4.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import "HBGGTCell2.h"


@implementation HBGGTCell2

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.stockImageView = [[UIImageView alloc] init];
        self.stockImageView.image = [UIImage imageNamed:@"HK"];
        [self.contentView addSubview:self.stockImageView];
        
        self.nameLabel = [[LLabel alloc] init];
        self.nameLabel.textColor = RGB_color(51);
        self.nameLabel.font = FONT_9_MEDIUM(15);
        self.nameLabel.textAlignment = NSTextAlignmentLeft;
        self.nameLabel.adjustsFontSizeToFitWidth = YES;
        self.nameLabel.edgInsets = UIEdgeInsetsMake(10, 0, 0, 0);
        self.nameLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        self.nameLabel.minimumScaleFactor = STOCK_CONTENT_NAME_MINPERCENT;
        [self.contentView addSubview:self.nameLabel];
        
        self.codeLabel = [[LLabel alloc] init];
        self.codeLabel.textColor = STOCK_CONTENT_CODE_COLOR;
        self.codeLabel.font = FONT_9_REGULAR(STOCK_CONTENT_CODE_FONT);
        self.codeLabel.textAlignment = NSTextAlignmentLeft;
        self.codeLabel.edgInsets = UIEdgeInsetsMake(6, 0, 10, 0);
        [self.contentView addSubview:self.codeLabel];
        
        
        self.zxjLabel = [[LLabel alloc] init];
        self.zxjLabel.textColor = STOCK_CONTENT_MIDDLE_COLOR;
        self.zxjLabel.font = FONT_9_BOLD(STOCK_CONTENT_MIDDLE_FONT);
        self.zxjLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.zxjLabel];
        
        
        self.zdfLabel = [[LLabel alloc] init];
        self.zdfLabel.textColor = STOCK_CONTENT_DEFAULTCOLOR;
        self.zdfLabel.font = FONT_9_BOLD(STOCK_CONTENT_MIDDLE_FONT);
        self.zdfLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.zdfLabel];
        
        
        
        
    }
    return self;
}
-(UIImageView *)delayImageView{
    if (!_delayImageView) {
        _delayImageView = [UIImageView new];
        _delayImageView.image = [UIImage imageNamed:@"delay"];
        [self.contentView addSubview:_delayImageView];
    }
    return _delayImageView;
}

-(LLabel *)delayLabel{
    if (!_delayLabel) {
        _delayLabel = [LLabel new];
        _delayLabel.textColor = [UIColor whiteColor];
        _delayLabel.backgroundColor = RGB(228, 19, 72);
        _delayLabel.font = FONT_9_BOLD(9);
        _delayLabel.text = @"延";
        _delayLabel.layer.cornerRadius = 1.f;
        _delayLabel.layer.masksToBounds = YES;
        _delayLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_delayLabel];
    }
    return _delayLabel;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.stockImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(11);
        make.left.mas_equalTo(MARKET_SPACING);
        make.size.mas_equalTo(CGSizeMake(15, 11));
    }];
    self.stockImageView.hidden = !self.isShowFlag;
    
    [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        if (self.isShowFlag) {
            make.left.mas_equalTo(32);
            make.width.mas_equalTo(HBWIDTH_SIDE-32);
        }else{
            make.left.mas_equalTo(MARKET_SPACING);
            make.width.mas_equalTo(HBWIDTH_SIDE-15);
        }
        make.height.mas_equalTo(25);
    }];
    
    
    [self.zxjLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(HBWIDTH_SIDE);
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(HBWIDTH_MIDDLE);
        make.bottom.mas_equalTo(0);
    }];
    [self.zdfLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-MARKET_SPACING);
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(HBWIDTH_SIDE-MARKET_SPACING);
        make.bottom.mas_equalTo(0);
    }];
    
    self.nameLabel.text = self.model2.name;
    self.codeLabel.text = self.model2.code.length > 2 ? [self.model2.code substringFromIndex:2]:@"";
    self.zxjLabel.text = self.model2.zxj;
    
//    CGSize codeWidth = [self.model2.code boundingRectWithSize:CGSizeMake(MAXFLOAT, self.contentView.frame.size.height - 25) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:self.codeLabel.font} context:nil].size;
    
    [self.codeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left);
        make.top.mas_equalTo(self.nameLabel.mas_bottom);
//        make.width.mas_equalTo(codeWidth.width+2);//self.nameLabel.mas_width
        make.bottom.mas_equalTo(0);
    }];
    
    if ([self.model2.zdf floatValue] > 0) {
        self.zdfLabel.textColor = STOCK_CONTENT_REDCOLOR;
        self.zdfLabel.text = [NSString stringWithFormat:@"+%@%%",self.model2.zdf];
    }else if ([self.model2.zdf floatValue] < 0) {
        self.zdfLabel.textColor = STOCK_CONTENT_GREENCOLOR;
        self.zdfLabel.text = [NSString stringWithFormat:@"%@%%",self.model2.zdf];
    }else if ([self.model2.zdf floatValue] == 0) {
        self.zdfLabel.textColor = STOCK_CONTENT_DEFAULTCOLOR;
        self.zdfLabel.text = [NSString stringWithFormat:@"%@%%",self.model2.zdf];
    }
    
//    if ([self.model2.isdelay isEqualToString:@"1"]) {
        [self.delayImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.codeLabel.mas_right).offset(3);
            make.top.mas_equalTo(self.codeLabel.mas_top).offset(4);
            make.size.mas_equalTo(CGSizeMake(13, 10));
        }];
        
//        [self.delayLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(self.codeLabel.mas_right).offset(33);
//            make.top.mas_equalTo(self.codeLabel.mas_top).offset(4);
//            make.size.mas_equalTo(CGSizeMake(13, 10));
//        }];
//    }
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
