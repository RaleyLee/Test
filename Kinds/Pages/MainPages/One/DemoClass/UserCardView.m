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
//        [self creatTheSubViews];
    }
    return self;
}

-(void)creatTheSubViews{
    
    float customHeight = 0.0;
    
    UIImageView * codeImage = [[UIImageView alloc] init];
    [self addSubview:codeImage];
    [codeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).with.offset(-20);
        make.centerY.equalTo(self);
        make.width.equalTo(@100);
        make.height.equalTo(@100);
    }];
    codeImage.backgroundColor = [UIColor redColor];
    
    UILabel * nameLabel = [[UILabel alloc] init];
    [self addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(10);
        make.top.equalTo(self.mas_top).with.offset(20);
        make.right.equalTo(codeImage.mas_left);
        make.height.equalTo(@30);
    }];
    nameLabel.font = CustomFont(15);
    nameLabel.text = @"姓名：小二丫";
    
    customHeight += 30;
    
    UILabel * phoneLabel = [[UILabel alloc] init];
    [self addSubview:phoneLabel];
    [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel.mas_left);
        make.top.equalTo(nameLabel.mas_bottom);
        make.width.equalTo(nameLabel.mas_width);
        make.height.equalTo(@30);
    }];
    phoneLabel.font = CustomFont(15);
    phoneLabel.text = @"电话：18033701747";
    
    customHeight += 30;
    
    UILabel * emailLabel = [[UILabel alloc] init];
    [self addSubview:emailLabel];
    [emailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(phoneLabel.mas_left);
        make.top.equalTo(phoneLabel.mas_bottom);
        make.right.equalTo(phoneLabel.mas_right);
        make.height.equalTo(phoneLabel.mas_height);
    }];
    emailLabel.font = CustomFont(15);
    emailLabel.text = @"邮箱：451852869@qq.com";
    
    customHeight += 30;
    
    UILabel * workLabel = [[UILabel alloc] init];
    [self addSubview:workLabel];
    [workLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(emailLabel.mas_left);
        make.top.equalTo(emailLabel.mas_bottom);
        make.width.equalTo(emailLabel.mas_width);
        make.height.equalTo(emailLabel.mas_height);
    }];
    workLabel.font = CustomFont(15);
    workLabel.text = @"所属行业：建筑工程";
    customHeight += 30;
    
    UILabel * companyLabel = [[UILabel alloc] init];
    [self addSubview:companyLabel];
    [companyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(workLabel.mas_left);
        make.top.equalTo(workLabel.mas_bottom);
        make.width.equalTo(@75);
        make.height.equalTo(workLabel.mas_height);
    }];
    companyLabel.font = CustomFont(15);
    companyLabel.text = @"企业名称：";
    companyLabel.backgroundColor = [UIColor yellowColor];
    
    NSString * companyString = @"我所在的公司是秘密单位，不能告诉你，只知道我不是一般人就行了";
    float height = [PublicAction judgeTheLabelHeightWithString:companyString andWithThefont:15 andwiththeheighth:ScreenWidth -120 -85] +5;
    
    UILabel * showLabel = [[UILabel alloc] init];
    [self addSubview:showLabel];
    [showLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(companyLabel.mas_right);
        make.top.equalTo(companyLabel.mas_top);
        make.right.equalTo(codeImage.mas_left);
        make.height.equalTo(@(height));
    }];
    showLabel.text = companyString;
    showLabel.font =CustomFont(15);
    showLabel.numberOfLines = 0;
    showLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    customHeight += height;
    
    
    UILabel * addressLabel = [[UILabel alloc] init];
    [self addSubview:addressLabel];
    [addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(companyLabel.mas_left);
        make.top.equalTo(showLabel.mas_bottom);
        make.width.equalTo(@40);
        make.height.equalTo(companyLabel.mas_height);
    }];
    addressLabel.font = CustomFont(15);
    addressLabel.text = @"地址";
    
    NSString * addressString = @"河北省石家庄市友谊大街与槐安路交叉口石邑大厦5层";
    float addressHeight = [PublicAction judgeTheLabelHeightWithString:addressString andWithThefont:15 andwiththeheighth:ScreenWidth -120 -55]+5;
    
    UILabel * showAddress = [[UILabel alloc] init];
    [self addSubview:showAddress];
    [showAddress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(addressLabel.mas_right);
        make.top.equalTo(addressLabel.mas_top);
        make.right.equalTo(codeImage.mas_left);
        make.height.equalTo(@(addressHeight));
    }];
    showAddress.font = CustomFont(15);
    showAddress.text = addressString;
    showAddress.lineBreakMode = NSLineBreakByWordWrapping;
    showAddress.numberOfLines = 0;
    showAddress.backgroundColor = [UIColor redColor];
    
    customHeight += addressHeight;
    NSLog(@"%f",customHeight);
    self.size = CGSizeMake(ScreenWidth, customHeight+10);
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
