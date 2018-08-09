//
//  HeaderSectionView.m
//  MarketAPP
//
//  Created by hibor on 2018/6/4.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import "HeaderSectionView.h"
#import "TButton.h"

@interface HeaderSectionView()
@property(nonatomic,strong)NSArray *titleArray;
@property(nonatomic,assign)NSInteger canTouchIndex;
@end

@implementation HeaderSectionView

-(instancetype)initWithFrame:(CGRect)frame withTitleArray:(NSArray *)titleArray canTouchIndex:(NSInteger)canTouchIndex isUPDown:(BOOL)updown withBlock:(SortButtonBlock)block{
    
    self.sortBlock = block;
    self.titleArray = titleArray;
    self.canTouchIndex = canTouchIndex;
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = STOCK_ZDSECTION_BGCOLOR;
        CGFloat width = SCREEN_WIDTH / titleArray.count;
        for (int i = 0; i < titleArray.count; i++) {
            TButton *button = [TButton buttonWithType:UIButtonTypeCustom];
            button.titleLabel.adjustsFontSizeToFitWidth = YES;
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            [button setTitle:titleArray[i] forState:UIControlStateNormal];
            [button setTitleColor:STOCK_SECTION_HEADER_TITLECOLOR forState:UIControlStateNormal];
            [button.titleLabel setFont:FONT_9_MEDIUM(STOCK_SECTION_HEADER_TITLEFONT)];
            [button setFrame:CGRectMake(width*i, 0, width, frame.size.height)];
            button.tag = 900 + i;
            if (i == 0) {
                button.titleEdgeInsets = UIEdgeInsetsMake(0, MARKET_SPACING, 0, 0);
                button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            }else if (i == titleArray.count - 1){
                button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
                button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, MARKET_SPACING);
            }else{
                button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            }
            if (i == canTouchIndex && canTouchIndex != 888) {
                [button setImage:[UIImage imageNamed:updown ? SORT_DOWN : SORT_UP] forState:UIControlStateNormal];
                if (i == titleArray.count -1) {
                    button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 26);
                    button.imageRect = CGRectMake(width-23, (frame.size.height - 12)/2, 8, 12);
                }else{

                    CGSize size = [titleArray[i] boundingRectWithSize:CGSizeMake(MAXFLOAT, STOCK_SECTION_HEADER_TITLEFONT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:button.titleLabel.font} context:nil].size;
                    button.imageRect = CGRectMake(width/2+size.width/2+1.5, (frame.size.height - 12)/2, 8, 12);
                    button.titleRect = CGRectMake(width/2-size.width/2-1.5, 0, size.width, frame.size.height);

                }
                [button setTitleColor:STOCK_CONTENT_REDCOLOR forState:UIControlStateNormal];
                [button addTarget:self action:@selector(sort) forControlEvents:UIControlEventTouchUpInside];
            }
            [self addSubview:button];

            
            if (i == titleArray.count -1) {
                [button mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(0);
                    make.right.mas_equalTo(0);
                    make.size.mas_equalTo(CGSizeMake(width, STOCK_SECTION_HEADER_HEIGHT));
                }];
            }
        }
        
        
    }
    return self;
}

-(void)setBgColor:(UIColor *)bgColor{
    self.backgroundColor = bgColor;
}

- (void)setIsAhStock:(BOOL)isAhStock{
    if (self.titleArray.count == 4 && isAhStock) {
        TButton *button901 = (TButton *)[self viewWithTag:901];
        button901.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        TButton *button902 = (TButton *)[self viewWithTag:902];
        button902.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    }
}

-(void)setUpDown:(BOOL)upDown{
    TButton *button = (TButton *)[self viewWithTag:900+self.canTouchIndex];
    [button setImage:[UIImage imageNamed:upDown ? SORT_DOWN : SORT_UP] forState:UIControlStateNormal];
}

-(void)sort{
    if (self.sortBlock) {
        if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable) {
            self.sortBlock(NO);
        }else{
            self.sortBlock(YES);
        }
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
