//
//  OCTableViewSectionView.h
//  TT
//
//  Created by hibor on 2018/4/3.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCTableModel.h"

@interface OCTableViewSectionView : UITableViewHeaderFooterView

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier;


/**
 是否隐藏More按钮
 */
@property(nonatomic,assign)BOOL hiddenMoreButton;

/**
 Section的背景颜色
 */
@property(nonatomic,strong)UIColor *contentBGColor;


@property(nonatomic,copy)OCTableModel *model;


/**
 Section下标
 */
@property(nonatomic,assign)NSInteger sectionTag;


/**
 点击More的回调 返回Section的下标
 */
@property(nonatomic,copy)void (^headerMoreClick)(NSInteger tag);


/**
 点击整个Section的回调
 */
@property(nonatomic,copy)void (^headerSectionClick)(void);

@end

