//
//  UITableView+EmptyData.m
//  HangQingNew
//
//  Created by hibor on 2018/5/28.
//  Copyright © 2018年 hibor. All rights reserved.
//

#define NODataMessage @"暂无数据"
#define NONetWorkMessage @"网络已走丢!!"
#define GetDataFailure @"获取数据异常"

#define NODataImage [UIImage imageNamed:@"NoDataImage"]
#define NONetWorkImage [UIImage imageNamed:@"NoNetWorkImage"]
#define GetDataFailureImage [UIImage imageNamed:@"GetDataFailure"]

#import "UITableView+EmptyData.h"
#import <objc/runtime.h>

static const void *UtilityKey = &UtilityKey;
static const void *UtilityKey_messageLabel = &UtilityKey_messageLabel;
static const void *UtilityKey_messageImage = &UtilityKey_messageImage;
static const void *UtilityKey_signView = &UtilityKey_signView;
static const void *UtilityKey_singerImageView = &UtilityKey_singerImageView;

@implementation UITableView (EmptyData)

@dynamic myBlock,messageImage,messageLabel,signView,singerImageView;

-(ReloadButtonBlock)myBlock{
    return objc_getAssociatedObject(self, UtilityKey);
}
-(void)setMyBlock:(ReloadButtonBlock)myBlock{
    objc_setAssociatedObject(self, UtilityKey, myBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(UILabel *)messageLabel{
    return objc_getAssociatedObject(self, UtilityKey_messageLabel);
}
-(void)setMessageLabel:(UILabel *)messageLabel{
    objc_setAssociatedObject(self, UtilityKey_messageLabel, messageLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(UIImageView *)messageImage{
    return objc_getAssociatedObject(self, UtilityKey_messageImage);
}
-(void)setMessageImage:(UIImageView *)messageImage{
    objc_setAssociatedObject(self, UtilityKey_messageImage, messageImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(UIView *)signView{
    return objc_getAssociatedObject(self, UtilityKey_signView);
}
-(void)setSignView:(UIView *)signView{
    objc_setAssociatedObject(self, UtilityKey_signView, signView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(UIImageView *)singerImageView{
    return objc_getAssociatedObject(self, UtilityKey_singerImageView);
}
-(void)setSingerImageView:(UIImageView *)singerImageView{
    objc_setAssociatedObject(self, UtilityKey_singerImageView, singerImageView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void)tableViewDisplayWithMessage:(NSString *)message ifNecessaryForRowCount:(NSUInteger)rowCount{
    if (rowCount == 0) {
        // Display a message when the table is empty
        // 没有数据的时候，UILabel的显示样式
        self.messageLabel = [UILabel new];
        self.messageLabel.text = message ? message : NODataMessage;
        self.messageLabel.font = [UIFont systemFontOfSize:15];
        self.messageLabel.textColor = RGB_color(150);
        self.messageLabel.textAlignment = NSTextAlignmentCenter;
        [self.messageLabel sizeToFit];
        
        self.backgroundView = self.messageLabel;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    } else {
        self.backgroundView = nil;
        self.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
}


-(void)tableViewDisplayWithImage:(UIImage *)image withMessage:(NSString *)message withType:(DisplayType)type ifNecessaryForRowCount:(NSUInteger)rowCount{
    if (rowCount == 0) {
        self.signView = [UIView new];
        self.backgroundView = self.signView;
        self.messageImage = [UIImageView new];
        self.messageImage.image = image ? image : [self returnSignImageWithType:type];
//        self.messageImage.backgroundColor = [UIColor redColor];
        [self.signView addSubview:self.messageImage];
        [self.messageImage mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self.mas_centerY).offset(-100);
            make.size.mas_equalTo(CGSizeMake(60, 60));
        }];
        self.messageLabel = [UILabel new];
        self.messageLabel.text = message ? message : [self returnSignMessageWithType:type];
        self.messageLabel.font = [UIFont systemFontOfSize:15];
        self.messageLabel.textColor = RGB_color(150);
        self.messageLabel.textAlignment = NSTextAlignmentCenter;
        [self.signView addSubview:self.messageLabel];
        [self.messageLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self.messageImage.mas_bottom).offset(5);
            make.size.mas_equalTo(CGSizeMake(200, 30));
        }];
        
        
        
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }else{
        self.backgroundView = nil;
        self.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
}

-(void)tableViewDisplayWithImage:(UIImage *)image withMessage:(NSString *)message withType:(DisplayType)type ifNecessaryForRowCount:(NSUInteger)rowCount reloadButtonBlock:(ReloadButtonBlock)block{
    
    self.myBlock = block;
    
    [self tableViewDisplayWithImage:image withMessage:message withType:type ifNecessaryForRowCount:rowCount];
    
    if (rowCount == 0) {
        
        
        UIButton *reloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [reloadButton setTitle:@"点击重试" forState:UIControlStateNormal];
        [reloadButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [reloadButton setTitleColor:RGB_color(150) forState:UIControlStateNormal];
        reloadButton.layer.borderColor = RGB_color(150).CGColor;
        reloadButton.layer.borderWidth = 1.0f;
        reloadButton.layer.cornerRadius = 15;
        reloadButton.layer.masksToBounds = YES;
        [reloadButton addTarget:self action:@selector(reloadDataWithButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.signView addSubview:reloadButton];
        [reloadButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self.messageLabel.mas_bottom);
            make.size.mas_equalTo(CGSizeMake(100, 30));
        }];
        
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }else{
        self.backgroundView = nil;
        self.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
}


-(void)tableViewDisplaySingerImage:(UIImage *)image{
    self.backgroundColor = [UIColor colorWithPatternImage:image];
//    self.signView = [UIView new];
//    self.backgroundView = self.signView;
//
//    self.singerImageView = [UIImageView new];
//    self.singerImageView.image = image;
//    self.singerImageView.backgroundColor = [UIColor redColor];
//    self.singerImageView.layer.cornerRadius = 75;
//    self.singerImageView.layer.masksToBounds = YES;
//    [self.signView addSubview:self.singerImageView];
//    [self.singerImageView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self);
//        make.top.equalTo(self.mas_centerY).offset(-50);
//        make.size.mas_equalTo(CGSizeMake(150, 150));
//    }];
    
}

-(void)reloadDataWithButtonClick:(UIButton *)sender{
    NSLog(@"重新加载");
    if (self.myBlock) {
        self.myBlock();
    }
}

//根据type返回初始化显示的内容
-(NSString *)returnSignMessageWithType:(DisplayType)type{
    if (type == DisplayTypeNotNetWork) {
        return NONetWorkMessage;
    }else if (type == DisplayTypeNoData){
        return NODataMessage;
    }else if (type == DisplayTypeGetDataFailure){
        return GetDataFailure;
    }
    return @"";
}

-(UIImage *)returnSignImageWithType:(DisplayType)type{
    if (type == DisplayTypeNotNetWork) {
        return NONetWorkImage;
    }else if (type == DisplayTypeNoData){
        return NODataImage;
    }else if (type == DisplayTypeGetDataFailure){
        return GetDataFailureImage;
    }
    return nil;
}

@end
