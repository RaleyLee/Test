//
//  WeMenuBottomView.m
//  Kinds
//
//  Created by hibor on 2018/8/3.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import "WeMenuBottomView.h"

@interface WeMenuBottomView()

@property(nonatomic,strong)NSArray *imageArray;
@property(nonatomic,strong)NSArray *titlesArray;

@end

@implementation WeMenuBottomView

-(instancetype)initWithImages:(NSArray *)imageArray withTitles:(NSArray *)titlesArray{
    if (self = [super init]) {
        _imageArray = imageArray;
        _titlesArray = titlesArray;
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
