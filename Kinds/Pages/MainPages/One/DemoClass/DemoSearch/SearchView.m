//
//  SearchView.m
//  Kinds
//
//  Created by hibor on 2018/8/8.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import "SearchView.h"

@implementation SearchView

-(instancetype)initWithFrame:(CGRect)frame withBlock:(changBlock)block{
    if (self = [super initWithFrame:frame]) {

        
        self.backgroundColor = [UIColor whiteColor];
        self.block =  block;
        UILabel *titleLabel = [UILabel new];
        titleLabel.text = @"热门搜索";
        titleLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(10);
        }];
    }
    return self;
}

-(void)setDataArray:(NSMutableArray *)dataArray{
    _dataArray = dataArray;
    
    CGFloat x = 10;
    CGFloat y = 40;
    CGFloat space = 10;
    CGFloat buttonWidth;
    for (int i = 0; i < _dataArray.count; i++) {
        NSString *title = _dataArray[i];
        CGSize size = [title boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
        buttonWidth = size.width+15;
        if (x + buttonWidth + space > SCREEN_WIDTH) {
            x = 10;
            y += 40;
        }
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:RGB_color(118) forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        button.layer.cornerRadius = 3;
        button.layer.borderColor = RGB(200, 200, 200).CGColor;
        button.layer.borderWidth = 0.5f;
        button.layer.masksToBounds = YES;
        button.tag = 100+i;
        button.exclusiveTouch = YES;//避免多指触摸
        [button addTarget:self action:@selector(itemClickAction:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(x, y, buttonWidth, 30);
        [self addSubview:button];
        x+= buttonWidth+10;
        
        
    }

    self.size = CGSizeMake(SCREEN_WIDTH, y+50);
    if (self.block) {
        self.block(y+50);
    }
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

-(void)itemClickAction:(UIButton *)sender{
    if (self.itemBlock) {
        self.itemBlock(_dataArray[sender.tag-100]);
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
