//
//  VRefreshBtn.m
//  PopupViewExample
//
//  Created by Vols on 2017/6/23.
//  Copyright © 2017年 vols. All rights reserved.
//

#import "VRefreshBtn.h"

@interface VRefreshBtn ()

@property (nonatomic, strong) UIButton * theButton;
@property (nonatomic, strong) UIButton * statusButton;
@property (nonatomic, strong) UIActivityIndicatorView * indicator;

@end


@implementation VRefreshBtn

#pragma mark - Lifecycle

+(instancetype)refreshButton{
   
    VRefreshBtn * Rbtn = [[VRefreshBtn alloc]initWithStockStatus:RefreshStockHomeStatus];
    return Rbtn;
}

-(instancetype)initWithStockStatus:(RefreshStockStatus)refreshStatus{
    
    self = [super init];
    
    if (self) {
        
        [self configureSubViews];
        
    }
    
    return self;
}

- (id)init{
    self = [super init];
    if (self) {
        
        [self configureViews];
    }
    return self;
}

-(void)configureSubViews{
    
    [self addSubview:self.indicator];
    [self addSubview:self.statusButton];
    
    [_statusButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [_indicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
    
    self.backgroundColor = [UIColor clearColor];

    
}


- (void)configureViews{
    
    [self addSubview:self.indicator];
    [self addSubview:self.theButton];

    [_theButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [_indicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
    
    self.backgroundColor = [UIColor clearColor];
}

- (void)statusClickAction:(UIButton *)button{

    button.hidden = YES;
    [_indicator startAnimating];
    
    if (_clickHandler) {
        _clickHandler();
    }
    
}
- (void)clickAction:(UIButton *)button {
    button.hidden = YES;
    [_indicator startAnimating];
    
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [_indicator stopAnimating];
        button.hidden = NO;
    });
    
    if (_clickHandler) {
        _clickHandler();
    }
}

-(void)refreshStatusEnd{
    
    double delayInSeconds = 0.8f;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [_indicator stopAnimating];
        _statusButton.hidden = NO;
    });


}

-(void)refreshStatusStart{
    
     _statusButton.hidden = YES;
    [_indicator startAnimating];
    
}
#pragma mark - Properties

- (UIButton *)theButton {
    if (_theButton == nil) {
        _theButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_theButton setImage:[UIImage imageNamed:@"nav_refresh"] forState:UIControlStateNormal];
        [_theButton addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _theButton;
}

-(UIButton *)statusButton{
    if (_statusButton == nil) {
        
        _statusButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_statusButton setImage:[UIImage imageNamed:@"nav_refresh"] forState:UIControlStateNormal];
        [_statusButton addTarget:self action:@selector(statusClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _statusButton;
}


-(void)setButtonImage:(UIImage *)buttonImage{
    [_theButton setImage:buttonImage forState:UIControlStateNormal];
    [_statusButton setImage:buttonImage forState:UIControlStateNormal];
}

- (UIActivityIndicatorView * )indicator {
    if (_indicator == nil) {
        _indicator = [[UIActivityIndicatorView alloc] init];
        _indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
        _indicator.backgroundColor = [UIColor clearColor];
        _indicator.alpha = 0.5;
        _indicator.layer.cornerRadius = 6;
    }
    return _indicator;
}



@end
