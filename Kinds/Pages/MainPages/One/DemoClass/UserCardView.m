//
//  UserCardView.m
//  易投标-官方正版
//
//  Created by 秦景洋 on 2018/8/17.
//  Copyright © 2018年 秦景洋. All rights reserved.
//

#import "UserCardView.h"

@implementation UserCardView

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = [UIColor greenColor];
        [self creatTheSubViews];
    }
    return self;
}

-(void)creatTheSubViews{
    
    float customHeight = 20.0;
    
    UIImageView * codeImage = [[UIImageView alloc] init];
    codeImage.backgroundColor = [UIColor redColor];
    [self addSubview:codeImage];
    [codeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.centerY.equalTo(self);
        make.width.equalTo(@100);
        make.height.equalTo(@100);
    }];
    
    
    UILabel * nameLabel = [[UILabel alloc] init];
    nameLabel.font = FONT_9_MEDIUM(15);
    nameLabel.text = @"姓名：小二丫";
    [self addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(20);
        make.right.equalTo(codeImage.mas_left);
        make.height.equalTo(@30);
    }];
    
    
    customHeight += 30;
    
    UILabel * phoneLabel = [[UILabel alloc] init];
    phoneLabel.font = FONT_9_MEDIUM(15);
    phoneLabel.text = @"电话：18033701747";
    [self addSubview:phoneLabel];
    [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel.mas_left);
        make.top.equalTo(nameLabel.mas_bottom);
        make.width.equalTo(nameLabel.mas_width);
        make.height.equalTo(@30);
    }];
    
    customHeight += 30;
    
    UILabel * emailLabel = [[UILabel alloc] init];
    emailLabel.font = FONT_9_MEDIUM(15);
    emailLabel.text = @"邮箱：451852869@qq.com";
    [self addSubview:emailLabel];
    [emailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(phoneLabel.mas_left);
        make.top.equalTo(phoneLabel.mas_bottom);
        make.right.equalTo(phoneLabel.mas_right);
        make.height.equalTo(phoneLabel.mas_height);
    }];
    
    
    customHeight += 30;
    
    UILabel * workLabel = [[UILabel alloc] init];
    workLabel.font = FONT_9_MEDIUM(15);
    workLabel.text = @"所属行业：建筑工程";
    [self addSubview:workLabel];
    [workLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(emailLabel.mas_left);
        make.top.equalTo(emailLabel.mas_bottom);
        make.width.equalTo(emailLabel.mas_width);
        make.height.equalTo(emailLabel.mas_height);
    }];
    
    customHeight += 30;
    
    UILabel * companyLabel = [[UILabel alloc] init];
    companyLabel.font = FONT_9_MEDIUM(15);
    companyLabel.text = @"企业名称：";
    companyLabel.backgroundColor = [UIColor yellowColor];
    [self addSubview:companyLabel];
    [companyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(workLabel.mas_left);
        make.top.equalTo(workLabel.mas_bottom);
        make.width.equalTo(@75);
        make.height.equalTo(workLabel.mas_height);
    }];
    
    
    NSString * companyString = @"我所在的公司是秘密单位，不能告诉你，只知道我不是一般人就行了";
    float height = [self judgeTheLabelHeightWithString:companyString andWithThefont:15 andwiththeheighth:SCREEN_WIDTH -120 -85]+5;
    
    UILabel * showLabel = [[UILabel alloc] init];
    showLabel.backgroundColor = [UIColor purpleColor];
    showLabel.text = companyString;
    showLabel.font =FONT_9_MEDIUM(15);
    showLabel.numberOfLines = 0;
    showLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self addSubview:showLabel];
    [showLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(companyLabel.mas_right);
        make.top.equalTo(companyLabel.mas_top);
        make.right.equalTo(codeImage.mas_left);
        make.height.equalTo(@(height));
    }];
    
    customHeight += height;
    
    
    UILabel * addressLabel = [[UILabel alloc] init];
    addressLabel.backgroundColor = [UIColor blueColor];
    addressLabel.font = FONT_9_MEDIUM(15);
    addressLabel.text = @"地址";
    [self addSubview:addressLabel];
    [addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(companyLabel.mas_left);
        make.top.equalTo(showLabel.mas_bottom);
        make.width.mas_equalTo(40);
        make.height.equalTo(companyLabel.mas_height);
    }];
    
    
    NSString * addressString = @"河北省石家庄市友谊大街与槐安路交叉口石邑大厦5层";
    float addressHeight = [self judgeTheLabelHeightWithString:addressString andWithThefont:15 andwiththeheighth:SCREEN_WIDTH -120 -50];
    
    UILabel * showAddress = [[UILabel alloc] init];
    showAddress.font = FONT_9_MEDIUM(15);
    showAddress.text = addressString;
    showAddress.lineBreakMode = NSLineBreakByWordWrapping|NSLineBreakByCharWrapping;
    showAddress.numberOfLines = 0;
    showAddress.backgroundColor = [UIColor redColor];
    [self addSubview:showAddress];
    [showAddress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(addressLabel.mas_right);
        make.top.equalTo(addressLabel.mas_top);
        make.right.equalTo(codeImage.mas_left);
        make.height.equalTo(@(addressHeight));
    }];
    
    
    customHeight += addressHeight;
    NSLog(@"%f",customHeight);
    self.size = CGSizeMake(SCREEN_WIDTH, customHeight+20);
}


-(CGFloat)judgeTheLabelHeightWithString:(NSString *)string andWithThefont:(NSInteger)font andwiththeheighth:(NSInteger)width{
    CGSize size = [string boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:FONT_9_MEDIUM(font)} context:nil].size;
    return size.height;
    
}

-(void)setTitleString:(NSString *)titleString{
    
    [self creatTheSubViews];
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

@end
