//
//  TButton.m
//  MarketAPP
//
//  Created by hibor on 2018/6/4.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import "TButton.h"

@implementation TButton

-(CGRect)titleRectForContentRect:(CGRect)contentRect{
    if (!CGRectIsEmpty(self.titleRect) && !CGRectEqualToRect(self.titleRect, CGRectZero)) {
        return self.titleRect;
    }
    return [super titleRectForContentRect:contentRect];
}

-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    if (!CGRectIsEmpty(self.imageRect) && !CGRectEqualToRect(self.imageRect, CGRectZero)) {
        return self.imageRect;
    }
    return [super titleRectForContentRect:contentRect];
}


@end
