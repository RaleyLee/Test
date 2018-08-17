//
//  ChoiceGroupCell.m
//  易投标-官方正版
//
//  Created by 秦景洋 on 2018/8/14.
//  Copyright © 2018年 秦景洋. All rights reserved.
//

#import "ChoiceGroupCell.h"

@implementation ChoiceGroupCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
 
        
        [self addSubview:self.clickButton];
        [_clickButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.contentView);
            make.width.equalTo(@60);
            make.height.equalTo(@40);
        }];
    }
    return self;
}


-(void)setModel:(ChoiceGroupModel *)model{
    
    
    [_clickButton setTitle:model.nameString forState:UIControlStateNormal];
    
}

-(UIButton *)clickButton{
    
    if (!_clickButton) {
        _clickButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _clickButton.frame = CGRectMake(0, 0, 60, 40);
        _clickButton.backgroundColor = [UIColor redColor];
        [self setTheCornerWithTheView:_clickButton andWithTheWidth:5];
        _clickButton.titleLabel.font= FONT_9_MEDIUM(17);
    }
    return _clickButton;
    
}

-(void)setTheCornerWithTheView:(UIView *)subView andWithTheWidth:(float)widths{
    
    //    //UIRectCornerAllCorners指定拿个角变为圆角
    UIBezierPath *maskPath1 = [UIBezierPath bezierPathWithRoundedRect:subView.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(widths, widths)];
    
    CAShapeLayer *maskLayer1 = [[CAShapeLayer alloc]init];
    //设置大小
    maskLayer1.frame = subView.bounds;
    //设置图形样子
    maskLayer1.path = maskPath1.CGPath;
    subView.layer.mask = maskLayer1;
    
}

-(void)setTheAssignCornerWithTheView:(UIView *)subView andWithTheWidth:(float)widths andWithTheleft:(UIRectCorner)corners{
    
    
    
    //    //UIRectCornerAllCorners指定拿个角变为圆角
    UIBezierPath *maskPath1 = [UIBezierPath bezierPathWithRoundedRect:subView.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(widths, widths)];
    
    CAShapeLayer *maskLayer1 = [[CAShapeLayer alloc]init];
    //设置大小
    maskLayer1.frame = subView.bounds;
    //设置图形样子
    maskLayer1.path = maskPath1.CGPath;
    subView.layer.mask = maskLayer1;
    
}
@end
