//
//  MusicToolCell2.m
//  Kinds
//
//  Created by hibor on 2018/7/20.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import "MusicToolCell2.h"

@implementation MusicToolCell2

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self = [[NSBundle mainBundle] loadNibNamed:@"MusicToolCell2" owner:self options:nil].lastObject;
    }
    return self;
}

@end
