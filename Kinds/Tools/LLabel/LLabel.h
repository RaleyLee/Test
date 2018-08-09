//
//  LLabel.h
//  WBAPP
//
//  Created by hibor on 2018/4/29.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LLabel : UILabel

@property(nonatomic,assign)UIEdgeInsets edgInsets;


-(CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines;

-(void)drawTextInRect:(CGRect)rect;

@end
