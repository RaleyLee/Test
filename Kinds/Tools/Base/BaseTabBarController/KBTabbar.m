//
//  KBTabbar.m
//  KBTabbarController
//
//  Created by kangbing on 16/5/31.
//  Copyright © 2016年 kangbing. All rights reserved.
//

#import "KBTabbar.h"

@implementation KBTabbar


- (instancetype)init
{
    self = [super init];
    if (self) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"plus_Last"] forState:UIControlStateNormal];
        btn.bounds = CGRectMake(0, 0, 64, 64);
        self.centerBtn = btn;
        [self addSubview:btn];
       
    }
    return self;
}

- (void)layoutSubviews
{
    
    [super layoutSubviews];
    
    self.centerBtn.center = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.3);
    
    int index = 0;
    CGFloat width = self.bounds.size.width / ((self.buttonTotalCount%2==0) ? self.buttonTotalCount+1 : self.buttonTotalCount);
    
    for (UIView* sub in self.subviews) {
        
        if ([sub isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            
            sub.frame = CGRectMake(index * width, self.bounds.origin.y, width, self.bounds.size.height - 2);
            
            index++;
            
            if (index == self.buttonTotalCount/2) { //说明有凸起的中间button
                index++;
            }
        }
    }
}



- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    if (self.isHidden == NO) {
        
        CGPoint newPoint = [self convertPoint:point toView:self.centerBtn];
        
        if ([self.centerBtn pointInside:newPoint withEvent:event]) {
            return self.centerBtn;
        }else{
            return [super hitTest:point withEvent:event];
        }
    }
    else {
        return [super hitTest:point withEvent:event];
    }
}



@end
