//
//  ChoiceHeadr.m
//  易投标-官方正版
//
//  Created by 秦景洋 on 2018/8/14.
//  Copyright © 2018年 秦景洋. All rights reserved.
//

#import "ChoiceHeadr.h"

@implementation ChoiceHeadr

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = [UIColor blueColor];
        [self addSubview:self.showLabel];
        [_showLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}


-(void)setTitleString:(NSString *)titleString{
    
    _showLabel.text = titleString;
    
}

-(UILabel *)showLabel{
    
    if (_showLabel == nil) {
        _showLabel = [[UILabel alloc] init];
        _showLabel.font = FONT_9_BOLD(15);
        _showLabel.textColor = [UIColor cyanColor];
        
    }
    
    return _showLabel;
}
@end
