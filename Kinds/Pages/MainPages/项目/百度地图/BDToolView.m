//
//  BDToolView.m
//  Kinds
//
//  Created by hibor on 2018/8/13.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import "BDToolView.h"
#import "BDManager.h"

@interface BDToolView ()

@property(nonatomic,strong)NSMutableArray *dataSourceArray;  //显示图片和文字的数组
@property(nonatomic,strong)NSMutableArray *stateArray;  //记录状态的数组
@property(nonatomic,strong)NSMutableDictionary *layerDictionary;

@end

@implementation BDToolView

-(instancetype)initWithDataSource:(NSArray *)dataArray{
    if (self = [super init]) {
        self.dataSourceArray = [NSMutableArray arrayWithArray:dataArray];
        self.backgroundColor = [UIColor whiteColor];
        self.stateArray = [NSMutableArray array];
        
        
        self.layerDictionary = [BDManager getLayerContent];
        
        for (int i = 0; i < dataArray.count; i++) {
            
            if (i == 0) {
                [self.stateArray addObject:[self.layerDictionary objectForKey:@"road-open"]];
            }else if (i == 2) {
                [self.stateArray addObject:[self.layerDictionary objectForKey:@"RealScene"]];
            }else{
                [self.stateArray addObject:@"0"];
            }
            
            UIView *itemView = [[UIView alloc] initWithFrame:CGRectMake(0, 50*i, 40, 50)];
            itemView.tag = 200 + i;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toolItemTapAction:)];
            [itemView addGestureRecognizer:tap];
            [self addSubview:itemView];
            
            UIImageView *iconImageView = [UIImageView new];
            iconImageView.image = [UIImage imageNamed:dataArray[i][@"image"]];
            iconImageView.contentMode = UIViewContentModeCenter;
            iconImageView.tag = 300 + i;
            [itemView addSubview:iconImageView];
            [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(itemView);
                make.top.mas_equalTo(10);
                make.size.mas_equalTo(CGSizeMake(20, 20));
            }];
            
            UILabel *titleLabel = [UILabel new];
            titleLabel.font = FONT_9_MEDIUM(10);
            titleLabel.text = dataArray[i][@"title"];
            titleLabel.textColor = RGB_color(21);
            titleLabel.textAlignment = NSTextAlignmentCenter;
            [itemView addSubview:titleLabel];
            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(itemView);
                make.bottom.mas_equalTo(itemView.bottom).offset(-5);
                make.height.mas_equalTo(15);
            }];
            
            if (i < dataArray.count -1) {
                UIView *lineView = [UIView new];
                lineView.backgroundColor = RGB_color(221);
                [itemView addSubview:lineView];
                [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.mas_equalTo(0);
                    make.height.mas_equalTo(1);
                    make.left.mas_equalTo(10);
                    make.right.mas_equalTo(-10);
                }];
            }
        }
        
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.layer.borderWidth = 0.5f;
    }
    return self;
}


-(void)toolItemTapAction:(UITapGestureRecognizer *)gesture{
    NSInteger tag = gesture.view.tag;
    if (tag == 200 || tag == 202) {
        if ([self.stateArray[tag-200] isEqualToString:@"0"]) {
            [self.stateArray replaceObjectAtIndex:tag-200 withObject:@"1"];
        }else if ([self.stateArray[tag-200] isEqualToString:@"1"]) {
            [self.stateArray replaceObjectAtIndex:tag-200 withObject:@"0"];
        }
        
        UIImageView *iconImage = [self viewWithTag:tag + 100];
        
        if (tag == 200) {
            if ([self.stateArray[tag-200] isEqualToString:@"0"]) {
                iconImage.image = [UIImage imageNamed:@"traffic-default"];
            }else if ([self.stateArray[tag-200] isEqualToString:@"1"]) {
                iconImage.image = [UIImage imageNamed:@"traffic-selected"];
            }
            
        }else if (tag == 202) {
            if ([self.stateArray[tag-200] isEqualToString:@"0"]) {
                iconImage.image = [UIImage imageNamed:@"panorama-default"];
            }else if ([self.stateArray[tag-200] isEqualToString:@"1"]) {
                iconImage.image = [UIImage imageNamed:@"panorama-selected"];
            }
        }
    }
    
    if (self.clickBlock) {
        self.clickBlock(tag - 200,[self.stateArray[tag-200] isEqualToString:@"1"]);
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
