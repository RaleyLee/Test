//
//  MusicBottomView.m
//  Kinds
//
//  Created by hibor on 2018/7/20.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import "MusicBottomView.h"

@implementation MusicBottomView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self = [[NSBundle mainBundle] loadNibNamed:@"MusicBottomView" owner:self options:nil].lastObject;
    }
    return self;
}

@end
