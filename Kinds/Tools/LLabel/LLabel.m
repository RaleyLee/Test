//
//  LLabel.m
//  WBAPP
//
//  Created by hibor on 2018/4/29.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import "LLabel.h"

@implementation LLabel

-(CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines{

    UIEdgeInsets insets = self.edgInsets;
    CGRect rect = [super textRectForBounds:UIEdgeInsetsInsetRect(bounds, insets)
                    limitedToNumberOfLines:numberOfLines];
    
    rect.origin.x    -= insets.left;
    rect.origin.y    -= insets.top;
    rect.size.width  += (insets.left + insets.right);
    rect.size.height += (insets.top + insets.bottom);
    
    return rect;
}

- (void)drawTextInRect:(CGRect)rect {

    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.edgInsets)];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
